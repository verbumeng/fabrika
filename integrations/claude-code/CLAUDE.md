# CLAUDE.md — [PROJECT_NAME]

> [One-line description of what this project is and why it exists.]

## Orchestration Principle

Claude Code orchestrates the entire development workflow. The human's role is decision-making and review: approving plans, reviewing evaluations, selecting sprint scope, and approving prompt improvements. The human never manually invokes agents, moves files, updates progress files, or runs checklists. If an action can be performed by the agent, the agent performs it automatically.

## Project Basics
- **Project Key:** [PROJECT_KEY] (e.g. MYAPP — used for branch naming and story IDs)
- **Project Type:** [web-app | data-app | analytics-engineering | data-engineering | ml-engineering | ai-engineering | automation | library | analytics-workspace | agentic-workflow] (can be multi-type for sprint-based types)
- **Repo:** `~/projects/[project-name]`
- **Project docs:** `~/projects/[project-name]/docs`
- **Document Catalog:** `[FABRIKA_PATH]/core/Document-Catalog.md`
- **Agent Catalog:** See `.fabrika/AGENT-CATALOG.md` or `[FABRIKA_PATH]/core/agents/AGENT-CATALOG.md` for which agents apply to this project type
- **Domain Language:** `docs/00-Index/Domain-Language.md` (shared domain vocabulary — if it exists)

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
| E2E verification | [e.g. Playwright MCP, pytest + output diff, N/A] | See Verification Method below |
| Dev server | [e.g. `npm run dev` on port 3000, `python app.py` on port 8050] | |
| CI | [e.g. GitHub Actions] | |

### Test Commands
- **Fast test command:** `[e.g. pytest -x -q --fast]` (used by pre-push hook, session health checks)
- **Full test command:** `[e.g. pytest --tb=short]` (used by maintenance sessions, CI)
- **E2E test command:** `[e.g. npx playwright test]` (used by test-writer for end-to-end verification)

### Verification Method

The verification approach depends on project type:

| Project Type | Primary Verification | Tool |
|-------------|---------------------|------|
| `web-app` | Full browser automation — navigate, click, verify | Playwright MCP |
| `data-app` | Browser automation for UI + model assertion tests | Playwright MCP + test runner |
| `analytics-engineering` | Output diffing against known-good oracle | Test runner + diff scripts |
| `data-engineering` | Pipeline integration tests + per-stage data quality checks | Test runner + diff scripts |
| `ml-engineering` | Model evaluation metrics + training reproducibility | Test runner + eval framework |
| `ai-engineering` | Eval harness (LLM output quality) + guardrail tests | Test runner + eval framework |
| `automation` | Integration tests against real/mock targets | Test runner |
| `library` | Unit + integration + backward compat + API contract | Test runner |
| `analytics-workspace` | Per-task validation (sanity checks, cross-references) | Data validator agent |

**This project's verification method:** [Describe which approach applies and any project-specific details]

### Model Routing

| Role | Agent(s) | Recommended Model | Rationale |
|------|----------|------------------|-----------|
| Planner (planning mode) | product-manager, experiment-planner, api-designer, analysis-planner | Opus | Spec/plan expansion needs strong reasoning |
| Planner (validation mode) | product-manager, experiment-planner, api-designer | Opus | Needs to catch spec gaps |
| Reviewer | code-reviewer, logic-reviewer, prompt-reviewer | Opus | Subtle bug/logic detection |
| Validator (strategy) | test-writer, model-evaluator, eval-engineer, data-quality-engineer, data-validator | Opus | Designing what to test/validate |
| Validator (execution) | test-writer, model-evaluator, eval-engineer, data-quality-engineer, data-validator | Sonnet | Running mechanical test/check scripts |
| Coordinator | scrum-master | Opus | Topology assessment, sprint planning |
| Maintenance session | (orchestrating session) | Sonnet | Checklist-driven, documentation updates |

