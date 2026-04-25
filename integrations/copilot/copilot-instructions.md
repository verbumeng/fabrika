# Project Copilot Instructions — [PROJECT_NAME]

> [One-line description of what this project is and why it exists.]

## Orchestration Principle

The AI agent orchestrates the entire development workflow. The human's role is decision-making and review: approving plans, reviewing evaluations, selecting sprint scope, and approving prompt improvements. The human never manually invokes agents, moves files, updates progress files, or runs checklists. If an action can be performed by the agent, the agent performs it automatically.

## Project Basics
- **Project Key:** [PROJECT_KEY] (e.g. MYAPP — used for branch naming and story IDs)
- **Project Type:** [web-app | data-app | analytics-engineering | data-engineering | ml-engineering | ai-engineering | automation | library | analytics-workspace] (can be multi-type for sprint-based types)
- **Repo:** `[project-root]`
- **Project docs:** `[project-root]/docs`
- **Document Catalog:** `[FABRIKA_PATH]/core/Document-Catalog.md`
- **Agent Catalog:** See `.fabrika/AGENT-CATALOG.md` or `[FABRIKA_PATH]/core/agents/AGENT-CATALOG.md` for which agents apply to this project type

## Current Phase

[Describe the current focus. What is the MVP? What are you building right now?]

**Goal:** "[What does success look like for this phase?]"

**Future phases (do NOT build yet):** [List later phases briefly. Complexity earns its way in via ADRs.]

## Project Stack

| Layer | Tool | Notes |
|-------|------|-------|
| Language | [e.g. Python 3.12, TypeScript 5.x] | |
| Framework | [e.g. Next.js 14, Plotly Dash, dbt] | |
| Database | [e.g. Supabase/Postgres, DuckDB, SQLite] | |
| Package manager | [e.g. uv, npm, pnpm] | |
| Test runner | [e.g. pytest, vitest] | |
| Linter | [e.g. ruff, eslint] | |
| E2E verification | [e.g. Playwright, pytest + output diff, N/A] | |
| Dev server | [e.g. `npm run dev` on port 3000] | |
| CI | [e.g. GitHub Actions] | |

### Test Commands
- **Fast test command:** `[e.g. pytest -x -q --fast]` (used by pre-push hook, session health checks)
- **Full test command:** `[e.g. pytest --tb=short]` (used by maintenance sessions, CI)
- **E2E test command:** `[e.g. npx playwright test]` (used by validator agent for end-to-end verification)

## Project Structure

### Sprint-based types
```
[project-name]/
├── .github/
│   ├── copilot-instructions.md     # This file
│   ├── agents/                     # Agent prompt files (*.agent.md)
│   └── workflows/ci.yml
├── docs/                           # Project docs
│   ├── 00-Index/
│   ├── 01-Product/
│   ├── 02-Engineering/
│   │   ├── ADRs/
│   │   ├── rubrics/
│   │   └── maintenance-checklist.md
│   ├── 03-Design/
│   ├── 04-Backlog/
│   │   ├── Epics/
│   │   ├── Stories/
│   │   ├── Bugs/
│   │   └── Sprints/
│   ├── 05-Research/
│   ├── 06-Visibility/
│   ├── 07-Operations/
│   ├── 08-Meeting-Notes/
│   ├── 09-Personal-Tasks/
│   ├── Templates/
│   ├── evaluations/
│   ├── plans/
│   ├── session-logs/
│   ├── evals/
│   │   ├── baseline/               # Shipped eval cases by archetype
│   │   └── [agent-name]/           # Project-specific eval cases
│   └── maintenance/
├── .fabrika/
├── src/
├── tests/
├── STATUS.md
├── features.json
└── Justfile
```

### Task-based types (analytics-workspace)
```
[project-name]/
├── .github/
│   ├── copilot-instructions.md     # This file
│   └── agents/                     # Agent prompt files (*.agent.md)
├── src/
│   ├── queries/
│   ├── scripts/
│   └── notebooks/
├── data/
│   ├── input/
│   └── output/
├── tasks/                          # One folder per analysis task
│   └── YYYY-MM-DD-name/
│       ├── brief.md
│       ├── plan.md
│       ├── outcome.md
│       └── work/
├── sources/
│   ├── README.md                   # Source registry index
│   ├── connections/
│   ├── tools/
│   └── files/
├── docs/
│   ├── Templates/
│   ├── evaluations/
│   └── evals/baseline/
├── .fabrika/
└── STATUS.md
```

