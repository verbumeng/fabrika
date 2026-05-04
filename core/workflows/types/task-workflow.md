# Task Workflow

The unparameterized workflow type — the domain-agnostic foundation
that all specialized workflows extend. Provides the full multi-agent
lifecycle (task, plan, implement, review, validate, deliver) without
any domain assumptions about what the task produces or how it is
evaluated. For trivially scoped work, simple mode lets the
orchestrator plan inline and skip the task folder — see the Simple
Mode section below.

In Fabrika's three-tier abstraction, this workflow sits in the middle:
**skills** (what agents do in one invocation) compose into **workflow
types** (multi-agent patterns), which compose into **projects**. The
task workflow is the base workflow type: it invokes base agents
(planner, implementer, reviewer, validator) with their unparameterized
skills. Specialized workflows add domain knowledge at each tier:
the analytics workflow adds data-specific agents, tiered review, and
domain criteria; domain workflows (software-development,
data-engineering, etc.) add sprint ceremony via the story-execution
protocol (`core/workflows/protocols/story-execution.md`) and
domain-specific planners, reviewers, validators, and implementers.
This base workflow carries no domain knowledge — its criteria come
from the plan, not from a domain model.

## Agent Roster

| Role | Agent | Purpose |
|------|-------|---------|
| Planner | [planner](../agents/planner.md) | Reads task document, produces plan with deliverables, acceptance criteria, sequencing |
| Implementer | [implementer](../agents/implementer.md) | Executes the plan, produces deliverables |
| Reviewer | [reviewer](../agents/reviewer.md) | Reviews against plan's acceptance criteria + general quality signals |
| Validator | [validator](../agents/validator.md) | Validates deliverables satisfy the task document |

All four are base agents — domain-agnostic versions that specialized
agents extend.

---

## Design Alignment for Complex Tasks

Before the standard lifecycle, the orchestrator assesses whether the
work warrants structured alignment. If the orchestrator determines
the work is a new phase or feature rather than a task, Design
Alignment fires per the standard triggers. Individual tasks use the
task/plan flow regardless of complexity.

Design Alignment triggers:

- New project or new phase
- Owner explicitly requests alignment
- Orchestrator detects ambiguity that cannot be resolved with
  clarifying questions alone

When triggered, Design Alignment produces a PRD (or Charter + PRD for
new projects). It does not produce task documents — tasks use the
standard task/plan flow without Design Alignment unless complexity
triggers escalation to a PRD.

Simple tasks skip alignment and proceed directly to the lifecycle
below.

---

## Simple Mode

For trivially scoped work, the orchestrator can skip the standard
lifecycle and plan inline. Simple mode is a ceremony reduction within
the task workflow, not a separate workflow.

**What it is.** The orchestrator conceives the plan in a sentence or
two, dispatches the implementer directly with the plan embedded in
the dispatch context, and routes the output through the reviewer.
There is no task folder, no plan.md artifact, and no planner subagent
invocation.

**Scope assessment threshold.** Judgment-based. If the orchestrator
can fully conceive the plan — deliverables, acceptance criteria, and
sequencing — in a sentence or two without needing the planner's
structured expansion, the task qualifies for simple mode. When in
doubt, use standard mode. Examples that qualify: a single file edit
with a clear spec, a configuration change, a brief research lookup.
Examples that do not: multi-step work with dependencies, tasks
requiring stakeholder alignment, anything where the acceptance
criteria need discussion.

**What it skips.**
- No task folder (`tasks/[date-name]/`)
- No plan.md artifact
- No planner subagent dispatch
- No validator dispatch (the reviewer covers quality)

**What it keeps.**
- Implementer dispatch (the orchestrator never implements directly)
- Reviewer dispatch (receives the inline plan and the diff)
- The commit message serves as the primary documentation artifact

