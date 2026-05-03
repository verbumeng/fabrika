# CR-17: Task Workspace Project Type

**Version target:** TBD (minor bump — new project type in core/)
**Dependencies:** CR-03 (implementer archetype — task-implementer
follows the pattern), CR-13 (review-revise loop — task-workspace
adopts the redesigned loop from day one)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

Fabrika currently offers three project type families:

1. **Sprint-based** (web-app, data-app, analytics-engineering,
   data-engineering, ml-engineering, ai-engineering, automation,
   library) — for building software products with sprints, stories,
   and domain-specific agents.
2. **Analytics-workspace** — task-based, for ad hoc analysis with
   data-flavored agents (analysis-planner, logic-reviewer,
   data-validator, data-analyst).
3. **Agentic-workflow** — methodology-based, for maintaining
   agent/workflow systems with structural agents (workflow-planner,
   methodology-reviewer, structural-validator, context-engineer).

Each type ships with domain-specific agents, workflows, and document
structures. This works well when the task fits a domain — but there
is a gap when it does not. Examples:

- Writing a research report or technical document
- Planning and executing an event or operational process
- Building a training curriculum
- Conducting a competitive analysis
- Migrating content between systems
- Any ad hoc project where the work is real and consequential but
  none of the existing types describe what you are doing

Today these tasks either get shoehorned into the closest type
(inheriting irrelevant domain ceremony — logic reviewers checking
prose, sprint planning for a one-off deliverable) or they get done
without Fabrika entirely, losing the engineering controls that make
agent-driven work reliable.

The analytics-workspace is the closest model — task-based, no
sprints, brief-plan-execute-validate-deliver lifecycle. But its
agents, review checklists, validation criteria, and folder structure
all assume the task produces data analysis artifacts. A domain-
agnostic version of that same architecture would serve as a catch-all
for tasks that need agentic rigor without domain assumptions.

## Solution Direction

A new project type called `task-workspace` that provides the full
agentic engineering framework — dispatch contracts, strict and
contextual context, implementer-reviewer pairing, validation,
iteration with cycle caps, outcome delivery — without any domain-
specific flavoring.

### Core Principles

1. **Same rigor, no domain.** Every engineering control that exists
   in analytics-workspace applies here: dispatch contracts, strict
   dispatch for reviewers/validators, contextual dispatch for the
   planner, implementer reads reviews directly, mandatory re-review
   after revision, 3-cycle cap with orchestrator diagnosis. The
   difference is that the agents, checklists, and validation criteria
   are domain-agnostic.

2. **Task-based lifecycle.** Same shape as analytics-workspace:
   brief -> plan -> implement -> review -> [revise -> re-review]* ->
   validate -> deliver. No sprints, no stories, no epics. Each task
   is a bounded unit of work.

3. **Agnostic agents.** The roster contains agents that make no
   assumptions about what the task produces. They work with whatever
   the plan says the deliverables are — code, documents, designs,
   configurations, research, anything.

4. **Minimal ceremony, maximum control.** The point is not to add
   ceremony but to ensure that whatever the task is, an independent
   reviewer checks it, a validator confirms it meets the brief, and
   there is a structured iteration path when it does not.

### Agent Roster

| Role | Agent | Description |
|------|-------|-------------|
| Planner | task-planner | Reads the brief and produces a plan: deliverables, acceptance criteria, sequencing. Domain-agnostic — derives structure from the brief, not from a predefined domain model. |
| Implementer | task-implementer | Executes the plan. Produces whatever artifacts the plan specifies. No assumptions about artifact type. |
| Reviewer | task-reviewer | Reviews implementation against the plan and brief. Checklist is derived from the plan's acceptance criteria and general quality signals (completeness, consistency, clarity, correctness). No domain-specific checklist items. |
| Validator | task-validator | Validates that the output satisfies the brief's question/goal. Checks deliverable completeness, acceptance criteria coverage, and internal consistency. Produces a validation report. |

No supplemental reviewers, no designer, no architect, no coordinator.
This is the minimal viable roster for controlled task execution. If a
task turns out to need domain-specific review (e.g., it is actually a
data analysis), the user should use the appropriate project type
instead.

### Workflow