## Project Structure
```
[project-name]/
├── CLAUDE.md                          # Central project control (this file)
├── STATUS.md                          # Current state snapshot (overwritten each session)
├── features.json                      # Agent-facing feature pass/fail tracker
├── Justfile
├── [pyproject.toml / package.json / etc.]
├── .gitignore
├── .claude/
│   ├── settings.json
│   ├── hooks/
│   │   ├── pre-push.sh               # Regression gate — blocks push if tests fail
│   │   ├── post-commit.sh            # Warns if STATUS.md not updated
│   │   └── pre-commit.sh             # Mesh topology: enforces isolation scope
│   └── current_tasks/                 # Task lock files for parallel session safety
├── .github/workflows/ci.yml
├── docs/                              # Project docs
│   ├── 00-Index/
│   ├── 01-Product/
│   │   ├── Project-Charter.md         # Created once via Design Alignment
│   │   ├── PRDs/                      # One PRD per phase/feature
│   │   └── Feature Specs/
│   ├── 02-Engineering/
│   │   ├── ADRs/
│   │   ├── rubrics/                   # Grading criteria for evaluator agents
│   │   │   ├── code-review-rubric.md
│   │   │   └── test-rubric.md
│   │   └── maintenance-checklist.md   # Maintenance session checklist
│   ├── 03-Design/
│   ├── 04-Backlog/
│   │   ├── Epics/
│   │   ├── Stories/                   # Story files (markdown mode) or local references (Jira mode)
│   │   ├── Bugs/                     # Bug reports with evaluator tracing
│   │   └── Sprints/
│   │       ├── Sprint-XX.md           # Sprint definition
│   │       ├── Sprint-XX-contract.md  # Sprint contract (topology-aware)
│   │       └── Sprint-XX-progress.md  # Per-sprint progress log
│   ├── 05-Research/
│   │   └── Data Source Research/
│   ├── 06-Visibility/
│   ├── 07-Operations/
│   ├── 08-Meeting-Notes/
│   ├── 09-Personal-Tasks/
│   ├── Templates/
│   │   ├── Sprint-Contract-Pipeline.md
│   │   ├── Sprint-Contract-Mesh.md
│   │   ├── Sprint-Contract-Hierarchical.md
│   │   └── Sprint-Retro-Template.md
│   ├── evaluations/                   # QA reports and code review reports
│   ├── plans/                         # Expanded specs from product-manager planning mode
│   ├── session-logs/                  # Session reports for context tracking
│   ├── evals/                         # Agent evaluation harness (scaffold — built over time)
│   │   ├── README.md
│   │   ├── agent-changelog.md         # Log of agent prompt modifications + failure context
│   │   ├── code-reviewer/
│   │   ├── test-writer/
│   │   ├── product-manager/
│   │   └── scrum-master/
│   └── maintenance/                   # Maintenance session outputs
│       ├── dedup-*.md
│       ├── full-test-*.md
│       ├── deps-*.md
│       └── context-review-*.md
├── wiki/                              # Knowledge layer (opt-in, default recommended)
│   ├── index.md                       # Progressive narrative overview of project knowledge
│   ├── topics/                        # Synthesized topic articles
│   └── meta/                         # Pipeline intermediates (batch indexes, agent-only)
├── src/
├── tests/
│   ├── fixtures/
│   └── [test files]
└── [other project-specific dirs]
```

### Task-based types (analytics-workspace)
```
[project-name]/
├── CLAUDE.md                          # Central project control (this file)
├── STATUS.md                          # Current state snapshot
├── .claude/
│   ├── settings.json
│   ├── agents/
│   │   ├── analysis-planner.md
│   │   ├── logic-reviewer.md
│   │   ├── data-validator.md
│   │   └── performance-reviewer.md    # Tier 2 only
│   └── hooks/
├── src/
│   ├── queries/                       # Reusable SQL
│   ├── scripts/                       # Python/R scripts
│   └── notebooks/                     # Jupyter, etc.
├── data/
│   ├─�� input/                         # CSVs, Excel files people send you
│   └── output/                        # Generated datasets, exports
├── tasks/                             # One folder per analysis task
│   └── YYYY-MM-DD-name/
│       ├── brief.md                   # Business question
│       ├── plan.md                    # Technical approach
│       ├── outcome.md                 # Results and methodology
│       ├── validation-report.md       # Human-facing evidence chain
│       └── work/                      # SQL, notebooks, scratch
│           └── execution-manifest.md  # Tier 2 only: metadata results
├── sources/
│   ├── README.md                      # Source registry index
│   ├── connections/                   # Queryable data sources
│   ├── tools/                         # BI/ETL tools (advisory mode)
│   └── files/                         # Recurring flat file sources
├── wiki/                              # Knowledge layer (opt-in, default recommended)
│   ├── index.md                       # Progressive narrative overview
│   ├── topics/                        # Synthesized topic articles
│   └── meta/                         # Pipeline intermediates (agent-only)
├── docs/
│   ├── Templates/
│   ├── evaluations/
│   └── evals/baseline/
└── .fabrika/
```

---

## Backlog System

- **Mode:** [markdown | jira]
- **Jira project key:** [PROJECT_KEY] (only if mode = jira)
- **Jira comment on status update:** [yes | no] (only if mode = jira)
- **Comment target:** [Sprint epic or sprint ticket key] (only if Jira comments enabled)

### Markdown Mode
Stories and epics are tracked as markdown files. Story files are the authoritative record of work status.

