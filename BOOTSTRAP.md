# Project Bootstrap Guide

> **Audience: the AI agent.** This document is your reference for bootstrapping a new project. Read it, execute the steps autonomously, and only ask the user for input when you genuinely need their answer. Do not ask the user to paste prompts — you drive the process.
>
> **Note:** This guide is for agents bootstrapping **new** projects. For adding Fabrika to an existing project, see [ADOPT.md](ADOPT.md).
>
> **Note:** This guide covers both sprint-based project types (web-app, data-app, analytics-engineering, data-engineering, ml-engineering, ai-engineering, automation, library) and task-based types (analytics-workspace). The flow branches after type alignment in Phase 1.

## Path Configuration

Set these paths before running. The agent should confirm these with the user if they differ from defaults.

| Path | Default | Description |
|------|---------|-------------|
| **Fabrika repo** | `[FABRIKA_PATH]` | Where the canonical Fabrika repo lives on this machine |
| **Projects root** | `~/projects/` | Parent directory where new project repos are created |

> **Note:** On some machines these may differ. The agent should ask the user to confirm paths if this guide was invoked without specifying them.

All paths in this guide use the defaults above. Replace them with the actual paths for your machine.

## What This Produces

### Sprint-based types (web-app, data-app, analytics-engineering, data-engineering, ml-engineering, ai-engineering, automation, library)
- A project repo with scaffold, git, agentic tool configuration, and hooks
- A docs vault (`docs/`) with type-appropriate documentation fully populated
- Progress files (STATUS.md, features.json) and evaluation scaffolding
- Grading rubrics, maintenance checklist, and sprint contract templates
- Type-appropriate agents installed (see Agent Catalog)
- Baseline eval cases installed
- A groomed backlog with epics, stories, and estimates
- Sprint 1 scoped with a topology-aware sprint contract
- If an external task management system is configured, one task per Sprint 1 story

### Task-based types (analytics-workspace)
- A workspace repo with task-centric folder structure, git, and agentic tool configuration
- A source registry (`sources/`) documenting data connections, BI tools, and file sources
- Task templates (brief, plan, outcome report)
- Analytics-specific agents installed (analysis-planner, logic-reviewer, data-validator)
- Baseline eval cases installed
- Ready to accept the first analysis task

---

## Phase 1: Project Setup (Agent-Driven, Minimal User Input)

The user has said something like "I'm starting a new project" or "set up a project at ~/projects/foo."

### 1.1 Confirm the basics
Ask: **"What's the project name?"**

### 1.2 Type alignment

Before creating any folders, determine the project type. Ask:

**"Before we set anything up — what kind of work is this? Give me a sentence or two about what you're trying to do."**

From the response, identify the project type using these signals:

| Type | Strong Signals | Disambiguating Question |
|------|---------------|------------------------|
| `web-app` | "app", "users", "auth", "SaaS", "frontend", "API", "mobile" | Is there a UI that end users interact with? |
| `data-app` | "dashboard", "reporting tool", "data entry", "replace Excel", "visualization", "Streamlit", "Retool" | Is this an interactive tool stakeholders use, or a data layer other tools consume? |
| `analytics-engineering` | "dbt", "DuckDB", "data warehouse", "transformations", "Alteryx migration", "data modeling", "star schema" | Are you building a modeled data layer, or the infrastructure that moves data into it? |
| `data-engineering` | "pipeline", "ingestion", "CDC", "streaming", "Airflow", "Dagster", "orchestration", "data lake", "ELT" | Are you building the infrastructure that moves and stores data across systems? |
| `ml-engineering` | "model", "training", "prediction", "classification", "features", "evaluation", "fine-tune" | Are you training/evaluating a model, or integrating a pre-trained one? |
| `ai-engineering` | "LLM", "RAG", "embeddings", "prompt", "GPT", "Claude API", "agents", "guardrails", "eval harness" | Are you building an application powered by an LLM? |
| `automation` | "script", "CLI", "bot", "cron", "scheduled", "scraper", "automate" | Is this a thing that runs on a schedule/trigger, or a package others import? |
| `library` | "package", "SDK", "module", "npm publish", "PyPI", "reusable", "API design" | Will other developers import and use this in their own projects? |
| `analytics-workspace` | "ad hoc", "analysis", "investigation", "data request", "one-off", "just need a place to work", "SQL queries" | Is this ongoing analytical work without a single end product? |
| `agentic-workflow` | "methodology", "operating system", "agent workflow", "prompts and workflows", "the system itself is the product", "maintaining a framework" | Is the methodology/workflow system itself the product you're building and maintaining? |

Confirm with the user: **"Based on what you've described, this sounds like a [type] project — [one sentence explaining what that means]. Does that sound right?"**

For sprint-based types, also explain briefly: "This means we'll do a brain dump to capture everything you know, set up documentation, and plan your first sprint with agents for [planner role], [reviewer role], [validator role], and sprint coordination."

For `analytics-workspace`, explain: "This means we'll set up a workspace for ad hoc analysis — we'll catalog your data sources and BI tools, then you'll be ready to start tasks. No sprints — work is organized as individual analysis tasks."

