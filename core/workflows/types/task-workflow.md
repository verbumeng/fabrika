# Task Workflow

The base workflow type — the domain-agnostic foundation that all
specialized workflows parameterize. Provides the full multi-agent
lifecycle (brief, plan, implement, review, validate, deliver) without
any domain assumptions about what the task produces or how it is
evaluated.

The analytics-workspace workflow is a parameterized version of this
base, adding data-specific agents (data-analyst, logic-reviewer,
data-validator), tiered workflows (local vs. production), and
domain-specific review criteria. Sprint-based workflows (development
workflow) add sprint ceremony, stories, and domain-specific planners.
This base workflow carries no domain knowledge — its criteria come
from the plan, not from a domain model.

## Agent Roster

| Role | Agent | Purpose |
|------|-------|---------|
| Planner | [planner](../agents/planner.md) | Reads brief, produces plan with deliverables, acceptance criteria, sequencing |
| Implementer | [implementer](../agents/implementer.md) | Executes the plan, produces deliverables |
| Reviewer | [reviewer](../agents/reviewer.md) | Reviews against plan's acceptance criteria + general quality signals |
| Validator | [validator](../agents/validator.md) | Validates deliverables satisfy the brief |

All four are base agents — domain-agnostic versions that specialized
agents extend.

---

## Design Alignment for Complex Tasks

Before the standard lifecycle, the orchestrator assesses whether the
task warrants structured alignment. If any complexity trigger is met,
the orchestrator runs the Design Alignment protocol
(`core/workflows/protocols/design-alignment.md`) before creating the brief:

- Multiple stakeholders with different needs
- Estimated effort exceeds 2 days
- High-stakes outcome (significant decisions depend on this)
- Orchestrator detects ambiguity in the ask that cannot be resolved
  with clarifying questions alone

When triggered, Design Alignment produces an enhanced brief with
deeper coverage of scope, terminology, and success criteria. The
output uses the standard brief template — it is not a Charter or PRD
(the task workflow is task-based, not sprint-based).

Simple tasks skip alignment and proceed directly to the lifecycle
below. The universal complexity assessment (CR-18, when codified)
will formalize when Design Alignment fires across all workflow types.

---

## Lifecycle

```
brief -> plan -> implement -> review ->
[revise -> re-review]* -> validate -> deliver
```

### Brief

The owner describes what they need. The orchestrator captures this as
`tasks/[date-name]/brief.md` using the Brief Template
(`core/templates/Brief-Template.md`).

The brief establishes:
- **What** is needed — the goal, question, or deliverable
- **Who** needs it — the audience and their context
- **When** — deadline and whether it is hard or soft
- **What format** — how the output should be delivered
- **Constraints** — boundaries, limitations, known challenges

For complex tasks (Design Alignment triggered), the brief includes
deeper scope, terminology, and success criteria coverage.

### Plan

Planner reads the brief and produces a plan at
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
  satisfies the brief

No domain-specific sections (no data sources, no SQL logic, no module
changes). The plan's structure comes from the brief, not from a
predefined domain model.

After the plan is written, present the token cost estimate per
`core/workflows/protocols/token-estimation.md`. Present the plan to the owner
for approval before execution begins.

### Implement

Implementer receives contextual dispatch with the plan and brief.
Produces deliverables to `tasks/[date-name]/work/`. Artifact type
depends entirely on the plan — documents, code, configurations,
research, designs, data, anything.

### Review

Reviewer receives strict dispatch: plan, brief, and file paths to the
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

Validator receives strict dispatch: brief, plan, and deliverable file
paths. Checks:

- **Brief satisfaction** — does the output answer the brief's
  question or fulfill its goal?
- **Deliverable completeness** — is everything the plan promised
  present?
- **Acceptance criteria coverage** — does each criterion have
  corresponding evidence?
- **Internal consistency** — do deliverables agree with each other
  and with the brief?

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
  brief.md                          <- What is needed
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
> and reference `tasks/[date-name]/outcome.md` and the brief for
> context."

Each task is a bounded unit of work with its own brief, plan,
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
| After each task delivery | Phases 1-2 (Extract + Index) | Index the task's brief, plan, and outcome as a batch in `wiki/meta/` |
| Monthly or on demand | Phases 3-4 (Synthesize + Link) | Synthesize recurring themes across tasks, update topic articles and `wiki/index.md` narrative. Triggered when 3+ batch indexes exist without a synthesis pass, or on owner request. |
| Quarterly | All phases (full reintegration) | Re-score salience, rewrite stale articles, merge/retire topics, rebuild narrative, clean up batch entries. Triggered when 3+ months since last reintegration. |

Extract+Index runs as part of the Deliver phase when a `wiki/`
directory exists. After the outcome report is written, the agent
indexes the task's brief, plan, and outcome as a batch. This is
automatic — no additional user action required.
