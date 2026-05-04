# Story Execution Protocol

Shared execution mechanics for work at story complexity or above,
regardless of domain. This protocol is referenced by all domain
workflow files. It is NOT a workflow type — it is a cross-cutting
procedure containing the mechanics that domain workflows compose with.

For the domain-specific agent roster, domain-specific gates, and
testing approach guidance for a particular domain, see the project's
domain workflow file:

- `core/workflows/types/software-development-workflow.md`
- `core/workflows/types/data-engineering-workflow.md`
- `core/workflows/types/analytics-engineering-workflow.md`
- `core/workflows/types/data-app-workflow.md`
- `core/workflows/types/ml-engineering-workflow.md`
- `core/workflows/types/ai-engineering-workflow.md`
- `core/workflows/types/library-workflow.md`

**Procedure classification:** Cross-cutting. Referenced by all domain
workflow types for work at story complexity or above.

---

## Design Alignment (Pre-Sprint)

Before sprint planning begins, the orchestrator runs Design Alignment
when triggered. Triggers: new project starting, new phase or major
feature, owner explicitly requests alignment, or the orchestrator
detects ambiguity (can't describe what the user wants in 2-3
sentences). See `core/workflows/protocols/design-alignment.md` for the full
protocol.

The document hierarchy:

1. Brain dump / owner idea
2. Design Alignment conversation (orchestrator mode)
3. Charter (first time) + PRD (per phase/feature)
4. Scrum master sprint planning (decomposes PRD into stories)
5. Per-story specs (planner agent)
6. Implementation

The orchestrator no longer creates epics and stories directly from
brain dumps. Brain dumps feed into Design Alignment, which produces
structured requirements that the scrum master then decomposes.

## Dispatch Protocol

Before invoking any sub-agent, read `core/workflows/protocols/dispatch-protocol.md` for what to provide and what to withhold. The dispatch protocol defines per-agent input contracts (what the orchestrator must hand over) and output contracts (what the sub-agent must produce). Two tiers: strict dispatch for reviewers, validators, and designers (plan + file paths + rubric only — no editorial); contextual dispatch for planners and coordinators (richer project state).

## Tier-Conditional Workflow Branching

Patch, Story, and Deep Story are ceremony tiers internal to story-type
work. They are unchanged from 0.29.0. These tiers do not apply to
tasks, bugs, or epics — those backlog types have their own ceremony
models (see `core/workflows/types/task-workflow.md` for task and bug
ceremony, `Domain-Language.md` for the full backlog type vocabulary).

Every story has a complexity tier assigned during sprint planning (see
`core/workflows/protocols/sprint-coordination.md`). The tier
determines which workflow gates apply. The orchestrator reads the
story's `tier` frontmatter field and routes to the appropriate path
below. If no tier is set, default to Story.

### Patch Path (tier: patch)

Patches are small, single-concern changes where the story file IS the
spec. The orchestrator skips spec creation and runs a reduced
evaluation cycle.

```
story file -> implementer -> code-reviewer -> commit
```

1. Read the story file and sprint contract
2. Read relevant project docs on demand, applying the freshness check described below (architecture, data model)
3. Skip spec creation — the story's acceptance criteria are the spec
4. Create feature branch: `feature/[PROJECT_KEY]-S-042-description`
5. Update story: `status: In Progress`
6. Dispatch the **implementer** — contextual dispatch per the dispatch
   protocol. Testing approach defaults to test-after for Patches.
7. Confirm the implementer's output: review implementation summary,
   verify files were created/modified as expected
8. Run tests — all pass (no regressions)
9. Run linter — no errors
10. Commit with conventional format
11. Invoke the **code-reviewer** — strict dispatch with story file
    (as the spec), file paths, and rubric pointer. Single reviewer
    only.
12. **If the code-reviewer fails the implementation:**
    - Dispatch the implementer for revision with the story file and
      the review report path
    - Re-invoke the code-reviewer with fresh dispatch
    - **Maximum 2 retry cycles.** If a Patch needs 3 rounds of
      review, the orchestrator promotes it to Story tier and presents
      the promotion to the owner before continuing
13. **If the code-reviewer passes:**
    - Update story: `status: In Review`, add `## Completion Summary`
    - Present session summary to the owner