For `agentic-workflow`, explain: "This means we'll set up a system where the methodology itself is the product — agent prompts, workflows, instruction files, and templates. Changes follow a 7-step protocol (plan, align, execute, verify, incorporate feedback, present, ship). No sprints — work is organized as structural changes with version tracking."

Multi-type is possible for sprint-based types (e.g., `data-app` + `automation`). Task-based types (`analytics-workspace`) and methodology-based types (`agentic-workflow`) cannot be combined with sprint-based types — use a separate repo.

### 1.3 Create the type-appropriate folder structure

**For sprint-based types**, create:
```
[project-name]/
├── src/
├── tests/
│   └── fixtures/
├── docs/
│   ├── 00-Index/
│   ├── 01-Product/
│   │   └── Feature Specs/
│   ├── 02-Engineering/
│   │   ├── ADRs/
│   │   └── rubrics/
│   ├── 03-Design/
│   ├── 04-Backlog/
│   │   ├── Epics/
│   │   ├── Stories/
│   │   ├── Bugs/
│   │   └── Sprints/
│   ├── 05-Research/
│   │   └── Data Source Research/
│   ├── 06-Visibility/
│   ├── 07-Operations/
│   ├── 08-Meeting-Notes/
│   ├── 09-Personal-Tasks/
│   ├── Templates/
│   ├── evaluations/
│   ├── plans/
│   ├── session-logs/
│   ├── evals/
│   │   ├── baseline/
│   │   │   ├── planner/
│   │   │   ├── reviewer/
│   │   │   ├── validator/
│   │   │   └── coordinator/
│   │   └── [per-agent directories — created based on installed agents]
│   └── maintenance/
├── .fabrika/
├── .github/
│   └── workflows/
├── .claude/
│   ├── agents/
│   ├── hooks/
│   └── current_tasks/
└── [other dirs added after brain dump]
```

**For `analytics-workspace`**, create:
```
[project-name]/
├── src/
│   ├── queries/                        # reusable SQL
│   ├── scripts/                        # Python/R scripts
│   └── notebooks/                      # Jupyter, etc.
├── data/
│   ├── input/                          # CSVs, Excel files people send you
│   └── output/                         # generated datasets, exports
├── tasks/                              # the core unit of work
├── sources/
│   ├── connections/                    # queryable data sources
│   ├── tools/                          # BI/ETL tools (advisory mode)
│   └── files/                          # recurring flat file sources
├── docs/
│   ├── Templates/
│   ├── evaluations/
│   └── evals/
│       └── baseline/
│           ├── planner/
│           ├── reviewer/
│           └── validator/
├── .fabrika/
├── .claude/
│   ├── agents/
│   └── hooks/
└── STATUS.md
```

Add `.gitkeep` to all empty folders. For `analytics-workspace`, also add `data/` to `.gitignore` (heavy data files should not be committed; small reference files can be force-added).

### 1.4 Initialize git
```bash
git init
```

### 1.5 Create placeholder and scaffold files
- `docs/00-Index/Home.md` — stub with project name
- `docs/09-Personal-Tasks/Someday-Maybe.md` — empty
- `STATUS.md` — copy from `[FABRIKA_PATH]/core/STATUS-template.md` (project in bootstrap phase)
- `features.json` — copy from `[FABRIKA_PATH]/core/features-template.json`
- `docs/evals/README.md` — copy from `[FABRIKA_PATH]/core/evals/README.md`
- `docs/evals/agent-changelog.md` — copy from `[FABRIKA_PATH]/core/evals/agent-changelog-template.md`
- `docs/evals/baseline/` — copy entire directory from `[FABRIKA_PATH]/core/evals/baseline/` (baseline eval cases for all agent archetypes)
- `.fabrika/FABRIKA.md` — copy from `[FABRIKA_PATH]/core/FABRIKA.md` (framework relationship guide, read on demand by agents)
- Basic `.gitignore` with .env and `__pycache__` exclusions

### 1.6 Generate the Fabrika manifest

After all files have been copied, generate `.fabrika/manifest.yml` in the consumer project. The manifest records what was installed and enables future upgrade diffing.

```yaml
fabrika_version: "<read from [FABRIKA_PATH]/VERSION>"
project_type: "<determined later in Phase 2, set to 'pending' for now>"
integrations: []
installed_at: "<YYYY-MM-DDTHH:MM:SS>"
files:
  - path: "STATUS.md"
    source: "core/STATUS-template.md"
    source_version: "<fabrika_version>"
    hash: "<sha256 of file contents>"
    customized: false
  - path: "features.json"
    source: "core/features-template.json"
    source_version: "<fabrika_version>"
    hash: "<sha256 of file contents>"
    customized: false
  - path: "docs/evals/README.md"
    source: "core/templates/evals-README.md"
    source_version: "<fabrika_version>"
    hash: "<sha256 of file contents>"
    customized: false
  # ... one entry per installed file
```

The agent should compute the sha256 hash of each copied file's contents at install time. As more files are copied in later phases, append entries to the `files` list and update `project_type` and `integrations` once known.

### 1.7 Initial commit
```bash
git add -A
git commit -m "chore: initialize [project-name] with vault structure"
```

