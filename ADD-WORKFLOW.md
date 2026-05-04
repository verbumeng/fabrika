# Adding a Workflow Type to an Existing Project

> **Audience: the AI agent (orchestrator).** This document tells you
> how to add a new workflow type to a project that already uses Fabrika.
> Projects are not locked to their declared project type — they can
> pull in additional workflow types as their work requires.

## When to Trigger

The orchestrator should initiate this process when:

1. **The user asks for work that doesn't fit installed workflows.** If
   the project has sprint-based agents but the user needs a quick
   bounded task (task, plan, execute, validate, deliver), the task
   workflow type fits better than shoehorning it into a sprint story.
2. **The user explicitly requests a workflow type.** "Can we add the
   analytics workflow?" or "I need to do some ad hoc analysis here."
3. **The orchestrator detects a pattern mismatch.** The work the user
   is describing would benefit from agents or ceremony not available
   in the installed workflow types.

The orchestrator does NOT auto-install workflow types without user
confirmation. It proposes: "This looks like [task/analytics/sprint]
work. Your project doesn't have that workflow type installed. Would
you like to add it?"

## What Gets Installed

Each workflow type has a defined set of files. The orchestrator copies
these from the Fabrika source into the consumer project.

### Task Workflow (base)

| File | Source | Destination |
|------|--------|-------------|
| Planner agent | `[FABRIKA_PATH]/core/agents/planner.md` | `.claude/agents/planner.md` or `.github/agents/planner.agent.md` |
| Implementer agent | `[FABRIKA_PATH]/core/agents/implementer.md` | `.claude/agents/implementer.md` or `.github/agents/implementer.agent.md` |
| Reviewer agent | `[FABRIKA_PATH]/core/agents/reviewer.md` | `.claude/agents/reviewer.md` or `.github/agents/reviewer.agent.md` |
| Validator agent | `[FABRIKA_PATH]/core/agents/validator.md` | `.claude/agents/validator.md` or `.github/agents/validator.agent.md` |
| Workflow definition | `[FABRIKA_PATH]/core/workflows/types/task-workflow.md` | `.fabrika/workflows/task-workflow.md` (reference copy) |
| Task template | `[FABRIKA_PATH]/core/templates/Task-Template.md` | Project template location |
| Plan template | `[FABRIKA_PATH]/core/templates/Plan-Template.md` | Project template location |
| Outcome template | `[FABRIKA_PATH]/core/templates/Outcome-Template.md` | Project template location |

Also creates `tasks/` and `docs/evaluations/` directories if they do
not exist.

### Analytics Workflow

Same as task workflow base, plus analytics-specific agents and
configuration. See BOOTSTRAP.md Phase 2W for the full analytics
workflow setup, which includes source registry scaffolding, platform
onboarding, and analytics-specific agents (analysis-planner,
data-analyst, logic-reviewer, data-validator). Bundled procedures:
analytics-workflow-onboarding and task-promotion are installed
alongside the analytics workflow.

### Domain Workflows

Domain workflows (software-development, data-engineering,
analytics-engineering, data-app, ml-engineering, ai-engineering,
library) provide domain-specific agent rosters and gates that compose
with the story-execution protocol. Adding a domain workflow installs:
the domain workflow file, the domain-specific agents, and a reference
to `core/workflows/protocols/story-execution.md` for shared execution
mechanics. The orchestrator also assesses whether **sprint
coordination** is needed based on the project's work complexity —
sprint coordination can be added independently of any workflow
addition. It is a complexity-triggered procedure, not a workflow type.

See BOOTSTRAP.md Phase 2 and ADOPT.md Tier 2 for full sprint
framework installation (sprint contracts, rubrics, hooks, evaluation
scaffold).

## Installation Procedure

1. **Confirm with the user.** Present what will be installed and where.
   List the specific files. Ask for approval before copying anything.

2. **Check for conflicts.** For each file to be installed, check if a
   file with the same name already exists. If it does, follow the
   merge protocol from ADOPT.md: read both files, present differences,
   ask the user whether to keep theirs, replace, or merge.

3. **Copy files.** Install the agent files, workflow definition, and
   templates. Create any required directories.

4. **Update the project instruction file.** Add the new workflow type
   to the project's CLAUDE.md or copilot-instructions.md. The
   orchestrator needs to know the workflow type is available so it can
   route work to the right agents.

5. **Update the manifest.** Add the new workflow type and installed
   files to `.fabrika/manifest.yml`.

6. **Confirm installation.** Report to the user what was installed and
   how to use the new workflow type. For the task workflow: "You can
   now bring any bounded task to the orchestrator. It will create a
   task, plan, execute, review, validate, and deliver — using
   domain-agnostic agents that work with whatever the task produces."

## Relationship to ADOPT.md

ADD-WORKFLOW.md is the workflow-level equivalent of ADOPT.md's tiered
adoption. Where ADOPT.md layers Fabrika onto a project that has never
used it, ADD-WORKFLOW.md adds a specific workflow type to a project
that already has Fabrika installed.

The key difference: ADOPT.md installs the framework (agents, project
configuration, status tracking). ADD-WORKFLOW.md installs a specific
workflow type within that framework (workflow-specific agents,
templates, directory structure).

## After Installation

The new workflow type is immediately available. The orchestrator routes
work to the appropriate agents based on the type of work the user
brings. If the user has multiple workflow types installed, the
orchestrator assesses which workflow fits the work and proposes
accordingly.