**Reviewer behavior in simple mode.** The reviewer receives strict
dispatch with: the orchestrator's inline plan (as the spec equivalent)
and file paths to the deliverables. The reviewer checks the
deliverables against the inline plan and general quality signals.
If the reviewer fails the implementation, the standard review-revise
loop applies (max 3 cycles).

**Promotion to standard mode.** If the orchestrator discovers during
dispatch that the work is more complex than initially assessed (e.g.,
the implementer surfaces unexpected dependencies, or the inline plan
grows beyond a sentence or two), the orchestrator promotes to standard
mode: creates the task folder, invokes the planner, and proceeds with
the full lifecycle. Promotion is one-way.

---

## Bug Tasks

Bugs are tasks with reproduction context. They use this workflow
(simple or standard mode) with a task document that includes:

- **Observed behavior** — what actually happens
- **Expected behavior** — what should happen
- **Reproduction steps** — how to trigger the bug
- **Environment context** — where it was observed (if relevant)

The reviewer additionally verifies that the fix addresses the
reproduction case — not just that the code changed, but that the
observed behavior now matches the expected behavior. No separate
agents, templates, or workflow changes — bugs are tasks with a
specific task document structure.

For sprint-based projects, bugs that surface during sprints follow
the project's bug workflow (`docs/02-Engineering/bug-workflow.md`)
rather than this task workflow.

---

## Lifecycle

```
task -> plan -> implement -> review ->
[revise -> re-review]* -> validate -> deliver
```