- **Epics:** `docs/04-Backlog/Epics/E-XX-[name].md` — globally numbered E-01 through E-99
- **Stories:** `docs/04-Backlog/Stories/S-XXX-[name].md` — globally numbered S-001 through S-999
- **Sprints:** `docs/04-Backlog/Sprints/Sprint-XX.md`
- **Bugs:** `docs/04-Backlog/Bugs/[PROJECT_KEY]-BXX-[name].md` — separate numbering from stories (B01, B02, ...)
- **Finding the next ID:**
  ```bash
  rg "^id: " docs/04-Backlog/Epics/ | sort | tail -1
  rg "^id: " docs/04-Backlog/Stories/ | sort | tail -1
  rg "^id: [PROJECT_KEY]-B" docs/04-Backlog/Bugs/ | sort | tail -1
  ```

### Jira Mode
Stories and epics are tracked in Jira via the `mcp-atlassian` MCP server. Local story files in `docs/04-Backlog/Stories/` are optional references — Jira is the authoritative record.

- Query Jira for backlog, sprint, and story status
- When creating stories, create in Jira first, then optionally create local markdown reference
- Apply topology-specific ticket conventions (see Scrum-Master Topology section in agent prompt)

### Feature Tracking (Both Modes)

`features.json` in the project root is the agent-facing progress tracker. It coexists with stories (markdown or Jira) — stories are the human-readable record; features.json is the machine-readable pass/fail tracker.

**Rules:**
- Agents may ONLY change the `passes` field in features.json
- When a feature passes, update BOTH features.json AND the story status
- features.json is updated during session close-out
- Maintenance sessions reconcile features.json with actual test results

### Story Statuses
`To Do` → `In Progress` → `In Review` → `Done`

Story points: Fibonacci — 1, 2, 3, 5, 8, 13

---

## Session Lifecycle

Every conversation follows this lifecycle. No steps are optional.

### Session Start (Orientation)
1. Read `STATUS.md` for current project state
2. Read the current sprint's progress file (`docs/04-Backlog/Sprints/Sprint-XX-progress.md`)
3. Read `git log --oneline -10` for recent history
4. Read `features.json` for current pass/fail state
5. Check `.claude/current_tasks/` for any stale lock files
6. Run quick health check: fast test command (verify codebase is in working state)
7. Determine next task based on sprint contract priorities and feature pass/fail state
8. Create a task lock file in `.claude/current_tasks/[TICKET-ID].lock`
9. Present orientation summary to the owner: where we are, what's next, any blockers

### Session Work
10. Work on ONE story/feature per session
11. Follow the Development Workflow below
12. Write and run tests as work progresses (unit + E2E as appropriate to project type)

### Session Close-Out
13. Git commit with conventional format (all work in a mergeable state)
14. Update `STATUS.md` with current state snapshot — including the `Cycle phase` field (see Sprint Lifecycle below)
15. Append to current sprint's progress file: what was done, what failed, what remains, **tokens consumed** (if available from the tool — measurement boundary is "begin story" to "ready for approval"), **any lessons / insights worth surfacing in the retro**, and **any agent quality observations** about subagents you invoked this session (missed bugs, false positives, judgment calls, useful catches — see the progress template for guidance). The orchestrating session is the right vantage point for this because it reads each subagent's output before acting on it.
16. Update `features.json` pass/fail status
17. Remove task lock file from `.claude/current_tasks/`
18. Write **narrative dev log** to `docs/session-logs/YYYY-MM-DD-[topic].md` (see Progress Files below for format)
19. If backlog mode is `jira` and Jira comments are enabled, post status summary as Jira comment to the sprint epic/ticket
20. Check: were any technical decisions made that aren't captured in an ADR?
21. Check: did we discuss anything that changes the architecture, data model, or other project docs?
22. If an external task management system is configured, log a summary there
23. Present the session summary to the owner using the **Session Summary Briefing** format (see Owner Briefings below)
24. **Issue the next-chat handoff prompt** (deterministic — do NOT skip; see Sprint Lifecycle below for which prompt fires when)

---

## Sprint Lifecycle

A sprint runs across **multiple chats**, not one long conversation. Each phase boundary is a hard new-chat handoff.
Phases: Alignment → Planning → Story chats → Close-Out → Maintenance → Retro → Next Alignment/Planning.
Alignment runs before planning when triggered (new project, new phase, ambiguity detected, owner request). It produces a Project Charter (first time) and PRD, then hands off to sprint planning in a fresh chat. Not every sprint cycle requires alignment — it fires on trigger, not on schedule.
STATUS.md's `Cycle phase` field tells each new chat which phase it is in and what to do next. Valid `Cycle phase` values include `alignment`.

**On phase transitions, read:** `[FABRIKA_PATH]/core/workflows/sprint-lifecycle.md`

---

## Design Alignment