Proceed immediately to Phase 2. Do **not** ask the user to open the docs vault yet — there's no content to look at.

> **Branch point:** If the project type is `analytics-workspace`, skip to **Phase 2W** below. If `agentic-workflow`, skip to **Phase 2A** below. All other types continue to Phase 2.

---

## Phase 2: Brain Dump & Scaffold (Agent + User — Iterative)

This is the most important phase. The goal is to extract everything the user knows, determine the project type and tech stack, populate all documentation, and build the backlog — all through an ongoing conversation.

**This is NOT a single prompt-and-done step.** Expect multiple rounds of conversation. The user may brain-dump in pieces across one or more sessions.

### 2.1 Start the conversation
The project type was already determined in Phase 1.2. Use the type-specific brain dump prompt:

**web-app:** "Tell me everything about this app — who uses it, what problem it solves, what the core user flows are, any tech you're already thinking about, and what you want to build first. If it's a consumer product, tell me about the market and competition. Don't worry about structure — just get it out."

**data-app:** "Tell me about this tool — what questions does it answer, who's the audience, what data feeds it, and what tool you're thinking of using (Streamlit, Retool, Dash, etc.). If it's replacing Excel or an existing report, tell me about the current process."

**analytics-engineering:** "Tell me about this data layer — what sources feed in, what are you migrating from (Alteryx, Excel, manual SQL), what does the clean modeled layer need to look like, and who or what consumes it downstream (dashboards, analysts, exports). If you're using dbt or DuckDB, tell me about your setup."

**data-engineering:** "Walk me through the data flow: where does data come from (sources, APIs, files), how does it get ingested, where does it land, what transformations happen, and who consumes the output. Tell me about your orchestration (Airflow, Dagster, cron), infrastructure (cloud, on-prem), and any reliability concerns."

**ml-engineering:** "Tell me about this ML work — what are you predicting or classifying, what data exists for training, what's the current baseline (human process, simple heuristic), how will the model be served (batch, real-time, API), and how you plan to evaluate it."

**ai-engineering:** "Tell me about this AI application — what's the core AI capability (generation, retrieval, classification, agents), which LLM(s) you're planning to use, what the quality and safety boundaries are, and how you plan to evaluate output quality."

**automation:** "Tell me about what you're automating — what triggers it, what it does, where the output goes, what happens when it fails, and how often it runs."

**library:** "Tell me about this library — who imports and uses it, what's the core functionality, what language and runtime, how it's distributed (npm, PyPI, internal), and what the public API surface looks like."

### 2.2 Determine backlog mode and tech stack

**Backlog mode:** Ask: **"Do you want to track stories in Jira (via MCP) or as local markdown files? If you have a Jira project set up, I can use that. Otherwise, markdown works great."**

If Jira: confirm the project key and verify the MCP connection works.
If markdown: stories will be tracked in `docs/04-Backlog/Stories/`.

**Tech stack:** Ask clarifying questions about technology choices only if they weren't covered in the brain dump. Don't re-ask things already stated.

### 2.3 Scaffold based on what you've learned
Now that you know the project type and stack, create the stack-specific scaffold:
- `.gitignore` appropriate for the language/stack
- `Justfile` with placeholder recipes: `run`, `test`, `test-fast`, `lint`, `check`
- Package manager initialization (e.g., `uv init --name [project-name]`)
- `.github/workflows/ci.yml` with lint + test pipeline

**Set up the agentic tool configuration.** Determine which agentic tool the project will use.

First, read the **Agent Catalog** at `[FABRIKA_PATH]/core/agents/AGENT-CATALOG.md` to determine which agents to install for this project type.

- **Claude Code:** Copy the project CLAUDE.md template from `[FABRIKA_PATH]/integrations/claude-code/CLAUDE.md`. Ask the user for a short project key (e.g., `MYAPP`). Copy the type-appropriate agent prompts from `[FABRIKA_PATH]/core/agents/` to `.claude/agents/` in the project repo — use the Agent Catalog mapping to select which agents apply. Also copy the implementer agent for the project type (see the Sprint-Based Types and Task-Based Types mapping tables in `[FABRIKA_PATH]/core/agents/AGENT-CATALOG.md` for which implementer to install). Multi-type projects should install all implementer agents that match their types. Copy settings from `[FABRIKA_PATH]/integrations/claude-code/settings-template.json` to `.claude/settings.json`.
- **GitHub Copilot:** Copy `[FABRIKA_PATH]/integrations/copilot/copilot-instructions.md` to `.github/copilot-instructions.md`. Copy the type-appropriate agent prompts from `[FABRIKA_PATH]/core/agents/` to `.github/agents/` (renaming `*.md` to `*.agent.md`). Include the implementer agent for the project type (see the AGENT-CATALOG mapping tables for which implementer to install). Fill in project name and key. Note: Claude Code hooks (`.claude/hooks/`) are not applicable to Copilot — instead, configure equivalent git hooks in `.git/hooks/` or use the CI pipeline for regression gating.

