# PRD-03: Implementer Archetype + Pure Orchestrator

**Version target:** 0.12.0
**Dependencies:** PRD-01 (archetype stubs exist), PRD-02 (Fabrika uses
agentic-workflow process)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

The orchestrating agent currently does all implementation work — writing
production code, modifying files, building features. Sub-agents only
handle planning, reviewing, validating, coordinating, and designing.
This means:

- The orchestrator's context window fills with implementation details,
  degrading its planning and routing judgment
- There are no explicit input/output contracts for implementation work
- Implementation quality depends entirely on whatever the orchestrator
  happens to know, rather than on specialized agent prompts with
  domain-specific expertise
- As projects grow in complexity (adding ML, analytics pipelines,
  infrastructure), a single implementing agent can't hold all domains

## Solution

Create the **implementer archetype** — the sixth archetype (seventh
including architect from PRD-04). Define 5 specialist implementer agents
mapped to project types. Rewrite the development workflow so the
orchestrator dispatches to implementers instead of implementing directly.

The orchestrator becomes a pure dispatcher: it understands what needs to
happen, routes work to the right specialist, receives results, and
synthesizes for the owner. It never writes production code.

### Implementer Agents

| Agent | Project Types | Domain |
|---|---|---|
| software-engineer | web-app, automation, library | Frontend/backend code, APIs, UI, CLI, infrastructure |
| data-engineer | data-engineering, analytics-engineering | Pipelines, transformations, orchestration DAGs, dbt, SQL |
| data-analyst | analytics-workspace, data-app | Analysis scripts, SQL, notebooks, DAX, report logic, dashboards |
| ml-engineer | ml-engineering | Model code, training scripts, feature engineering, eval harnesses |
| ai-engineer | ai-engineering | Prompt engineering, RAG pipelines, agent code, eval suites, guardrails |

### Archetype Definition

**Tool profile:** Full access — terminal, read, write, edit. The
implementer is the agent (besides validator) that creates and modifies
source code files.

**Dispatch contract:** Strict-ish. The implementer receives:
- Approved spec (from planner)
- Relevant architecture docs
- File paths / directories to work in
- Testing strategy (from spec or scrum master)
- Domain Language document (if exists)

The implementer returns:
- Changed file paths
- Brief implementation summary (what was done, any spec deviations)
- Any questions or blockers encountered

**Behavioral rules:**
- Implement against the approved spec — do not add features or
  refactor beyond scope
- Follow the project's Canonical Patterns and Structural Constraints
- Name things using Domain Language terms (when available)
- If the spec is ambiguous, flag it rather than guessing
- Run tests after implementation (basic verification, not full eval)

### Lightweight Dispatch Threshold

For trivial tasks (< 5 minutes estimated work, < 3 files touched), the
orchestrator dispatches with a lightweight contract: task description +
file paths only. No full spec required. The implementer still does the
work — the orchestrator still doesn't implement — but the ceremony is
reduced.

### Cross-Domain Scoping

Each implementer stays tightly scoped to its domain. A data-engineer
doing pipeline work is capable of writing SQL queries to verify data
flow — that's within domain. But if a story requires both pipeline
changes AND frontend dashboard changes, the orchestrator dispatches to
data-engineer AND software-engineer, not one agent trying to do both.

## Key Decisions (Already Aligned)

- 5 implementer agents is the right granularity
- The orchestrator NEVER writes production code, even for trivial tasks
- Lightweight dispatch is a reduced-ceremony path, not an "orchestrator
  does it" path
- Each implementer is scoped to its domain; cross-domain work gets
  multiple dispatches
- Implementer agents carry domain expertise in their prompts — this
  knowledge travels across projects (not re-taught via CLAUDE.md)

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `core/agents/archetypes/implementer.md` | Full archetype definition (replaces stub from PRD-01) |
| `core/agents/software-engineer.md` | Implementer for web-app, automation, library |
| `core/agents/data-engineer.md` | Implementer for data-engineering, analytics-engineering |
| `core/agents/data-analyst.md` | Implementer for analytics-workspace, data-app |
| `core/agents/ml-engineer.md` | Implementer for ml-engineering |
| `core/agents/ai-engineer.md` | Implementer for ai-engineering |

### Modified files

| File | Change |
|---|---|
| `core/agents/AGENT-CATALOG.md` | Full implementer archetype section. Add all 5 agents. Update every project type mapping table to include implementer column. |
| `core/workflows/development-workflow.md` | Major rewrite: "Starting a Story" dispatches to implementer after spec approval. Orchestrator no longer writes code. Add lightweight dispatch path. Cross-domain dispatch instructions. |
| `core/workflows/dispatch-protocol.md` | Add dispatch contracts for all 5 implementer agents. Define lightweight vs. full dispatch. Define implementer output contract. |
| `integrations/claude-code/CLAUDE.md` | Update session lifecycle, development workflow summary, and subagents table to reflect pure orchestrator role. |
| `integrations/copilot/copilot-instructions.md` | Same updates for Copilot parity. Add tool declarations for implementer archetype. |
| `VERSION` | 0.12.0 |
| `CHANGELOG.md` | Entry for 0.12.0 |
| `MIGRATIONS.md` | Consumer migration: copy new archetype + 5 agent files, update integration templates. Note this fundamentally changes orchestrator behavior. |

## Stubs from PRD-01

PRD-01 (0.10.0) created the following stubs that this PRD should flesh
out:

- `core/agents/archetypes/implementer.md` — stub archetype with base
  tool profile, dispatch contract, output contract, and behavioral
  rules. This PRD replaces it with the full archetype definition.
- `core/agents/methodology-reviewer.md` — stub reviewer for
  agentic-workflow. This PRD should create the full agent with
  detailed evaluation criteria, calibration examples, and context
  window hygiene guidance.
- `core/agents/structural-validator.md` — stub validator for
  agentic-workflow. This PRD should create the full agent with
  detailed verification procedures and output format.

## Open Items (To Resolve During Execution)

- How the implementer interacts with TDD workflow (PRD-07 depends on
  this — does the implementer run tests as it goes, or does it produce
  code and the validator runs tests?)
- Exact prompt structure for each implementer — what domain knowledge
  gets baked into each one vs. loaded from project docs
- How lightweight dispatch threshold is communicated (orchestrator
  judgment? explicit rules? scrum master flag?)
- How implementer agents handle the refactor step (after tests pass,
  does the implementer self-refactor, or does the architect review
  and then the implementer refactors?)

## Verification Criteria

- All 5 implementer agents follow the archetype template pattern
  (orientation, checklist, output, calibration, context window hygiene)
- AGENT-CATALOG mapping tables include implementers for every project
  type
- development-workflow.md has no steps where the orchestrator writes
  production code
- Dispatch contracts specify explicit input/output for each implementer
- Integration templates reflect pure orchestrator role
- Lightweight dispatch path is documented with clear threshold criteria
- No smell test violations
