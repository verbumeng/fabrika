# Development Workflow

The agent drives the development process proactively. Do not wait for the owner to orchestrate each step.

## Dispatch Protocol

Before invoking any sub-agent, read `core/workflows/dispatch-protocol.md` for what to provide and what to withhold. The dispatch protocol defines per-agent input contracts (what the orchestrator must hand over) and output contracts (what the sub-agent must produce). Two tiers: strict dispatch for reviewers, validators, and designers (plan + file paths + rubric only — no editorial); contextual dispatch for planners and coordinators (richer project state).

## Starting a Story
1. Read the story file (or issue tracker ticket) and the sprint contract for this sprint
2. Read relevant project docs on demand: Architecture Overview, Data Model, relevant ADRs, research notes
3. Read the grading rubrics at `docs/02-Engineering/rubrics/` to understand evaluation criteria
4. Invoke the **planner** agent in **planning mode** to expand the story into a full implementation spec (saved to `docs/plans/[TICKET]-spec.md`)
5. Present the spec to the owner for approval using the **Spec Briefing** format (see briefing docs)
6. Create feature branch: `feature/[PROJECT_KEY]-S-042-description`
7. Update story: `status: In Progress`
8. Implement the feature against the approved spec
9. Invoke the **validator** agent to write tests for the new code

## Completing a Story (Evaluation Cycle)
Before marking a story complete, run the full evaluation cycle automatically:
1. Run tests — all pass (including existing tests — no regressions)
2. Run linter — no errors
3. Commit with conventional format: `feat([PROJECT_KEY]-S-042): description`
4. Invoke the **reviewer** agent — it reviews against the sprint contract acceptance criteria, grading rubrics, and runs semgrep
5. Invoke the **validator** agent — it verifies test coverage meets rubric standards and runs E2E verification if applicable to this project type
6. Invoke the **planner** agent in **validation mode** — it verifies acceptance criteria from the sprint contract are met
7. Each evaluator writes a report to `docs/evaluations/[TICKET]-[agent]-review.md`

**If any evaluator fails the implementation (Rollback Protocol):**
8. Read all evaluation reports. Present the assessment to the owner: what failed, why, and proposed fix approach
9. If fixable without reverting (missing handler, wrong endpoint, UI misalignment) → fix the specific issues, re-invoke the failing evaluator(s)
10. If fundamental approach is wrong (wrong data model, architecture mismatch) → `git revert` to last passing commit, re-read sprint contract, propose a different approach to the owner
11. **Maximum 2 retry cycles.** After 2 failed attempts, stop and present: all evaluation reports, summary of what was tried, recommended next steps (rescope, break into smaller stories, research the blocker)

**If all evaluators pass:**
12. Update project docs if implementation diverged (architecture, data model, research notes)
13. Create an ADR for any significant technical decision made during implementation
14. Update story: `status: In Review`, add `## Completion Summary`
15. If an external task management system is configured, mark the corresponding task as done
16. Present the session summary to the owner using the **Session Summary Briefing** format (see briefing docs)

## Sprint Planning
1. Invoke the **scrum-master** (coordinator) agent to facilitate
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