Before sprint planning, the orchestrator runs Design Alignment when triggered: new project, new phase, ambiguity detected, or owner request. Design Alignment is a structured requirements-gathering protocol that captures design intent in durable documents before sprint planning begins. Brain dumps no longer go directly to story creation — they flow through Design Alignment first.

For sprint-based projects, Design Alignment produces:
- **Project Charter** (first time only) — problem space, target user, core capabilities, constraints, success criteria. Created once at project inception, lives at `docs/01-Product/Project-Charter.md`.
- **PRD** (per phase/feature) — problem statement, solution, user stories, module changes, implementation decisions, testing decisions. Lives in `docs/01-Product/PRDs/`.
- **Domain Language** — shared domain vocabulary, created or updated during alignment, lives at `docs/00-Index/Domain-Language.md`. Terms captured during alignment, code-level names populated during implementation.

After the owner approves the Charter and/or PRD, the orchestrator issues a fresh-chat handoff to sprint planning. The scrum master receives the approved PRD as its primary input for story decomposition.

**For the full protocol, read:** `[FABRIKA_PATH]/core/workflows/design-alignment.md`

---

## Development Workflow

Claude Code drives the development process proactively. Don't wait for the owner to orchestrate each step.

**Before starting any story, sprint planning, or bug fix, read:** `[FABRIKA_PATH]/core/workflows/development-workflow.md`

Summary of workflows covered:
- **Design Alignment** — structured requirements gathering → Project Charter + PRD → fresh-chat handoff to sprint planning (see Design Alignment section above)
- **Starting a Story** — spec expansion → approval → optional architect design review → branch → testing approach branching (TDD: test-writer spec-first → implementer vertical slices → refactor; test-informed: implementer → test-writer coverage; test-after: implementer → evaluation cycle) → evaluate → fix cycle
- **Completing a Story (Evaluation Cycle)** — tests → lint → commit → reviewer → validator → planner validation → optional architect structural evaluation → rollback protocol (max 2 retries)
- **Sprint Planning** — scrum-master receives approved PRD → topology assessment → 2-3 stories → contract → approval
- **Ideation & Backlog Grooming** — new stories, re-scoping, someday-maybe
- **Research & Technical Discussion** — research docs, ADRs
- **Bug Reporting & Fix Workflow** — see `docs/02-Engineering/bug-workflow.md`
- **Architecture Assessment (Ad Hoc)** — owner-initiated or orchestrator-detected structural review of existing code

---

## Analytics Workspace Workflow (analytics-workspace type only)

No sprints. Work is organized as individual analysis tasks with a tiered review workflow based on data environment.

**Tier 1 (local data only):** plan -> promotion check -> write -> logic review -> [revise -> re-review]* -> execute -> validate + brief check -> deliver. No execution manifest or performance review.

**Tier 2 (production data):** plan -> promotion check -> write (code + metadata queries) -> logic review -> [revise -> re-review]* -> execute metadata -> performance review -> [revise -> re-review]* -> [cost approval - cloud only] -> execute -> validate + brief check -> deliver.

Mixed sources use highest tier. Stakes (low/medium/high) scale review intensity within tiers. The orchestrator classifies tier and stakes after plan approval, before workflow begins.

For complex analyses (3+ data sources, multiple stakeholders, novel domain, >2 day effort, or significant decision impact), Design Alignment triggers to produce an enhanced Analysis Brief — not a Charter/PRD. This is optional and driven by complexity, not by default.

**For analytics-workspace projects, read:** `[FABRIKA_PATH]/core/workflows/analytics-workspace.md`

---

## Agentic-Workflow Lifecycle (agentic-workflow type only)

No sprints. Work is organized as structural changes following a 7-step protocol: Plan → Align → Execute → Verify → Incorporate Feedback → Present → Ship. Each change gets a version bump and CHANGELOG entry. The planner writes a persistent plan file to `docs/plans/[identifier]-plan.md` — owner pushback re-invokes the planner to revise (the orchestrator never edits plans directly). Verification agents receive the plan file path in their strict dispatch for independent assessment.

Operational mode (if enabled) is human-initiated and interactive — no agent orchestration for operational sessions.

**For agentic-workflow projects, read:** `[FABRIKA_PATH]/core/workflows/agentic-workflow-lifecycle.md`

---

## Owner Briefings

When presenting plans, results, or summaries to the owner, do not dump raw artifacts or tell the owner to go read files. Present a plain-language briefing that explains what happened, why it matters, and how it affects the product. Read the briefing principles first, then follow the appropriate format:

