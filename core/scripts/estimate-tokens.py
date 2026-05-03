# /// script
# requires-python = ">=3.11"
# dependencies = ["pyyaml"]
# ///
"""Token cost estimation for Fabrika workflows.

Deterministic utility invoked by the orchestrator to produce token band
estimates and record actual usage for calibration. Emits JSON to stdout.

Usage (estimation mode):
    uv run core/scripts/estimate-tokens.py \
      --agents '<json-list>' \
      --calibration .fabrika/calibration.yml \
      --priors core/calibration/priors.yml \
      --pricing core/calibration/pricing.yml

Usage (record-actuals mode):
    uv run core/scripts/estimate-tokens.py \
      --record-actuals \
      --actual-input 12000 \
      --actual-output 4500 \
      --workflow development-workflow \
      --agent code-reviewer \
      --model claude-opus-4-6 \
      --calibration .fabrika/calibration.yml \
      --priors core/calibration/priors.yml
"""

import argparse
import json
import math
import sys
from datetime import date
from pathlib import Path

import yaml


def load_yaml(path: Path) -> dict:
    """Load a YAML file, returning empty dict if file doesn't exist."""
    if not path.exists():
        return {}
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def save_yaml(path: Path, data: dict) -> None:
    """Write data to a YAML file, creating parent dirs if needed."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        yaml.dump(data, f, default_flow_style=False, sort_keys=False)


def resolve_tier(agent_entry: dict, priors: dict) -> str:
    """Resolve the tier for an agent entry.

    Priority: explicit tier field > model lookup > default.
    """
    # If tier is explicitly provided, use it
    if agent_entry.get("tier"):
        return agent_entry["tier"]

    # If model is provided, look it up in the model-tier table
    model = agent_entry.get("model")
    if model:
        lookup = priors.get("model_tier_lookup", {})
        if model in lookup:
            return lookup[model]

    # Fall back to default
    return priors.get("default_tier", "mid")


def get_prior(tier: str, priors: dict) -> tuple[int, int]:
    """Get the prior input/output token counts for a tier."""
    tier_priors = priors.get("tier_priors", {})
    tier_data = tier_priors.get(tier, tier_priors.get("mid", {}))
    return (
        tier_data.get("typical_input_tokens", 12000),
        tier_data.get("typical_output_tokens", 5000),
    )


def ewma_blend(local_mean: float, prior: float, count: int, k: int) -> float:
    """Apply EWMA blending: w * local_mean + (1 - w) * prior.

    w = count / (count + k)
    """
    w = count / (count + k)
    return w * local_mean + (1 - w) * prior


def compute_calibration_state(count: int) -> str:
    """Determine calibration state from run count."""
    if count == 0:
        return "uncalibrated"
    elif count < 5:
        return "bootstrapping"
    else:
        return "calibrated"


def compute_typical_error(count: int) -> int:
    """Estimate typical error percentage based on calibration depth.

    Starts at 50% uncalibrated, decreases as runs accumulate.
    Floors at ~15% for well-calibrated workflows.
    """
    if count == 0:
        return 50
    # Exponential decay from 50% toward 15%
    error = 15 + 35 * math.exp(-0.15 * count)
    return round(error)


def estimate_agent(
    agent_entry: dict,
    calibration_entries: dict,
    priors: dict,
    workflow_id: str | None,
) -> dict:
    """Produce token estimates for a single agent.

    Returns dict with low/high input and output token counts.
    """
    agent_name = agent_entry.get("agent", "unknown")
    model = agent_entry.get("model")
    tier = resolve_tier(agent_entry, priors)
    iteration_multiplier = agent_entry.get("iteration_multiplier", 1)
    k = priors.get("smoothing_constant_k", 5)

    # Get tier-level priors
    prior_input, prior_output = get_prior(tier, priors)

    # Look up calibration data if available
    cal_key = None
    cal_entry = None
    if workflow_id and model:
        cal_key = f"{workflow_id}.{agent_name}.{model}"
        cal_entry = calibration_entries.get(cal_key)
    elif workflow_id:
        # Try tier-based key as fallback (less specific)
        cal_key = f"{workflow_id}.{agent_name}.{tier}"
        cal_entry = calibration_entries.get(cal_key)

    # Compute blended estimate
    if cal_entry and cal_entry.get("count", 0) > 0:
        count = cal_entry["count"]
        blended_input = ewma_blend(
            cal_entry.get("mean_input", prior_input), prior_input, count, k
        )
        blended_output = ewma_blend(
            cal_entry.get("mean_output", prior_output), prior_output, count, k
        )
    else:
        blended_input = prior_input
        blended_output = prior_output
        count = 0

    # Low estimate = single pass (1x multiplier)
    # High estimate = declared iteration_multiplier
    input_low = round(blended_input)
    input_high = round(blended_input * iteration_multiplier)
    output_low = round(blended_output)
    output_high = round(blended_output * iteration_multiplier)

    return {
        "agent": agent_name,
        "model": model,
        "tier": tier,
        "input_tokens": {"low": input_low, "high": input_high},
        "output_tokens": {"low": output_low, "high": output_high},
        "iteration_multiplier": iteration_multiplier,
        "_count": count,  # Internal, used for aggregate calibration state
    }


def compute_dollar_cost(
    total_input_low: int,
    total_input_high: int,
    total_output_low: int,
    total_output_high: int,
    per_agent_results: list[dict],
    pricing: dict,
) -> dict:
    """Compute dollar cost if all agents have model-level pricing.

    Returns dict with low/high costs and availability flag.
    """
    pricing_data = pricing.get("pricing", {})

    # Check if all agents with models have pricing available
    all_have_pricing = True
    cost_low = 0.0
    cost_high = 0.0

    for agent_result in per_agent_results:
        model = agent_result.get("model")
        if not model:
            all_have_pricing = False
            break

        if model not in pricing_data:
            all_have_pricing = False
            break

        model_pricing = pricing_data[model]
        input_per_token = model_pricing["input_per_1m"] / 1_000_000
        output_per_token = model_pricing["output_per_1m"] / 1_000_000

        cost_low += (
            agent_result["input_tokens"]["low"] * input_per_token
            + agent_result["output_tokens"]["low"] * output_per_token
        )
        cost_high += (
            agent_result["input_tokens"]["high"] * input_per_token
            + agent_result["output_tokens"]["high"] * output_per_token
        )

    if all_have_pricing:
        return {
            "low": round(cost_low, 2),
            "high": round(cost_high, 2),
            "available": True,
        }
    else:
        return {"low": 0, "high": 0, "available": False}


def run_estimation(args: argparse.Namespace) -> dict:
    """Run estimation mode and return the result dict."""
    # Parse agent list
    try:
        agents = json.loads(args.agents)
    except json.JSONDecodeError as e:
        return {"error": f"Invalid --agents JSON: {e}"}

    if not isinstance(agents, list):
        return {"error": "--agents must be a JSON array"}

    # Load data files
    priors = load_yaml(Path(args.priors))
    pricing = load_yaml(Path(args.pricing)) if args.pricing else {}
    calibration = load_yaml(Path(args.calibration)) if args.calibration else {}
    calibration_entries = calibration.get("entries", {})

    # Determine workflow ID from calibration keys (heuristic: use first
    # agent's calibration key prefix if exists, otherwise None)
    workflow_id = None
    if calibration_entries:
        first_key = next(iter(calibration_entries), "")
        parts = first_key.split(".")
        if len(parts) >= 3:
            workflow_id = parts[0]

    # Apply overrides
    for agent_entry in agents:
        if args.override_model:
            agent_entry["model"] = args.override_model
        if args.override_tier:
            agent_entry["tier"] = args.override_tier

    # Estimate each agent
    per_agent_results = []
    for agent_entry in agents:
        result = estimate_agent(agent_entry, calibration_entries, priors, workflow_id)
        per_agent_results.append(result)

    # Aggregate totals
    total_input_low = sum(r["input_tokens"]["low"] for r in per_agent_results)
    total_input_high = sum(r["input_tokens"]["high"] for r in per_agent_results)
    total_output_low = sum(r["output_tokens"]["low"] for r in per_agent_results)
    total_output_high = sum(r["output_tokens"]["high"] for r in per_agent_results)

    # Dollar cost
    dollar_cost = compute_dollar_cost(
        total_input_low,
        total_input_high,
        total_output_low,
        total_output_high,
        per_agent_results,
        pricing,
    )

    # Calibration metadata (aggregate across all agents)
    counts = [r["_count"] for r in per_agent_results]
    min_count = min(counts) if counts else 0
    total_count = sum(counts)
    avg_count = total_count // len(counts) if counts else 0

    state = compute_calibration_state(min_count)
    typical_error = compute_typical_error(avg_count)

    # Build warnings
    warnings = []
    for r in per_agent_results:
        if not r.get("model") and not dollar_cost["available"]:
            warnings.append(
                f"Agent '{r['agent']}' has no model declared — dollar cost unavailable"
            )
            break  # One warning is enough

    # Clean internal fields from per-agent results
    clean_results = []
    for r in per_agent_results:
        clean = {k: v for k, v in r.items() if not k.startswith("_")}
        clean_results.append(clean)

    return {
        "estimate": {
            "total_input_tokens": {"low": total_input_low, "high": total_input_high},
            "total_output_tokens": {
                "low": total_output_low,
                "high": total_output_high,
            },
            "dollar_cost": dollar_cost,
            "per_agent": clean_results,
        },
        "calibration": {
            "run_count": avg_count,
            "typical_error_pct": typical_error,
            "state": state,
        },
        "warnings": warnings,
    }


def run_record_actuals(args: argparse.Namespace) -> dict:
    """Record actual token usage to calibration file."""
    # Validate required arguments
    if not args.actual_input or not args.actual_output:
        return {"error": "--actual-input and --actual-output are required"}
    if not args.workflow or not args.agent or not args.model:
        return {"error": "--workflow, --agent, and --model are required"}
    if not args.calibration:
        return {"error": "--calibration path is required"}

    cal_path = Path(args.calibration)
    priors_path = Path(args.priors) if args.priors else None

    # Load calibration data
    calibration = load_yaml(cal_path)
    if "entries" not in calibration:
        calibration["entries"] = {}

    # Load priors for smoothing constant
    priors = load_yaml(priors_path) if priors_path else {}
    k = priors.get("smoothing_constant_k", 5)

    # Build calibration key
    cal_key = f"{args.workflow}.{args.agent}.{args.model}"

    # Get existing entry or create new
    entry = calibration["entries"].get(cal_key, {})
    old_count = entry.get("count", 0)
    old_mean_input = entry.get("mean_input", 0)
    old_mean_output = entry.get("mean_output", 0)

    # Update with new actual data using running mean
    new_count = old_count + 1
    if old_count == 0:
        new_mean_input = args.actual_input
        new_mean_output = args.actual_output
    else:
        # Incremental mean update
        new_mean_input = old_mean_input + (args.actual_input - old_mean_input) / new_count
        new_mean_output = (
            old_mean_output + (args.actual_output - old_mean_output) / new_count
        )

    # Store updated entry
    calibration["entries"][cal_key] = {
        "count": new_count,
        "mean_input": round(new_mean_input),
        "mean_output": round(new_mean_output),
        "last_updated": date.today().isoformat(),
    }

    # Write back
    save_yaml(cal_path, calibration)

    return {
        "recorded": True,
        "key": cal_key,
        "new_run_count": new_count,
    }


def build_parser() -> argparse.ArgumentParser:
    """Build the argument parser."""
    parser = argparse.ArgumentParser(
        description="Token cost estimation for Fabrika workflows.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Estimate tokens for a workflow
  uv run core/scripts/estimate-tokens.py \\
    --agents '[{"agent":"code-reviewer","model":"claude-opus-4-6","tier":"high","iteration_multiplier":2}]' \\
    --priors core/calibration/priors.yml \\
    --pricing core/calibration/pricing.yml \\
    --calibration .fabrika/calibration.yml

  # Record actual usage
  uv run core/scripts/estimate-tokens.py \\
    --record-actuals \\
    --actual-input 14500 --actual-output 6200 \\
    --workflow development-workflow --agent code-reviewer --model claude-opus-4-6 \\
    --calibration .fabrika/calibration.yml \\
    --priors core/calibration/priors.yml
        """,
    )

    # Shared arguments
    parser.add_argument(
        "--calibration",
        type=str,
        help="Path to per-project calibration YAML file (.fabrika/calibration.yml)",
    )
    parser.add_argument(
        "--priors",
        type=str,
        default="core/calibration/priors.yml",
        help="Path to bundled priors YAML file",
    )
    parser.add_argument(
        "--pricing",
        type=str,
        default="core/calibration/pricing.yml",
        help="Path to pricing YAML file",
    )

    # Estimation mode arguments
    parser.add_argument(
        "--agents",
        type=str,
        help="JSON array of agent entries for estimation",
    )
    parser.add_argument(
        "--override-model",
        type=str,
        help="Override model for all agents (conversational override)",
    )
    parser.add_argument(
        "--override-tier",
        type=str,
        choices=["low", "mid", "high"],
        help="Override tier for all agents",
    )

    # Record-actuals mode arguments
    parser.add_argument(
        "--record-actuals",
        action="store_true",
        help="Switch to record-actuals mode",
    )
    parser.add_argument(
        "--actual-input",
        type=int,
        help="Actual input tokens consumed (record-actuals mode)",
    )
    parser.add_argument(
        "--actual-output",
        type=int,
        help="Actual output tokens consumed (record-actuals mode)",
    )
    parser.add_argument(
        "--workflow",
        type=str,
        help="Workflow identifier (record-actuals mode)",
    )
    parser.add_argument(
        "--agent",
        type=str,
        help="Agent identifier (record-actuals mode)",
    )
    parser.add_argument(
        "--model",
        type=str,
        help="Model identifier (record-actuals mode)",
    )

    return parser


def main() -> None:
    """Entry point."""
    parser = build_parser()
    args = parser.parse_args()

    if args.record_actuals:
        result = run_record_actuals(args)
    elif args.agents:
        result = run_estimation(args)
    else:
        parser.print_help()
        sys.exit(1)

    # Emit JSON to stdout
    json.dump(result, sys.stdout, indent=2)
    print()  # Trailing newline


if __name__ == "__main__":
    main()
