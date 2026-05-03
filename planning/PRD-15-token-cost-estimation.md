# PRD-15: Token Cost Estimation Across Workspaces

**Version target:** 0.24.0 (minor bump — adds new core/ files and modifies existing core/workflows/ files)
**Dependencies:** PRD-11 (analytics workspace workflow — provides one
implementation surface), PRD-13 (review-revise loop — defines the
iteration cycles that token estimation must account for)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

Users currently have no visibility into expected token consumption
before committing to a plan. They learn how many tokens were consumed
only after the work is done (the session summary reports tokens
used). This creates two problems:

1. **No cost-informed planning.** A user might approve a plan that
   will consume significantly more tokens than expected. By the time
   they see the token count, the budget is spent.

2. **No feedback loop during plan revision.** As the user iterates on
   a drafted plan — adding scope, raising stakes, requesting
   additional review cycles — the token cost changes. Without
   real-time estimates, the user cannot make trade-offs between
   thoroughness and cost during the planning phase when those
   trade-offs are cheapest to make.

## Key Decisions

The following were aligned during the design-alignment session on
2026-05-02. These are settled — not for re-litigation during execution.

### 1. Ship live estimates with calibration metadata (not calibration-first)

v1 displays the heuristic estimate during plan alignment, paired with
an explicit confidence indicator showing calibration state and typical
error. Calibration data accumulates passively and *actively recalibrates*
the estimate over time. Owners get immediate visibility without being
misled about precision. Example readout:

> *Estimated: ~18k–34k tokens (~$0.42–$0.78 at API pricing) —
> calibrated against 7 prior runs of this workflow type, typical
> error ±25%.*
> *Note: subscription plans (Claude Code, Copilot, etc.) decouple from
> API rates — actual cost on those plans differs.*

### 2. Tier sourcing is a layered cascade

Three sources, with precedence:

1. **Per-agent metadata** (default) — each agent prompt file declares
   its preferred model in frontmatter
2. **Per-project config** (override) — consumer projects can override
   per-agent defaults at the project level
