# Fabrika — Framework Relationship Guide

> **Audience: the AI agent working on this project.** Read this file on demand when you need to understand how this project relates to canonical Fabrika — especially during sprint retros, when agent prompts are modified, or when the owner asks about flowing improvements to other projects. This file does NOT need to be loaded into every session.

## What Fabrika is

Fabrika is the agentic workflow framework that provided this project's agents, sprint contracts, rubrics, hooks, evaluation harness, and project configuration template (CLAUDE.md or copilot-instructions.md). The canonical Fabrika repo is the source of truth for the framework itself. This project is a **consumer** of Fabrika.

## What `.fabrika/` contains

The `.fabrika/` directory at this project's root contains:
- **`manifest.yml`** — Tracks which Fabrika version was installed, which files were placed, and whether any have been customized locally. This is how the update protocol knows what to sync. **Do not modify this file directly** — it's updated by the bootstrap, adopt, and update protocols.
- **`calibration.yml`** — Per-project calibration data for token cost estimation. Updated automatically after workflow runs when token data is available. Improves estimate accuracy over time via EWMA blending against bundled priors. Scaffolded from `core/templates/Calibration-Template.yml` at bootstrap. **Do not manually edit** — the estimation script manages it.
- **`evals/sprint-NN.md`** — Per-sprint evaluation artifacts that capture how each agent performed. These are the input to the harvest workflow. **You write these during sprint retros.**
- **`FABRIKA.md`** — This file.

## Framework Scripts

`core/scripts/` contains deterministic helpers invokable by the
orchestrator. Scripts are computational tools — they receive
structured input, perform calculations, and emit JSON output. They
are not agents and do not make judgment calls. See
`core/scripts/README.md` for conventions and admission criteria.

## How local changes work

During a sprint, you may modify any Fabrika-originated file to fit this project's needs — agent prompts, workflow steps in the project configuration (CLAUDE.md), sprint contract templates, rubrics, the maintenance checklist, hooks, or anything else. **This is expected and encouraged.** Local customization is how the framework adapts to specific projects. These changes stay local — they do not automatically propagate anywhere.

The manifest tracks which files have been customized (their hash drifts from the install-time hash). When you modify an agent prompt specifically, also log the change to `docs/evals/agent-changelog.md` with: what changed, why, and which session logs document the context.

## How local changes flow back to canonical Fabrika

The flow is: **eval artifacts + manifest drift → harvest → canonical update → propagation to other projects.**

### Step 1: Write eval artifacts (your job)

During the sprint retro, write `.fabrika/evals/sprint-NN.md` using the eval artifact template. For each agent invoked this sprint, record:
- **Outcome:** success, friction, or failure
- **What happened:** concrete description
- **Root cause:** if friction or failure — why the agent behaved this way
- **Local fix applied:** what changed in the local agent file, if anything
- **Generalizable?** `yes | no | maybe` with brief reasoning

The `Generalizable?` field is the most important part. "Yes" means the fix would improve the agent for ALL projects. "Maybe" means it might help but needs more evidence. "No" means it's specific to this project.

Draw from:
- The "Agent quality observations" bullets in the sprint progress file
- The evaluation reports in `docs/evaluations/`
- Any agent-changelog entries from this sprint
- Agent prompt changes approved in the retro

### Step 2: Harvest (the owner's job, not yours)

A separate harvest workflow — run by the owner across all Fabrika-managed projects — reads both eval artifacts AND manifest drift (diffs of all customized files against their canonical versions). It finds generalizable improvements across agents, workflow steps, templates, rubrics, and any other Fabrika-originated file. This happens outside of any individual project. You do not push changes upstream yourself.

### Step 3: Canonical update (the owner's job)

Accepted proposals are applied to canonical Fabrika with version bumps and changelog entries.

### Step 4: Propagation (the owner's job)

The owner runs the update protocol against this project (and others). It reads this project's manifest, checks the Fabrika changelog for what changed between versions, and for each changed file:
- If you haven't customized it locally → overwrites cleanly
- If you have customized it → presents a diff and asks the owner to choose: keep local, accept canonical, or merge

## Quick reference for the agent

- **Customize any Fabrika file freely** during sprints — agents, CLAUDE.md workflow, templates, rubrics, whatever the project needs. You won't break canonical Fabrika.
- **Log agent prompt changes** to `docs/evals/agent-changelog.md`
- **Write eval artifacts** during retro — the Sprint Retro Template prompts for this
- **Don't modify `.fabrika/manifest.yml`** directly
- If the owner asks "how do I get this improvement into my other projects?" → the answer is the harvest workflow, not manual copying. Point them to `HARVEST.md` in the Fabrika repo.
