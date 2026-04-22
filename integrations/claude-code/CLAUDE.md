# CLAUDE.md — [PROJECT_NAME]

> [One-line description of what this project is and why it exists.]

## Orchestration Principle

Claude Code orchestrates the entire development workflow. The human's role is decision-making and review: approving plans, reviewing evaluations, selecting sprint scope, and approving prompt improvements. The human never manually invokes agents, moves files, updates progress files, or runs checklists. If an action can be performed by the agent, the agent performs it automatically.

## Project Basics
- **Project Key:** [PROJECT_KEY] (e.g. MYAPP — used for branch naming and story IDs)
- **Project Type:** [data-app | data-platform | ml-project | web-app | automation] (can be multi-type)
- **Repo:** `~/projects/[project-name]`
- **Project docs:** `~/projects/[project-name]/docs`
- **Document Catalog:** `[FABRIKA_PATH]/core/Document-Catalog.md`

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
| Web app | Full browser automation — navigate, click, verify | Playwright MCP |
| Data app (Dash, Streamlit) | Browser automation for UI + model assertion tests | Playwright MCP + test runner |
| Data infrastructure (dbt, pipelines) | Output diffing against known-good oracle | Test runner + diff scripts |
| Automation (scripts, scrapers) | Integration tests against real/mock targets | Test runner |
| ML project | Model evaluation metrics + training reproducibility | Test runner + eval framework |

**This project's verification method:** [Describe which approach applies and any project-specific details]

### Model Routing

| Agent | Recommended Model | Rationale |
|-------|------------------|-----------|
| product-manager (planning) | Opus | Spec expansion needs strong reasoning |
| product-manager (validation) | Opus | Needs to catch spec gaps |
| code-reviewer | Opus | Subtle bug detection |
| test-writer (strategy) | Opus | Designing what to test |
| test-writer (execution) | Sonnet | Running mechanical test scripts |
| scrum-master | Opus | Topology assessment, sprint planning |
| maintenance session | Sonnet | Checklist-driven, documentation updates |

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
├── src/
├── tests/
│   ├── fixtures/
│   └── [test files]
└── [other project-specific dirs]
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
- **Finding the next ID:**
  ```bash
  rg "^id: " docs/04-Backlog/Epics/ | sort | tail -1
  rg "^id: " docs/04-Backlog/Stories/ | sort | tail -1
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
15. Append to current sprint's progress file: what was done, what failed, what remains, **any lessons / insights worth surfacing in the retro**, and **any agent quality observations** about subagents you invoked this session (missed bugs, false positives, judgment calls, useful catches — see the progress template for guidance). The orchestrating session is the right vantage point for this because it reads each subagent's output before acting on it.
16. Update `features.json` pass/fail status
17. Remove task lock file from `.claude/current_tasks/`
18. Write **narrative dev log** to `docs/session-logs/YYYY-MM-DD-[topic].md` (see Dev Log Format below)
19. If backlog mode is `jira` and Jira comments are enabled, post status summary as Jira comment to the sprint epic/ticket
20. Check: were any technical decisions made that aren't captured in an ADR?
21. Check: did we discuss anything that changes the architecture, data model, or other project docs?
22. If an external task management system is configured, log a summary there
23. Summarize what was done and what to review
24. **Issue the next-chat handoff prompt** (deterministic — do NOT skip; see Sprint Lifecycle below for which prompt fires when)

### Dev Log Format (`docs/session-logs/`)
Dev logs are the **primary fuel for social media content** via content generation workflows. They must be narrative, not just metrics.

Write each dev log from **the user's first-person perspective** (as if they're telling a colleague what they built today). Include:

- **What was built** — the feature, the implementation approach, what it does
- **What decisions were made and why** — trade-offs considered, alternatives rejected
- **What was interesting or surprising** — edge cases, things that worked unexpectedly well or poorly
- **Lessons learned** — insights about the tech, the domain, or the process
- **What's next** — what the next session should pick up

**Tone:** Casual-smart, thinking-out-loud. Raw material for content generation.
**Length:** 200-500 words. A builder's diary entry, not a formal report.

---

## Sprint Lifecycle

A sprint runs across **multiple chats**, not one long conversation. Each phase boundary is a hard new-chat handoff. This is deliberate — see Sprint Lifecycle Hygiene below.

### Phases (in order)

```
Sprint Planning chat
    ↓ (planning produces sprint file, contract, progress file → prompts for new chat)
Story 1 chat ─┐
Story 2 chat  │  (one chat per story; close-out prompts for next story chat)
...           │
Story N chat ─┘ (last story close-out prompts for sprint close-out chat)
    ↓
Sprint Close-Out (Merge) chat   → prompts for new chat: maintenance
    ↓
Maintenance chat                → prompts for new chat: retro
    ↓