---

## Backlog System

- **Mode:** [markdown | jira]
- **Jira project key:** [PROJECT_KEY] (only if mode = jira)

### Markdown Mode
- **Epics:** `docs/04-Backlog/Epics/E-XX-[name].md`
- **Stories:** `docs/04-Backlog/Stories/S-XXX-[name].md`
- **Sprints:** `docs/04-Backlog/Sprints/Sprint-XX.md`
- **Bugs:** `docs/04-Backlog/Bugs/[PROJECT_KEY]-BXX-[name].md`

### Jira Mode
Stories and epics tracked in Jira via `mcp-atlassian`. Local story files optional.

### Feature Tracking (Both Modes)
`features.json` in project root — agent-facing pass/fail tracker. Agents may ONLY change the `passes` field. Updated during session close-out.

Story statuses: `To Do` → `In Progress` → `In Review` → `Done`
Story points: Fibonacci — 1, 2, 3, 5, 8, 13

---

## Session Lifecycle

Every conversation follows this lifecycle. No steps are optional.

### Session Start (Orientation)
1. Read `STATUS.md` for current project state
2. Read the current sprint's progress file
3. Read `git log --oneline -10` for recent history
4. Read `features.json` for current pass/fail state
5. Run quick health check: fast test command
6. Determine next task based on sprint contract priorities and feature pass/fail state
7. Present orientation summary to the owner

### Session Work
8. Work on ONE story/feature per session
9. Follow the Development Workflow below
10. Write and run tests as work progresses

### Session Close-Out
11. Git commit with conventional format
12. Update `STATUS.md` with current state — including the `Cycle phase` field
13. Append to current sprint's progress file: what was done, what failed, what remains, tokens consumed (if available), lessons/insights for retro, agent quality observations
14. Update `features.json` pass/fail status
15. Write narrative dev log to `docs/session-logs/YYYY-MM-DD-[topic].md` (see Dev Log Format below)
16. If Jira mode with comments enabled, post status summary to sprint epic/ticket
17. Check: any technical decisions not captured in an ADR? Any doc updates needed?
18. If an external task management system is configured, log a summary there
19. Present the session summary to the owner using the **Session Summary Briefing** format
20. **Issue the next-chat handoff prompt** (see Sprint Lifecycle)

### Dev Log Format (`docs/session-logs/`)
Write each dev log from **the user's first-person perspective** (as if they're telling a colleague what they built today):
- What was built — the feature, the approach, what it does
- What decisions were made and why
- What was interesting or surprising
- Lessons learned
- What's next

**Tone:** Casual-smart, thinking-out-loud. **Length:** 200-500 words.

---

## Sprint Lifecycle

A sprint runs across **multiple chats**, not one long conversation. Each phase boundary is a hard new-chat handoff.

### Phases (in order)

```
Sprint Planning chat → Story 1 chat → Story 2 chat → ... → Story N chat
    → Sprint Close-Out (Merge) chat → Maintenance chat → Sprint Retro chat
    → Next Sprint Planning chat
```

**Four chats between sprints**: close-out merge, maintenance, retro, planning. They are not bundled.

### Cycle phase indicator

`STATUS.md` carries a `Cycle phase` field. Allowed values:
- `planning` — sprint planning in progress
- `story-in-progress` — a story chat is active
- `sprint-close` — last story approved; merge chat needs to run
- `maintenance` — merge done; maintenance chat needs to run
- `retro` — maintenance done; retro chat needs to run

### What each phase chat does

**Sprint Planning chat** — Invoke the scrum-master agent. Produces sprint file, contract, progress file. Sets `Cycle phase: story-in-progress`. Close-out: *"Sprint planning complete. Open a new chat to start [TICKET]."*

**Story chat** — Standard Session Lifecycle. One story per chat. Close-out branches:
- More stories → `Cycle phase: story-in-progress`. *"Story complete. Open a new chat for [NEXT-TICKET]."*
- Last story → `Cycle phase: sprint-close`. *"Last story complete. Open a new chat for sprint close-out."*

**Sprint Close-Out (Merge) chat** — Verify: working tree clean, all sprint branches merged or explicitly deferred, main is active. Set `Cycle phase: maintenance`. *"Open a new chat to run maintenance."*

