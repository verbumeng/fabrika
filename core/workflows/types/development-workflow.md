# Development Workflow

The agent drives the development process proactively. Do not wait for the owner to orchestrate each step.

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

## Starting a Story
1. Read the story file (or issue tracker ticket) and the sprint contract for this sprint
2. Read relevant project docs on demand: Architecture Overview, Data Model, relevant ADRs, research notes
3. Read the grading rubrics at `docs/02-Engineering/rubrics/` to understand evaluation criteria
4. Invoke the **planner** agent in **planning mode** to expand the story into a full implementation spec (saved to `docs/plans/[TICKET]-spec.md`)
5. After the spec is drafted, invoke the token cost estimation protocol (`core/workflows/protocols/token-estimation.md`) to present the cost estimate alongside the spec briefing.
6. Present the spec to the owner for approval using the **Spec Briefing** format (see briefing docs)
7. **(Optional) Invoke the architect agent for design review.** If the spec proposes new modules, significant restructuring, or changes to component boundaries, dispatch the appropriate architect (software-architect or data-architect based on project type) in **design mode** with the spec's module section. The architect reviews proposed module depth, interface design, and component boundaries. Present the architect's findings alongside the spec for owner approval. Skip if the story is a small feature change within existing module boundaries.
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
      spec. The orchestrator manages the loop. When the tool supports
      persistent agent sessions (e.g., Claude Code), reuse the same
      test-writer and implementer sessions across cycles to preserve
      context. When it does not (e.g., Copilot subagents), each
      dispatch is self-contained — include all prior test files and
      implementation files in the dispatch payload.
   4. Once all spec behaviors have passing tests, dispatch the
      implementer for **refactor** — same dispatch plus instruction
      to improve code structure while keeping tests green.
   5. (Optional, if story is architecturally flagged or code-reviewer's
      Module Depth criterion scored Partial/Fail) Dispatch the
      **architect** in review mode after refactor.
   6. Proceed to Completing a Story (Evaluation Cycle).

   **If testing approach = Test-informed:**
   1. Dispatch the **implementer** — contextual dispatch per the
      dispatch protocol. The implementer has access to the spec's
      Test Boundaries section (if produced by the planner), which
      identifies expected behaviors, I/O contracts, and edge cases
      that tests will cover. This shapes implementation choices
      (keeping interfaces testable, not hiding logic in private
      methods) but does not change the dispatch mechanics.
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
8. **(Optional) Invoke the architect agent for structural evaluation.** If the implementation creates new modules, changes component boundaries, or the code-reviewer flagged structural concerns (Module Depth / Interface Simplicity criterion scored Partial or Fail), dispatch the appropriate architect in **review mode** with strict dispatch. The architect evaluates whether the implementation maintains or degrades module depth. This supplements the code-reviewer — the code-reviewer evaluates code quality, the architect evaluates structural design. Skip for implementations that work entirely within existing module boundaries.
9. Each evaluator writes a report to
   `docs/evaluations/[TICKET]-[agent]-review.md`

**If any evaluator fails the implementation (Feedback Loop):**

10. Dispatch the implementer for revision with: the original spec,
    relevant file paths, and a `Review report paths` field containing
    the paths to all evaluation reports from the current cycle. The
    implementer reads the review reports directly alongside the
    original plan — the orchestrator does not synthesize or interpret
    findings. See `core/design-principles.md` for the rationale.
11. The implementer addresses each finding and returns an updated
    output summary.
12. Sanity-check the fixes: does the implementer's summary address
    each evaluator finding? If a finding was clearly missed, dispatch
    clarification back to the implementer before burning a retry cycle.
13. Re-invoke ALL evaluators with fresh dispatch — same spec, same
    rubric, updated file paths. No prior evaluation report included.
    All evaluators re-check, not just the ones that failed — a fix
    can introduce new issues in areas that previously passed.
14. **Maximum 3 retry cycles** through steps 10-13. After 3 failed
    cycles, the orchestrator reads all reports across all cycles,
    diagnoses the failure pattern (same issue recurring? different
    issues each time? narrowing but not resolving?), and presents the
    diagnosis to the user in plain language. The user decides the path
    forward: rescope, break into smaller stories, research the
    blocker, or override. The review cycle still runs after
    intervention.

**If all evaluators pass:**

15. Update project docs if implementation diverged (architecture, data
    model, research notes)
16. Create an ADR for any significant technical decision made during
    implementation
17. Update story: `status: In Review`, add `## Completion Summary`
18. If an external task management system is configured, mark the
    corresponding task as done
19. Present the session summary to the owner using the **Session
    Summary Briefing** format (see briefing docs)

## Multi-Domain Story Completion

When a story's spec contains a Task Decomposition section (multiple
implementation domains), each task runs as its own session:

### Per-Task Sessions

Each task runs in a separate session with the domain's implementer:

1. Read the spec's Task Decomposition for this task — scope, files,
   interface contracts
2. Dispatch to the domain implementer with: task section from the
   spec, interface contracts, file paths, relevant architecture docs