No planner validation. No test-writer verification (unless the sprint
contract's testing strategy mandates it for the affected area). No
architect review.

### Story Path (tier: story)

The standard execution workflow. Follow "Starting a Story" and
"Completing a Story (Evaluation Cycle)" below with no modifications.
All existing gates apply.

### Deep Story Path (tier: deep-story)

Deep Stories add a mandatory research phase and architect review. The
orchestrator must complete all Deep Story gates — none are optional.

```
research -> planner (spec) -> architect review -> implementer ->
full evaluation cycle + architect structural review -> commit
```

1. **Research phase.** Before invoking the planner, the orchestrator
   conducts on-demand context research of the affected subsystems.
   Read architecture docs, relevant ADRs, data model, existing code
   in the affected area. Produce a research document at
   `docs/plans/[TICKET]-research.md` summarizing: subsystems affected,
   current state, constraints discovered, risks identified, and open
   questions. Compress the research findings before passing to the
   planner (compaction principle applies).
2. Invoke the **planner** in **planning mode** with the story content
   plus the research document path as an additional contextual field.
   The planner expands the story into a full spec at
   `docs/plans/[TICKET]-spec.md`.
3. After the spec is drafted, invoke the token cost estimation
   protocol.
4. Present the spec to the owner for approval.
5. **Mandatory architect review.** Invoke the appropriate architect
   in **design mode** with the spec's module section. This is NOT
   optional for Deep Stories — the architect must review before
   implementation begins. Present the architect's findings alongside
   the spec for owner approval.
6. Proceed with "Starting a Story" steps 8-10 (branch creation,
   status update, testing approach branching).
7. After implementation, run the full evaluation cycle (steps 1-9 of
   "Completing a Story").
8. **Mandatory architect structural review.** After the evaluation
   cycle passes (or as part of it), invoke the architect in **review
   mode**. This is NOT optional for Deep Stories.
9. Proceed with story completion (steps 15-19 of "Completing a
   Story").

### Tier Promotion (Mid-Execution)

A Patch can be promoted to Story if:
- The code-reviewer flags scope creep
- The implementer discovers the change is more complex than expected
- The orchestrator detects the implementer touching >3 files
- The Patch fails 2 review cycles (automatic promotion)

A Story can be promoted to Deep Story if:
- The planner flags that the spec requires research into unfamiliar
  subsystems
- The architect (if optionally invoked) rates the structural risk as
  high
- The owner requests promotion

Promotion is one-way (up only) and triggers the orchestrator to
present the situation to the owner before continuing. Demotion
(Deep Story to Story) is owner-initiated only.

## Freshness-Aware Context Loading

When loading Tier 1 context documents at story/task start, the
orchestrator checks each document's `last-validated` frontmatter field
against the project's freshness threshold. This applies to all workflow
types that load Tier 1 docs — domain workflows, task workflow, and
any future workflow that reads structural context at start.

**Freshness threshold.** Configurable per project, recorded in the
project's instruction file (CLAUDE.md or equivalent) as
`freshness-threshold`. Default: 2 completed sprints (~4 weeks). If no
threshold is configured, use the default. Individual documents can
override the global threshold via their own `freshness-threshold`
frontmatter field (useful for docs that drift slowly, like Domain
Language).

**Passive freshness note at story/task start.** The freshness check at
story/task start is passive. When the orchestrator detects a stale
document during orientation, it emits a one-line warning in its
orientation output (e.g., "Note: Architecture Overview last validated
6 weeks ago") and proceeds with Strategy B — load the document with a
caveat. No blocking, no user interaction, no triage at start. The
orchestrator includes the document in the dispatch payload with the
caveat note prepended: "This document was last validated on [date]. If
your work touches areas described here, verify against the actual code
before relying on it."

**Strategy B: Load with caveat (universal default).** Load the stale
document with a caveat note prepended. This is the default for ALL
tiers — Patch, Story, and Deep Story alike.

**Strategy A: Skip and research (owner override only).** Do not load
the stale document. Strategy A exists only as an explicit owner
override for docs the owner knows are seriously wrong.

**Triage belongs to sweeps, not story start.** The three-option triage
(re-validate, mark for refresh, accept staleness) is NOT performed at
story/task start. It belongs only in periodic sweeps — maintenance
sessions for sprint projects, on-demand sweeps for non-sprint projects.
See `core/workflows/protocols/sprint-coordination.md` for the sprint
maintenance sweep.

See the Freshness Metadata section in `core/Document-Catalog.md` for
which documents carry the `last-validated` field.

## Starting a Story
1. Read the story file (or issue tracker ticket) and the sprint contract for this sprint
2. Read relevant project docs on demand, applying the freshness check described above: Architecture Overview, Data Model, relevant ADRs, research notes
3. Read the grading rubrics at `docs/02-Engineering/rubrics/` to understand evaluation criteria
4. Invoke the **planner** agent in **planning mode** to expand the story into a full implementation spec (saved to `docs/plans/[TICKET]-spec.md`)
5. After the spec is drafted, invoke the token cost estimation protocol (`core/workflows/protocols/token-estimation.md`) to present the cost estimate alongside the spec briefing.
6. Present the spec to the owner for approval using the **Spec Briefing** format (see briefing docs)
7. **(Optional) Invoke the architect agent for design review.** If the spec proposes new modules, significant restructuring, or changes to component boundaries, dispatch the appropriate architect in **design mode** with the spec's module section. The architect reviews proposed module depth, interface design, and component boundaries. Present the architect's findings alongside the spec for owner approval. Skip if the story is a small feature change within existing module boundaries.
   For Deep Story tier, architect review is mandatory — see
   "Tier-Conditional Workflow Branching" above.
8. Create feature branch: `feature/[PROJECT_KEY]-S-042-description`
9. Update story: `status: In Progress`
10. **Branch on testing approach.** Read the sprint contract's testing
   approach for this story (assigned by the scrum master during sprint
   planning). The testing approach determines implementation flow:

   **If testing approach = TDD:**
   1. Dispatch the **test-writer** in **spec-first mode** — strict
      dispatch with approved spec and test conventions only (no source
      paths). The test-writer writes tests for one behavior or a small
      batch of related behaviors (one vertical slice).
   2. Dispatch the **implementer** — contextual dispatch per the
      dispatch protocol, plus a "Tests to pass" field pointing to the
      failing tests from step 1. The implementer writes the minimum
      code necessary to make those specific tests pass.
   3. Repeat steps 1-2 for each remaining behavior identified in the
      spec. The orchestrator manages the loop.
   4. Once all spec behaviors have passing tests, dispatch the
      implementer for **refactor** — same dispatch plus instruction
      to improve code structure while keeping tests green.
   5. (Optional) Dispatch the **architect** in review mode after refactor.
   6. Proceed to Completing a Story (Evaluation Cycle).

   **If testing approach = Test-informed:**
   1. Dispatch the **implementer** — contextual dispatch per the
      dispatch protocol.
   2. Dispatch the **test-writer** in **coverage mode** — strict
      dispatch with spec, source paths, and test conventions.
   3. (Optional) Dispatch the implementer for refactor if the
      test-writer identified structural issues.
   4. Proceed to Completing a Story (Evaluation Cycle).

   **If testing approach = Test-after (or not specified):**
   1. Dispatch the **implementer** — contextual dispatch per the
      dispatch protocol.
   2. Proceed to Completing a Story (Evaluation Cycle). The
      test-writer is invoked during the evaluation cycle as before.

   **Lightweight dispatch** (trivial changes — single-file edits where
   the spec fully specifies the change and it's not a new feature,
   refactor, or architectural change): the orchestrator still
   dispatches to the implementer, but uses the lightweight dispatch
   path. Testing approach defaults to test-after for lightweight
   dispatch.

   **Cross-domain stories** (spec contains a Task Decomposition
   section): each task runs in its own session with the appropriate
   domain implementer and its own evaluation cycle. The testing
   approach applies per-task. See "Multi-Domain Story Completion"
   below.

## Completing a Story (Evaluation Cycle)

Before marking a story complete, run the full evaluation cycle:

1. Confirm the implementer's output: review the implementation summary,
   verify files were created/modified as expected
2. Run tests — all pass (including existing tests — no regressions)
3. Run linter — no errors
4. Commit with conventional format: `feat([PROJECT_KEY]-S-042): description`
5. Invoke the **reviewer** agent — strict dispatch with spec, file
   paths, and rubric pointer. The reviewer reviews against acceptance
   criteria, rubrics, and runs security scans
6. Invoke the **validator** agent — strict dispatch (coverage mode).
   For TDD stories, the test-writer verifies that no tests were
   broken during refactor and checks for coverage gaps beyond the
   spec-first tests. For test-informed stories, the test-writer
   verifies coverage. For test-after stories, the test-writer writes
   and verifies tests. Runs E2E verification if applicable.
7. Invoke the **planner** agent in **validation mode** — strict
   dispatch. It verifies acceptance criteria from the sprint contract
   are met
8. **(Optional) Invoke the architect agent for structural evaluation.**
   For Deep Story tier, architect structural evaluation is mandatory —
   see "Tier-Conditional Workflow Branching" above.
9. Each evaluator writes a report to
   `docs/evaluations/[TICKET]-[agent]-review.md`

**If any evaluator fails the implementation (Feedback Loop):**

10. Dispatch the implementer for revision with: the original spec,
    relevant file paths, and a `Review report paths` field containing
    the paths to all evaluation reports from the current cycle.
11. The implementer addresses each finding and returns an updated
    output summary.
12. Sanity-check the fixes.
13. Re-invoke ALL evaluators with fresh dispatch.
14. **Maximum 3 retry cycles** (2 for Patch tier).

**If all evaluators pass:**

15. Update project docs if implementation diverged
16. Create an ADR for any significant technical decision
17. Update story: `status: In Review`, add `## Completion Summary`
18. If an external task management system is configured, mark done
19. Present the session summary to the owner

## Multi-Domain Story Completion

When a story's spec contains a Task Decomposition section (multiple
implementation domains), each task runs as its own session:

### Per-Task Sessions

Each task runs in a separate session with the domain's implementer:

1. Read the spec's Task Decomposition for this task
2. Dispatch to the domain implementer
3. After implementation, run the evaluation cycle
4. Include prior task output summaries as context for subsequent tasks
5. **Session handoff:** After the task's evaluation cycle passes,
   issue the deterministic handoff prompt

### Integration Session (Final)

After all per-task sessions complete:

1. No implementer dispatch — this session verifies integration
2. Invoke the **planner** agent in **validation mode**
3. Invoke the **reviewer** agent on the full change set
4. If integration issues are found, dispatch to the relevant domain
   implementer

### Guidance for Orchestrators

- **Prefer single-domain stories.** Multi-domain stories are the
  exception, not the norm.
- **Two-domain stories** are acceptable when the domains are tightly
  coupled.
- **Three+ domain stories** should be decomposed by the planner.

## Sprint Planning
1. Invoke the **scrum-master** (coordinator) agent to facilitate
2. Check maintenance timing
3. Query backlog and check for unfinished stories
4. The scrum-master assesses **sprint topology**
5. Propose 2-3 stories (10-15 points)
6. Create sprint file, sprint contract, and sprint progress file
7. Update story assignments and create `features.json` entries
8. If an external task management system is configured, create tasks
9. Present the sprint plan to the owner for approval

## Ideation & Backlog Grooming
When the owner is brainstorming features, re-prioritizing, or refining stories:
1. New stories defined -> create story files
2. Existing stories re-scoped -> update story frontmatter/body
3. Ideas that are exploratory -> add to Someday-Maybe
4. Scope moves between phases -> update Phase Definitions

## Research & Technical Discussion
When the conversation involves investigating a technology or debating an approach:
1. Technology evaluation -> create/update research doc
2. Data source investigation -> create/update research note
3. Discussion produces a decision -> create an ADR
4. Discussion changes architecture or data model -> update those docs

## Bug Reporting & Fix Workflow
When the owner reports a bug, read and follow `docs/02-Engineering/bug-workflow.md`.

## Architecture Assessment (Ad Hoc)
When the owner requests an architectural review of existing code, or when the orchestrator detects refactoring discussion:
1. Identify the appropriate architect agent based on domain
2. Dispatch with contextual dispatch (ad hoc mode)
3. The architect produces an assessment report
4. Present the assessment to the owner
5. For approved refactor proposals: create stories in the backlog
