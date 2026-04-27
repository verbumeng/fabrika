# PRD-06: Domain Language

**Version target:** 0.15.0
**Dependencies:** PRD-05 (Design Alignment produces terminology, PRD
template references Domain Language)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

The current Glossary.md is Tier 4 (nice-to-have), has no workflow to
create or maintain it, no agent references it, and there's no
expectation that code uses its terms. Meanwhile, every briefing
reinvents jargon definitions from scratch, planners and implementers
choose their own terminology independently, and there's no mechanism
to catch when code terminology drifts from how the user and team talk
about the product.

Domain-Driven Design's "ubiquitous language" concept addresses exactly
this: a shared vocabulary used consistently in conversations, code,
documentation, and planning. Pocock's practical application of this
showed that AI agents think less verbosely and implement more accurately
when they share a constrained, well-defined vocabulary with the user.

## Solution

Elevate the Glossary concept to a first-class, living **Domain Language**
document. Make it Tier 1. Wire it into the workflows where terminology
is created (Design Alignment), consumed (planning, implementation,
briefings), and maintained (maintenance).

### What the Domain Language Document Contains

- **Term definitions:** Each domain concept with a plain-language
  definition, the code-level name (if different), and relationships
  to other terms
- **Anti-terms:** Things this term is NOT (prevents confusion with
  similar concepts)
- **Organized by domain area** (not alphabetical — grouped by the part
  of the system they relate to)

### Where It Gets Created and Updated

| Workflow Step | What Happens |
|---|---|
| Design Alignment (PRD-05) | New terms emerge during grilling. Orchestrator adds them to Domain Language as they crystallize. |
| PRD creation | PRD references Domain Language terms. New terms from PRD get added. |
| Implementation | Implementer uses Domain Language terms for naming. If a new concept emerges during implementation, flag it for addition. |
| Maintenance | Terminology drift check — are there terms in the code that diverge from the Domain Language? Are there Domain Language terms no longer used? |
| Briefings | Jargon glossary in briefings draws from Domain Language rather than being invented ad hoc. |

### Who Consumes It

| Agent | How |
|---|---|
| Planner (all variants) | Reads Domain Language before writing specs. Uses its terms. |
| Implementer (all variants) | Receives Domain Language in dispatch. Names things using its terms. |
| Reviewer (code-reviewer) | Checks terminology consistency as a rubric criterion. |
| Architect | Uses Domain Language for domain concepts, architecture vocabulary for structural concepts (distinct vocabularies). |
| Orchestrator | References Domain Language when writing briefings. Updates it during alignment. |

## Key Decisions (Already Aligned)

- Tier 1, not Tier 4 — this is a must-have, not a nice-to-have
- Living document, not a static reference — updated during alignment,
  implementation, and maintenance
- Feeds into briefings (replaces ad hoc jargon glossary creation)
- Feeds into implementer dispatch (terms used in code naming)
- Feeds into code-review rubric (terminology consistency criterion)
- Maintenance includes a terminology drift check
- Organized by domain area, not alphabetically

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `core/templates/Domain-Language-Template.md` | Template for the Domain Language document with structure and examples |

### Modified files

| File | Change |
|---|---|
| `core/Document-Catalog.md` | Replace Glossary.md (Tier 4) with Domain Language (Tier 1, all project types). Update description to emphasize living ubiquitous language, not static reference. |
| `core/workflows/design-alignment.md` | Add terminology capture step — during alignment, new terms get added to Domain Language. |
| `core/workflows/dispatch-protocol.md` | Add Domain Language to planner and implementer dispatch contracts (conditional — if exists). |
| `core/rubrics/code-review-rubric.md` | Add "Terminology Consistency" criterion — do code names match Domain Language? |
| `core/maintenance-checklist.md` | Add "Terminology Drift Check" step — scan code for terms that diverge from or are missing from Domain Language. |
| `core/briefings/briefing-principles.md` | Add instruction: jargon glossary in briefings should draw from Domain Language document when it exists, rather than inventing definitions ad hoc. |
| `integrations/claude-code/CLAUDE.md` | Add Domain Language to project docs section. Reference in session lifecycle where relevant. |
| `integrations/copilot/copilot-instructions.md` | Same updates for Copilot parity. |
| `VERSION` | 0.15.0 |
| `CHANGELOG.md` | Entry for 0.15.0 |
| `MIGRATIONS.md` | Consumer migration: rename/upgrade Glossary to Domain Language (if exists), copy template, update rubric and maintenance checklist. |

## Open Items (To Resolve During Execution)

- Whether Domain Language should include code-level naming conventions
  (e.g., "Order → class Order, table orders, variable current_order")
  or just conceptual definitions
- How Domain Language interacts with the wiki knowledge layer (PRD-09)
  — is the wiki glossary phase essentially the Domain Language
  maintenance process?
- Whether analytics-workspace needs its own Domain Language or if the
  source registry serves that purpose
- How to handle multi-type projects where different domains have
  different vocabularies (e.g., web-app + ai-engineering where
  "model" means different things)

## Verification Criteria

- Domain Language template exists with clear structure
- Document-Catalog lists Domain Language as Tier 1 for all types
- Design Alignment workflow includes terminology capture
- Dispatch contracts include Domain Language for planners and
  implementers
- Code-review rubric has terminology consistency criterion
- Maintenance checklist has terminology drift check
- Briefing principles reference Domain Language
- Integration templates reflect new capability
- No smell test violations
