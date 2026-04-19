---
type: reference
title: Agent Evaluation Harness
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [evals, agents, quality]
---

# Agent Evaluation Harness

## What This Is

A test suite for your agents, not your code. Eval cases verify that agent prompts produce correct, consistent output. Each case has a known correct answer — run the agent, compare output to ground truth, measure accuracy.

## Why It Matters

Without evals, prompt changes are guesswork. You change a code-reviewer prompt and hope it finds more bugs. With evals, you change the prompt, re-run the eval suite, and see: "Accuracy improved from 6/10 to 8/10, no regressions on other cases."

## When to Build Evals

**Not immediately.** Evals should be built from real observed failures, not synthetic scenarios. The system graduates through three stages:

### Stage 1: Capture (from project day 1)
- Session logs (`docs/session-logs/`) capture agent activity every session
- `agent-changelog.md` (this directory) captures every agent prompt modification and the failure that motivated it
- These accumulate automatically through the normal workflow

### Stage 2: Build (after 2-3 sprints of real work)
The maintenance session reviews accumulated data and builds eval cases:
- Reviews `agent-changelog.md` for prompt modifications driven by repeated failures
- Reviews session logs for failure patterns (same type of failure 3+ times)
- Drafts eval cases from real failures
- Presents cases to the owner for review and approval
- Saves approved cases to `docs/evals/{agent-name}/eval-NNN.md`

**Trigger:** The maintenance session recommends building evals when agent prompts have been modified 3+ times based on observed failures, OR when the project has completed 3+ sprints.

### Stage 3: Improve (ongoing once evals exist)
The maintenance session runs evals and proposes improvements:
- Runs all eval cases against current agent prompts
- Reports accuracy per agent
- Identifies consistently failing cases
- Drafts prompt improvements and tests them against the eval suite
- Presents results: "This change improves code-reviewer accuracy from 6/10 to 8/10"
- Owner reviews and approves/rejects

## Coverage Target

Aim for the top 10 observed failure modes per agent. Stop adding evals when:
- Accuracy is stable across maintenance cycles (no regressions)
- No new failure patterns are emerging from session logs
- The maintenance session reports: "Eval suite appears comprehensive"

This is a judgment call made by the maintenance session and confirmed by the owner.

## Eval Case Format

Each eval case is a markdown file at `docs/evals/{agent-name}/eval-NNN.md`:

```markdown
---
type: eval-case
agent: code-reviewer
id: eval-001
created: YYYY-MM-DD
source: "Session log 2026-04-10 — missed route shadowing bug in MYAPP-28"
---

# Eval 001: Route Shadowing Detection

## Input
[Code sample or task description that the agent will be given]

## Expected Output
[What the agent should find/produce — the ground truth]

## Failure Mode
[What the agent was doing wrong that this eval catches]

## Result Log
| Date | Passed | Notes |
|------|--------|-------|
| YYYY-MM-DD | yes/no | [Brief note] |
```

## Agent Changelog Format

`agent-changelog.md` in this directory logs every agent prompt modification:

```markdown
## YYYY-MM-DD — [agent-name]
**Change:** [What was modified in the prompt]
**Failure that motivated it:** [The observed failure — what went wrong]
**Session logs:** [References to session logs documenting the failure]
**Files modified:** [Which agent prompt files were changed]
**Eval coverage:** [Does an eval case exist for this failure mode? If yes, which one?]
```

## Directory Structure

```
docs/evals/
├── README.md              # This file
├── agent-changelog.md     # Running log of prompt modifications
├── code-reviewer/         # Eval cases for code-reviewer
│   ├── eval-001.md
│   └── ...
├── test-writer/           # Eval cases for test-writer
├── product-manager/       # Eval cases for product-manager
└── scrum-master/          # Eval cases for scrum-master
```
