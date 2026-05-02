# PRD-13: Review-Revise Loop Redesign

**Version target:** TBD
**Dependencies:** PRD-03 (implementer archetype), PRD-11 (analytics
pre-execution review — implements the revised loop for analytics
workspace first)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

The review-revise loop across all three project types has two design
issues that undermine the implementer-reviewer pairing principle:

### 1. The orchestrator synthesizes fix instructions

When a reviewer fails an implementation, the current dispatch protocol
(Retry Protocol, dispatch-protocol.md lines 803-827) has the
orchestrator read all evaluation reports, synthesize findings into
"implementer-actionable fix instructions," and dispatch those to the
implementer. The orchestrator is interpreting what's wrong and deciding
what to fix — that is the implementer's job.

This mixes orchestration with implementation. The orchestrator could
misinterpret a reviewer finding, lose nuance, or prescribe a fix that
doesn't address the root cause. The implementer is the domain expert
who wrote the code — it is better positioned to read the review,
understand the finding in context, and determine the correct fix.

### 2. Re-review after revision is not explicit

The current protocol re-invokes failing evaluators after the
implementer addresses findings, but it is not explicit that revision
itself can introduce new errors. A fix to a join condition might break
a filter. A cost optimization might change aggregation logic. The
re-review must verify both that original findings were addressed AND
that no new issues were introduced.

## Solution

### Implementer reads reviews directly

After a reviewer writes its evaluation report to
`docs/evaluations/`, the orchestrator routes the review file path(s)
to the implementer. The implementer reads the review reports directly,
alongside the original plan/spec, and determines how to address each
finding. The orchestrator does not interpret, summarize, or prescribe
fixes.

This preserves the separation of concerns: reviewers review,
implementers implement, the orchestrator routes and manages the loop.

### Mandatory re-review after every revision

After any revision, ALL reviewers that assessed the original
implementation re-check — not just the ones that failed. A revision
to address a logic reviewer finding could introduce a performance
problem, or vice versa. Each reviewer writes a new versioned report
(`-v2.md`, `-v3.md`).

### 3-cycle cap with orchestrator diagnosis

The retry cap increases from 2 to 3 cycles. After 3 failed review
cycles:

1. **Orchestrator reads all review reports across all 3 cycles** and
   diagnoses the failure pattern:
   - Same finding recurring in all 3 cycles? The implementer doesn't
     understand the issue or cannot resolve it within the current
     approach.
   - Different findings each cycle? Fixes are introducing new
     problems — the approach may be fundamentally flawed.
   - Findings narrowing but not resolving? Close to resolution but
     needs targeted help on a specific issue.

2. **Orchestrator presents the diagnosis to the user** in plain
   language, using Domain Language terms where available. Explains:
   what failed, what the pattern across cycles was, and what it
   recommends as a path forward.

3. **User decides:** accept the orchestrator's recommendation, propose
   a different approach, or take manual control.

4. **Orchestrator dispatches the implementer** with the agreed path
   forward. The implementer still does the fixing — the orchestrator
   facilitates alignment between the user and the work, it does not
   write code.

5. **Review cycle still runs** after the intervention. The revision
   still needs green lights from all reviewers.

6. **If it still fails after intervention,** the orchestrator returns
   to the user again with an updated diagnosis. This continues until
   resolution — there is no hard cutoff after user intervention,
   just the user staying in the loop.

### Design philosophy: implementer-reviewer pairing

This change codifies a broader design philosophy that should be
stated explicitly in Fabrika's framework:

**Implementer-reviewer pairing:** Every implementer output gets an
independent review before it is considered complete or acted upon
downstream. The implementer produces, the reviewer independently
assesses, the implementer revises based on findings, and the reviewer
re-checks. The orchestrator routes but does not interpret or
synthesize.

**Implementer-validator pairing:** Every implementer output that
produces observable results gets validated against expected outcomes.
The nature of validation differs by workspace type:

- **Analytics workspace:** Validation is on actual execution output
  (data correctness, completeness, format).
- **Sprint-based:** Validation is on code correctness (test passage,
  acceptance criteria, security).
- **Agentic workflow:** Validation is on structural correctness
  (cross-references, pattern adherence, integration surface).

The principle is the same across all types: independent verification
that the output does what it is supposed to do.

## Scope

This is a cross-cutting change that affects all three project types.

### Modified files

| File | Change |
|---|---|
| `core/design-principles.md` | **New file.** Codifies implementer-reviewer pairing and implementer-validator pairing as cross-cutting framework principles |
| `core/workflows/dispatch-protocol.md` | Rewrite Retry Protocol section: implementer reads reviews directly, mandatory re-review after revision, 3-cycle cap, orchestrator diagnosis protocol |
| `core/workflows/development-workflow.md` | Update Completing a Story (Evaluation Cycle) feedback loop (steps 10-14) to reflect new retry protocol |
| `core/workflows/agentic-workflow-lifecycle.md` | Update verification retry flow in Step 5 to reflect new retry protocol |
| `core/workflows/analytics-workspace.md` | Will already be updated by PRD-11 — this PRD ensures the loop design is consistent with sprint-based and agentic |
| `core/agents/archetypes/implementer.md` | Add orientation step: "When invoked for revision, read the review report(s) at the provided paths alongside the original plan" |
| `integrations/claude-code/CLAUDE.md` | Reflect updated retry protocol |
| `integrations/copilot/copilot-instructions.md` | Reflect updated retry protocol |
| `VERSION` | Bump (minor — core workflow changes) |
| `CHANGELOG.md` | Entry for the new version |

### What does NOT change

- Reviewer and validator agent prompts (they already write
  independent reports — the change is in how those reports are
  consumed, not how they are produced)
- Strict dispatch for reviewers/validators (they still receive plan +
  file paths + rubric, no editorial — this principle is reinforced,
  not changed)
- The content or structure of evaluation reports

## Key Decisions (Aligned)

- **Pairing philosophy location:** Standalone
  `core/design-principles.md`. Cross-cutting principle that affects
  every agent interaction — keeping it in its own file makes it
  discoverable and avoids bloating the dispatch protocol.

- **3-cycle cap:** Fixed at 3 for all project types. No
  configurability. The user can always override after the orchestrator
  diagnosis, which already adapts to what went wrong regardless of
  project type.

- **Copilot state limitation:** No special handling needed. Copilot
  subagents already read all context from files at each step — the
  file-based state transfer pattern (review reports on disk) is
  reinforced by this change, not challenged by it.

## Verification Criteria

- Implementer agents receive review file paths, not orchestrator
  summaries, during revision dispatch
- All reviewers re-check after every revision (not just failing ones)
- 3-cycle cap is enforced before orchestrator diagnosis
- Orchestrator diagnosis identifies failure pattern across cycles
- User is presented with diagnosis and decides path forward
- Review cycle runs after user intervention
- Pattern is consistent across sprint-based, analytics-workspace,
  and agentic-workflow project types
- No regression to how reviewers produce their initial reports
