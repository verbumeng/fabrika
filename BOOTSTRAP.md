# Project Bootstrap Guide

> **Audience: the AI agent.** This document is your reference for bootstrapping a new software development project. Read it, execute the steps autonomously, and only ask the user for input when you genuinely need their answer. Do not ask the user to paste prompts — you drive the process.
>
> **Note:** This guide is for agents bootstrapping **new** projects. For adding Fabrika to an existing project, see [ADOPT.md](ADOPT.md).

## Path Configuration

Set these paths before running. The agent should confirm these with the user if they differ from defaults.

| Path | Default | Description |
|------|---------|-------------|
| **Fabrika repo** | `[FABRIKA_PATH]` | Where the canonical Fabrika repo lives on this machine |
| **Projects root** | `~/projects/` | Parent directory where new project repos are created |

> **Note:** On some machines these may differ. The agent should ask the user to confirm paths if this guide was invoked without specifying them.

All paths in this guide use the defaults above. Replace them with the actual paths for your machine.

## What This Produces

- A project repo with scaffold, git, agentic tool configuration, and hooks
- A docs vault (`docs/`) with type-appropriate documentation fully populated
- Progress files (STATUS.md, features.json) and evaluation scaffolding
- Grading rubrics, maintenance checklist, and sprint contract templates
- A groomed backlog with epics, stories, and estimates
- Sprint 1 scoped with a topology-aware sprint contract
- If an external task management system is configured, one task per Sprint 1 story

---

## Phase 1: Project Setup (Agent-Driven, Minimal User Input)

The user has said something like "I'm starting a new project" or "set up a project at ~/projects/foo."

### 1.1 Confirm the basics
Ask only: **"What's the project name?"**

That's it for now. Everything else — project type, tech stack, scope — will come out naturally during the brain dump in Phase 2.

### 1.2 Create the universal folder structure
```
[project-name]/
├── src/
├── tests/
│   └── fixtures/
├── docs/                              # docs vault root
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
│   │   ├── code-reviewer/
│   │   ├── test-writer/
│   │   ├── product-manager/
│   │   └── scrum-master/
│   └── maintenance/
├── .fabrika/
├── .github/
│   └── workflows/
├── .claude/
│   ├── hooks/
│   └── current_tasks/
└── [other dirs added after brain dump]
```

Add `.gitkeep` to all empty folders.

### 1.3 Initialize git
```bash
git init
```

### 1.4 Create placeholder and scaffold files
- `docs/00-Index/Home.md` — stub with project name
- `docs/09-Personal-Tasks/Someday-Maybe.md` — empty
- `STATUS.md` — copy from `[FABRIKA_PATH]/core/STATUS-template.md` (project in bootstrap phase)
- `features.json` — copy from `[FABRIKA_PATH]/core/features-template.json`
- `docs/evals/README.md` — copy from `[FABRIKA_PATH]/core/templates/`
- `docs/evals/agent-changelog.md` — copy from `[FABRIKA_PATH]/core/templates/`
- `.fabrika/FABRIKA.md` — copy from `[FABRIKA_PATH]/core/FABRIKA.md` (framework relationship guide, read on demand by agents)
- Basic `.gitignore` with .env and `__pycache__` exclusions

### 1.5 Generate the Fabrika manifest

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

### 1.6 Initial commit
```bash
git add -A
git commit -m "chore: initialize [project-name] with vault structure"
```

Proceed immediately to Phase 2. Do **not** ask the user to open the docs vault yet — there's no content to look at.

---

## Phase 2: Brain Dump & Scaffold (Agent + User — Iterative)

This is the most important phase. The goal is to extract everything the user knows, determine the project type and tech stack, populate all documentation, and build the backlog — all through an ongoing conversation.

**This is NOT a single prompt-and-done step.** Expect multiple rounds of conversation. The user may brain-dump in pieces across one or more sessions.

### 2.1 Start the conversation
Ask: **"Tell me everything you know about this project — what it does, why you're building it, who uses it, what data or systems are involved, any tech you're already thinking about, constraints, and what you want to build first. Don't worry about structure or completeness — just get it out and we'll go from there. If you're not sure about parts of it yet, that's fine — we'll work through those together."**