3. After implementation, run the evaluation cycle above — with the
   domain-appropriate validator (data-quality-engineer for pipeline
   tasks, model-evaluator for ML tasks, etc.)
4. Include prior task output summaries as context when dispatching
   subsequent implementers — so later tasks can implement against the
   interfaces produced by earlier tasks
5. **Session handoff:** After the task's evaluation cycle passes, run
   the standard session close-out (commit, update STATUS.md, append
   to sprint progress file). Update STATUS.md's `Next chat should:`
   field to point to the next task: *"Continue [TICKET] — Task N:
   [task name] ([domain] implementer)"*. Issue the deterministic
   handoff prompt: *"Task N-1 complete. Open a new chat to continue
   [TICKET] — Task N: [task name]."* Do NOT start the next task in
   the same chat.

### Integration Session (Final)

After all per-task sessions complete, the final handoff prompt
from the last task session should read: *"All tasks complete. Open
a new chat for [TICKET] integration verification."*

The integration session:

1. No implementer dispatch — this session verifies integration
2. Invoke the **planner** agent in **validation mode** — check the
   unified story's acceptance criteria, especially integration criteria
   ("data flows end-to-end from ingestion through serving")
3. Invoke the **reviewer** agent on the full change set — looking
   specifically at the seams between domains (interface contracts
   honored, data formats match, error handling at boundaries)
4. If integration issues are found, dispatch to the relevant domain
   implementer in a follow-up session with specific fix instructions

### Guidance for Orchestrators

- **Prefer single-domain stories.** Multi-domain stories are the
  exception, not the norm.
- **Two-domain stories** are acceptable when the domains are tightly
  coupled (e.g., pipeline + dashboard for the same data).
- **Three+ domain stories** should be decomposed by the planner
  during spec expansion. The scrum-master should flag these during
  sprint planning.
- The planner defines interface contracts between tasks at spec time.
  These contracts are the alignment mechanism — they specify data
  formats, API contracts, file paths, and schema expectations so each
  implementer can work independently.

## Sprint Planning
1. Invoke the **scrum-master** (coordinator) agent to facilitate. If an approved PRD exists for this phase, provide the PRD pointer — the scrum master decomposes the PRD into epics and stories for the first sprint of the phase
2. Check when the last maintenance session ran (read `maintenance-latest` git tag). If >1 week or >1 sprint ago, run maintenance first
3. Query backlog (`status: To Do`) and check for unfinished stories from the previous sprint
4. The scrum-master assesses **sprint topology** based on task coupling:
   - **Pipeline** (default): Single feature through plan → build → evaluate cycle
   - **Mesh**: Independent tasks, no shared state, can be worked in any order
   - **Hierarchical**: Coupled tasks with dependencies, must be sequenced
5. Propose 2-3 stories (10-15 points) based on priority, dependencies, and topology
6. Create sprint file (`docs/04-Backlog/Sprints/Sprint-XX.md`), sprint contract (using the appropriate topology template from `docs/Templates/`), and sprint progress file
7. Update story assignments and create `features.json` entries for the sprint
8. If an external task management system is configured, create one task per sprint story linking to the story file
9. Present the sprint plan and contract to the owner for approval using the **Sprint Plan Briefing** format (see briefing docs)

## Ideation & Backlog Grooming
When the owner is brainstorming features, re-prioritizing, or refining stories:
1. New stories defined → create story files (and Jira tickets if Jira mode) and update epic
2. Existing stories re-scoped → update story frontmatter/body (and Jira ticket if Jira mode)
3. Ideas that are exploratory and not committed → add to `docs/09-Personal-Tasks/Someday-Maybe.md`
4. Scope moves between phases → update `docs/01-Product/Phase Definitions.md`

## Research & Technical Discussion
When the conversation involves investigating a technology or debating an approach:
1. Technology evaluation → create or update a research doc in `05-Research/`
2. Data source investigation → create or update a research note in `05-Research/Data Source Research/`
3. If the discussion produces a decision → create an ADR in `02-Engineering/ADRs/`
4. If the discussion changes the data model or architecture → update those docs

## Bug Reporting & Fix Workflow
When the owner reports a bug, read and follow `docs/02-Engineering/bug-workflow.md`. Summary: file bug → trace root cause through evaluator reports → fix with regression test → invoke reviewer (always), validator (always), planner (if behavior changed or spec was root cause) → create eval case for the missed failure mode.

## Architecture Assessment (Ad Hoc)
When the owner requests an architectural review of existing code, or when the orchestrator detects the owner is discussing refactoring, module organization, or code structure:
1. Identify the appropriate architect agent based on project type (software-architect for web-app/automation/library/ai-engineering, data-architect for data-engineering/analytics-engineering/data-app/ml-engineering)
2. Dispatch with **contextual dispatch (ad hoc mode):** Architecture Overview pointer, the target module/directory/codebase scope, owner's specific concern (if any)
3. The architect produces an assessment report with findings, recommendations, and done thresholds
4. Present the assessment to the owner. Architect proposals are owner-gated — they go on the backlog only if the owner approves
5. For approved refactor proposals: create stories in the backlog with the architect's recommendations as acceptance criteria and the done threshold from the assessment