- **Principles:** `[FABRIKA_PATH]/core/briefings/briefing-principles.md` — read this first; it applies to all briefings
- **After spec expansion:** `[FABRIKA_PATH]/core/briefings/spec-briefing.md` — presenting a spec from product-manager planning mode
- **After sprint planning:** `[FABRIKA_PATH]/core/briefings/sprint-plan-briefing.md` — presenting a sprint plan from scrum-master
- **Session close-out / story completion:** `[FABRIKA_PATH]/core/briefings/session-summary-briefing.md` — summarizing what was done and what it means
- **After sprint retro:** `[FABRIKA_PATH]/core/briefings/retro-briefing.md` — translating the retro artifact into plain-language takeaways
- **After analytics-workspace plan creation:** `[FABRIKA_PATH]/core/briefings/task-plan-briefing.md` — presenting an analysis plan from the analysis planner
- **After analytics-workspace task delivery:** `[FABRIKA_PATH]/core/briefings/task-outcome-briefing.md` — summarizing analysis results and their business impact
- **After agentic-workflow plan (Step 2):** `[FABRIKA_PATH]/core/briefings/structural-plan-briefing.md` — presenting a structural update plan for approval
- **After agentic-workflow execution (Step 6):** `[FABRIKA_PATH]/core/briefings/change-summary-briefing.md` — presenting completed changes before shipping

All briefings that report on completed work (session summaries, retros, task outcomes, change summaries) should include token efficiency data when available. See briefing-principles.md for the canonical token cost format.

---

## Progress Files

- **STATUS.md** — Project state snapshot, overwritten each session. Contains `Cycle phase` and `Next chat should:` fields for orientation.
- **Sprint Progress File** — `docs/04-Backlog/Sprints/Sprint-XX-progress.md` — append-only sprint log.
- **Dev Logs** — `docs/session-logs/YYYY-MM-DD-[topic].md` — narrative first-person dev diary entries (200-500 words).

**For templates and format details, read:** `[FABRIKA_PATH]/core/workflows/progress-files.md`

---

## Hooks

Hooks enforce workflow conventions mechanically — the agent cannot rationalize around them. Two layers: git hooks (universal) and Claude Code hooks (in `.claude/settings.json`).

Git hooks: pre-commit (branch protection, secret scanning, STATUS.md gate, mesh scope), commit-msg (conventional format), post-commit (STATUS.md advisory), pre-push (test gate).
Claude Code hooks: destructive git guard, protected file guard, auto-format, lock file cleanup.

**For full hook inventory and hook discovery workflow, read:** `[FABRIKA_PATH]/core/workflows/hooks-reference.md`

---

## Maintenance Sessions

Run between sprints or weekly (whichever comes first). See full checklist at `docs/02-Engineering/maintenance-checklist.md`.

**Summary of what maintenance covers:**
- Documentation sync (ARCHITECTURE.md, CLAUDE.md, README)
- Code quality (dedup scan, TODO/FIXME scan, dead code)
- Evaluation findings sweep (triage non-blocking observations from evaluation reports)
- Test health (full test suite, features.json reconciliation, regression check)
- Bug review (open bugs, missed-by patterns, eval case coverage, root cause clusters)
- Progress file reconciliation (STATUS.md accuracy, sprint progress completeness)
- Dependency health (outdated packages, security advisories — report only, do NOT auto-update)
- Architecture review (conditional — after major features, on request, or when code-reviewer flags structural concerns)
- Knowledge synthesis (conditional — when `wiki/` exists: extract+index new artifacts, synthesize topic articles when trigger met, update wiki narrative)
- Context efficiency review (scan session logs for wasteful patterns)
- Hook health (verify hooks match current test runner and sprint configuration)
- Evaluation health (review agent-changelog.md, build/update eval cases, run evals, propose prompt improvements)

**Git convention:** `maint:` commit prefix. `git tag maintenance-YYYY-MM-DD && git tag -f maintenance-latest` after completion.

---

## Wiki Knowledge Layer

If this project has a `wiki/` directory, it contains a knowledge layer that synthesizes scattered project artifacts (ADRs, retros, evaluation reports, research docs) into organized, continuously updated topic articles. The wiki serves both humans and agents:

- **Check `wiki/index.md` first** for a narrative overview of the project — from what it is and why it exists, through its major knowledge domains, to its current state and open questions. This is faster and more complete than searching individual files.
- **Check `wiki/topics/`** for synthesized knowledge on specific subjects before grepping through raw artifacts.
- **During brainstorming and alignment conversations**, draw on wiki topics to surface relevant project history, past decisions, and open questions.

The wiki is maintained automatically during maintenance sessions (see the Knowledge Synthesis section of the maintenance checklist). Topic articles are created via a notice-and-proceed model — the agent creates and notifies the owner, proceeding unless the owner objects. All topic articles use Domain Language terms.

**For the synthesis workflow, read:** `[FABRIKA_PATH]/core/workflows/knowledge-synthesis.md`
**For the pipeline specification, read:** `[FABRIKA_PATH]/core/workflows/knowledge-pipeline.md`

---