Sprint Retro chat               → produces Sprint-XX-retro.md → prompts for new chat: next planning
    ↓
Next Sprint Planning chat
```

**Four chats between sprints**: close-out merge, maintenance, retro, planning. They are not bundled.

### Cycle phase indicator

`STATUS.md` carries a `Cycle phase` field that any new chat reads during orientation to know where it is and what to do next. Allowed values:

- `planning` — sprint planning chat is in progress or just finished
- `story-in-progress` — a story chat is active or the previous story chat just closed (a non-last story)
- `sprint-close` — last story is approved; merge chat needs to run
- `maintenance` — merge done; maintenance chat needs to run
- `retro` — maintenance done; retro chat needs to run

### What each phase chat does

**Sprint Planning chat** — Invoke the scrum-master agent. Produces `Sprint-XX.md`, `Sprint-XX-contract.md`, `Sprint-XX-progress.md`, `features.json` entries, and external task system entries (if configured). Sets `Cycle phase: story-in-progress` in STATUS.md. **Close-out prompt:** *"Sprint planning complete. Open a new chat to start [TICKET] — [Story 1 title]."*

**Story chat (each)** — Standard Session Lifecycle. One story per chat. **Close-out prompt branches on whether more stories remain in the sprint:**
- More stories remain → set `Cycle phase: story-in-progress`. Prompt: *"Story [TICKET] complete and reviewed. Open a new chat to start [NEXT-TICKET] — [Next title]."*
- This was the last story → set `Cycle phase: sprint-close`. Prompt: *"Last sprint story is complete and reviewed. Open a new chat for sprint close-out (merge all sprint branches)."*

**Sprint Close-Out (Merge) chat** — Verify branch hygiene gate before doing anything else:
1. Working tree clean
2. All `feature/[PROJECT_KEY]-S-XXX-*` branches for this sprint either merged to `main` or explicitly deferred (deferral noted in `Sprint-XX-progress.md`)
3. `main` is the active branch
4. Archive any sprint-specific scratch files; ensure `Sprint-XX-progress.md` is final

Set `Cycle phase: maintenance` in STATUS.md. **Close-out prompt:** *"Sprint branches merged. Working tree clean. Open a new chat to run maintenance."*

**Maintenance chat** — Run the full checklist at `docs/02-Engineering/maintenance-checklist.md`. Tag git: `git tag maintenance-YYYY-MM-DD && git tag -f maintenance-latest`. Set `Cycle phase: retro` in STATUS.md. **Close-out prompt:** *"Maintenance complete. Open a new chat with the scrum-master to run the sprint retro."*

**Sprint Retro chat** — Invoke the scrum-master agent. It reads `Sprint-XX-progress.md`, the latest `docs/maintenance/*-YYYY-MM-DD.md` outputs, the previous sprint's retro file (if any), and writes `docs/04-Backlog/Sprints/Sprint-XX-retro.md` using `docs/Templates/Sprint-Retro-Template.md`. Set `Cycle phase: planning` in STATUS.md. **Close-out prompt:** *"Retro file written at Sprint-XX-retro.md. Open a new chat with the scrum-master to plan the next sprint."*

**Next Sprint Planning chat** — Scrum-master orientation must read the previous sprint's retro file before proposing scope. The retro's "process changes for next sprint" items are inputs to planning, not optional reading.

### Sprint Lifecycle Hygiene (why fresh chats matter)

The phase boundaries are hard new-chat handoffs for three reasons:

1. **Context window stays clean.** A single chat that spans planning → 5 stories → maintenance → retro will accumulate hundreds of file reads and tool calls irrelevant to the current task. Fresh chats start with the orientation routine reading the small set of files actually needed.
2. **Fresh evaluator agents make better evaluators.** A code-reviewer that's already sat through three story implementations has anchored on patterns that aren't necessarily good. A new chat re-invokes the agent against the rubric without that bias.
3. **Failure modes don't leak across stories.** If story 1 had a flaky test that got worked around, story 2 should not inherit "we ignore that test class." A new chat starts from STATUS.md and the sprint contract, not from the previous story's running context.

Do not "optimize" away the new-chat boundaries by combining phases. The friction is the feature.

---

## Development Workflow

Claude Code drives the development process proactively. Don't wait for the owner to orchestrate each step.

### Starting a Story
1. Read the story file (or issue tracker ticket) and the sprint contract for this sprint
2. Read relevant project docs on demand: Architecture Overview, Data Model, relevant ADRs, research notes
3. Read the grading rubrics at `docs/02-Engineering/rubrics/` to understand evaluation criteria
4. Invoke the **product-manager** agent in **planning mode** to expand the story into a full implementation spec (saved to `docs/plans/[TICKET]-spec.md`)
5. Present the spec to the owner for approval
6. Create feature branch: `feature/[PROJECT_KEY]-S-042-description`
7. Update story: `status: In Progress`
8. Implement the feature against the approved spec
9. Invoke the **test-writer** agent to write tests for the new code

### Completing a Story (Evaluation Cycle)
Before marking a story complete, run the full evaluation cycle automatically:
1. Run tests — all pass (including existing tests — no regressions)
2. Run linter — no errors
3. Commit with conventional format: `feat([PROJECT_KEY]-S-042): description`
4. Invoke the **code-reviewer** agent — it reviews against the sprint contract acceptance criteria, grading rubrics, and runs semgrep
5. Invoke the **test-writer** agent — it verifies test coverage meets rubric standards and runs E2E verification if applicable to this project type
6. Invoke the **product-manager** agent in **validation mode** — it verifies acceptance criteria from the sprint contract are met
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
16. Tell the owner what was done and what to review

### Sprint Planning
1. Invoke the **scrum-master** agent to facilitate
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
9. Present the sprint plan and contract to the owner for approval

### Ideation & Backlog Grooming
When the owner is brainstorming features, re-prioritizing, or refining stories:
1. New stories defined → create story files (and Jira tickets if Jira mode) and update epic
2. Existing stories re-scoped → update story frontmatter/body (and Jira ticket if Jira mode)
3. Ideas that are exploratory and not committed → add to `docs/09-Personal-Tasks/Someday-Maybe.md`
4. Scope moves between phases → update `docs/01-Product/Phase Definitions.md`

### Research & Technical Discussion
When the conversation involves investigating a technology or debating an approach:
1. Technology evaluation → create or update a research doc in `05-Research/`
2. Data source investigation → create or update a research note in `05-Research/Data Source Research/`
3. If the discussion produces a decision → create an ADR in `02-Engineering/ADRs/`
4. If the discussion changes the data model or architecture → update those docs

---

## Progress Files

### STATUS.md (Project Root)

A **snapshot** of current project state, overwritten each session. Always small. Used for quick orientation.

```markdown
## [PROJECT_NAME] — Status
Last updated: YYYY-MM-DD

### Current Sprint: Sprint X
- **Topology:** [pipeline | mesh | hierarchical]
- **Cycle phase:** [planning | story-in-progress | sprint-close | maintenance | retro]
- **Next chat should:** [one-line pointer — e.g., "Start S-007: Add export button" or "Run sprint close-out merge" or "Run sprint retro"]
- **Sprint contract:** docs/04-Backlog/Sprints/Sprint-XX-contract.md
- **Progress file:** docs/04-Backlog/Sprints/Sprint-XX-progress.md

### Active Work
- [TICKET]: [title] — [status: in-progress | blocked | in-review]

### Blockers
- [Any blockers or risks]

### Last Maintenance
- Date: YYYY-MM-DD
- Tag: maintenance-YYYY-MM-DD
```

The `Cycle phase` and `Next chat should:` fields are how a fresh chat orients itself — see Sprint Lifecycle for what each phase means.

### Sprint Progress File (Per-Sprint)

`docs/04-Backlog/Sprints/Sprint-XX-progress.md` — append-only log for the current sprint. Archived when the sprint closes. Topology-tagged entries.

---

## Hooks

Three Claude Code hooks enforce workflow conventions mechanically:

### Pre-Push (`.claude/hooks/pre-push.sh`)
Runs the fast test command. Blocks push if any test fails. Prevents regressions from reaching the remote.

### Post-Commit (`.claude/hooks/post-commit.sh`)
Verifies STATUS.md was modified in the commit. Warns (does not block) if missing. Ensures session lifecycle compliance.

### Pre-Commit (`.claude/hooks/pre-commit.sh`)
For mesh topology sprints: reads the active sprint contract's isolation scopes and verifies modified files fall within the declared scope for the active ticket. Blocks commit if out-of-scope files are modified. Inactive for pipeline and hierarchical topologies.

---

## Maintenance Sessions

Run between sprints or weekly (whichever comes first). See full checklist at `docs/02-Engineering/maintenance-checklist.md`.

**Summary of what maintenance covers:**
- Documentation sync (ARCHITECTURE.md, CLAUDE.md, README)
- Code quality (dedup scan, TODO/FIXME scan, dead code)
- Test health (full test suite, features.json reconciliation, regression check)
- Progress file reconciliation (STATUS.md accuracy, sprint progress completeness)
- Dependency health (outdated packages, security advisories — report only, do NOT auto-update)
- Context efficiency review (scan session logs for wasteful patterns)
- Hook health (verify hooks match current test runner and sprint configuration)
- Evaluation health (review agent-changelog.md, build/update eval cases, run evals, propose prompt improvements)

**Git convention:** `maint:` commit prefix. `git tag maintenance-YYYY-MM-DD && git tag -f maintenance-latest` after completion.

---

## Evaluation System

A graduated, self-building system for measuring and improving agent quality. Scaffolded at project creation; populated over time by the maintenance session.

- **docs/evals/agent-changelog.md** — Log of agent prompt modifications with failure context. Written whenever an agent prompt is modified. Captures WHAT changed, WHY (the observed failure), and WHICH session logs document the failure.
- **docs/evals/{agent-name}/** — Eval cases per agent. Each case has a known correct answer. Built from real observed failures, not synthetic scenarios.
- **Lifecycle:** Session logs capture failures (day 1) → maintenance reviews and builds eval cases (after 2-3 sprints) → maintenance runs evals and proposes prompt improvements (ongoing) → human reviews and approves changes.
- **Coverage target:** Top 10 observed failure modes per agent. Stop adding evals when accuracy is stable and no new failure patterns are emerging.

See `docs/evals/README.md` for detailed format and process.

---

## Document Creation Triggers

During ongoing development, create new documents when these situations arise. Reference the **Document Catalog** for document structure and purpose.

| Trigger | Action |
|---------|--------|
| Technical decision made (stack, library, pattern) | Create ADR in `02-Engineering/ADRs/` |
| New data source discussed | Create Data Source Research note in `05-Research/Data Source Research/` |
| Feature is getting complex (many edge cases, domain logic) | Create Feature Spec in `01-Product/Feature Specs/` |
| Implementation diverges from Architecture Overview | Update `02-Engineering/Architecture Overview.md` |
| Schema changes | Update `02-Engineering/Data Model.md` |
| New transformation logic | Update `02-Engineering/Transformation Logic.md` (if `data-platform`) |
| Dashboard/report design discussed | Create or update spec in `03-Design/` |
| User wants to demo or present the project | Create Stakeholder Presentation or Demo Script in `06-Visibility/` |
| Deployment or infrastructure changes | Update `07-Operations/` docs |
| Agent prompt modified | Log change + failure context to `docs/evals/agent-changelog.md` |
| Idea for future work surfaces | Add to `09-Personal-Tasks/Someday-Maybe.md` |

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

All agents are invoked proactively by Claude Code at the trigger points in the Development Workflow. Agent prompts are **stack-agnostic** — they read project-specific details from this CLAUDE.md file and on-demand reference docs.

- **scrum-master** — Sprint planning (including topology assessment), maintenance scheduling, sprint retros. Also invoked when conversation drifts into prolonged deliberation.
- **product-manager** — Two modes:
  - **Planning mode:** Expands short story descriptions into full implementation specs with user stories, data models, and design direction. Invoked when starting a story.
  - **Validation mode:** Verifies acceptance criteria are met against the sprint contract. Invoked before marking a story done.
- **code-reviewer** — Reviews implementation against sprint contract acceptance criteria, grading rubrics (`docs/02-Engineering/rubrics/code-review-rubric.md`), and runs semgrep. Checks for duplicate implementations of existing functionality. Enforces isolation scope compliance for mesh topology. Do NOT skip.
- **test-writer** — Writes tests during/after implementation. Verifies coverage against rubric standards (`docs/02-Engineering/rubrics/test-rubric.md`). Runs E2E verification using the project's verification method when applicable.

---

## Fabrika Relationship

This project uses **Fabrika**, an agentic workflow framework. Local agent changes are expected — tune freely during sprints. For how changes flow back to canonical Fabrika (eval artifacts, harvest workflow, updates), read `.fabrika/FABRIKA.md` on demand. Do not load it into every session.

---

## Doc Standards
When creating or editing any doc in `docs/`:
- Always include YAML frontmatter: `type`, `status`, `created`, `updated`, `tags`
- Use `[[wikilinks]]` to connect related docs
- Write in plain language — no jargon without explanation
- Docs should be self-contained: readable without CLAUDE.md context

---

## Testing Rules
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
- **Stack-agnostic agent prompts.** Never put technology-specific references in global agent prompts. All tech details live in this CLAUDE.md's Project Stack section.

---

## Future Considerations

These are documented for reference but not implemented in the current workflow:

- **Generator agent formalization:** If moving to fully autonomous multi-agent pipelines (no human in the loop for extended periods), the main Claude Code session should be formalized as a dedicated generator agent with its own prompt. Not needed while a human is present and driving sessions.
- **External context integration:** Making external knowledge bases or task management content available to project agents via symlinks or MCP. Currently project docs are self-contained in `docs/`; information flows FROM project docs TO external systems, not the reverse.
- **Agent self-improvement:** Maintenance sessions proposing and validating prompt improvements against the eval harness. This activates naturally once the evaluation system has accumulated cases. See `docs/evals/README.md`.