```
brief -> plan -> implement -> review ->
[revise -> re-review]* -> validate -> deliver
```

**Brief.** The user describes what they need. The orchestrator
captures this as `tasks/[date-name]/brief.md`. For complex tasks, the
orchestrator runs Design Alignment
(`core/workflows/design-alignment.md`) to produce an enhanced brief.
Complexity triggers are the same as analytics-workspace but
domain-agnostic: multiple stakeholders, estimated effort >2 days,
high-stakes outcome, or orchestrator detects ambiguity.

**Plan.** Task-planner reads the brief and produces a plan at
`tasks/[date-name]/plan.md`. The plan includes: deliverables (what
will be produced), acceptance criteria (how to judge completeness and
quality), sequencing (order of work if multi-step), and any
constraints or assumptions. No domain-specific sections.

**Implement.** Task-implementer receives contextual dispatch with the
plan and brief. Produces deliverables to `tasks/[date-name]/work/`.
Artifact type depends entirely on the plan — code files, documents,
configurations, research notes, whatever.

**Review.** Task-reviewer receives strict dispatch: plan, brief, and
file paths to the implementation. Reviews against the plan's
acceptance criteria and general quality signals. Writes evaluation
report to `docs/evaluations/[task-name]-review.md`. No domain-
specific checklist — the checklist is derived from what the plan said
the deliverables should be and how they should be evaluated.

**Revise (if needed).** Task-implementer reads the review report
directly (not orchestrator summaries) alongside the original plan.
Addresses findings.

**Re-review (if revised).** Task-reviewer re-checks. Versioned
report. Loop until green or 3 failed cycles -> orchestrator diagnosis
-> user intervention. Follows the review-revise loop design from
CR-13.

**Validate.** Task-validator receives strict dispatch: brief, plan,
and deliverable file paths. Checks: every acceptance criterion in the
plan is met, deliverables are complete (nothing promised in the plan
is missing), deliverables are internally consistent, and the output
answers the brief's question or fulfills its goal. Writes internal
evaluation to `docs/evaluations/[task-name]-validation.md`. Writes
human-facing validation report to
`tasks/[date-name]/validation-report.md`.

**Deliver.** Task-planner writes `tasks/[date-name]/outcome.md`.
Presents outcome and validation report to the owner using the Task
Outcome Briefing format. Prompts for follow-up.

### Task Folder Structure

```
tasks/[date-name]/
  brief.md                          <- What is needed
  plan.md                           <- How it will be done
  work/                             <- The deliverables
    (artifacts depend on the task)
  outcome.md                        <- Results and methodology
  validation-report.md              <- Human-facing evidence chain

docs/evaluations/
  [task-name]-review.md             <- Task-reviewer findings
  [task-name]-review-v2.md          <- Versioned if revision occurred
  [task-name]-validation.md         <- Task-validator internal report
```

### Bootstrap (Phase 2T)

A new Phase 2T in BOOTSTRAP.md for `task-workspace`, parallel to
Phase 2W (analytics-workspace) and Phase 2A (agentic-workflow).

Simpler than either — no source registry, no version tracking, no
structural protocol. The onboarding conversation asks:

1. **"What kind of work will you typically do in this workspace?"** —
   not to classify into a type (that already happened) but to
   understand the shape of tasks so the planner can orient faster.
2. **"Are there any tools, platforms, or systems your tasks typically
   involve?"** — captured in the project instruction file so agents
   have baseline context.
3. **"How do you want deliverables organized? The default is one
   folder per task with a brief, plan, work artifacts, and outcome.
   Does that work?"** — allows customization if the user has a
   preference.

Creates:
- Project instruction file with workspace context
- `tasks/` directory
- `docs/evaluations/` directory
- `STATUS.md` with workspace type and active task count
- Agents installed per the roster

### Type Alignment Signal

Added to BOOTSTRAP.md Phase 1.2 type alignment table:

| Type | Strong Signals | Disambiguating Question |
|------|----------------|------------------------|
| `task-workspace` | "I just need to get something done", "none of these fit", "it's not really code or data", "one-off project", "generic tasks", "catch-all" | Is this work that doesn't fit into software development, data analysis, or methodology maintenance — but you still want structured agent support? |

