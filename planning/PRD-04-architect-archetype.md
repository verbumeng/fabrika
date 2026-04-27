# PRD-04: Architect Archetype

**Version target:** 0.13.0
**Dependencies:** PRD-01 (archetype stub), PRD-03 (implementer exists —
architect proposes, implementer executes)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

AI-generated code tends toward shallow modules — lots of small pieces
with complex interfaces that are locally clean but globally hard to
navigate and maintain. There is no agent in Fabrika that evaluates or
improves structural design. The code-reviewer checks code quality but
not module depth or architectural patterns. Maintenance has a dedup scan
but nothing about module structure. There's no mechanism to catch
architectural drift before it compounds.

This draws from John Ousterhout's "A Philosophy of Software Design"
(deep modules vs. shallow modules) and the practical observation that
good codebases — ones that are easy to change, easy to test, and easy
for both humans and AI to navigate — have fewer, deeper modules with
simple interfaces hiding complexity.

## Solution

Create the **architect archetype** — the seventh archetype. Define 2
specialist agents: software-architect and data-architect. The architect
evaluates and improves structural design — it proposes, it doesn't
implement (that's the implementer's job).

### Architect Agents

| Agent | Project Types | Focus |
|---|---|---|
| software-architect | web-app, automation, library, ai-engineering | Module depth, interface design, dependency structure, API surface, component boundaries |
| data-architect | data-engineering, analytics-engineering, data-app, ml-engineering | Schema design, pipeline topology, storage layering, query patterns, data flow boundaries |

### Archetype Definition

**Tool profile:** Read, search, terminal (for running analysis). Write
access constrained to: architecture assessment reports, refactor
proposals, interface design documents. No production code edits — the
architect proposes, the implementer executes.

**Dispatch contract:** Contextual for design mode (rich project context
including architecture docs, Domain Language, codebase structure).
Strict for review mode (PRD + proposed modules only, no leading).

**Behavioral rules:**
- Think in terms of depth, interfaces, seams, and locality (Ousterhout
  vocabulary)
- Apply the deletion test: if removing a module would concentrate
  complexity, it's earning its keep; if complexity just moves, it's
  a pass-through
- Proposals go to the owner, never directly to the backlog
- Include a "done threshold" — when is a module deep enough that it
  shouldn't be re-evaluated until significant new functionality lands?
- Use Domain Language terms for domain concepts, architecture vocabulary
  for structural concepts

### Invocation Points

1. **After PRD creation** — Reviews the PRD's module section. Are
   proposed modules deep enough? Are interfaces well-designed? Catches
   architectural problems before code is written.
2. **During maintenance** — Scans for shallow modules, identifies
   deepening opportunities, proposes refactor stories to the owner.
   Only triggers under specific conditions (not every maintenance cycle).
3. **Ad hoc** — Owner points architect at an existing codebase for
   architectural assessment and refactoring recommendations. This
   enables bringing architectural discipline to codebases written
   without it.
4. **During evaluation** — Optional supplement to code-reviewer,
   checking whether new code maintains or degrades module depth.

### Spiral Mitigation

The risk: architect generates refactor stories every maintenance cycle,
creating infinite optimization loops. Mitigations:

1. **Owner-gated proposals.** Architect proposals go to the owner, not
   straight to the backlog. Owner decides what's worth doing.
2. **Done thresholds.** Each proposal includes: "After this refactor,
   the module meets depth criteria and should not be re-evaluated until
   significant new functionality is added."
3. **Conditional maintenance trigger.** Architecture review during
   maintenance only triggers: after a major feature lands, when the
   owner requests it, or when the code-reviewer flags structural
   concerns. Not every cycle.
4. **Assessment tracking.** Lightweight log of modules assessed + dates,
   so stable modules aren't re-examined.

## Key Decisions (Already Aligned)

- 2 agents (software-architect, data-architect) — no separate ML
  architect. ML architectural concerns are data pipeline problems
  covered by data-architect.
- Architect is its own archetype, not a mode of an existing agent
- Output is proposals and assessments, never implementations
- Owner approval required for all refactor work
- Ad hoc invocation is a first-class use case (point at existing
  codebase, get assessment)
- "Design the interface, delegate the implementation" (Pocock/Ousterhout)
  is the core principle

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `core/agents/archetypes/architect.md` | Full archetype definition (replaces stub from PRD-01) |
| `core/agents/software-architect.md` | Architect for software-oriented project types |
| `core/agents/data-architect.md` | Architect for data-oriented project types |

### Modified files

| File | Change |
|---|---|
| `core/agents/AGENT-CATALOG.md` | Full architect archetype section. Add both agents. Update project type mapping tables with architect column. |
| `core/workflows/development-workflow.md` | Add architect invocation point after PRD approval (optional). Add architect as optional evaluation supplement. |
| `core/workflows/dispatch-protocol.md` | Add dispatch contracts for both architect agents (contextual for design, strict for review). |
| `core/rubrics/code-review-rubric.md` | Add "Module Depth / Interface Simplicity" criterion. |
| `core/maintenance-checklist.md` | Add architecture review step with conditional trigger. Add assessment tracking. |
| `integrations/claude-code/CLAUDE.md` | Update subagents table, add architect invocation points. |
| `integrations/copilot/copilot-instructions.md` | Same updates for Copilot parity. |
| `VERSION` | 0.13.0 |
| `CHANGELOG.md` | Entry for 0.13.0 |
| `MIGRATIONS.md` | Consumer migration: copy archetype + 2 agent files, update rubric, maintenance checklist, integration templates. |

## Stubs from PRD-01

PRD-01 (0.10.0) created `core/agents/archetypes/architect.md` as a
stub archetype focused on agentic-workflow instruction architecture
(decomposition, pointer patterns, context budgets). This PRD replaces
it with the full archetype definition covering both code architecture
(software-architect) and data architecture (data-architect), while
preserving the agentic-workflow instruction architecture capabilities
as a shared concern across both specialists.

## Open Items (To Resolve During Execution)

- Exact Ousterhout/Pocock vocabulary to standardize in architect
  prompts (module, interface, implementation, depth, seam, adapter,
  leverage, locality — from Pocock's LANGUAGE.md)
- How architecture assessment interacts with Domain Language (PRD-06) —
  do module names become Domain Language terms?
- Whether the architect needs access to test coverage data to assess
  testability
- How ad hoc invocation works mechanically — is it a workflow step,
  a direct dispatch, or something the orchestrator offers when it
  detects the user wants refactoring?

## Verification Criteria

- Both architect agents follow the archetype pattern
- AGENT-CATALOG maps architects to correct project types
- Dispatch contracts define contextual and strict modes
- Code-review rubric has module depth criterion
- Maintenance checklist has architecture review with conditional trigger
  and spiral mitigation
- Architect output is proposals, never code changes
- Ad hoc invocation path is documented
- Integration templates reflect new capability
- No smell test violations