**Fill in the Project Stack section** of the project config with all tech details: language, framework, database, package manager, test runner, linter, dev server, CI. Determine and fill in the test commands:
- Fast test command (for hooks and session health checks)
- Full test command (for maintenance and CI)
- E2E test command (if applicable)

**Configure hooks:**
- Copy git hook templates from `[FABRIKA_PATH]/core/hooks/` to `.claude/hooks/` (includes `pre-commit.sh`, `commit-msg.sh`, `post-commit.sh`, `pre-push.sh`)
- Copy Claude Code hook scripts from `[FABRIKA_PATH]/core/hooks/claude-code/` to `.claude/hooks/claude-code/`
- Update `pre-push.sh` with the fast test command
- Update `auto-format.sh` with the project's formatter command (e.g., `prettier --write`, `ruff format`, `gofmt -w`) — leave empty to disable
- Register hooks in `.claude/settings.json` (the settings template includes the hooks section)
- Copy `[FABRIKA_PATH]/core/hook-discovery-workflow.md` to `.fabrika/hook-discovery-workflow.md`
- Copy `[FABRIKA_PATH]/core/hook-adaptation-guide.md` to `.fabrika/hook-adaptation-guide.md`
- For non-Claude-Code tools: install git hooks to `.git/hooks/` and see `.fabrika/hook-adaptation-guide.md` for tool-specific adaptation

**Set up E2E verification (if applicable):**
Based on project type, determine the verification method:
| Project Type | Verification | Setup Guidance |
|-------------|-------------|----------------|
| `web-app` | Playwright MCP | Ask user: "Would you like to set up Playwright for browser-based E2E testing? I'll guide you through the MCP configuration." |
| `data-app` | Playwright MCP + pytest | Same as web app — Dash/Streamlit render in browsers. Also set up model assertion tests. |
| `analytics-engineering` | Output diffing | Create `tests/benchmarks/` directory. Ask about known-good oracle data for transformation validation. |
| `data-engineering` | Pipeline integration tests + output diffing | Create `tests/benchmarks/` directory. Set up per-stage data quality checks. |
| `ml-engineering` | Eval framework | Create `tests/eval/` directory. Ask about baseline metrics and evaluation datasets. |
| `ai-engineering` | Eval harness + guardrail tests | Create `tests/eval/` directory. Set up LLM eval framework (input → expected output characteristics). |
| `automation` | Integration tests | Standard pytest/vitest setup is sufficient. |
| `library` | Unit + integration + backward compat | Standard test suite plus public API contract tests. |

If the user wants Playwright MCP, guide them through setup: install the Playwright MCP server, add it to `.claude/settings.json`, verify the connection works with a simple navigation test.

**Copy and populate template files:**
- `docs/02-Engineering/rubrics/code-review-rubric.md` — from `[FABRIKA_PATH]/core/rubrics/`
- `docs/02-Engineering/rubrics/test-rubric.md` — from `[FABRIKA_PATH]/core/rubrics/`
- `docs/02-Engineering/maintenance-checklist.md` — from `[FABRIKA_PATH]/core/templates/`
- `docs/Templates/Sprint-Contract-Pipeline.md` — from `[FABRIKA_PATH]/core/topologies/`
- `docs/Templates/Sprint-Contract-Mesh.md` — from `[FABRIKA_PATH]/core/topologies/`
- `docs/Templates/Sprint-Contract-Hierarchical.md` — from `[FABRIKA_PATH]/core/topologies/`
- `docs/Templates/Sprint-Retro-Template.md` — from `[FABRIKA_PATH]/core/templates/`

Update `.fabrika/manifest.yml` with entries for all newly copied files, the determined `project_type`, and the chosen integration in the `integrations` list.

### 2.4 Read the Document Catalog and create Tier 1 docs
Read the **Document Catalog** at `[FABRIKA_PATH]/core/Document-Catalog.md`. Based on the project type, identify all Tier 1 documents and create them.

Copy the appropriate vault templates from `[FABRIKA_PATH]/core/templates/` into `docs/Templates/`. Always copy: `Epic-Template.md`, `Story-Template.md`, `Sprint-Template.md`, `ADR-Template.md`, `Session-Log-Template.md`. Add type-specific templates per the catalog.

### 2.5 Fill in documents from the brain dump
Using the brain dump content, fill in all Tier 1 documents with real content — not stubs. Populate:
- `docs/00-Index/Home.md` — Project overview, purpose, key links
- `docs/01-Product/Phase Definitions.md` — What each phase delivers, what's excluded
- `docs/02-Engineering/Architecture Overview.md` — Stack, data flow, key components. When defining the component structure, prefer organizing the repo so that each major concern or domain lives in its own directory subtree. This is an agent-efficiency choice: agents work most effectively when they can complete a task within a scoped subtree without needing full-repo context. Monorepo workspaces, Python packages, or even just well-separated top-level directories all work.
- `docs/02-Engineering/Canonical-Patterns.md` — Start with 3-5 canonical patterns based on the tech stack: error handling, API/data access, state management, logging, test structure. Each pattern gets a concrete code example and anti-patterns to avoid. This document grows during maintenance sessions.
- `docs/02-Engineering/Testing Strategy.md` — Test approach, verification method, coverage targets
- Type-specific Tier 1 docs (Data Model, Pipeline Design, Dashboard Spec, Model Design, etc.)

