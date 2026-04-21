# Harvest Workflow

> **Audience: the AI agent.** This document describes how generalizable learnings from individual projects flow back into canonical Fabrika. This is NOT automated — it's a human-triggered, agent-assisted judgment call.

## The Problem

Each project that installs Fabrika gets a fork of the canonical agents. Over time, those forks diverge as agents are tuned for the specific project. Some of those tunings are project-specific (e.g., "pay extra attention to SQL injection in this data app"). Others are generalizable (e.g., "the code-reviewer should always check for unused destructured fields"). The harvest workflow separates the two.

## What Can Be Harvested

Harvest is NOT limited to agent prompts. Any Fabrika-originated file in a consumer project can diverge and contain generalizable improvements. The manifest tracks every installed file and whether it's been customized. Common sources of harvestable changes:

| File type | Examples of generalizable changes |
|-----------|----------------------------------|
| **CLAUDE.md** (project config) | New workflow steps (e.g., "prompt user to review story before moving to next"), new backlog types (e.g., bugs alongside stories/epics), session lifecycle improvements, evaluation cycle refinements |
| **Agent prompts** | Better orientation steps, new check categories, improved skepticism calibration |
| **Sprint contract templates** | Additional stage gates, new sections for specific topology types |
| **Rubrics** | Adjusted criteria weights, new grading dimensions discovered through real use |
| **Maintenance checklist** | New check categories, refined thresholds |
| **Document Catalog** | New document types, tier adjustments based on what actually gets used |
| **Hooks** | Improved logic, additional checks |
| **Templates** (story, epic, sprint, etc.) | New fields, structural improvements |

## Two Inputs to the Harvest

### Input 1: Eval artifacts (structured, per-sprint)

Each consuming project produces a structured eval artifact after each sprint, stored at `.fabrika/evals/sprint-NN.md`. The template is at `core/evals/eval-artifact-template.md`.

The key field in each entry is **`Generalizable?`** — marked `yes`, `no`, or `maybe` with brief reasoning. This is the primary harvest signal for agent-level changes.

The orchestrating agent writes the eval artifact during the sprint retro phase. It draws from:
- The sprint progress file's "Agent quality observations" bullets
- The evaluation reports in `docs/evaluations/`
- The agent-changelog entries from this sprint
- Any agent prompt changes approved in the retro

### Input 2: Manifest drift (file-level, any time)

The `.fabrika/manifest.yml` records every Fabrika-originated file and its install-time hash. Any file where the current hash differs from the install hash has been customized. The harvest workflow should **diff every customized file against its canonical source** — not just the agents.

This catches workflow changes (CLAUDE.md modifications, template additions, rubric adjustments) that the eval artifacts might not cover because they aren't agent-specific.

### Cross-machine note

Projects live on whichever machine they're developed on. Per-project forks and eval artifacts stay local to that machine. Canonical Fabrika is what syncs across machines (via `git pull`). This is correct and intentional — do not try to engineer cross-machine sync of fork state. The harvest workflow is the bridge.

## The Harvest Workflow

This is triggered by the user (or by an external task management system on a schedule). It is NOT triggered automatically.

### 1. Scan both inputs

For each project (the user provides the list, or the agent discovers them by searching for `.fabrika/manifest.yml` under the projects root):

**a. Eval artifacts:** Read `.fabrika/evals/sprint-*.md` files. Collect entries marked `Generalizable: yes` or `Generalizable: maybe`.

