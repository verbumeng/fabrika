# Adopting Fabrika in an Existing Project

> **Audience: the AI agent.** This document tells you how to integrate Fabrika into a project that already exists — it has code, maybe docs, maybe its own workflow. Unlike BOOTSTRAP.md (which starts from scratch), ADOPT.md respects what's already there and layers Fabrika on top.

## Before Starting

Read the target project. Understand:
- What files and directories exist
- Whether there's an existing docs/ folder and what's in it
- Whether there are existing CI, test, or hook configurations
- What AI coding tool is in use (Claude Code, Copilot, both, neither)

Ask the user: **"I've read your project structure. Which Fabrika integration tier would you like?"**

## Integration Tiers

### Tier 1: Agents Only

**What it installs:** The four Fabrika agents + project configuration file + STATUS.md + features.json. Nothing else.

**Who it's for:** Someone who wants to try the agentic workflow without restructuring their project. Minimal footprint.

**Steps:**
1. Ask which tool integration: Claude Code, Copilot, or both
2. For Claude Code:
   - **Agent files (`.claude/agents/`):** If the directory doesn't exist, copy all agents from `[FABRIKA_PATH]/core/agents/*.md`. If `.claude/agents/` already exists, check each agent file individually:
     - If the agent file doesn't exist locally → copy it in
     - If an agent file with the same name already exists → **do NOT overwrite.** Read both the existing agent and the Fabrika canonical version. Present a diff to the user: "You have a custom [agent-name] agent. Fabrika's version includes [X, Y, Z sections]. Options: (1) Keep yours, (2) Replace with Fabrika's, (3) Merge — I'll add Fabrika sections your version is missing while preserving your customizations." Record the decision in the manifest.
     - If the user has agents with different names (custom agents not in Fabrika) → leave them alone, they're not Fabrika's concern
   - **Project configuration (CLAUDE.md):** If no `CLAUDE.md` exists, copy the Fabrika template from `[FABRIKA_PATH]/integrations/claude-code/CLAUDE.md`. If a `CLAUDE.md` already exists, **do NOT overwrite it.** Instead:
     1. Read the existing CLAUDE.md and the Fabrika template
     2. Identify which Fabrika sections are missing from the existing file (Session Lifecycle, Sprint Lifecycle, Development Workflow, Evaluation System, Hooks, Maintenance, Subagents, Testing Rules, Task Locking, etc.)
     3. Present the user with a section-by-section summary: "Your CLAUDE.md already has [X, Y, Z]. Fabrika would add [A, B, C]. Your existing sections will be preserved."
     4. Merge by appending Fabrika's workflow sections below the existing content, preserving everything the user already has (their Project Basics, Stack, constraints, custom rules)
     5. If any sections conflict (e.g., user has their own "Git Workflow" section), present both versions and ask: keep theirs, use Fabrika's, or merge
   - Copy `[FABRIKA_PATH]/integrations/claude-code/settings-template.json` to `.claude/settings.json` (if `.claude/settings.json` doesn't already exist — if it does, merge Fabrika's permission rules into the existing file without overwriting existing settings)
   - Ask the user to fill in any empty Project Basics and Project Stack sections
3. For Copilot:
   - **Agent files (`.github/agents/`):** Same merge protocol as Claude Code agents above, but with `*.agent.md` naming. Check each file individually — copy missing agents, merge or ask on conflicts, leave custom agents alone.
   - **Project configuration (copilot-instructions.md):** If no `.github/copilot-instructions.md` exists, copy from `[FABRIKA_PATH]/integrations/copilot/copilot-instructions.md`. If one already exists, **do NOT overwrite it.** Instead, read both files, identify Fabrika sections missing from the existing file, present a section-by-section summary, and merge Fabrika's workflow sections into the existing file — preserving everything the user already has
