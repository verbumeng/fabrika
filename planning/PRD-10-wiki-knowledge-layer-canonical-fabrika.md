# PRD-10: Wiki Knowledge Layer — Canonical Fabrika

**Version target:** 0.19.0
**Dependencies:** PRD-02 (Fabrika is an agentic-workflow project),
PRD-06 (Domain Language exists), PRD-09 (wiki pipeline defined for
consumer projects)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

Canonical Fabrika generates its own knowledge: design decisions across
versions, harvest findings from consumer projects, cross-consumer
patterns, framework evolution rationale, alignment sessions like this
one. This knowledge currently lives in CHANGELOG entries, git history,
and conversation context that evaporates. There's no persistent,
topic-organized knowledge base that helps future sessions understand
WHY Fabrika is the way it is.

This is distinct from consumer project wikis (PRD-09) because Fabrika's
knowledge concerns are framework-level: what patterns work across
projects, what design decisions shaped the current architecture, what
harvest findings influenced changes, and what the owner's evolving
philosophy is about agentic workflows.

## Solution

Apply the wiki knowledge layer to canonical Fabrika itself, adapted for
Fabrika's specific concerns. This is lighter than the consumer version
— Fabrika doesn't have the same volume of recurring artifacts — but
addresses the unique challenge of maintaining framework-level
institutional knowledge.

### What Fabrika's Wiki Covers

| Knowledge Domain | Source Artifacts | Why It Matters |
|---|---|---|
| Framework design philosophy | Alignment sessions (like this one), CHANGELOG rationale, ADRs | Future sessions need to understand WHY Fabrika works the way it does, not just WHAT it does |
| Cross-consumer patterns | Harvest findings (HARVEST.md outputs), consumer feedback | Patterns that work across multiple projects should inform framework evolution |
| Agent design decisions | Agent prompt iterations, eval findings, archetype evolution | Why each agent is structured the way it is, what was tried and didn't work |
| Workflow evolution | Version history, migration patterns, workflow changes | How workflows changed over time and why — prevents re-litigating settled decisions |
| Owner philosophy | Alignment session outputs, feedback, confirmed approaches | The owner's evolving understanding of how agentic workflows should work |

### Fabrika-Specific Adaptations

**Cadence:** Fabrika doesn't have sprints or regular maintenance. The
wiki gets updated:
- After each system update (as part of the ship step) — index the
  changes and their rationale
- During alignment sessions like this one — capture design philosophy
  and cross-cutting decisions
- When harvest findings come in from consumer projects
- On demand when the owner requests synthesis

**Interaction with existing artifacts:**
- CHANGELOG provides the "what changed" — wiki provides the "why and
  how it connects"
- MIGRATIONS.md provides consumer instructions — wiki provides the
  design rationale behind those instructions
- ADRs (if Fabrika adds them) provide individual decisions — wiki
  synthesizes patterns across decisions

**Wiki structure for Fabrika:**
```
wiki/
  index.md
  topics/
    framework-philosophy.md    — core design principles and their evolution
    agent-model.md             — how the agent architecture works and why
    workflow-design.md          — workflow patterns and their rationale
    harvest-patterns.md        — patterns observed across consumer projects
    owner-preferences.md       — confirmed approaches and communication style
    [topic].md                 — additional topics as they emerge
```

**Domain Language for Fabrika:** Fabrika needs its own Domain Language
document — the terms used in the framework (archetype, dispatch,
contract, strict vs. contextual, topology, etc.) should be formally
defined. This serves both framework maintainers and consumer projects
trying to understand Fabrika's vocabulary.

### Relationship to Consumer Wiki (PRD-09)

Fabrika's wiki and consumer wikis are separate systems:
- Consumer wikis are about the consumer project's domain knowledge
- Fabrika's wiki is about the framework's design knowledge
- Harvest findings flow from consumer wikis → Fabrika wiki (patterns
  observed) but not the reverse
- Fabrika's Domain Language informs consumer integration templates
  (the vocabulary used in CLAUDE.md and copilot-instructions.md)

## Key Decisions (Already Aligned)

- Canonical Fabrika gets its own wiki, separate from consumer wikis
- Lighter than consumer version (no sprint cadence, fewer recurring
  artifacts)
- Updated after system updates, alignment sessions, and harvest
- Fabrika needs its own Domain Language document
- Wiki captures "why" to complement CHANGELOG's "what"
- Owner philosophy and confirmed approaches are legitimate wiki topics

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `wiki/index.md` | Fabrika's wiki navigational entry point |
| `wiki/topics/` | Directory for synthesized topic articles |
| `Domain-Language.md` | Fabrika's own ubiquitous language document (framework terms) |

### Modified files

| File | Change |
|---|---|
| `SYSTEM-UPDATE.md` | Add wiki update step to the ship phase — after committing, index the changes and their rationale in the wiki |
| `CLAUDE.md` (project-level) | Add wiki reference and Domain Language pointer |
| `VERSION` | 0.19.0 |
| `CHANGELOG.md` | Entry for 0.19.0 |

### What does NOT change for consumers

This is internal to canonical Fabrika. Consumer projects are not
affected. No MIGRATIONS.md entry needed.

## Open Items (To Resolve During Execution)

- Whether Fabrika's wiki should be committed to git (it's framework
  knowledge, arguably canonical) or gitignored (it's operational state)
- Whether existing CHANGELOG entries should be retroactively synthesized
  into wiki topics (bootstrapping the wiki with historical context)
- How alignment session outputs (like this conversation) get captured —
  do they feed the wiki directly, or does the system update process
  capture the relevant bits?
- Whether Fabrika's Domain Language should live at the repo root or
  in `core/` (it's both a canonical reference for consumers AND a
  working document for Fabrika development)
- How the wiki interacts with the planning/ directory (current PRDs)
  — are PRDs sources that get indexed into the wiki after execution?

## Verification Criteria

- Wiki directory exists with index and initial topic articles
- Domain Language document exists with Fabrika's framework terms
- SYSTEM-UPDATE.md includes wiki update step
- CLAUDE.md references wiki and Domain Language
- Wiki topics cover the five knowledge domains listed above
- Content is framework-level, not personal/project-specific (smell
  test: would this be useful to a stranger contributing to Fabrika?)
- No smell test violations