### 2.2 Determine project type, tech stack, and backlog mode
From the brain dump, determine:

**Project type** (can be multi-type):
| Type | Signals in Brain Dump |
|------|----------------------|
| `data-app` | "replace Excel", "dashboard", "reporting tool", "data entry", "visualization" |
| `data-platform` | "dbt", "DuckDB", "pipeline", "ETL", "data warehouse", "Alteryx replacement", "transformations" |
| `ml-project` | "model", "prediction", "training", "classification", "features", "evaluation" |
| `web-app` | "app", "users", "auth", "SaaS", "API", "frontend", "mobile" |
| `automation` | "script", "CLI", "bot", "cron", "scheduled", "automate" |

Confirm with the user: **"Based on what you've described, this sounds like a [type] project. Does that sound right?"**

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

**Set up the agentic tool configuration.** Determine which agentic tool the project will use:

- **Claude Code:** Copy the project CLAUDE.md template from `[FABRIKA_PATH]/integrations/claude-code/CLAUDE.md`. Ask the user for a short project key (e.g., `MYAPP`). Copy agent prompts from `[FABRIKA_PATH]/core/agents/` to `.claude/agents/` in the project repo — these define the product-manager, code-reviewer, test-writer, and scrum-master agents referenced by the development workflow in CLAUDE.md. Copy settings from `[FABRIKA_PATH]/integrations/claude-code/settings-template.json` to `.claude/settings.json`.
- **GitHub Copilot:** Copy `[FABRIKA_PATH]/integrations/copilot/copilot-instructions.md` to `.github/copilot-instructions.md`. Copy agent prompts from `[FABRIKA_PATH]/core/agents/` to `.github/agents/` (renaming `*.md` to `*.agent.md`). Fill in project name and key. Note: Claude Code hooks (`.claude/hooks/`) are not applicable to Copilot — instead, configure equivalent git hooks in `.git/hooks/` or use the CI pipeline for regression gating.

**Fill in the Project Stack section** of the project config with all tech details: language, framework, database, package manager, test runner, linter, dev server, CI. Determine and fill in the test commands:
- Fast test command (for hooks and session health checks)
- Full test command (for maintenance and CI)
- E2E test command (if applicable)

**Configure hooks:**
- Copy the hook templates from `[FABRIKA_PATH]/core/hooks/` to `.claude/hooks/`
- Update `pre-push.sh` with the fast test command
- Register hooks in `.claude/settings.json`

**Set up E2E verification (if applicable):**
Based on project type, determine the verification method:
| Project Type | Verification | Setup Guidance |
|-------------|-------------|----------------|
| Web app | Playwright MCP | Ask user: "Would you like to set up Playwright for browser-based E2E testing? I'll guide you through the MCP configuration." |
| Data app (Dash, Streamlit) | Playwright MCP + pytest | Same as web app — Dash/Streamlit render in browsers. Also set up model assertion tests. |
| Data infrastructure | Output diffing | Create `tests/benchmarks/` directory. Ask about known-good oracle data. |
| Automation | Integration tests | Standard pytest/vitest setup is sufficient. |
| ML project | Eval framework | Create `tests/eval/` directory. Ask about baseline metrics. |

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

## Phase 3: Sprint Planning (Agent + User)

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
8. Hooks are installed and configured (pre-push has the correct test command)
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
- [ ] Hooks configured and registered
- [ ] Rubrics in place
- [ ] Maintenance checklist in place
- [ ] Evaluation scaffold in place
- [ ] `.fabrika/manifest.yml` generated with all installed files

### Type-specific
- [ ] `data-app`: Dashboard Spec, Data Model, Data Pipeline Design populated
- [ ] `data-platform`: Transformation Logic, Data Model, Data Pipeline Design populated
- [ ] `ml-project`: Model Design, Training Data Spec, Evaluation Criteria populated
- [ ] `web-app` (consumer): Vision & Positioning, UX Specification populated
- [ ] All with external data: Data Source Research notes for each known source
- [ ] `web-app` or `data-app`: E2E verification configured (Playwright MCP or equivalent)
