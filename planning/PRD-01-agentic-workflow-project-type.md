# PRD-01: Agentic-Workflow Project Type

**Version target:** 0.10.0
**Dependencies:** None (bootstrap PRD)
**Execution method:** Current SYSTEM-UPDATE.md protocol

## Problem Statement

Fabrika's project type taxonomy (web-app, data-app, analytics-engineering,
data-engineering, ml-engineering, ai-engineering, automation, library,
analytics-workspace) does not cover systems where the "product" is the
agentic workflow methodology itself. Systems like canonical Fabrika and
MyVitaOraOS are maintained by agents operating within structured
methodologies, but neither fits any existing project type.

Both systems have independently evolved overlapping engineering controls
(decision files before implementation, status continuity, retrieval
policies, separation of operational content from system infrastructure).
This duplication signals a missing abstraction.

## Solution

Define a new project type — **agentic-workflow** — for systems where
agents operate within a structured methodology and the methodology itself
is the product. This type has two modes:

**Structural mode (required):** Modifying the system's infrastructure —
skills, prompts, schemas, workflows, agents, templates. Uses the full
7-step change protocol (plan, align, execute, verify, incorporate
feedback, present, ship). Feature branch + PR required.

**Operational mode (optional):** Running the system day-to-day —
executing tasks, logging, reviewing, maintaining state. Commits directly
to main. Not all agentic-workflow projects need this. Fabrika does not.
VitoraOS does.

This PRD also introduces the **implementer** and **architect** archetypes
as dependencies, since the agentic-workflow type needs to reference them
in its agent mapping. These archetypes are defined here in the context
of agentic-workflow only — their broader rollout across all project
types happens in PRD-03 and PRD-04.

## Key Decisions (Already Aligned)

- Two modes: structural (all projects) and operational (opt-in). The
  structural mode is the core — it's the part both Fabrika and VitoraOS
  share.
- Fabrika uses structural mode only. No operational cadences (daily,
  weekly, monthly reviews) are needed for Fabrika.
- The structural update protocol should be the heavier Fabrika-style
  7-step protocol, not a lighter decision-file-only approach.
- The implementer archetype (7 total archetypes: planner, reviewer,
  validator, coordinator, designer, implementer, architect) is created
  here as a stub that PRD-03 will flesh out for all project types.
- The architect archetype is created here as a stub that PRD-04 will
  flesh out.

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `core/agents/archetypes/implementer.md` | Stub archetype definition — tool profile, dispatch contract, behavioral rules for agents that write production code/docs. Full detail in PRD-03. |
| `core/agents/archetypes/architect.md` | Stub archetype definition — evaluates and improves structural design. Full detail in PRD-04. |

### Modified files

| File | Change |
|---|---|
| `core/agents/AGENT-CATALOG.md` | Add agentic-workflow to project type tables. Add implementer and architect archetype sections (stub). Define agent mapping for agentic-workflow: planner, reviewer, validator, implementer, architect (structural); add coordinator for operational mode. |
| `core/Document-Catalog.md` | Add agentic-workflow document types. Structural: decision records, system update plans, change verification reports, version/changelog. Operational (if enabled): status file, ritual templates, operational logs. |
| `core/workflows/` | New or modified workflow file(s) for the agentic-workflow structural update lifecycle — the 7-step protocol adapted as a Fabrika workflow with agent dispatch points. |
| `MANIFEST_SPEC.md` | Add `agentic-workflow` to the valid project types enum. |
| `BOOTSTRAP.md` | Add agentic-workflow bootstrap instructions. |
| `VERSION` | 0.10.0 |
| `CHANGELOG.md` | Entry for 0.10.0 |
| `MIGRATIONS.md` | Consumer migration note (new type available, no action required for existing projects) |

## Open Items (To Resolve During Execution)

- Exact agent roster for agentic-workflow — which existing agents
  map and which need agentic-workflow-specific variants (e.g., does
  the planner need a "system design" mode distinct from product-manager
  planning mode?)
- Whether operational mode needs its own workflow file or can be a
  section within the structural workflow
- How the structural update protocol workflow maps to the existing
  SYSTEM-UPDATE.md steps with agent dispatch (Step 1 = planner,
  Step 3 = implementer, Step 4 = reviewer/validator, etc.)
- Integration template considerations — does agentic-workflow need
  its own CLAUDE.md template variant or can it use the existing
  template with type-specific sections?
- How the coordinator role works in operational mode (ritual-based
  cadence management vs. sprint-based coordination)

## Verification Criteria

- AGENT-CATALOG lists agentic-workflow with correct agent mapping
- Document-Catalog has agentic-workflow entries for both modes
- MANIFEST_SPEC accepts `agentic-workflow` as a valid type
- Implementer and architect archetype stubs exist and are referenced
- Workflow file(s) describe the full structural update lifecycle
- No smell test violations (no personal names, no product-specific
  assumptions, works for any agentic-workflow system)