Update the project config with: Current Phase, Tech Stack table, Project Structure, Backlog System configuration (mode, Jira key if applicable, comment settings), Verification Method details.

For any significant tech decisions made during the brain dump, create ADRs in `docs/02-Engineering/ADRs/`.

### 2.6 Ask clarifying questions — iteratively
After filling in what you can, review each document for gaps. Ask clarifying questions **one category at a time** — don't overwhelm with a long list.

**Keep going until you're confident.** This is an ongoing conversation, not a single round. The agent should:
- Track which documents still have gaps
- Ask follow-up questions in subsequent messages or sessions
- Surface specific unknowns
- Suggest decisions when the user is uncertain

**Signs you're ready to move on:**
- All Tier 1 docs have real, substantive content (no placeholder text)
- The user has confirmed tech stack choices
- Open questions have either been resolved or explicitly deferred with an ADR
- You have enough understanding to propose epics and stories

### 2.7 Propose Epics
The agent proposes an initial set of Epics and lists them for the user's approval before creating any files:
```
Proposed Epics:
  E-01: [name] — [1-sentence description]
  E-02: [name] — [1-sentence description]
  E-03: [name] — [1-sentence description]

Does this look right? Should I add, remove, or rename any?
```

### 2.8 Create Epics and propose Stories
Once approved, create Epic files (in markdown and/or Jira depending on backlog mode). Then for each epic, the agent proposes 3-5 Stories:
```
Stories for E-01 ([epic name]):
  S-001: [name] — [description] (est: 3 pts, priority: High)
  S-002: [name] — [description] (est: 5 pts, priority: Medium)
  S-003: [name] — [description] (est: 2 pts, priority: Medium)
```

### 2.9 Create Story files
Once approved, create Story files with full YAML frontmatter, description, acceptance criteria, technical notes, and an empty Notes section. If backlog mode is Jira, create stories in Jira and optionally create local markdown references.

### 2.10 Flag and resolve research items
If stories have unresolved technical questions, create research notes in `docs/05-Research/` and work through them with the user. For each:
1. Share what you know or can infer
2. Ask the user for additional context
3. Propose a direction with trade-offs in plain language
4. If decided, create an ADR

### 2.11 Tell the user to open the vault
Now that there's real content: **"The vault is populated with [N] documents, [N] epics, and [N] stories. Open `~/projects/[project-name]/docs/` as your project docs vault. If using Obsidian as docs viewer, install recommended plugins: Templater, Dataview, Kanban, Projects. Let me know when that's done."**

### 2.12 Commit
```bash
git add -A
git commit -m "feat: populate vault with project context, epics, and stories"
```

---

## Phase 2W: Analytics Workspace Onboarding (analytics-workspace only)

> This phase replaces Phase 2 for `analytics-workspace` projects. There is no brain dump, no backlog, no sprint planning. Instead, the onboarding focuses on cataloging data sources and BI tools so the agent can be useful from the first task.

### 2W.1 Set up agentic tool configuration

Copy analytics-workspace agents from `[FABRIKA_PATH]/core/agents/` to the tool-appropriate location:

- **Claude Code:** Copy to `.claude/agents/`:
  - `analysis-planner.md`, `logic-reviewer.md`, `data-validator.md`
  - Copy CLAUDE.md template from `[FABRIKA_PATH]/integrations/claude-code/CLAUDE.md`, set project type to `analytics-workspace`
  - Copy settings from `[FABRIKA_PATH]/integrations/claude-code/settings-template.json` to `.claude/settings.json`
- **GitHub Copilot:** Copy to `.github/agents/` (renaming `*.md` to `*.agent.md`):
  - `analysis-planner.agent.md`, `logic-reviewer.agent.md`, `data-validator.agent.md`
  - Copy copilot-instructions from `[FABRIKA_PATH]/integrations/copilot/copilot-instructions.md` to `.github/copilot-instructions.md`, set project type to `analytics-workspace`

Copy templates from `[FABRIKA_PATH]/core/templates/`:
- `Analysis-Brief-Template.md` → `docs/Templates/Analysis-Brief-Template.md`
- `Analysis-Plan-Template.md` → `docs/Templates/Analysis-Plan-Template.md`
- `Outcome-Report-Template.md` → `docs/Templates/Outcome-Report-Template.md`
- `Task-Contract-Template.md` → `docs/Templates/Task-Contract-Template.md`
- `Source-Connection-Template.md` → `docs/Templates/Source-Connection-Template.md`
- `Source-Tool-Template.md` → `docs/Templates/Source-Tool-Template.md`
- `Source-File-Template.md` → `docs/Templates/Source-File-Template.md`

Copy baseline evals from `[FABRIKA_PATH]/core/evals/baseline/` → `docs/evals/baseline/` (skip coordinator evals — no scrum master in workspaces).

Copy eval scaffold from `[FABRIKA_PATH]/core/evals/README.md` and `agent-changelog-template.md`.

Set up the CLAUDE.md or copilot-instructions as applicable.

### 2W.2 Source inventory conversation