**Maintenance chat** — Run checklist at `docs/02-Engineering/maintenance-checklist.md`. Tag: `git tag maintenance-YYYY-MM-DD && git tag -f maintenance-latest`. Set `Cycle phase: retro`. *"Open a new chat for sprint retro."*

**Sprint Retro chat** — Invoke scrum-master. Write `Sprint-XX-retro.md`. Present using Retro Briefing format. Set `Cycle phase: planning`. *"Open a new chat to plan next sprint."*

### Why fresh chats matter
1. Context window stays clean
2. Fresh evaluator agents make better evaluators (no anchoring bias)
3. Failure modes don't leak across stories

---

## Development Workflow

The agent drives the development process proactively. Don't wait for the owner to orchestrate each step.

### Starting a Story
1. Read the story file and sprint contract
2. Read relevant project docs on demand
3. Read grading rubrics at `docs/02-Engineering/rubrics/`
4. Invoke the **planner** agent to expand the story into a full spec (saved to `docs/plans/[TICKET]-spec.md`)
5. Present the spec to the owner using the **Spec Briefing** format
6. Create feature branch: `feature/[PROJECT_KEY]-S-042-description`
7. Update story: `status: In Progress`
8. Implement the feature
9. Invoke the **validator** agent to write tests

### Completing a Story (Evaluation Cycle)
1. Run tests — all pass (no regressions)
2. Run linter — no errors
3. Commit with conventional format
4. Invoke the **reviewer** agent — reviews against acceptance criteria, rubrics, security
5. Invoke the **validator** agent — verifies coverage meets rubric, runs E2E verification
6. Invoke the **planner** agent in **validation mode** — verifies acceptance criteria met
7. Each evaluator writes a report to `docs/evaluations/[TICKET]-[agent]-review.md`

**If any evaluator fails (Rollback Protocol):**
8. Present the assessment to the owner: what failed, why, proposed fix
9. If fixable → fix specific issues, re-invoke failing evaluator(s)
10. If fundamental approach is wrong → `git revert`, propose different approach
11. **Maximum 2 retry cycles.** After 2 failures, stop and present all reports with recommendations.

**If all evaluators pass:**
12. Update project docs if implementation diverged
13. Create ADR for significant technical decisions
14. Update story: `status: In Review`
15. Present session summary using Session Summary Briefing format

### Sprint Planning
1. Invoke the **scrum-master** (coordinator) agent
2. Check when last maintenance ran. If >1 week, run maintenance first.
3. Query backlog and check for unfinished stories
4. Scrum-master assesses **topology** (Pipeline / Mesh / Hierarchical)
5. Propose 2-3 stories (10-15 points)
6. Create sprint file, contract, and progress file
7. Present using **Sprint Plan Briefing** format

### Ideation & Backlog Grooming
- New stories → create story files
- Re-scoped stories → update frontmatter/body
- Exploratory ideas → `docs/09-Personal-Tasks/Someday-Maybe.md`
- Phase changes → `docs/01-Product/Phase Definitions.md`

### Research & Technical Discussion
- Tech evaluation → create doc in `05-Research/`
- Data source investigation → `05-Research/Data Source Research/`
- Decision made → create ADR in `02-Engineering/ADRs/`

### Bug Reporting & Fix Workflow
Read and follow `docs/02-Engineering/bug-workflow.md`. Summary: file bug → trace root cause → fix with regression test → invoke reviewer + validator + planner (if spec was root cause) → create eval case for missed failure mode.

---

## Analytics Workspace Workflow (analytics-workspace type only)

No sprints. Work is organized as individual analysis tasks.

### Task Lifecycle
1. **Brief** — Analysis planner takes the ask, writes `tasks/[date-name]/brief.md` (business question, stakeholder, deadline, desired output)
2. **Plan** — Analysis planner writes `tasks/[date-name]/plan.md` (data sources, approach, SQL/logic, assumptions, validation strategy). Owner approves.
3. **Execute** — Work happens in `tasks/[date-name]/work/`. SQL files, notebooks, scripts.
4. **Validate** — Logic reviewer checks join/filter/aggregation logic. Data validator runs sanity checks (row counts, distributions, cross-references).
5. **Deliver** — `tasks/[date-name]/outcome.md` — results, methodology, data quality notes, output location.

