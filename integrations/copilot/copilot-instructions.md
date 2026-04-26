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
15. Write narrative dev log to `docs/session-logs/YYYY-MM-DD-[topic].md` (see Progress Files below for format)
16. If Jira mode with comments enabled, post status summary to sprint epic/ticket
17. Check: any technical decisions not captured in an ADR? Any doc updates needed?
18. If an external task management system is configured, log a summary there
19. Present the session summary to the owner using the **Session Summary Briefing** format
20. **Issue the next-chat handoff prompt** (see Sprint Lifecycle)

---

## Sprint Lifecycle

A sprint runs across **multiple chats**, not one long conversation. Each phase boundary is a hard new-chat handoff.
Phases: Planning → Story chats → Close-Out → Maintenance → Retro → Next Planning.
Four chats between sprints (close-out, maintenance, retro, planning) — they are not bundled.
STATUS.md's `Cycle phase` field tells each new chat which phase it is in and what to do next.

**On phase transitions, read:** `[FABRIKA_PATH]/core/workflows/sprint-lifecycle.md`

---

## Development Workflow

The agent drives the development process proactively. Don't wait for the owner to orchestrate each step.

**Before starting any story, sprint planning, or bug fix, read:** `[FABRIKA_PATH]/core/workflows/development-workflow.md`

Summary of workflows covered:
- **Starting a Story** — spec expansion → approval → branch → implement → test
- **Completing a Story (Evaluation Cycle)** — tests → lint → commit → reviewer → validator → planner validation → rollback protocol (max 2 retries)
- **Sprint Planning** — scrum-master → topology assessment → 2-3 stories → contract → approval
- **Ideation & Backlog Grooming** — new stories, re-scoping, someday-maybe
- **Research & Technical Discussion** — research docs, ADRs
- **Bug Reporting & Fix Workflow** — see `docs/02-Engineering/bug-workflow.md`

---

## Analytics Workspace Workflow (analytics-workspace type only)

No sprints. Work is organized as individual analysis tasks: Brief → Plan → Execute → Validate → Deliver.

**For analytics-workspace projects, read:** `[FABRIKA_PATH]/core/workflows/analytics-workspace.md`

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

- **STATUS.md** — Project state snapshot, overwritten each session. Contains `Cycle phase` and `Next chat should:` fields for orientation.
- **Sprint Progress File** — `docs/04-Backlog/Sprints/Sprint-XX-progress.md` — append-only sprint log.
- **Dev Logs** — `docs/session-logs/YYYY-MM-DD-[topic].md` — narrative first-person dev diary entries (200-500 words).

**For templates and format details, read:** `[FABRIKA_PATH]/core/workflows/progress-files.md`

---

## Subagents

All agents are invoked proactively at trigger points in the Development Workflow. Agent prompts are **stack-agnostic** — they read project-specific details from this instructions file and on-demand reference docs. Which agents are installed depends on the project type (see Agent Catalog).

**Dispatch protocol:** Before invoking any sub-agent, read `[FABRIKA_PATH]/core/workflows/dispatch-protocol.md`. It defines what to provide and what to withhold for each agent at each invocation point. Reviewers, validators, and designers get strict dispatch (plan + file paths + rubric only); planners and coordinators get contextual dispatch (richer project state).

**Archetypes:** Each agent implements one of five archetypes (Planner, Reviewer, Validator, Coordinator, Designer) that define base tool profiles and contracts. See `[FABRIKA_PATH]/core/agents/archetypes/` for templates.

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

### Copilot Agent Configuration

Agent prompt files live in `.github/agents/` as `[agent-name].agent.md` with YAML frontmatter. **Do not use wildcards (`*`) for tool assignment** — spell out each tool explicitly using `namespace/tool` format. Wildcards are unreliable in VS Code Copilot (see GitHub issue #12647).

Each archetype defines a base tool set. Copy the tools list from the relevant archetype template at `[FABRIKA_PATH]/core/agents/archetypes/` and adjust if the specific agent needs more or fewer tools.

**Tool reference (VS Code Copilot, current as of early 2025 — verify if behavior seems off):**

| Namespace | Tools | Purpose |
|-----------|-------|---------|
| `read/` | readFile, problems, terminalLastCommand | Read file contents, workspace diagnostics, terminal output |
| `search/` | codebase, fileSearch, textSearch, listDirectory, usages, changes | Find files, search code, list dirs, find references, view diffs |
| `edit/` | createFile, createDirectory, editFiles | Create new files/dirs, modify existing files |
| `execute/` | runInTerminal, getTerminalOutput, testFailure | Run commands, read output, get test failure details |

**Tool set shorthands** (e.g., `edit` for all `edit/*` tools) exist but may not reliably grant all sub-tools. Prefer explicit tool names.

**Example `.github/agents/code-reviewer.agent.md` frontmatter:**
```yaml
---
name: code-reviewer
description: Reviews implementation against acceptance criteria, rubrics, and security baseline
tools:
  - read/readFile
  - read/problems
  - read/terminalLastCommand
  - search/codebase
  - search/fileSearch
  - search/textSearch
  - search/listDirectory
  - search/usages
  - search/changes
  - edit/createFile
  - edit/createDirectory
  - execute/runInTerminal
  - execute/getTerminalOutput
  - execute/testFailure
---
```

**Instruction-level constraints** (enforced in the agent prompt, not mechanically by tools):
- Reviewers: `createFile` only, no `editFiles` — they create reports, never modify code
- Validators: `editFiles` restricted to `tests/` and `docs/evaluations/`
- Planners: `editFiles` restricted to `docs/` and `tasks/`
- Coordinators: `editFiles` restricted to `STATUS.md`, `docs/04-Backlog/`, and `features.json`
- Designers: `createFile` only, no `editFiles`

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

When technical decisions, data sources, schema changes, architecture divergences, bugs, or other trigger events occur during development, create the appropriate document.

**For the full trigger table, read:** `[FABRIKA_PATH]/core/workflows/doc-triggers.md`

---

## Hooks & Enforcement

Hooks enforce workflow conventions mechanically. Two layers: git hooks (in `.git/hooks/`) and instruction-based rules.

Git hooks: pre-commit (branch protection, secret scanning, STATUS.md gate, mesh scope), commit-msg (conventional format), post-commit (STATUS.md advisory), pre-push (test gate).
Instruction-based (Copilot has no mechanical hook equivalent): never run destructive git commands without user confirmation, never write to secret/credential files, verify lock file cleanup after commit.
Auto-formatting: use VS Code's `editor.formatOnSave: true`.

**For full hook inventory and adaptation guidance, read:** `[FABRIKA_PATH]/core/workflows/hooks-reference.md`

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