Run through these questions to catalog the workspace's data sources. Create source files as the user describes each one.

**Step 1 — Connections:** "What databases, warehouses, or data systems do you connect to? For each one, tell me: the type (Snowflake, SQL Server, PostgreSQL, etc.), how you connect (ODBC, direct, VPN), and which schemas or tables you use most."

For each source described, create a file in `sources/connections/` using the Source-Connection-Template.

**Step 2 — BI/ETL Tools:** "What BI or ETL tools does your team use? Things like Tableau Server, Power BI, Alteryx, Looker, etc. For each one: where it lives (URL, network path), what key workbooks or workflows are there, and how often they refresh."

For each tool described, create a file in `sources/tools/` using the Source-Tool-Template.

**Step 3 — Flat files:** "Do you regularly receive flat files — CSVs, Excel files, YXDBs, etc.? Who sends them, how often, and where do they land?"

For each recurring file source described, create a file in `sources/files/` using the Source-File-Template.

**Step 4 — Local tools:** "What tools do you have locally for working with data? DuckDB, Python, R, Tableau Desktop, Alteryx Designer, Excel?"

Record in `STATUS.md` under a "Local tools" section.

**Step 5 — Domain context:** "What's your team's domain? What kind of questions do people typically ask you? This helps me understand the context when you bring analysis tasks."

Record in `sources/README.md` as domain context.

### 2W.3 Populate sources/README.md

Write the source registry index with three sections:
- **Connections** — links to each file in `sources/connections/`
- **Tools** — links to each file in `sources/tools/`
- **Files** — links to each file in `sources/files/`

Each entry: name, one-line description, link to detail file.

### 2W.4 Initialize STATUS.md

Set `STATUS.md` with:
- Project type: analytics-workspace
- Active tasks: (none yet)
- Local tools: (from Step 4)
- Source count: N connections, N tools, N file sources

### 2W.5 Commit

```bash
git add -A
git commit -m "feat: initialize analytics workspace with source registry"
```

### 2W.6 Ready

Tell the user: **"Your analytics workspace is set up with [N] data sources cataloged. To start an analysis task, just tell me what you need — a question to answer, data to pull, logic to review, or an investigation to run. I'll create a task folder and walk you through brief → plan → execute → validate → deliver."**

**Do NOT proceed to Phase 3 or Phase 4.** Analytics workspaces do not have sprints or readiness checks. The workspace is ready for tasks.

---

## Phase 2A: Agentic-Workflow Setup (agentic-workflow only)

> This phase replaces Phase 2 for `agentic-workflow` projects. There is no brain dump, no backlog, no sprint planning. The setup focuses on establishing the structural update infrastructure: version tracking, change protocol, and agent installation.

### 2A.1 Set up agentic tool configuration

Copy agentic-workflow agents from `[FABRIKA_PATH]/core/agents/` to the tool-appropriate location:

- **Claude Code:** Copy to `.claude/agents/`:
  - `workflow-planner.md`, `methodology-reviewer.md`, `structural-validator.md`, `context-engineer.md`, `context-architect.md`
  - Copy CLAUDE.md template from `[FABRIKA_PATH]/integrations/claude-code/CLAUDE.md`, set project type to `agentic-workflow`
  - Copy settings from `[FABRIKA_PATH]/integrations/claude-code/settings-template.json` to `.claude/settings.json`
- **GitHub Copilot:** Copy to `.github/agents/` (renaming `*.md` to `*.agent.md`):
  - `workflow-planner.agent.md`, `methodology-reviewer.agent.md`, `structural-validator.agent.md`, `context-engineer.agent.md`, `context-architect.agent.md`
  - Copy copilot-instructions from `[FABRIKA_PATH]/integrations/copilot/copilot-instructions.md` to `.github/copilot-instructions.md`, set project type to `agentic-workflow`

The scrum-master agent is used from the standard agent set (it serves the coordinator role for change backlog sequencing).

### 2A.2 Establish version tracking

Create the core versioning files:
- `VERSION` — set to `0.1.0` (or whatever the user specifies as the starting version)
- `CHANGELOG.md` — initial entry for the starting version
- `MIGRATIONS.md` — empty with header explaining its purpose

### 2A.3 Establish the structural update protocol

Ask: **"Does your system already have a change protocol (like SYSTEM-UPDATE.md), or should we create one based on the Fabrika agentic-workflow lifecycle?"**

If creating fresh: adapt the 7-step protocol from `[FABRIKA_PATH]/core/workflows/agentic-workflow-lifecycle.md` into a project-specific `SYSTEM-UPDATE.md` or equivalent.

If the project already has one: review it for compatibility with the agentic-workflow lifecycle and suggest adjustments if needed.

### 2A.4 Structural conversation

Ask: **"Tell me about this system — what does it do, what are its main components (prompts, workflows, instruction files, templates), and how are they organized. What are the key design principles that govern how the system is structured?"**

From the response, populate:
- A project README or equivalent overview
- `STATUS.md` with current system state
- Any existing structural docs the user describes

### 2A.5 Mode selection

Ask: **"Does this system have operational sessions (daily reviews, status checks, periodic rituals that you run interactively), or is it purely structural changes?"**