### Advisory Mode (GUI Tools)
For Tableau, Power BI, Alteryx, and similar tools the agent cannot directly access:
- **Agent can:** Write SQL, draft DAX/M expressions, draft calculated fields, write validation queries, review described logic
- **Human does:** Execute inside the tool, screenshot results, describe workflow steps for review

### Source Registry
`sources/README.md` is the index. Three categories:
- `sources/connections/` — queryable data sources (warehouses, databases, ODBC, APIs)
- `sources/tools/` — BI/ETL tools in advisory mode (Tableau Server, Power BI, Alteryx)
- `sources/files/` — recurring flat file sources (CSVs, Excel, YXDBs)

---

## Owner Briefings

When presenting plans, results, or summaries to the owner, do not dump raw artifacts or tell the owner to go read files. Present a plain-language briefing:

- **Principles:** `[FABRIKA_PATH]/core/briefings/briefing-principles.md` — read first; applies to all briefings
- **After spec expansion:** `[FABRIKA_PATH]/core/briefings/spec-briefing.md`
- **After sprint planning:** `[FABRIKA_PATH]/core/briefings/sprint-plan-briefing.md`
- **Session close-out / story completion:** `[FABRIKA_PATH]/core/briefings/session-summary-briefing.md`
- **After sprint retro:** `[FABRIKA_PATH]/core/briefings/retro-briefing.md`

---

## Progress Files

### STATUS.md (Project Root)
A **snapshot** of current project state, overwritten each session:
```markdown
## [PROJECT_NAME] — Status
Last updated: YYYY-MM-DD

### Current Sprint: Sprint X
- **Topology:** [pipeline | mesh | hierarchical]
- **Cycle phase:** [planning | story-in-progress | sprint-close | maintenance | retro]
- **Next chat should:** [one-line pointer]
- **Sprint contract:** docs/04-Backlog/Sprints/Sprint-XX-contract.md
- **Progress file:** docs/04-Backlog/Sprints/Sprint-XX-progress.md

### Active Work
- [TICKET]: [title] — [status]

### Blockers
- [Any blockers]

### Last Maintenance
- Date: YYYY-MM-DD
- Tag: maintenance-YYYY-MM-DD
```

### Sprint Progress File (Per-Sprint)
`docs/04-Backlog/Sprints/Sprint-XX-progress.md` — append-only log. Archived when sprint closes.

---

## Subagents

All agents are invoked proactively at trigger points in the Development Workflow. Agent prompts are **stack-agnostic** — they read project-specific details from this instructions file and on-demand reference docs. Which agents are installed depends on the project type (see Agent Catalog):

### Sprint-based types
| Role | Default Agent | Specialized Variants |
|------|--------------|---------------------|
| **Planner** | product-manager | experiment-planner (ml-engineering), api-designer (library) |
| **Reviewer** | code-reviewer | + prompt-reviewer (ai-engineering, supplemental) |
| **Validator** | test-writer | model-evaluator (ml-engineering), eval-engineer (ai-engineering), data-quality-engineer (data-engineering) |
| **Coordinator** | scrum-master | (same for all sprint-based types) |

### Task-based types (analytics-workspace)
| Role | Agent |
|------|-------|
| **Planner** | analysis-planner |
| **Reviewer** | logic-reviewer |
| **Validator** | data-validator |

---

## Evaluation System

A graduated, self-building system for measuring and improving agent quality.

- **Baseline evals** in `docs/evals/baseline/` — ship day one, test fundamental behaviors by role archetype
- **Project-specific evals** in `docs/evals/{agent-name}/` — built from real observed failures during maintenance sessions
- **Agent changelog** at `docs/evals/agent-changelog.md` — logs every prompt modification with failure context
- **Bug reports** in `docs/04-Backlog/Bugs/` with `missed-by` tracing — ground truth for agent quality

See `docs/evals/README.md` for detailed format and process.

---

## Maintenance Sessions

Run between sprints or weekly. See full checklist at `docs/02-Engineering/maintenance-checklist.md`.

**Summary:** Documentation sync, code quality (dedup, TODO scan), evaluation findings sweep, test health, bug review, progress reconciliation, dependency health, context efficiency review, hook health, evaluation health (run evals, propose prompt improvements).