**b. Manifest drift:** Read `.fabrika/manifest.yml`. For every file with `customized: true` (or where the current file hash differs from the manifest's install-time hash), compute a diff against the canonical source in the Fabrika repo. Collect all diffs.

### 2. Analyze

For each finding (eval artifact entry or file diff):
- Read the full context: what changed, why, what problem it solved
- Classify: **generalizable** (any project benefits), **type-specific** (benefits a subset of project types), or **project-specific** (only relevant to this project's domain)
- For manifest diffs: distinguish between project-specific customization (e.g., filled-in Project Stack section in CLAUDE.md) and framework-level improvements (e.g., added a story review step to the session lifecycle)

### 3. Propose

For each generalizable or type-specific finding, propose a concrete canonical update:
- Which file in the Fabrika repo to modify (could be `core/agents/`, `core/templates/`, `integrations/claude-code/CLAUDE.md`, `core/Document-Catalog.md`, etc.)
- The specific change (diff or before/after snippet)
- Which project types it affects (all, or a subset)
- The rationale

Present all proposals to the user as a batch, grouped by file.

### 5. Review

The user reviews each proposal:
- **Accept** — Apply the change to canonical Fabrika. Bump VERSION (minor for `core/**`), add CHANGELOG entry.
- **Reject** — The finding is project-specific after all, or the proposed change isn't right. Note why.
- **Defer** — Worth considering but not now. Add to a `SOMEDAY.md` in the Fabrika repo (or the user's notes).

### 6. Propagate

Accepted changes are now in canonical Fabrika. They flow to other projects via the normal UPDATE.md protocol the next time those projects update.

## Ordering: Harvest Before Update

**Always run the harvest before running UPDATE.md on consumer projects.** If you update first, the update may overwrite locally customized files (if the user accepts the canonical version), and the local diffs you wanted to harvest are lost. Eval artifacts would still describe agent-level changes, but workflow changes captured only as CLAUDE.md or template diffs would be gone.

The correct sequence when a new Fabrika version is available AND projects have local changes to harvest:

1. **Harvest** — scan eval artifacts, propose canonical updates, accept/reject
2. **Commit accepted changes to canonical Fabrika** — version bump, changelog entry
3. **Update consumer projects** — now the update includes both the upstream changes and the harvested improvements in a single pass

This avoids updating twice and ensures no local work is lost.

## What NOT to Harvest

- **Project-specific customization** — filled-in placeholders (Project Stack, Project Basics), domain-specific agent tuning (e.g., "check for pandas deprecation warnings"), project-specific workflow steps that don't generalize
- **Duplicates** — changes that are already in the current canonical version
- **Single occurrences** — wait for a pattern (at least 2 independent observations across different sprints or projects) before proposing a canonical change. Exception: if a change is obviously correct and universally applicable (e.g., fixing a broken step in the session lifecycle), one occurrence is enough.

## How to Run the Harvest

The harvest is not automated — you trigger it by pointing an agent at this document and your projects. There are three ways to do this depending on your setup.

### Option A: Hand an agent this prompt

Open a new chat in the Fabrika repo directory and give the agent this prompt (fill in your project paths):

> Read HARVEST.md. Run the harvest workflow against these projects:
> - ~/projects/project-a
> - ~/projects/project-b
> - ~/projects/project-c
>
> For each project:
> 1. Read `.fabrika/manifest.yml` and diff every customized file against its canonical source in this Fabrika repo
> 2. Read `.fabrika/evals/sprint-*.md` for eval artifact entries marked `Generalizable: yes` or `maybe`
> 3. For each finding (file diff or eval entry), assess: is this project-specific, type-specific, or universally generalizable?
> 4. Propose concrete canonical updates for anything generalizable. Present all proposals grouped by file for my review.

The agent reads this doc for the full protocol, diffs customized files, reads eval artifacts, and does the analysis. You review the proposals and accept/reject/defer.

### Option B: Integrate with your task/review system

If you use a task management system with recurring reviews (weekly, monthly), add a harvest check to your review workflow:

1. During your review, check: "Has any project completed a sprint since the last harvest?"
2. If yes, run the harvest (Option A) before or after the review
3. The review system can automate the check by scanning for new `.fabrika/evals/sprint-*.md` files with timestamps newer than the last harvest

This is the recommended approach for users who have a regular review cadence — the harvest piggybacks on a rhythm you already have.

### Option C: Ad hoc, when you notice a pattern

If you're working in Project A and the code-reviewer misses something, and you think "wait, this happened in Project B too" — that's a harvest trigger. You don't need to wait for a scheduled review. Open a chat in the Fabrika repo and run Option A targeting just those two projects.

## Frequency

There's no prescribed cadence. Good triggers:
- After completing a sprint in any project, review that project's latest eval artifact
- During a weekly or monthly review cycle, scan all projects
- When you notice the same agent failure across multiple projects

The harvest is cheap — eval artifacts are small, structured, and have the `Generalizable?` field pre-tagged. Most of the human effort is in the review step, not the scan.

## Verifying Eval Artifacts Exist

If you're unsure whether your projects are producing eval artifacts, check:

```bash
# From your projects root directory
find ~/projects -path "*/.fabrika/evals/sprint-*.md" -newer ~/.fabrika-last-harvest 2>/dev/null
```

If no artifacts are found, the likely issue is that the sprint retro phase isn't writing them. Check the consumer project's CLAUDE.md — the "Fabrika Relationship" section describes when eval artifacts should be written. The Sprint Retro Template (`docs/Templates/Sprint-Retro-Template.md`) should prompt for it, but if the project was bootstrapped before eval artifacts were added, you may need to add the step to the retro workflow manually.