When reading Tier 1 context documents at task start, the orchestrator
checks the document's `last-validated` frontmatter against the
project's freshness threshold. If stale, the orchestrator emits a
one-line note (e.g., "Note: Architecture Overview last validated 6
weeks ago") and loads the document with a caveat. See
`core/workflows/protocols/story-execution.md` (Freshness-Aware
Context Loading) for the full protocol.

### Task Document

The owner describes what they need. The orchestrator captures this as
`tasks/[date-name]/task.md` using the Task Template
(`core/templates/Task-Template.md`).

The task document establishes:
- **What** is needed — the goal, question, or deliverable
- **Who** needs it — the audience and their context
- **When** — deadline and whether it is hard or soft
- **What format** — how the output should be delivered
- **Constraints** — boundaries, limitations, known challenges

### Plan

Planner reads the task document and produces a plan at
`tasks/[date-name]/plan.md` using the Plan Template
(`core/templates/Plan-Template.md`).

The plan includes:
- **Deliverables** — what will be produced, in what format, stored
  where
- **Acceptance criteria** — how to judge completeness and quality for
  each deliverable
- **Sequencing** — order of work if multi-step
- **Constraints and assumptions** — what is being assumed, what is
  out of scope
- **Validation approach** — how the validator will confirm the output
  satisfies the task document

No domain-specific sections (no data sources, no SQL logic, no module
changes). The plan's structure comes from the task document, not from a
predefined domain model.

After the plan is written, present the token cost estimate per
`core/workflows/protocols/token-estimation.md`. Present the plan to the owner
for approval before execution begins.

### Implement

Implementer receives contextual dispatch with the plan and task document.
Produces deliverables to `tasks/[date-name]/work/`. Artifact type
depends entirely on the plan — documents, code, configurations,
research, designs, data, anything.

### Review

Reviewer receives strict dispatch: plan, task document, and file paths to the
deliverables. Reviews against:

1. **Plan's acceptance criteria** — each criterion is a checklist item
2. **General quality signals** — completeness, consistency, clarity,
   correctness

No domain-specific checklist — the checklist is derived from what the
plan said the deliverables should be and how they should be evaluated.

Writes evaluation report to
`docs/evaluations/[task-name]-review.md`.

### Revise (if needed)

Implementer reads the review report directly (not orchestrator
summaries) alongside the original plan. Addresses findings. See
`core/design-principles.md` for the rationale behind direct
implementer-reviewer pairing.

### Re-review (if revised)

Reviewer re-checks. Versioned report
(`docs/evaluations/[task-name]-review-v2.md`). Loop until pass or 3
failed cycles, at which point the orchestrator diagnoses the failure
pattern and presents it to the user for intervention.

### Validate

Validator receives strict dispatch: task document, plan, and
deliverable file paths. Checks:

- **Task document satisfaction** — does the output answer the task
  document's question or fulfill its goal?
- **Deliverable completeness** — is everything the plan promised
  present?
- **Acceptance criteria coverage** — does each criterion have
  corresponding evidence?
- **Internal consistency** — do deliverables agree with each other
  and with the task document?

Writes internal evaluation to
`docs/evaluations/[task-name]-validation.md`. Writes human-facing
validation report to `tasks/[date-name]/validation-report.md`.

### Deliver

Planner writes `tasks/[date-name]/outcome.md` using the Outcome
Template (`core/templates/Outcome-Template.md`). Presents outcome and
validation report to the owner using the Task Outcome Briefing format
(`core/briefings/task-outcome-briefing.md`). Prompts for follow-up.

---

## Review-Revise Loop

The task workflow's review-revise loop follows the universal pattern
defined in `core/design-principles.md` (implementer-reviewer pairing):

- **Implementer reads reviews directly.** The implementer reads the
  review report from `docs/evaluations/` alongside the original plan.
  The orchestrator routes file paths — it does not synthesize or
  interpret findings.
- **Mandatory re-review after every revision.** Revised work goes back
  through the reviewer. A fix can introduce new issues.
- **3-cycle cap.** After 3 failed review cycles, the orchestrator
  diagnoses the failure pattern across all cycles and presents it to
  the user in plain language. User decides the path forward. Review
  cycle still runs after intervention.

---

## Task Folder Structure

```
tasks/[date-name]/
  task.md                           <- What is needed
  plan.md                           <- How it will be done
  work/                             <- The deliverables
    (artifacts depend on the task)
  outcome.md                        <- Results and methodology
  validation-report.md              <- Human-facing evidence chain

docs/evaluations/
  [task-name]-review.md             <- Reviewer findings
  [task-name]-review-v2.md          <- Versioned if revision occurred
  [task-name]-validation.md         <- Validator internal report
```

---

## Exploratory Iteration and Handoff

After delivery, the orchestrator prompts the user:

> "Results delivered. If you have follow-up work, start a new chat
> and reference `tasks/[date-name]/outcome.md` and the task document
> for context."

Each task is a bounded unit of work with its own task document, plan,
validation, and outcome. Follow-up iteration starts a new chat that
picks up from the outcome. The planner in the new session reads the
prior outcome as part of its orientation.

---

## Knowledge Pipeline Cadence

When a project has a `wiki/` directory, the knowledge pipeline runs at
cadences tied to task delivery rather than sprints. For the full
pipeline specification, see
`core/workflows/protocols/knowledge-pipeline.md`. For the step-by-step
procedure, see `core/workflows/protocols/knowledge-synthesis.md`.

| Cadence | Pipeline Phases | What Happens |
|---------|----------------|--------------|
| After each task delivery | Phases 1-2 (Extract + Index) | Index the task's task document, plan, and outcome as a batch in `wiki/meta/` |
| Monthly or on demand | Phases 3-4 (Synthesize + Link) | Synthesize recurring themes across tasks, update topic articles and `wiki/index.md` narrative. Triggered when 3+ batch indexes exist without a synthesis pass, or on owner request. |
| Quarterly | All phases (full reintegration) | Re-score salience, rewrite stale articles, merge/retire topics, rebuild narrative, clean up batch entries. Triggered when 3+ months since last reintegration. |

Extract+Index runs as part of the Deliver phase when a `wiki/`
directory exists. After the outcome report is written, the agent
indexes the task's task document, plan, and outcome as a batch. This
is automatic — no additional user action required.
