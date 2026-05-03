# Token Cost Estimation Protocol

How the orchestrator surfaces token cost estimates to the owner during
planning. The goal: give the owner enough cost visibility to make
informed scope decisions, without adding friction or requiring action.

## When Estimation Surfaces

| Moment | Behavior |
|--------|----------|
| Design alignment (Q&A walk) | No structured estimate. Orchestrator may informally mention cost at major scope decisions if it would meaningfully shape the choice. |
| Plan draft (planner returns plan) | Structured readout — token band, calibration metadata, optional dollar costs |
| Plan revision iterations | Re-estimate after each revision (cheap because deterministic) |
| Plan approval | Dedicated readout in approval message |
| Owner request | Anytime |

## Invoking the Estimator

Script location: `core/scripts/estimate-tokens.py`
Runtime: `uv run`

### CLI Surface

```
uv run core/scripts/estimate-tokens.py \
  --agents '<json-list>' \
  --calibration <path-to-calibration-file> \
  --priors <path-to-priors-file> \
  --pricing <path-to-pricing-file> \
  [--override-model <model-id>] \
  [--override-tier <low|mid|high>] \
  [--record-actuals --actual-input <int> --actual-output <int> --workflow <id> --agent <id> --model <id>]
```

The `--agents` argument is a JSON array. The orchestrator builds this
from the workflow's agent roster and each agent's frontmatter. Format:

```json
[
  {"agent": "code-reviewer", "model": "claude-opus-4-6", "tier": "high", "iteration_multiplier": 2},
  {"agent": "software-engineer", "model": "claude-sonnet-4-6", "tier": "mid", "iteration_multiplier": 2}
]
```

### How the Orchestrator Reads Output

The script emits JSON to stdout. The orchestrator parses it and
formats the readout for the owner using the Readout Format below.

### JSON Output Schema (Estimation Mode)

```json
{
  "estimate": {
    "total_input_tokens": {"low": 45000, "high": 82000},
    "total_output_tokens": {"low": 12000, "high": 28000},
    "dollar_cost": {"low": 0.42, "high": 0.78, "available": true},
    "per_agent": [
      {
        "agent": "code-reviewer",
        "model": "claude-opus-4-6",
        "tier": "high",
        "input_tokens": {"low": 15000, "high": 30000},
        "output_tokens": {"low": 5000, "high": 8000},
        "iteration_multiplier": 2
      }
    ]
  },
  "calibration": {
    "run_count": 7,
    "typical_error_pct": 25,
    "state": "calibrated"
  },
  "warnings": []
}
```

### JSON Output Schema (Record-Actuals Mode)

```json
{
  "recorded": true,
  "key": "agentic-workflow.methodology-reviewer.claude-opus-4-6",
  "new_run_count": 8
}
```

## Readout Format

### With Concrete Model (Tokens + Dollars + Calibration Metadata)

> *Estimated: ~18k–34k tokens (~$0.42–$0.78 at API pricing) —
> calibrated against 7 prior runs of this workflow type, typical
> error ±25%.*
> *Note: subscription plans (Claude Code, Copilot, etc.) decouple
> from API rates — actual cost on those plans differs.*

### With Tier Only (Tokens Only)

> *Estimated: ~18k–34k tokens — tier-level estimates only. Declare
> `model:` in agent frontmatter (per `core/agents/agent-frontmatter-spec.md`)
> to unlock dollar cost estimates.*
> *Calibration: 3 prior runs, typical error ±40%.*

### Uncalibrated (First Run)

> *Estimated: ~15k–30k tokens (~$0.35–$0.70 at API pricing) —
> uncalibrated (using bundled priors). Accuracy improves after
> ~5 runs.*

## Calibration

### How Calibration Works

Per-project calibration data lives at `.fabrika/calibration.yml`.
Each entry tracks actual token usage for a specific (workflow, agent,
model) combination.

**EWMA blend formula:**
`estimate = w * local_mean + (1 - w) * prior`
where `w = count / (count + k)` and `k = 5` (smoothing constant).

With k=5: after 5 runs, local data reaches 50% weight. After 10 runs,
67%. After 20, 80%.

**Calibration key structure:** `<workflow>.<agent>.<model>`
Example: `agentic-workflow.methodology-reviewer.claude-opus-4-6`

### When Calibration Updates

Calibration updates happen during session close-out:

- **Sprint-based and analytics-workspace:** During session close-out
  when token data is available from the tool
- **Agentic-workflow:** During Step 7 (Ship), after commit but before
  PR

The orchestrator invokes:

```
uv run core/scripts/estimate-tokens.py \
  --record-actuals \
  --actual-input <N> \
  --actual-output <N> \
  --workflow <id> \
  --agent <id> \
  --model <id>
```

The script updates `.fabrika/calibration.yml` in place using the EWMA
formula.

### Soft Invalidation

When a model identifier changes (e.g., `claude-sonnet-4-6` to
`claude-sonnet-4-7`), the new key has no local data. It falls back to
tier-level priors. Old data under the previous model key is retained
but not migrated — it remains available if the model is referenced
again.

## Budget Warning (Advisory)

Projects can set `token_budget_warn` in their project config
(`.fabrika/manifest.yml`). When set to an integer (token count), the
orchestrator displays a soft warning if the estimate exceeds the
threshold:

> *This plan exceeds your configured warning threshold of 50,000
> tokens. Proceed, revise, or update threshold?*

This is advisory only — never blocks execution. The orchestrator does
not nudge owners toward setting it.

## Worked Examples

### Example 1: Sprint Story with 3 Agents, Calibrated

A sprint-based project runs a story with: product-manager (plan),
software-engineer (implement), code-reviewer (review). Calibration
has 8 prior runs.

Agent list passed to script:

```json
[
  {"agent": "product-manager", "model": "claude-opus-4-6", "tier": "high", "iteration_multiplier": 1},
  {"agent": "software-engineer", "model": "claude-sonnet-4-6", "tier": "mid", "iteration_multiplier": 2},
  {"agent": "code-reviewer", "model": "claude-opus-4-6", "tier": "high", "iteration_multiplier": 2}
]
```

The iteration_multiplier of 2 applies to the engineer and reviewer
(they participate in review-revise cycles). The planner runs once.

Readout: *Estimated: ~52k–98k tokens (~$1.20–$2.25 at API pricing) —
calibrated against 8 prior runs, typical error ±22%.*

### Example 2: Agentic-Workflow Change, Uncalibrated (First Run)

A structural update with: workflow-planner (plan), agentic-engineer
(execute), methodology-reviewer + structural-validator +
context-architect (verify). First run — no calibration data.

The script uses tier-level priors only. Dollar costs available because
all agents declare `model:`.

Readout: *Estimated: ~75k–150k tokens (~$1.73–$3.45 at API pricing)
— uncalibrated (using bundled priors). Accuracy improves after
~5 runs.*

### Example 3: Analytics Task with Tier-Only Declarations

An analytics task where the consumer project uses `model_tier: mid`
for the data-analyst and `model_tier: high` for the analysis-planner.
No `model:` declared.

Dollar costs unavailable. Readout:
*Estimated: ~25k–50k tokens — tier-level estimates only. Declare
`model:` in agent frontmatter to unlock dollar cost estimates.
Calibration: uncalibrated.*