The disambiguating question is important: task-workspace is the
fallback, not the default. If a more specific type fits, use it —
domain-specific agents produce better results than generic ones.

## Scope

### New files

| File | Purpose |
|------|---------|
| `core/agents/task-planner.md` | Planner agent — domain-agnostic task planning |
| `core/agents/task-implementer.md` | Implementer agent — executes plans, any artifact type |
| `core/agents/task-reviewer.md` | Reviewer agent — reviews against plan acceptance criteria |
| `core/agents/task-validator.md` | Validator agent — validates deliverables against brief |
| `core/workflows/task-workspace.md` | Workflow definition (parallel to analytics-workspace.md) |

### Modified files

| File | Change |
|------|--------|
| `core/agents/AGENT-CATALOG.md` | Add task-workspace roster to Task-Based Types table; use workflow-type language in new sections |
| `core/Document-Catalog.md` | Add task-workspace to applicable project types for relevant documents |
| `core/workflows/dispatch-protocol.md` | Add dispatch contracts for task-workspace agents |
| `BOOTSTRAP.md` | Add task-workspace to type alignment table, add Phase 2T, add on-demand workflow addition mechanism (or create ADD-WORKFLOW.md) |
| `ADOPT.md` | Add task-workspace as an adoptable type |
| `MANIFEST_SPEC.md` | Add task-workspace as a valid project_type value (structural schema change to workflow_types deferred to CR-22) |
| `Domain-Language.md` | Add task-workspace definition; introduce "workflow type" as first-class term with "project type" as legacy/transition alias |
| `integrations/claude-code/CLAUDE.md` | Reflect task-workspace availability and agent roster; use workflow-type language in new sections |
| `integrations/copilot/copilot-instructions.md` | Reflect task-workspace availability and agent roster; use workflow-type language in new sections |
| `README.md` | Update project type count and list |
| `VERSION` | Bump |
| `CHANGELOG.md` | Entry |

### What does NOT change

- Sprint-based workflows (this is task-based, no overlap)
- Analytics-workspace workflow (stays domain-specific for data work)
- Agentic-workflow lifecycle (methodology-based, separate concern)
- Existing agent prompts (no modifications to current agents)
- Rubrics (task-reviewer derives its checklist from the plan, not
  from a predefined rubric — open question whether a rubric should
  exist)

## Design Decisions to Align

1. **Should task-workspace have rubrics?** Analytics-workspace has
   none (checklist is built into agent prompts). Sprint-based types
   have rubrics per role. For task-workspace, the reviewer's
   "checklist" is derived from the plan's acceptance criteria — there
   is no predefined domain checklist to grade against. A generic
   quality rubric (completeness, consistency, clarity, correctness)
   could exist, but it might be so generic as to be useless. Leaning
   toward: no rubric, reviewer derives criteria from the plan.

2. **Should task-workspace support Design Alignment?** The analytics-
   workspace triggers Design Alignment for complex analyses. Task-
   workspace could do the same for complex tasks. Leaning toward: yes,
   same trigger pattern (multiple stakeholders, >2 day effort, high
   stakes, ambiguity detected). Design Alignment produces an enhanced
   brief, not a Charter or PRD — same as analytics-workspace.

3. **Should task-workspace support the wiki knowledge pipeline?**
   Analytics-workspace indexes task outcomes into the wiki on delivery.
   Task-workspace could do the same — the brief/plan/outcome structure
   is identical. Leaning toward: yes, same cadence model (extract +
   index on delivery, synthesize monthly or on demand).

4. **Should task-workspace support task promotion?** Analytics-
   workspace promotes recurring analyses through five levels
   (templatize, scriptify, visualize, automate, spin out). Some of
   these are analytics-specific (visualize). A generic version might
   just be: templatize and automate. Or task promotion might not
   apply — if a task recurs, it probably belongs in a more specific
   project type. Leaning toward: not in v1, revisit if the pattern
   emerges.

5. **Name: `task-workspace` vs alternatives.** Considered:
   `general-workspace` (too vague), `ad-hoc` (too informal),
   `generic` (pejorative connotation). `task-workspace` mirrors
   `analytics-workspace` and signals the task-based lifecycle. Open
   to other suggestions.