Record the mode in the project config:
- Structural only: note that all work follows the 7-step protocol
- Structural + operational: note that structural changes follow the protocol; operational sessions are human-initiated and interactive

### 2A.6 Generate manifest and commit

Generate `.fabrika/manifest.yml` with all installed files. Commit:

```bash
git add -A
git commit -m "feat: initialize agentic-workflow project with structural update infrastructure"
```

### 2A.7 Ready

Tell the user: **"Your agentic-workflow project is set up with version tracking, change protocol, and [N] agents installed. To make structural changes, follow the 7-step lifecycle: plan → align → execute → verify → incorporate → present → ship. Each change gets a version bump and CHANGELOG entry."**

**Do NOT proceed to Phase 3 or Phase 4.** Agentic-workflow projects do not have sprints or readiness checks.

---

## Phase 3: Sprint Planning (Agent + User)

> **Sprint-based types only.** Skip this phase for `analytics-workspace`.

### 3.1 Assess sprint topology
Review the proposed Sprint 1 stories. Assess task coupling:
- Do any stories modify the same files or directories?
- Do any share data models, API contracts, or UI state?
- Is there a dependency chain where one story's output feeds another?

Recommend a topology:
- **Pipeline** (default): For a single complex feature or when coupling is ambiguous
- **Mesh**: For independent tasks with no shared state
- **Hierarchical**: For coupled tasks with a dependency chain

Present: **"I recommend a [topology] sprint because [rationale]. Does that sound right?"**

### 3.2 Propose sprint scope
Review the full backlog. Propose 2-3 stories totaling ~10-15 points:
- Priority (High before Medium before Low)
- Dependencies (foundational stories first)
- What unblocks the most future work

Ask: **"Here's my proposed Sprint 1 scope. Does this look right?"**
```
Sprint 1 proposal:
  Topology: [pipeline | mesh | hierarchical]
  S-001: [name] (3 pts, High)
  S-003: [name] (5 pts, Medium)
  Total: 8 points

Sprint goal: [one sentence]
```

### 3.3 Ask for sprint dates
Ask: **"When does Sprint 1 start, and are we doing 2-week sprints?"**

### 3.4 Create sprint artifacts
- Sprint file: `docs/04-Backlog/Sprints/Sprint-01.md`
- Sprint contract: use the appropriate topology template from `docs/Templates/`. Fill in all sections:
  - For pipeline: stage gates with entry/exit conditions
  - For mesh: isolation scopes per story
  - For hierarchical: dependency graph and shared interfaces
  - Acceptance criteria for each story (copied from story files, refined for testability)
- Sprint progress file: `docs/04-Backlog/Sprints/Sprint-01-progress.md`
- Update `features.json` with feature entries for each story
- Update story assignments (`sprint: Sprint-01`)

### 3.5 Create external tasks
If an external task management system is configured, create one task per sprint story. Each task should link to the corresponding story in its notes section.

### 3.6 Update STATUS.md
Update `STATUS.md` in the project root with current sprint info, topology, and active stories.

### 3.7 Commit
```bash
git add -A
git commit -m "feat: plan Sprint 1 with story assignments and sprint contract"
```

---

## Phase 4: Readiness Check (Agent-Driven, User Approval to Proceed)

Run this check autonomously and report findings.

### Verify:
1. All Tier 1 vault docs have non-stub content
2. Project config has all `[PLACEHOLDER]` values filled in
3. Project scaffold is clean: runs without errors, CI pipeline is valid YAML, git history is clean
4. Sprint 1 stories all have: acceptance criteria, story points, epic assignment, sprint assignment
5. Sprint contract exists with topology and acceptance criteria
6. Testing Strategy has real content
7. Pre-Dev Checklist has actionable items
8. Hooks are installed and configured (pre-push has the correct test command, pre-commit has branch/secret/STATUS.md checks, commit-msg validates format, Claude Code hooks registered in settings.json)
9. Rubrics are in place at `docs/02-Engineering/rubrics/`
10. Maintenance checklist is in place
11. Sprint contract templates are in `docs/Templates/`
12. Evaluation scaffold exists (`docs/evals/README.md`, `agent-changelog.md`, agent directories)
13. `STATUS.md` and `features.json` are current
14. Backlog mode is configured (markdown or Jira)
15. `.fabrika/manifest.yml` exists and records all installed files with hashes

### Report:
```
Readiness check:
  ✓ All vault docs populated ([N] Tier 1 docs)
  ✓ Project config complete
  ✓ Sprint 1: [N] stories, [N] points, [topology] topology
  ✓ Sprint contract: [topology] with acceptance criteria
  ✓ Hooks configured (pre-push: [test command])
  ✓ Rubrics, maintenance checklist, contract templates in place
  ✓ Evaluation scaffold ready
  ✓ Backlog mode: [markdown | jira]
  ✓ Fabrika manifest generated
  ⚠ [any remaining issues]
```

Wait for the user's go-ahead before proceeding to implementation.

---

## Vault Structure Reference