**Git convention:** `maint:` commit prefix. `git tag maintenance-YYYY-MM-DD && git tag -f maintenance-latest`.

---

## Document Creation Triggers

| Trigger | Action |
|---------|--------|
| Technical decision made | Create ADR in `02-Engineering/ADRs/` |
| New data source discussed | Create note in `05-Research/Data Source Research/` |
| Complex feature | Create spec in `01-Product/Feature Specs/` |
| Architecture divergence | Update `02-Engineering/Architecture Overview.md` |
| Schema changes | Update `02-Engineering/Data Model.md` |
| New transformation logic | Update `02-Engineering/Transformation Logic.md` (analytics-engineering, data-engineering) |
| Agent prompt modified | Log to `docs/evals/agent-changelog.md` |
| Bug reported | Create in `04-Backlog/Bugs/`, run bug workflow |
| Future idea | Add to `09-Personal-Tasks/Someday-Maybe.md` |

---

## Hooks & Enforcement

Git hooks in `.git/hooks/` enforce workflow rules mechanically. Install from the Fabrika hook templates.

**What the hooks enforce:**
- **pre-commit:** Blocks commits to main/master, scans for secrets, requires STATUS.md when task lock active, enforces mesh isolation scope
- **commit-msg:** Validates conventional commit format (`type(scope): description`)
- **pre-push:** Runs fast test suite, blocks push on failure
- **post-commit:** Reminds if STATUS.md wasn't updated (advisory)

**Rules enforced by instruction (no mechanical hook in Copilot):**
- Never run destructive git commands (`push --force`, `reset --hard`, `checkout -- .`, `restore .`, `branch -D`, `clean -f`) without explicit user confirmation
- Never write to `.env` files, key files, or any file containing secrets or credentials
- After git commit, verify all task lock files have been cleaned up

**Auto-formatting:** Use VS Code's built-in format-on-save (`editor.formatOnSave: true`).

For the full hook inventory and adaptation guidance, see `.fabrika/hook-adaptation-guide.md`.

---

## Git & Branch Workflow
- **Branch naming:** `feature/[PROJECT_KEY]-S-XXX-description` for stories, `chore/description` for non-story work
- **Commit format:** `feat([PROJECT_KEY]-S-042): add login form`
  - Prefixes: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`, `maint:`
- **Never commit directly to main.**
- **No AI attribution** in commit messages.

---

## Doc Standards
- Always include YAML frontmatter: `type`, `status`, `created`, `updated`, `tags`
- Use `[[wikilinks]]` to connect related docs
- Write in plain language — no jargon without explanation
- Docs should be self-contained: readable without this instructions file

---

## Testing Rules
- **No mocking the database.** Use in-memory or temp-file instances.
- **Fixture-based tests** where applicable. Save real response snapshots in `tests/fixtures/`.
- **Coverage:** 80%+ on core logic and storage.
- **CI:** GitHub Actions runs linter + tests on every PR.
- **Concise test output:** Summary lines, not full stack traces. Errors grep-friendly: `ERROR: [component] [description]`.
- **Regression baseline:** Every sprint contract includes "all existing tests continue to pass."
- **Test summary:** After full test run, produce `tests/latest-summary.md`.

---

## Fabrika Relationship

This project uses **Fabrika**, an agentic workflow framework. Local agent changes are expected — tune freely during sprints. For how changes flow back to canonical Fabrika, read `.fabrika/FABRIKA.md` on demand.

---

## Key Constraints
- **Orchestrate, don't wait.** Drive the workflow proactively.
- **Verify and report failures.** After every file creation, git operation, or external call — if it fails, stop and explain.
- **Respect the phases.** Don't build future-phase infrastructure during the current phase.
- **Small PRs.** One feature per PR.
- **Tests are not optional.** Every PR touching `src/` includes tests.
- **Privacy first.** No credentials in git. No third-party services unless decided via ADR.
- **Conservative sprint scope.** 2-3 stories per sprint. Favor shipping over perfecting.
- **Context window hygiene.** Load docs on demand, not up front. Return concise summaries.
- **Stack-agnostic agent prompts.** Tech details live in this file's Project Stack section.

---

## Communication Style
- Explain architectural decisions and trade-offs in plain language
- When making a choice between approaches, tell me WHY you chose it
- Narrate what you're doing as you work
- If something could be done multiple ways, briefly mention the alternatives