3. **Per-run conversational override** — owner can state an override
   after plan is drafted ("estimate it for high-tier reviewers
   instead"); orchestrator re-runs the script with the override

### 3. Agent metadata supports both `model` and `model_tier`

Schema:

```yaml
model: claude-sonnet-4-6      # concrete — preferred when known
model_tier: mid               # fallback when concrete model isn't declared
```

The script reads `model` first; if absent, falls back to `model_tier`;
if both absent, uses a default (suggest `mid`). When `model` is set,
the script derives the tier via a model→tier lookup table (used for
prior bootstrapping). When only `model_tier` is set, dollar-cost
estimates are unavailable (no concrete pricing).

### 4. Calibration mechanics

- **Storage:** per-project YAML at `.fabrika/calibration.yml`
- **Update formula:** EWMA-blended against bundled priors; weight
  shifts toward local data as run count grows:
  `estimate = w · local_mean + (1 − w) · prior` where
  `w = count / (count + k)` for a smoothing constant `k`
- **Granularity:** per-(workflow, agent, model). Calibration key
  example: `agentic-workflow-lifecycle.methodology-reviewer.claude-sonnet-4-6`
- **Surfaced in readout:** confidence indicator displays run count and
  typical error
- **Soft invalidation:** when a model identifier changes (e.g.,
  `claude-sonnet-4-6` → `claude-sonnet-4-7`), the new key falls back
  to priors; old data is not migrated

### 5. Bundled priors are tier-level only

Per-(workflow, agent, model) entries do not ship as priors — they
bootstrap from tier-level priors on first use. Bundled priors are a
small table:

| Tier | Model example | Typical input tokens | Typical output tokens |
|---|---|---|---|
| Low | Haiku 4.5 | ~10,000 | ~2,000 |
| Mid | Sonnet 4.6 | ~12,000 | ~5,000 |
| High | Opus 4.7 | ~15,000 | ~8,000 |

These represent baselines for one typical agent invocation. An
**iteration multiplier** layered on top: 1x for the minimum estimate
(single review pass), 2x for the likely-upper estimate (one full
review-revise cycle, applied only to review/implement participants).
Maintenance: refresh priors during HARVEST flow when accumulated
cross-project data shows tier-level guesses are systematically wrong.
No new infrastructure.

### 6. Dollar costs displayed only with concrete model, framed as API pricing

When `model` is specified, the readout includes dollar estimates
using published API pricing. Always paired with the subscription
caveat (see readout example above). When only `model_tier` is set,
tokens-only readout with a hint that declaring a model unlocks dollar
estimates.

### 7. Token budget gate is advisory by default, opt-in soft warning

Project config exposes a `token_budget_warn` field, defaulted off.
When set, the orchestrator displays a soft warning if the estimate
exceeds the threshold ("This plan exceeds your configured warning
threshold of 50k tokens. Proceed, revise, or update threshold?").
No hard gate. Documentation explains how to enable; orchestrator
does not nudge owners toward setting it.

### 8. Estimation runs as a deterministic script, not via the orchestrator LLM

Estimation lives at `core/scripts/estimate-tokens.py` (Python via
`uv`). The orchestrator invokes it via Bash; the script reads the
plan, agent metadata, and calibration data, applies coefficients,
returns JSON. Costs ~zero tokens to recompute — the orchestrator can
re-invoke it freely.

### 9. Cadence: estimation surfaces at plan-stage, not design-alignment

| Moment | Behavior |
|---|---|
| Design alignment (Q&A walk) | No structured estimate. Orchestrator may *informally* mention cost at major scope decisions if it would meaningfully shape the choice. |
| Plan draft (workflow-planner returns plan) | Structured readout — token band, calibration metadata, optional dollar costs |
| Plan revision iterations | Re-estimate after each revision (cheap because deterministic) |
| Plan approval | Dedicated readout in approval message |
| Owner request | Anytime |

### 10. Centralized estimation protocol document

A single new document, `core/workflows/token-estimation.md`, defines
the estimation protocol — script CLI surface, readout format,
calibration update rules. Existing workflow files reference it with
a one-line pointer rather than inlining instructions. This matches
Fabrika's context decomposition principle and avoids 4-way
duplication.

## Scope

### Structural Precedents Established

This PRD introduces two conventions Fabrika hasn't had before. Both
need to be named explicitly in canonical files so the next change
that touches them has a precedent to point at:

1. **YAML frontmatter on agent prompts.** Currently no agent prompt
   in `core/agents/` has a frontmatter block — files start with
   `# Agent Title` or a paragraph. PRD-15 introduces the convention
   for the `model` / `model_tier` fields. Decision needed during
   execution: do archetype files (`core/agents/archetypes/*.md`)
   also gain frontmatter, or only concrete agents? Recommendation:
   archetypes declare *required* frontmatter fields; concrete agents
   provide values. The frontmatter schema lives at a new file
   `core/agents/agent-frontmatter-spec.md` referenced from
   AGENT-CATALOG (rather than embedded in the catalog itself —
   AGENT-CATALOG is a roster, not a schema spec).

2. **Executable code in `core/scripts/`.** Fabrika has been pure
   prose-and-config; this PRD adds the first script. The convention
   needs to be captured (likely in `core/FABRIKA.md` or as a short
   `core/scripts/README.md`): scripts in `core/scripts/` are
   deterministic helpers invokable by the orchestrator, ship to
   consumers verbatim, and require only `uv` (no per-script
   environments).

### New files

| File | Purpose |
|---|---|
| `core/workflows/token-estimation.md` | Defines the estimation protocol — script invocation contract, readout format, calibration update protocol, cadence rules |
| `core/scripts/estimate-tokens.py` | Deterministic estimator — reads plan + agent metadata + calibration; emits JSON estimate |
| `core/scripts/README.md` | Captures the `core/scripts/` convention (what belongs here, runtime expectations, how the orchestrator invokes them) |
| `core/calibration/priors.yml` | Bundled tier-level priors (the table in Decision 5) plus model→tier lookup table |
| `core/templates/Calibration-Template.yml` | Template for consumer-project calibration file (`.fabrika/calibration.yml`) |
| `core/agents/agent-frontmatter-spec.md` | Defines the agent frontmatter schema (`model`, `model_tier`, future fields). Referenced from AGENT-CATALOG.md and from each archetype |

### Modified files

| File | Change |
|---|---|
| `core/workflows/development-workflow.md` | One-line reference to `token-estimation.md` at plan-presentation step |
| `core/workflows/analytics-workspace.md` | One-line reference at plan-presentation step (Tier 1 and Tier 2) |
| `core/workflows/agentic-workflow-lifecycle.md` | One-line reference inside Step 2 (Align), specifically at the seam where the workflow-planner's output is presented to the owner — not at the top of the Align section. Readers should find the estimation pointer where they'd look for "what the orchestrator does with the planner's output." |
| `core/workflows/design-alignment.md` | Soft note about informal cost-awareness during Q&A walk; no structured estimate at this stage |
| `core/agents/*.md` (concrete agent prompts, ~26 files) | Add YAML frontmatter block (new convention) with `model` and/or `model_tier` fields |
| `core/agents/archetypes/*.md` | Declare required frontmatter fields per archetype (each archetype specifies what frontmatter its concrete agents must provide) |
| `core/agents/AGENT-CATALOG.md` | Cross-reference to the new `agent-frontmatter-spec.md` for schema; do not embed schema in the catalog |
| `core/Document-Catalog.md` | New entries for: `.fabrika/calibration.yml` (consumer-project artifact), `core/calibration/priors.yml` (bundled framework artifact), and `Calibration-Template.yml` (under Templates → "Included based on project type") |
| `core/FABRIKA.md` | Surface token-estimation capability to the agent if FABRIKA.md surfaces other capabilities; add the `core/scripts/` convention paragraph if not captured in `core/scripts/README.md` |
| `Domain-Language.md` | Add entries for new vocabulary: "calibration", "tier-level prior", "EWMA blend", "iteration multiplier", "soft invalidation", "calibration key" |
| `integrations/claude-code/CLAUDE.md` | Surface estimation availability; note `model:` field in agent frontmatter |
| `integrations/copilot/copilot-instructions.md` | Surface estimation availability; document Copilot CLI limitation (no `model:` support yet, falls back to picker) |
| `MANIFEST_SPEC.md` | Document `token_budget_warn` project-config field; **also** enumerate the full `.fabrika/` directory contract (`manifest.yml` existing, `calibration.yml` new, plus any other implicit contents) — the `.fabrika/` directory has been growing implicitly and this PRD is a good moment to make it explicit |
| `BOOTSTRAP.md` | Scaffold `.fabrika/calibration.yml` at install time (empty, ready for first run) |
| `UPDATE.md` | Update guidance for existing consumers picking up 0.24.0 (calibration-file scaffolding step, agent-frontmatter migration) |
| `MIGRATIONS.md` | Migration entry: existing consumer projects need a calibration file scaffolded; agent metadata additions are non-breaking but documented |
| `README.md` | Add token estimation to the user-visible feature list and any workflow description summary |
| `examples/**` | Any example project with a `.fabrika/` directory gets a scaffolded `calibration.yml` so the example stays runnable post-update (no version-bump impact per CLAUDE.md, but listed for completeness) |
| `VERSION` | 0.23.0 → 0.24.0 |
| `CHANGELOG.md` | Entry under 0.24.0 |

### What does NOT change

- Agent prompt instructions (only frontmatter gains `model`/`model_tier`; no behavioral changes)
- Actual execution of plans (estimation is advisory, not a gate)
- Post-execution token reporting (the session summary continues to
  report actual tokens used)
- Phase-level granularity (per-(workflow, agent, model) is the v1 ceiling; phase splits stay deferred)
- Hard token budget gating (out of scope; advisory only)

## Open Items (carry into execution)

These are concrete TBDs the workflow-planner and context-engineer
should resolve during execution rather than being re-aligned now:

- **CLI surface for `estimate-tokens.py`** — exact arguments, JSON
  schema for input/output. Likely something like
  `estimate-tokens.py --plan <path> --agents <dir> --calibration <path> [--override-model <id>]`
- **Initial smoothing constant `k`** in the EWMA blend formula.
  Recommend k ≈ 5 (priors dominate until ~5 runs accumulate, then
  local data takes over) — confirm during implementation.
- **Model→tier lookup table contents** — needs to cover all current
  Claude/GPT models likely to be referenced. Lives in `priors.yml`.
- **Token-estimation.md structure** — final document outline, including
  worked examples.
- **Copilot CLI limitation handling** — integration template should
  document the fallback behavior; no code workaround needed since
  GitHub is shipping parity. Watch for parity ship date.
- **Calibration update trigger** — when does the script update
  `.fabrika/calibration.yml` after a run completes? Likely a separate
  invocation (`estimate-tokens.py --record-actuals ...`) called as a
  post-workflow hook. Confirm during implementation.

## Migration (Consumer Impact)

Consumer projects updating to 0.24.0 will need to:

1. Copy new files: `core/workflows/token-estimation.md`,
   `core/scripts/estimate-tokens.py`, `core/calibration/priors.yml`,
   `core/templates/Calibration-Template.yml`
2. Update modified workflow files (refs to token-estimation.md)
3. Add `model` or `model_tier` frontmatter to their copies of agent
   prompts (or accept the default)
4. Scaffold an empty `.fabrika/calibration.yml` from the template
5. Optionally configure `token_budget_warn` in project config

The MIGRATIONS.md entry should include a one-liner script for
scaffolding the calibration file, plus guidance on which agents
benefit most from `model` vs `model_tier` declarations.

## Architectural Note (Captured for Future Consideration)

During alignment, owner observed that Fabrika's current
"agent-archetype-in-workflow" model may be better expressed as
**composable skills** parameterized by workflow + phase. As agent
archetypes get reused across more workflows (e.g., implementer
archetype from PRD-03), per-(workflow, agent) calibration risks
duplicating identical work under different keys.

This is **out of scope for PRD-15** but should be captured as a
future CR. The per-(workflow, agent, model) calibration granularity
chosen here is compatible with that future direction — if agents
become skills, the calibration key naturally becomes
`(skill, invocation-context, model)`.