```
docs/
├── 00-Index/
│   └── Home.md
├── 01-Product/
│   ├── Phase Definitions.md
│   ├── Feature Specs/
│   └── (type-specific: Vision, User Stories, domain docs)
├── 02-Engineering/
│   ├── Architecture Overview.md
│   ├── Testing Strategy.md
│   ├── ADRs/
│   ├── rubrics/
│   │   ├── code-review-rubric.md
│   │   └── test-rubric.md
│   ├── maintenance-checklist.md
│   └── (type-specific: Data Model, Pipeline Design, Transformation Logic, Model Design, API Conventions)
├── 03-Design/
│   └── (type-specific: Dashboard Spec, Wireframes, UX Spec, Brand Guidelines)
├── 04-Backlog/
│   ├── Epics/
│   ├── Stories/
│   └── Sprints/
│       ├── Sprint-XX.md
│       ├── Sprint-XX-contract.md
│       └── Sprint-XX-progress.md
├── 05-Research/
│   └── (type-specific: Data Source Research, Market Analysis, Tech Evaluations)
├── 06-Visibility/
│   └── (Stakeholder Presentations, Demo Scripts, ROI Analysis, GTM, Launch Plan)
├── 07-Operations/
│   └── (Deployment, Environment Config, Business Setup, Legal)
├── 08-Meeting-Notes/
│   └── (Session Logs, Decision Records)
├── 09-Personal-Tasks/
│   ├── Someday-Maybe.md
│   └── Pre-Dev Checklist.md
├── Templates/
│   ├── Sprint-Contract-Pipeline.md
│   ├── Sprint-Contract-Mesh.md
│   ├── Sprint-Contract-Hierarchical.md
│   └── Sprint-Retro-Template.md
├── evaluations/
├── plans/
├── session-logs/
├── evals/
│   ├── README.md
│   ├── agent-changelog.md
│   └── [agent-name]/
└── maintenance/
```

See the **Document Catalog** for the full inventory of every possible document, which project types need it, and when to create it.

## Readiness Checklist

Use this during the Phase 4 readiness check.

### Universal (all project types)
- [ ] Home.md has real content
- [ ] Phase Definitions.md defines current phase scope
- [ ] Architecture Overview.md documents the stack and data flow
- [ ] Testing Strategy.md defines test approach and verification method
- [ ] At least one ADR for major tech choices
- [ ] At least 2 Epics created
- [ ] At least 5 Stories with acceptance criteria and estimates
- [ ] Sprint-01.md with goal and story assignments
- [ ] Sprint-01-contract.md with topology-aware acceptance criteria
- [ ] Sprint-01-progress.md initialized
- [ ] Pre-Dev Checklist.md completed
- [ ] Project config fully filled in (no `[PLACEHOLDER]` values)
- [ ] STATUS.md reflects current state
- [ ] features.json has Sprint 1 entries
- [ ] Hooks configured and registered (git hooks + Claude Code hooks if applicable)
- [ ] Hook discovery workflow and adaptation guide in `.fabrika/`
- [ ] Rubrics in place
- [ ] Maintenance checklist in place
- [ ] Evaluation scaffold in place
- [ ] `.fabrika/manifest.yml` generated with all installed files

### Type-specific (sprint-based)
- [ ] `data-app`: Dashboard Spec, Data Model, Data Pipeline Design populated
- [ ] `analytics-engineering`: Transformation Logic, Data Model, Data Pipeline Design populated
- [ ] `data-engineering`: Source System Contracts, Ingestion Design, Storage Architecture, Serving Contracts, Orchestration Design, Data Pipeline Design populated
- [ ] `ml-engineering`: Model Design, Training Data Spec, Evaluation Criteria populated
- [ ] `ai-engineering`: Prompt Library, Model Configuration, Evaluation Strategy populated
- [ ] `web-app` (consumer): Vision & Positioning, UX Specification populated
- [ ] `library`: API Design Guide populated
- [ ] All with external data: Data Source Research notes for each known source
- [ ] `web-app` or `data-app`: E2E verification configured (Playwright MCP or equivalent)
- [ ] Agents installed match project type (per Agent Catalog)
- [ ] Implementer agent for your project type(s) is installed (see AGENT-CATALOG mapping tables)
- [ ] Baseline evals copied to `docs/evals/baseline/`

### Type-specific (analytics-workspace)
- [ ] `sources/README.md` populated with source registry index
- [ ] At least one source documented in `sources/connections/`, `sources/tools/`, or `sources/files/`
- [ ] Analysis agents installed (analysis-planner, logic-reviewer, data-validator)
- [ ] Task templates in `docs/Templates/`
- [ ] Baseline evals copied (planner, reviewer, validator — not coordinator)
- [ ] `STATUS.md` initialized with local tools and source count

### Type-specific (agentic-workflow)
- [ ] `VERSION` file exists with starting version
- [ ] `CHANGELOG.md` exists with initial entry
- [ ] `MIGRATIONS.md` exists
- [ ] Structural update protocol established (SYSTEM-UPDATE.md or equivalent)
- [ ] Mode documented (structural only, or structural + operational)
- [ ] Agentic-workflow agents installed (workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect)
- [ ] `STATUS.md` initialized
- [ ] `.fabrika/manifest.yml` generated with all installed files