6. **Can task-workspace combine with other types?** Analytics-
   workspace and agentic-workflow cannot combine with sprint-based
   types. Should task-workspace be combinable? Leaning toward: no —
   if you need domain-specific agents alongside generic ones, use the
   domain-specific type. Task-workspace is the fallback, not a
   supplement.

## Alignment Notes (Design Philosophy Session, 2026-05-02)

The following decisions were resolved during a design philosophy
session that produced the Phase 2 roadmap (ROADMAP-v2.md):

1. **This is the BASE workflow, not just a fallback.** The task
   workspace is the purest expression of the multi-agent pattern.
   All specialized workflows (analytics, sprint-based, etc.) are
   parameterized specializations of this base. This reframes the
   entire project type system — "project types" are becoming
   "workflow types."

2. **Agents should be base agents, not domain-specific agents.** The
   CR originally proposed task-planner, task-implementer,
   task-reviewer, task-validator. These should instead be the BASE
   agents — the domain-agnostic versions that all specialized agents
   derive from. Naming is open (could be "planner" or keep
   "task-planner" as the base name), but the conceptual role is
   clear: these are the unparameterized skills.

3. **Design Decision #5 (Naming) is reframed.** The name
   "task-workspace" remains the working name for implementation, but
   the understanding is that as the workflow composition model
   matures (CR-22), naming may evolve to reflect workflow types
   rather than project types. For now, the name signals the
   task-based lifecycle, which is accurate.

4. **Design Decision #6 (Combinability) is inverted in principle.**
   The workflow composition model means projects SHOULD eventually
   compose multiple workflow types. For CR-17's implementation, the
   existing single-type constraint can remain — the combinability
   redesign is CR-22's scope. But the base workflow should be
   designed with composition in mind.

5. **Connects to CR-22 (Composable Skills).** CR-17 is the first
   concrete expression of the composable skills vision. The base
   agents created here demonstrate that workflow-agnostic agents
   work. CR-22 will formalize the pattern; CR-17 proves it.

6. **Establish "workflow type" vocabulary.** CR-17 introduces
   "workflow type" as a first-class term in Domain-Language.md,
   with "project type" noted as the legacy/transition term. The
   AGENT-CATALOG, BOOTSTRAP, and integration templates use
   workflow-type language in the new sections CR-17 adds. Existing
   sections are not rewritten — they update organically as later
   CRs touch them. The structural schema change (manifest
   `project_type` → `workflow_types`) is CR-22's scope.

7. **On-demand workflow addition mechanism.** Projects should be able
   to pull in new workflow types after initial bootstrap — not just
   at project creation. CR-17 establishes this pattern: when the
   orchestrator detects a workflow type is needed that is not
   installed, it guides the user through a mini-bootstrap that pulls
   the relevant agent files and workflow definition from Fabrika
   into the project. This is the workflow-level equivalent of
   ADOPT.md's tiered adoption. The mechanism should be documented
   in a new section of BOOTSTRAP.md (or a separate ADD-WORKFLOW.md)
   and referenced from the integration templates so the orchestrator
   knows when and how to trigger it.

8. **Fabrika's own self-understanding must update.** Fabrika is a
   consumer of itself (agentic-workflow project type since v0.11.0).
   CR-17 updates this self-understanding: Fabrika uses the
   "agentic workflow type" (not "agentic-workflow project type")
   and — like any project — can pull in other workflow types as
   needed. The project-level CLAUDE.md should reflect this shift.

9. **Integration templates must communicate the paradigm shift.**
   This is fundamental: the consumer project's CLAUDE.md and
   copilot-instructions.md must tell the orchestrator that projects
   are NOT bound to their declared project type. They can pull in
   any workflow type on demand — the right tool for the right
   problem at the right time. This must be prominent, not buried.
   The orchestrator should understand that when a user's work
   doesn't fit the installed workflow, the answer is to add a
   workflow type, not to shoehorn the work.

10. **ADOPT.md and UPDATE.md must carry this message.** Existing
    projects updating to the new version need to understand the
    shift. ADOPT.md should communicate that adopted projects gain
    the freedom to compose workflow types. UPDATE.md migration
    guidance for this version should flag the philosophical change:
    you are no longer locked into your declared type.