## Evaluation System

A graduated, self-building system for measuring and improving agent quality. Scaffolded at project creation; populated over time by the maintenance session.

- **docs/evals/agent-changelog.md** — Log of agent prompt modifications with failure context. Written whenever an agent prompt is modified. Captures WHAT changed, WHY (the observed failure), and WHICH session logs document the failure.
- **docs/evals/{agent-name}/** — Eval cases per agent. Each case has a known correct answer. Built from real observed failures, not synthetic scenarios.
- **docs/04-Backlog/Bugs/** — Bug reports with `missed-by` tracing. Bugs are the ground truth for agent quality — they are the only reliable signal that the evaluation cycle missed something. Every bug with a `missed-by` field produces an eval case.
- **Lifecycle:** Session logs capture failures (day 1) → bugs reported by owner provide ground truth → maintenance reviews and builds eval cases (after 2-3 sprints) → maintenance runs evals and proposes prompt improvements (ongoing) → human reviews and approves changes.
- **Coverage target:** Top 10 observed failure modes per agent. Stop adding evals when accuracy is stable and no new failure patterns are emerging.

See `docs/evals/README.md` for detailed format and process.

---

## Document Creation Triggers

When technical decisions, data sources, schema changes, architecture divergences, bugs, or other trigger events occur during development, create the appropriate document.

**For the full trigger table, read:** `[FABRIKA_PATH]/core/workflows/doc-triggers.md`

---

## Git & Branch Workflow
- **Branch naming:** `feature/[PROJECT_KEY]-S-XXX-description` for stories, `chore/description` for non-story work
- **Commit format:** Conventional commits: `feat([PROJECT_KEY]-S-042): add login form`
  - Prefixes: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`, `maint:`
- **Never commit directly to main.** Always use a feature branch.
- **No AI attribution** in commit messages.
- **Hooks:** Pre-push, post-commit, and pre-commit hooks enforce conventions mechanically. See Hooks section.

---

## Subagents

All agents are invoked proactively by Claude Code at the trigger points in the Development Workflow. Agent prompts are **stack-agnostic** — they read project-specific details from this CLAUDE.md file and on-demand reference docs. Which agents are installed depends on the project type — see the Agent Catalog.

**Dispatch protocol:** Before invoking any sub-agent, read `[FABRIKA_PATH]/core/workflows/dispatch-protocol.md`. It defines what to provide and what to withhold for each agent at each invocation point. Reviewers, validators, and designers get strict dispatch (plan + file paths + rubric only — no editorial, no hints); planners and coordinators get contextual dispatch (richer project state).

**Archetypes:** Each agent implements one of seven archetypes (Planner, Reviewer, Validator, Coordinator, Designer, Implementer, Architect) that define base tool profiles and contracts. See `[FABRIKA_PATH]/core/agents/archetypes/` for templates.

### Sprint-based types

| Role | Default Agent | Specialized Variants |
|------|--------------|---------------------|
| **Planner** | product-manager | experiment-planner (ml-engineering), api-designer (library) |
| **Reviewer** | code-reviewer | + prompt-reviewer (ai-engineering, supplemental) |
| **Validator** | test-writer | model-evaluator (ml-engineering), eval-engineer (ai-engineering), data-quality-engineer (data-engineering) |
| **Coordinator** | scrum-master | (same for all sprint-based types) |
| **Implementer** | software-engineer | data-engineer (data-engineering, analytics-engineering), data-analyst (analytics-workspace, data-app), ml-engineer (ml-engineering), ai-engineer (ai-engineering) |
| **Architect** | software-architect | data-architect (data-engineering, analytics-engineering, data-app, ml-engineering) |

**Role behaviors:**
- **Planner** — Two modes: **planning mode** (expands stories into specs, invoked at story start) and **validation mode** (verifies acceptance criteria, invoked before marking done). Specialized planners adapt the spec format: experiment-planner produces experiment designs; api-designer produces API surface specs.
- **Reviewer** — Reviews implementation against acceptance criteria, rubrics (`docs/02-Engineering/rubrics/code-review-rubric.md`), and security (semgrep). Checks for duplicates. Enforces mesh isolation scope. For ai-engineering, the prompt-reviewer is a supplemental reviewer that checks prompt quality, safety, and cost alongside the code-reviewer.
- **Validator** — Two modes: **spec-first** (TDD stories — writes behavioral tests from the spec before code exists, one vertical slice at a time) and **coverage** (test-informed and test-after stories — writes tests after implementation, verifies coverage against rubric at `docs/02-Engineering/rubrics/test-rubric.md`). Mode is determined by dispatch: no source paths = spec-first, source paths present = coverage. Runs E2E verification per project type. Specialized validators adapt: model-evaluator runs metric evals; eval-engineer runs LLM eval suites; data-quality-engineer tests at every pipeline lifecycle stage.
- **Coordinator** — Sprint planning, topology assessment, maintenance scheduling, retros. Also invoked when conversation drifts into prolonged deliberation.
- **Implementer** — Writes production code against the approved spec. Dispatched by the orchestrator after spec approval — the orchestrator never writes code directly, even for trivial tasks. Specialized implementers carry domain expertise for their project type(s). For lightweight changes (single-file, fully specified, not a new feature), uses reduced-ceremony dispatch but still goes through the implementer agent.
- **Architect** — Evaluates structural design: module depth, interface simplicity, component boundaries. Three modes: **design mode** (reviews proposed modules in a spec, invoked after spec approval), **review mode** (evaluates implemented changes, optional supplement to code-reviewer), and **ad hoc** (owner-initiated assessment of existing code). Specialized architects adapt: software-architect for web-app/automation/library/ai-engineering; data-architect for data-engineering/analytics-engineering/data-app/ml-engineering. Output is proposals and assessments, never code changes — refactor proposals require owner approval.

### Task-based types (analytics-workspace)

| Role | Agent |
|------|-------|
| **Planner** | analysis-planner — takes vague asks, produces briefs and technical plans; validation mode checks output against brief |
| **Reviewer** | logic-reviewer — validates SQL/Python/DAX logic (pre-execution) |
| **Reviewer (Tier 2)** | performance-reviewer — assesses execution manifest for cost/efficiency (Tier 2 production data only) |
| **Validator** | data-validator — sanity checks, cross-references, spot-checks on output; produces validation report |
| **Implementer** | data-analyst — implements analysis scripts, SQL, notebooks; write-only and execute-metadata modes |

No coordinator agent for analytics workspaces (no sprints to coordinate).

### Methodology-based types (agentic-workflow)

| Role | Agent |
|------|-------|
| **Planner** | workflow-planner — expands change requests into plan files (`docs/plans/[identifier]-plan.md`) with file inventories, integration analysis, and risk identification |
| **Reviewer** | methodology-reviewer — evaluates cross-reference consistency, prompt patterns, instruction decomposition, smell tests |
| **Validator** | structural-validator — mechanically verifies file existence, version consistency, catalog accuracy, reference resolution |
| **Implementer** | context-engineer — writes methodology artifacts (agent prompts, workflows, instruction files, catalogs, integration templates) against approved plan |
| **Architect** | context-architect — evaluates instruction architecture: decomposition, pointer patterns, context budgets, integration surface completeness |
| **Coordinator** | scrum-master — for change backlog sequencing (structural mode only) |

No agent orchestration for operational mode sessions (human-driven).

### Claude Code Tool Guidance

When invoking sub-agents via the Agent tool, control tool access through the prompt and sub-agent configuration. Each archetype defines a recommended tool set in `[FABRIKA_PATH]/core/agents/archetypes/`:

- **Planners:** Read, Glob, Grep, Write, Edit. No Bash.
- **Reviewers (with commands):** Read, Glob, Grep, Write, Bash. No Edit.
- **Reviewers (no commands):** Read, Glob, Grep, Write. No Edit, no Bash.
- **Validators:** Read, Glob, Grep, Write, Edit, Bash. Edit constrained to `tests/` and `docs/evaluations/`.
- **Coordinators:** Read, Glob, Grep, Write, Edit, Bash. Edit constrained to status files and backlog. Bash constrained to git and search.
- **Designers:** Read, Glob, Grep, Write. No Edit, no Bash.
- **Implementers:** Read, Glob, Grep, Write, Edit, Bash. Full toolset — they write production changes.
- **Architects:** Read, Glob, Grep, Write. No Edit, no Bash — they evaluate and report, they do not change files.

Instruction-level constraints (enforced in the sub-agent prompt):
- Reviewers create new files (reports) — they do not modify existing files
- Validators write to `tests/` and `docs/evaluations/` only, never `src/`
- Coordinators edit `STATUS.md`, `docs/04-Backlog/`, and `features.json` only
- Implementers modify production files according to the approved plan only — no unplanned changes
- Architects create new files (assessment reports) — they do not modify production files

---

## Fabrika Relationship

This project uses **Fabrika**, an agentic workflow framework. Local agent changes are expected — tune freely during sprints. For how changes flow back to canonical Fabrika (eval artifacts, harvest workflow, updates), read `.fabrika/FABRIKA.md` on demand. Do not load it into every session.

---

## Doc Standards
When creating or editing any doc in `docs/`:
- Always include YAML frontmatter: `type`, `status`, `created`, `updated`, `tags`
- Use `[[wikilinks]]` to connect related docs
- Write in plain language — no jargon without explanation
- When creating or editing docs, use terms from the Domain Language document (`docs/00-Index/Domain-Language.md`) when it exists. If you introduce a new domain concept, flag it for addition to the Domain Language.
- Docs should be self-contained: readable without CLAUDE.md context

---

## Testing Rules

### Graduated Testing Approach
Each sprint story is assigned a testing approach by the scrum master
during sprint planning. The approach is recorded in the sprint
contract per story and determines the implementation flow:

- **TDD** (high complexity — new modules, complex logic, greenfield):
  Test-writer writes spec-first tests before code exists,
  implementer codes to pass them in vertical slices (one behavior at
  a time), then refactor. The orchestrator alternates between
  test-writer and implementer dispatches. Reuse agent sessions
  across cycles when using Claude Code's Agent tool (SendMessage to
  continue an existing agent preserves context).
- **Test-informed** (medium complexity — modifying existing modules):
  Implementer codes with awareness of test boundaries from the spec,
  then test-writer writes tests in coverage mode.
- **Test-after** (low complexity — config changes, minor fixes):
  Implementer codes, test-writer verifies during the evaluation
  cycle.

The development workflow branches on testing approach. See
`[FABRIKA_PATH]/core/workflows/development-workflow.md` for the
full flow.

### General Testing Rules
- **No mocking the database.** Use in-memory or temp-file instances — fast and honest.
- **Fixture-based tests** where applicable. Save real response snapshots in `tests/fixtures/`.
- **Coverage:** 80%+ on core logic and storage.
- **CI:** GitHub Actions runs linter + tests on every PR.
- **Concise test output:** Test runners should print summary lines, not full stack traces. Details go to log files. Errors should be grep-friendly: `ERROR: [component] [description]`.
- **Fast mode:** The fast test command runs a subset for quick feedback. Full suite is gated on merge and maintenance.
- **Regression baseline:** Every sprint contract includes "all existing tests continue to pass" as a baseline criterion.
- **Test summary:** After a full test run, produce a summary at `tests/latest-summary.md` that an agent can read to understand test state without re-running.

---

## Task Locking

When starting work on a story, create a lock file at `.claude/current_tasks/[TICKET-ID].lock` containing the session start timestamp and ticket title. Remove it during session close-out. This prevents duplicate work if multiple sessions are running and provides an audit trail of what is actively being worked on.

If a stale lock file exists (from a session that didn't clean up), the session orientation step flags it for the owner's attention before proceeding.

---

## Key Constraints
- **Orchestrate, don't wait.** Drive the workflow proactively. The owner provides decisions and reviews; you handle everything else.
- **Verify and report failures.** After every file creation, git operation, or external call — if it fails, stop and explain. Never silently skip.
- **Respect the phases.** Don't build future-phase infrastructure during the current phase.
- **Small PRs.** One feature per PR. Split if it grows.
- **Tests are not optional.** Every PR touching `src/` includes tests.
- **Privacy first.** No credentials in git. No third-party services unless decided via ADR.
- **Conservative sprint scope.** 2-3 stories per sprint. Favor shipping over perfecting.
- **Context window hygiene.** Load docs on demand, not up front. Return concise summaries from subagent invocations. Avoid reading large files when targeted grep would suffice.
- **Progressive context disclosure.** This CLAUDE.md is front-loaded into every session — keep it to what every session needs (identity, lifecycle, git conventions, stack config). Phase-specific context (sprint planning rules, evaluation workflow, maintenance checklist) lives in agent prompt files and referenced docs, loaded only when that phase is active. If a section of this file has not been relevant in 3+ sprints, move it to an on-demand doc and add a pointer here.
- **Stack-agnostic agent prompts.** Never put technology-specific references in global agent prompts. All tech details live in this CLAUDE.md's Project Stack section.
- **Prefer improving existing agents over adding new ones.** If a new capability is needed, first check if it belongs in an existing agent's scope. Only create a new agent if the capability requires a fundamentally different evaluation lens.
- **Pure orchestrator.** The orchestrator dispatches to implementer agents for all production code changes — it does not implement directly, even for trivial tasks. Lightweight dispatch reduces ceremony, not the dispatch itself.

---

## Future Considerations

These are documented for reference but not implemented in the current workflow:

- **Generator agent formalization:** If moving to fully autonomous multi-agent pipelines (no human in the loop for extended periods), the main Claude Code session should be formalized as a dedicated generator agent with its own prompt. Not needed while a human is present and driving sessions.
- **External context integration:** Making external knowledge bases or task management content available to project agents via symlinks or MCP. Currently project docs are self-contained in `docs/`; information flows FROM project docs TO external systems, not the reverse.
- **Agent self-improvement:** Maintenance sessions proposing and validating prompt improvements against the eval harness. This activates naturally once the evaluation system has accumulated cases. See `docs/evals/README.md`.