4. Copy `[FABRIKA_PATH]/core/STATUS-template.md` to `STATUS.md` in project root (if STATUS.md doesn't exist)
5. Copy `[FABRIKA_PATH]/core/features-template.json` to `features.json` in project root (if features.json doesn't exist)
6. Generate `.fabrika/manifest.yml` recording what was installed
7. Report to the user what was placed and where

**The user's existing project structure is not modified.** No docs reorganization, no hooks, no templates.

### Tier 2: Agents + Sprint Framework

**What it installs:** Everything from Tier 1, plus sprint contracts, rubrics, hooks, evaluation scaffold, and maintenance checklist. Templates go into the existing docs structure — no reorganization.

**Who it's for:** Someone who wants the full sprint workflow but has an existing docs structure they want to keep.

**Steps (in addition to Tier 1):**
1. Ask: **"Where do your project docs live?"** (e.g., `docs/`, `documentation/`, root-level markdown, wiki)
2. Create a `Templates/` subdirectory in the docs location for sprint contract templates
   - Copy topology templates from `[FABRIKA_PATH]/core/topologies/`
   - Copy Sprint-Retro-Template from `[FABRIKA_PATH]/core/templates/Sprint-Retro-Template.md`
3. Create a `rubrics/` subdirectory (or place in existing engineering docs area)
   - Copy rubrics from `[FABRIKA_PATH]/core/rubrics/`
4. Copy maintenance checklist from `[FABRIKA_PATH]/core/maintenance-checklist.md` into the docs area
5. Create an `evaluations/` directory for QA reports
6. Create an `evals/` directory with scaffold:
   - Copy `[FABRIKA_PATH]/core/evals/README.md`
   - Copy `[FABRIKA_PATH]/core/evals/agent-changelog-template.md` as `agent-changelog.md`
   - Create empty agent subdirectories: `evals/code-reviewer/`, `evals/test-writer/`, `evals/product-manager/`, `evals/scrum-master/`
7. For Claude Code — **hooks (`.claude/hooks/`):**
   - If no hooks exist, copy all three from `[FABRIKA_PATH]/core/hooks/` and update `pre-push.sh` with the project's test command (ask if not obvious)
   - If hooks already exist, check each one individually:
     - **pre-push.sh:** If one exists, read it. If it already runs tests, ask whether to keep theirs, replace with Fabrika's, or merge (e.g., add Fabrika's blocked-push logging alongside the existing test command). If it does something unrelated to testing (linting, formatting), merge Fabrika's regression gate as an additional step.
     - **post-commit.sh / pre-commit.sh:** Same approach — read the existing hook, present what Fabrika's version adds, merge or ask.
   - Register hooks in `.claude/settings.json` (merging into existing settings if the file exists)
8. For Copilot: check for existing git hooks in `.git/hooks/` or CI pipeline gates. If they exist, suggest merging Fabrika's hook logic into them rather than replacing. If none exist, suggest creating equivalent hooks or CI steps.
9. Update the manifest with all newly installed files

**The existing docs structure is preserved.** Fabrika adds directories alongside what's already there. The numbered `00-Index/` through `09-Personal-Tasks/` hierarchy from BOOTSTRAP.md is NOT imposed.

### Tier 3: Full Restructure

**What it installs:** Everything from Tier 2, plus the full BOOTSTRAP.md docs hierarchy.

**Who it's for:** Someone starting a major new phase of an existing project who wants a clean documentation slate. Recommended only with explicit user consent.

**Warning to present to the user:**
> "Tier 3 will reorganize your docs/ directory into the Fabrika convention (numbered sections: 00-Index through 09-Personal-Tasks, plus evaluations, plans, session-logs, evals, and maintenance directories). This is recommended if you're starting a major new phase and want a clean slate. **Back up your current docs/ first.** I'll show you where each existing file would move before making changes."

**Steps (in addition to Tier 2):**
1. Inventory the existing docs directory
2. Propose a mapping: each existing file → where it would live in the Fabrika structure
3. Present the mapping to the user for approval. Highlight any conflicts or files that don't have an obvious home.
4. Create the numbered directory structure from BOOTSTRAP.md
5. Move files per the approved mapping
6. Copy all templates from `[FABRIKA_PATH]/core/templates/` into `docs/Templates/`
7. Create any missing Tier 1 documents as stubs (Home.md, Phase Definitions.md, Architecture Overview.md, etc.)
8. Read the Document Catalog at `[FABRIKA_PATH]/core/Document-Catalog.md` for the full list of documents appropriate to this project type
9. Update the manifest

## Handling Conflicts

Some files are almost certain to already exist in a real project. These require **merge, not overwrite** — the default posture for ADOPT is to never destroy existing project content.

### Files that always require merge (never overwrite)

| File | Why | Merge approach |
|------|-----|----------------|
| **CLAUDE.md** | User's primary project control document with project-specific config | Section-by-section merge — see Tier 1 protocol above |
| **copilot-instructions.md** | Same as CLAUDE.md for Copilot users | Section-by-section merge |
| **.claude/settings.json** | User has existing permissions, preferences, MCP server configs | Merge Fabrika's permission rules into existing JSON structure |
| **Agent files** (`.claude/agents/*.md`, `.github/agents/*.agent.md`) | User may have custom-tuned agents with the same names | Per-file diff and user choice: keep, replace, or merge |
| **Hooks** (`.claude/hooks/*`, `.git/hooks/*`) | User likely has existing test/lint/formatting hooks | Merge Fabrika's hook logic as additional steps alongside existing logic |
| **.gitignore** | Every project has one | Append Fabrika-relevant entries that aren't already present — never remove existing entries |
| **Justfile / Makefile** | User has existing build recipes | If BOOTSTRAP would add recipes (`run`, `test`, `lint`), add only missing ones — never remove or rename existing recipes |

### Files safe to write (ask only if they exist)

| File | Notes |
|------|-------|
| **STATUS.md** | Unlikely to pre-exist with this name. If it does, ask. |
| **features.json** | Unlikely to pre-exist. If it does, ask. |
| **Sprint contract templates, rubrics, checklists** | New files in new directories. If the user happens to have a `rubrics/` directory already, place alongside existing files. |
| **Eval scaffold** (README.md, agent-changelog) | New files in new directories. |

### General conflict protocol

For any file not listed above, when a Fabrika file would overwrite an existing file:
1. Read both the existing file and the Fabrika source file
2. Present a summary of differences to the user
3. Ask: **"This file already exists. Options: (1) Keep yours, (2) Replace with Fabrika version, (3) Merge — I'll combine both."**
4. Record the decision in the manifest. If the user kept theirs, set `customized: true`.

## After Adoption

- The project now has `.fabrika/manifest.yml` and can use UPDATE.md for future Fabrika updates
- Sprint workflow is available immediately (start with the scrum-master agent for sprint planning)
- The evaluation harness will build itself over time through normal maintenance sessions
- `.fabrika/evals/` will accumulate sprint eval artifacts that feed the harvest loop