## Verification Criteria

- Task-workspace appears in BOOTSTRAP.md type alignment table with
  clear disambiguation from other types
- Phase 2T bootstrap produces a functional workspace with agents
  installed and task folder structure ready
- Agent roster is in AGENT-CATALOG with correct role mappings
- All four agent prompts follow established archetype patterns
  (implementer archetype for task-implementer, etc.)
- Dispatch contracts exist in dispatch-protocol.md for all four agents
- Workflow file documents the full lifecycle with phase details
- Integration templates reflect task-workspace availability
- Domain-Language.md defines the project type
- No domain-specific assumptions leak into agent prompts or workflow
  (no references to SQL, code, data, sprints, methodology, etc.
  unless used as examples of what task-workspace is NOT)

## Alignment Notes (CR-17 Execution Session, 2026-05-02/03)

The following decisions were resolved during execution alignment with
the owner.

1. **Naming: task-workflow, not task-workspace.** The workflow file
   should be `task-workflow.md`, not `task-workspace.md`. The
   "-workspace" suffix was inherited from analytics-workspace but
   "workflow" is the correct term in the compositional model. This
   renames the workflow file but not the project type value (which
   remains `task-workspace` in MANIFEST_SPEC until CR-22 restructures
   the schema).

2. **Base agent naming resolved.** The agents are `planner.md`,
   `implementer.md`, `reviewer.md`, `validator.md` — NOT
   task-planner, task-implementer, etc. These are the base agents:
   the unparameterized versions that all specialized agents
   (product-manager, code-reviewer, data-analyst, etc.) are
   domain-specific extensions of. (This confirms and strengthens
   Alignment Note #2 from the earlier session.)

3. **Design Alignment triggers connect to the universal complexity
   spectrum.** Design Alignment for complex tasks is confirmed (yes),
   but the trigger mechanism is part of the broader complexity
   assessment being formalized in CR-18. The base workflow doesn't
   independently define when Design Alignment fires — that's
   determined by the universal complexity assessment: ad-hoc work
   skips it, tasks may trigger it, stories and above always get
   structured planning.

4. **Wiki knowledge pipeline confirmed.** Task outcomes feed the wiki
   the same way analytics outcomes do: extract+index on delivery,
   synthesize monthly or on demand. Same cadence model as
   analytics-workspace.

5. **Task promotion deferred.** Task promotion (the five-level
   promotion workflow from analytics-workspace: templatize, scriptify,
   visualize, automate, spin out) does not apply to the generic base
   workflow. If a task recurs, the orchestrator should assess whether
   a more specific workflow type fits. Promotion is an analytics-
   specific concern, not a base workflow concern.

6. **No rubric for the base reviewer.** The base reviewer derives its
   checklist from the plan's acceptance criteria plus four general
   quality signals: completeness, consistency, clarity, correctness.
   There is no predefined rubric file. Domain-specific reviewers
   (code-reviewer, logic-reviewer) have rubrics because they have
   domain-specific criteria. The base reviewer is domain-agnostic —
   its criteria come from the plan, not from a rubric.

7. **ADD-WORKFLOW.md confirmed as separate file.** On-demand workflow
   addition is a distinct procedure, documented in its own file at the
   repo root. BOOTSTRAP.md points to it. Context decomposition
   principle applies.

8. **Brief as the base alignment artifact.** The owner identified that
   brief, story, PRD, and project charter are all points on the same
   spectrum — the orchestrator-to-owner alignment artifact at
   different complexity levels. A brief is the base (lightest). A PRD
   is a brief with more ceremony. A project charter is the
   highest-level alignment. This insight is out of scope for CR-17 but
   has been captured for a future CR. CR-17 uses the brief as its
   alignment artifact, which is correct.

9. **CR-17 scope clarification.** CR-17 creates the base workflow and
   base agents — that's its scope. The broader paradigm shift
   (dissolving the three project type categories, universal complexity
   assessment, unified document hierarchy) lives in downstream CRs
   (18, 22, 24, and a new CR for document hierarchy). CR-17 uses
   "workflow type" language in new content but does not restructure
   existing content.
