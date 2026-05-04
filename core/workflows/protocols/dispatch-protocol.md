# Dispatch Protocol

How the orchestrator hands off work to sub-agents. This document
defines what to provide and what to withhold at each invocation point.

The core principle: reviewers, validators, and designers receive
strict dispatch (plan + file paths + rubric, nothing else) to
preserve independence. Planners and coordinators receive contextual
dispatch (richer project state) because they are creating plans, not
judging implementations.

For archetype-level tool profiles and base contracts, see
`core/agents/archetypes/`.

---

## Dispatch Tiers

**Strict dispatch** — the orchestrator provides only the approved
plan, file paths, and rubric pointer. No opinions, no hints, no
pre-digested summaries. The sub-agent must form its own judgment.

**Contextual dispatch** — the orchestrator provides broader project
context: conversation history, owner preferences, prior decisions.
The sub-agent uses this context to make better plans, not to confirm
the orchestrator's conclusions.

Both tiers have required fields. The orchestrator must provide every
required field — omitting a required field means the sub-agent is
working blind on something it needs.

---

## Lightweight Dispatch

Lightweight dispatch is a reduced-ceremony invocation path for trivial
implementation changes. It does NOT mean the orchestrator implements
directly — the orchestrator NEVER writes production code. Lightweight
dispatch reduces the ceremony of the dispatch payload, not the dispatch
itself.

**All three conditions must be true for lightweight dispatch:**

1. The change touches exactly one file
2. The spec fully specifies the edit (no design decisions required by
   the implementer)
3. The change is not a new feature, refactor, or architectural change

**What changes under lightweight dispatch:**
- The plan field can be inline text in the dispatch (not a spec file
  path)
- Architecture pointers are optional
- Version state is only required if the change bumps a version

**What does NOT change:**
- The orchestrator still dispatches to the implementer agent
- The implementer still produces the standard output (changed files,
  summary, deviations)
- The evaluation cycle still runs after implementation

---

## Tier-Conditional Dispatch

Complexity tiers determine which agents the orchestrator invokes for a
given story. Tier-conditional dispatch is orthogonal to dispatch tiers
(strict vs. contextual) — it controls WHICH agents are dispatched, not
HOW they are dispatched. Each dispatched agent still receives its
standard payload per the per-agent contracts in the archetype files
below.

### Patch Tier

| Agent | Invoked? | Notes |
|-------|----------|-------|
| Planner (planning mode) | No | Story file IS the spec |
| Implementer | Yes | Standard contextual dispatch |
| Code-reviewer | Yes | Strict dispatch; story file serves as the spec |
| Test-writer | No | Unless sprint contract testing strategy mandates it for the affected area |
| Planner (validation mode) | No | Acceptance criteria are trivially verifiable from the story |
| Architect (design mode) | No | |
| Architect (review mode) | No | |

Retry cap: 2 cycles. Promotion to Story if exceeded.

### Story Tier

| Agent | Invoked? | Notes |
|-------|----------|-------|
| Planner (planning mode) | Yes | Standard contextual dispatch |
| Implementer | Yes | Standard contextual dispatch |
| Code-reviewer | Yes | Standard strict dispatch |
| Test-writer | Yes | Mode depends on testing approach |
| Planner (validation mode) | Yes | Standard strict dispatch |
| Architect (design mode) | Optional | Per existing rules (new modules, restructuring) |
| Architect (review mode) | Optional | Per existing rules (structural concerns flagged) |

Retry cap: 3 cycles.

### Deep Story Tier

| Agent | Invoked? | Notes |
|-------|----------|-------|
| Planner (planning mode) | Yes | Contextual dispatch with research document path as additional field |
| Implementer | Yes | Standard contextual dispatch |
| Code-reviewer | Yes | Standard strict dispatch |
| Test-writer | Yes | Mode depends on testing approach |
| Planner (validation mode) | Yes | Standard strict dispatch |
| Architect (design mode) | **Mandatory** | Not optional — must review before implementation |
| Architect (review mode) | **Mandatory** | Not optional — must review after implementation |

Retry cap: 3 cycles.

---

## Per-Agent Contracts

Per-agent dispatch contracts are organized by archetype in separate
files. Each file defines the required fields, conditional fields, and
fields that must NOT be included (to preserve independence) for every
agent in that archetype.

