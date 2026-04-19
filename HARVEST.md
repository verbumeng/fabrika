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

## What NOT to Harvest

- Project-specific agent tuning (e.g., "check for pandas deprecation warnings" in a data-platform project)
- Findings that are already in the canonical agent (duplicates)
- Findings from a single occurrence (wait for a pattern — at least 2 independent observations across different sprints or projects)

## Frequency

There's no prescribed cadence. Good triggers:
- After completing a sprint in any project, review that project's latest eval artifact
- During a weekly or monthly review cycle, scan all projects
- When you notice the same agent failure across multiple projects

The harvest is cheap — eval artifacts are small, structured, and have the `Generalizable?` field pre-tagged. Most of the human effort is in the review step, not the scan.
