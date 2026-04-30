# Fabrika Wiki

Fabrika is a methodology framework for agentic project workflows.
This wiki captures the design knowledge behind the framework: why
it works the way it does, what decisions shaped it, what patterns
have emerged, and what questions remain open.

The CHANGELOG tells you *what* changed in each version. This wiki
tells you *why* — the rationale, the trade-offs, the alternatives
considered, and the principles that connect individual changes into
a coherent system.

---

## Knowledge Domains

### [Framework Philosophy](topics/framework-philosophy.md)

Core design principles: canonical vs. consumer separation, smell
tests, context decomposition, progressive disclosure, stack-agnostic
agents, and the bootstrap/adopt/update model. These principles
emerged incrementally from v0.1.0 through v0.18.0, each driven by
concrete problems observed in practice.

### [Agent Model](topics/agent-model.md)

How agents are organized, dispatched, and constrained. Covers the
archetype system (Planner, Reviewer, Implementer, Coordinator,
Architect, Designer, Validator), dispatch tiers (strict vs.
contextual), the pure orchestrator principle, specialist implementers,
and agent maturity progression. The model grew from 4 agents to 23
across 18 versions.

### [Workflow Design](topics/workflow-design.md)

The three workflow families (sprint-based, analytics-workspace,
agentic-workflow) and the patterns that govern them: lifecycle
definitions, dispatch protocol, design alignment, graduated testing,
the briefing system, and the knowledge pipeline. Each workflow
addition addressed a specific process gap.

### [Harvest Patterns](topics/harvest-patterns.md)

Cross-consumer patterns flowing from consumer projects back into the
canonical framework. Currently sparse — the harvest mechanism is
documented but no data has been collected yet. This topic will grow
as consumer projects begin using Fabrika and feeding back findings.

### [Owner Preferences](topics/owner-preferences.md)

Framework-level communication design decisions: briefing style,
alignment patterns, audience calibration, version discipline as
communication contract. These are codified methodology choices about
how agents communicate with project owners, not personal preferences
of a specific individual.

---

## How This Wiki Works

**Cadence:** The wiki is updated after each system update (as part of
the Ship step in the structural update lifecycle), during alignment
sessions when design rationale emerges, and when harvest findings
arrive from consumer projects. There is no fixed schedule — updates
are driven by framework evolution.

**Relationship to other artifacts:**
- CHANGELOG provides "what changed" — wiki provides "why and how it
  connects"
- MIGRATIONS.md provides consumer instructions — wiki provides the
  design rationale behind those instructions
- Domain Language (`Domain-Language.md`) defines the framework
  vocabulary used in wiki articles

**Writing standards:** Articles follow the topic template's section
structure (Summary, Key Decisions, Current State, Open Questions,
Related Topics, Sources) but omit the YAML frontmatter (salience
scores, source arrays, status fields) because Fabrika's articles
are hand-curated during system updates rather than synthesized from
batch indexes. Content must pass the smell test: would this be
useful to a stranger contributing to Fabrika? No personal, product-
specific, or tool-specific assumptions.

---

## Current State

As of v0.19.0, this wiki was initialized with five topic articles
synthesized from CHANGELOG entries v0.10.0–v0.18.0 and planning
PRDs. Articles will deepen over subsequent system updates as new
design rationale is captured.

### Sources Summary

Initial articles draw from:
- CHANGELOG entries for versions 0.1.0 through 0.18.0
- Planning PRDs 01–10 (in `planning/`)
- Core workflow files, agent prompts, and integration templates
- Alignment session outputs from the v0.10.0–v0.19.0 roadmap
  execution
