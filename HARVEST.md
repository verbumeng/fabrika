# Harvest Workflow

> **Audience: the AI agent.** This document describes how generalizable learnings from individual projects flow back into canonical Fabrika. This is NOT automated — it's a human-triggered, agent-assisted judgment call.

## The Problem

Each project that installs Fabrika gets a fork of the canonical agents. Over time, those forks diverge as agents are tuned for the specific project. Some of those tunings are project-specific (e.g., "pay extra attention to SQL injection in this data app"). Others are generalizable (e.g., "the code-reviewer should always check for unused destructured fields"). The harvest workflow separates the two.

## Eval Artifacts — The Input

Each consuming project produces a structured eval artifact after each sprint, stored at `.fabrika/evals/sprint-NN.md`. The template for this artifact is at `core/evals/eval-artifact-template.md`.

The key field in each agent entry is **`Generalizable?`** — marked `yes`, `no`, or `maybe` with brief reasoning. This is the harvest signal.

### Who writes eval artifacts

The orchestrating agent writes the eval artifact during the sprint retro phase (or as a dedicated step after the retro). It draws from:
- The sprint progress file's "Agent quality observations" bullets
- The evaluation reports in `docs/evaluations/`
- The agent-changelog entries from this sprint
- Any agent prompt changes approved in the retro

### Cross-machine note

Projects live on whichever machine they're developed on. Per-project agent forks and eval artifacts stay local to that machine. Canonical Fabrika is what syncs across machines (via `git pull`). This is correct and intentional — do not try to engineer cross-machine sync of fork state. The harvest workflow is the bridge.

## The Harvest Workflow

This is triggered by the user (or by an external task management system on a schedule). It is NOT triggered automatically.

### 1. Scan

Read `.fabrika/evals/` directories across all project directories on this machine. The user should provide the list of project paths, or the agent can discover them by searching for `.fabrika/manifest.yml` files under the projects root.

### 2. Filter

Find all eval artifact entries marked `Generalizable: yes` or `Generalizable: maybe`. Collect them into a single list grouped by agent.

### 3. Analyze

For each generalizable finding:
- Read the full context: what happened, what the root cause was, what local fix was applied
- Determine if the finding genuinely applies to ALL projects using this agent, or only to a subset of project types
- If it applies to a subset, note which project types

### 4. Propose

For each finding that passes analysis, propose a concrete canonical update:
- Which file in `core/agents/` to modify
- The specific change (diff or before/after snippet)
- Which project types it affects
- The rationale

Present all proposals to the user as a batch.

### 5. Review

The user reviews each proposal:
- **Accept** — Apply the change to canonical Fabrika. Bump VERSION (minor for `core/**`), add CHANGELOG entry.
- **Reject** — The finding is project-specific after all, or the proposed change isn't right. Note why.
- **Defer** — Worth considering but not now. Add to a `SOMEDAY.md` in the Fabrika repo (or the user's notes).

### 6. Propagate

Accepted changes are now in canonical Fabrika. They flow to other projects via the normal UPDATE.md protocol the next time those projects update.

## Ordering: Harvest Before Update

**Always run the harvest before running UPDATE.md on consumer projects.** If you update first, the update may overwrite locally customized agent files (if the user accepts the canonical version), and the local diff you wanted to harvest is lost. The eval artifact would still describe the change, but the actual modified file is gone.

The correct sequence when a new Fabrika version is available AND projects have local changes to harvest:

1. **Harvest** — scan eval artifacts, propose canonical updates, accept/reject
2. **Commit accepted changes to canonical Fabrika** — version bump, changelog entry
3. **Update consumer projects** — now the update includes both the upstream changes and the harvested improvements in a single pass

This avoids updating twice and ensures no local work is lost.

## What NOT to Harvest

- Project-specific agent tuning (e.g., "check for pandas deprecation warnings" in a data-platform project)
- Findings that are already in the canonical agent (duplicates)
- Findings from a single occurrence (wait for a pattern — at least 2 independent observations across different sprints or projects)

## How to Run the Harvest

The harvest is not automated — you trigger it by pointing an agent at this document and your projects. There are three ways to do this depending on your setup.

### Option A: Hand an agent this prompt

Open a new chat in the Fabrika repo directory and give the agent this prompt (fill in your project paths):

> Read HARVEST.md. Scan the following project directories for `.fabrika/evals/sprint-*.md` files:
> - ~/projects/project-a
> - ~/projects/project-b
> - ~/projects/project-c
>
> Find all entries marked `Generalizable: yes` or `Generalizable: maybe`. Group them by agent. For each finding, read the full context, assess whether it genuinely applies to all projects or a subset, and propose concrete canonical updates. Present all proposals for my review.

That's it. The agent reads this doc for the full protocol, reads the eval artifacts, and does the analysis. You review the proposals and accept/reject/defer.

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