| Archetype | Contract file | Agents covered |
|-----------|--------------|----------------|
| Planner | [planner-contracts.md](dispatch/planner-contracts.md) | product-manager (planning + validation), experiment-planner (planning + validation), api-designer (planning + validation), analysis-planner (+ validation), planner base (planning + validation), workflow-planner |
| Reviewer | [reviewer-contracts.md](dispatch/reviewer-contracts.md) | code-reviewer, logic-reviewer, prompt-reviewer, security-reviewer, performance-reviewer (domain + analytics modes), reviewer base, methodology-reviewer |
| Validator | [validator-contracts.md](dispatch/validator-contracts.md) | test-writer (spec-first + coverage), model-evaluator, eval-engineer, data-quality-engineer, data-validator, validator base, structural-validator |
| Implementer | [implementer-contracts.md](dispatch/implementer-contracts.md) | software-engineer, data-engineer, data-analyst (+ write-only + execute-metadata), ml-engineer, ai-engineer, implementer base, agentic-engineer |
| Architect | [architect-contracts.md](dispatch/architect-contracts.md) | software-architect (design + review + ad hoc), data-architect (design + review + ad hoc), context-architect |
| Coordinator | [coordinator-contracts.md](dispatch/coordinator-contracts.md) | scrum-master (sprint planning + retro) |
| Designer | [designer-contracts.md](dispatch/designer-contracts.md) | visualization-designer (design + review) |

---

## Retry Protocol

When an evaluator FAILs an implementation, the implementer reads the
review reports directly and revises. The orchestrator routes file
paths — it does not synthesize, interpret, or translate findings. See
`core/design-principles.md` for the rationale (implementer-reviewer
pairing).

1. The orchestrator dispatches the implementer for revision with: the
   original plan (spec or plan file), relevant file paths, and a
   `Review report paths` field containing the paths to all evaluation
   reports from the current cycle. The implementer reads the review
   reports directly alongside the original plan.
2. The implementer addresses each finding and returns an updated
   output summary.
3. The orchestrator sanity-checks the fixes: does the implementer's
   summary address each evaluator finding? If a finding was clearly
   missed, dispatch clarification back to the implementer before
   burning a retry cycle.
4. The orchestrator re-invokes ALL evaluators with fresh dispatch —
   same payload as the original invocation, updated file paths, no
   prior evaluation report included. All evaluators re-check, not
   just the ones that failed. A fix can introduce new issues in areas
   that previously passed.
5. Each evaluator writes its new report with a versioned filename:
   `[TICKET]-code-review-v2.md` (not overwriting the original).
6. **Maximum 3 retry cycles.** After 3 failed cycles, the
   orchestrator reads all reports across all cycles, diagnoses the
   failure pattern (same issue recurring? different issues each time?
   narrowing but not resolving?), and presents the diagnosis to the
   user in plain language. The user decides the path forward: rescope,
   break into smaller stories, research the blocker, or override.
   The orchestrator dispatches accordingly; the review cycle still
   runs after intervention.

---

## Output Format Constraints

The dispatch contracts above specify what the orchestrator sends to
each agent (inputs). This section specifies what agents return
(outputs). The goal is compaction: each agent produces a compressed
artifact that is self-contained for whoever reads it next. See
`core/design-principles.md` for the principle and anti-patterns.

Organized by role category, not per-agent, to complement rather than
duplicate the per-agent dispatch contracts.

### Research and exploration outputs

Sub-agent research, file lookups, and exploratory reads should return:

- File paths with line numbers and relevant code snippets
- Behavior summaries and constraints discovered
- Gotchas or surprising findings that affect the plan

Exclude: full file contents, raw tool call outputs, exploration
dead-ends that did not yield useful signal.

### Plan and spec outputs

All planner agents produce plans or specs that must be self-contained
— the implementer reads the plan, not the research that produced it.

- Include actual code snippets showing what changes (not just
  descriptions of what to change)
- Include mechanically verifiable acceptance criteria
- Include the test or validation approach

### Evaluation report outputs

All reviewers and validators produce evaluation reports. Lead with
signal, not ceremony.

- Lead with the verdict (PASS / FAIL / SOUND / UNSOUND / etc.)
- Include specific file paths and line numbers for each finding
- Suggest a fix approach, not just "this is wrong"

Exclude: general praise, restated code the reader can already see,
preamble about the review process.

### Sub-agent returns

When any agent is dispatched as a sub-agent by another agent, the
dispatch contract should specify what signal the parent needs. The
sub-agent returns compressed results so the parent does not need to
re-read the sub-agent's inputs.

If the dispatch does not specify signal requirements, default to:
paths, summaries, and verdicts — not raw content.
