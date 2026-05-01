# PRD-15: Token Cost Estimation Across Workspaces

**Version target:** TBD
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

2. **No feedback loop during alignment.** As the user iterates on a
   plan during alignment — adding scope, raising stakes, requesting
   additional review cycles — the token cost changes. Without
   real-time estimates, the user cannot make trade-offs between
   thoroughness and cost during the planning phase when those
   trade-offs are cheapest to make.

## Solution Direction (Needs Design Alignment)

### Token estimation at plan alignment

Once a plan has been aligned (or at each iteration of the plan during
alignment), the orchestrator presents an estimated token cost:

- **Minimum estimate:** Assumes single review cycle, all green lights,
  no revisions. This is the best-case cost for executing the plan as
  written.
- **Likely upper estimate:** Assumes two full review-revise cycles
  (the typical upper bound for plans that need iteration). This gives
  the user a sense of what the plan would cost if things don't go
  smoothly on the first pass.

The estimate is presented alongside the plan for approval:

> "Estimated token cost: ~15,000 tokens (minimum, single review
> cycle) to ~28,000 tokens (if two review cycles needed). This
> does not include the alignment conversation tokens already used."

### Estimation during alignment iterations

As the plan evolves during alignment, each iteration recalculates:

> "Current plan estimate: ~15,000 - 28,000 tokens"
> [User adds a new requirement]
> "Updated plan estimate: ~22,000 - 38,000 tokens"

This gives the user a running sense of how their decisions affect
cost. If a requirement pushes the estimate significantly higher, the
user can make an informed decision about whether it's worth it.

### Applies across all workspace types

| Workspace type | When estimate is shown | What it covers |
|---|---|---|
| Analytics workspace | After plan approval, before workflow begins | Write + review cycles + execute + validate + deliver |
| Sprint-based | After spec approval, before implementation begins | Implement + evaluation cycle (review, test, validate) |
| Agentic workflow | After plan approval, before execution begins | Implement + verification cycle (methodology, structural, architectural review) |

### Estimation methodology

Token estimates are based on:

- **Agent prompt sizes** — known from the agent prompt files
- **Expected input sizes** — estimated from file sizes in the plan
  (spec, source docs, architecture docs, etc.)
- **Expected output sizes** — estimated from typical output patterns
  for each agent type
- **Number of agent invocations** — determined by the workflow (how
  many reviewers, whether performance review is needed, etc.)
- **Iteration multiplier** — 1x for minimum, 2x for likely upper
  (each review-revise cycle approximately doubles the reviewer +
  implementer token cost)

This is a heuristic, not an exact calculation. The estimate should
be within 30-50% of actual for typical workflows. Edge cases
(unusually large codebases, complex multi-domain stories) may
exceed estimates.

## Scope (Preliminary)

### Likely modified files

| File | Change |
|---|---|
| `core/workflows/development-workflow.md` | Add token estimation step after spec approval |
| `core/workflows/analytics-workspace.md` | Add token estimation step after plan approval |
| `core/workflows/agentic-workflow-lifecycle.md` | Add token estimation step after plan approval |
| `core/workflows/design-alignment.md` | Add running estimate during alignment iterations |
| `integrations/claude-code/CLAUDE.md` | Reflect token estimation availability |
| `integrations/copilot/copilot-instructions.md` | Reflect token estimation availability |
| `VERSION` | TBD |
| `CHANGELOG.md` | Entry |

### What does NOT change

- Agent prompts (estimation is an orchestrator function, not an agent
  function)
- The actual execution of plans (estimation is advisory, not a gate)
- Post-execution token reporting (the session summary continues to
  report actual tokens used)

## Open Questions

- Should the estimate include a dollar cost translation based on the
  LLM pricing model (e.g., Claude API pricing)? This would require
  knowing which model is being used and its per-token cost.
- Should there be a configurable token budget that triggers a warning
  or confirmation before proceeding? ("This plan exceeds your
  configured token budget of 50,000 tokens. Proceed?")
- How accurate can heuristic estimation be in practice? This may need
  calibration data from real workflow executions before the estimates
  are useful. Should the first version just collect actuals vs.
  estimates to build a calibration baseline?
- Should token estimates account for context compression? Long
  conversations compress prior messages, which affects how many tokens
  are actually sent to the model vs. how many the user "pays for."
