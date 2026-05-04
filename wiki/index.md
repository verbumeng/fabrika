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
agent maturity progression, the implementer-reviewer pairing
philosophy (v0.20.0), base agents as the unparameterized foundation
(v0.26.0), and the skills abstraction (v0.32.0) where agents carry
skills — the atomic unit of capability exercised per invocation. The
three project type categories (sprint-based, task-based,
methodology-based) were dissolved in v0.32.0; all types are now
workflow types in a unified model. The model grew from 4 agents to
32 across 32 versions.

### [Workflow Design](topics/workflow-design.md)

Ten workflow types — the base task workflow (v0.26.0), seven domain
workflows (v0.32.0: software-development, data-engineering,
analytics-engineering, data-app, ml-engineering, ai-engineering,
library), analytics workflow, and agentic-workflow — and the patterns
that govern them: lifecycle definitions, dispatch protocol, design
alignment, graduated testing, the briefing system, and the knowledge
pipeline. As of v0.31.0, work is categorized into four universal
backlog types (task, bug, story, epic) that determine which workflow
handles it. Ceremony graduates within each type, not across types:
tasks have simple and standard modes, stories have patch/story/deep
story tiers, bugs use the task workflow with reproduction context,
and epics are coordination envelopes. The orchestrator asks "What
kind of work?" before "How much ceremony?" In v0.32.0,
development-workflow.md was decomposed and deleted — its story
execution mechanics extracted into the story-execution.md protocol,
with domain-specific concerns distributed across seven new domain
workflow files. Sprint coordination was reframed as a
complexity-triggered procedure, and procedures were classified into
three categories (cross-cutting, workflow-bundled,
complexity-triggered). Workflows are organized into types and
protocols, all types are now "workflow types" (the "project types"
transition completed in v0.32.0), context compaction governs phase
transitions, freshness-aware context loading prevents stale Tier
1 docs from polluting agent work, and the decomposition hierarchy
(Charter → Roadmap → PRD → Epic → Story | Task | Bug) was formalized
as the alignment hierarchy in v0.33.0 — "brief" merged into "task"
and the "enhanced brief" concept was killed.

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

This wiki was initialized in v0.19.0 with five topic articles
synthesized from CHANGELOG entries v0.10.0-v0.18.0 and planning PRDs.
In v0.20.0, three articles (Workflow Design, Agent Model, Framework
Philosophy) were substantially updated with design rationale from the
PRD-11 alignment session. In v0.26.0, Workflow Design and Agent Model
were updated with the base workflow type, base agent model, workflow
composition paradigm, and cross-cutting concern insights from the
CR-17 execution session. In v0.27.0, Workflow Design and Framework
Philosophy were updated with the types/protocols directory split
rationale, the deferred development-workflow rename decision, and the
CLAUDE.md path validation design lesson from CR-28. In v0.29.0,
Workflow Design was updated with the universal complexity tiers
design rationale, the research-vs-Design-Alignment distinction, and
the ceremony spectrum concept from CR-18. In v0.30.0, Workflow
Design was updated with the backlog type model (task, bug, story,
epic), simple task mode, and work type routing from CR-19. In
v0.31.0, Workflow Design was updated with freshness-aware context
loading from CR-21. In v0.32.0, Agent Model was updated with the
skills model formalization and category dissolution, and Workflow
Design was updated with development-workflow decomposition, domain
workflows, story-execution protocol, sprint coordination reframing,
and procedure classification from CR-22. In v0.33.0, Workflow Design
was updated with the unified document hierarchy: decomposition
hierarchy formalized as alignment hierarchy, brief merged into task,
enhanced brief killed, brief check retired to plan check, and
Roadmap-Template added from CR-29.

### Sources Summary

Articles draw from:
- CHANGELOG entries for versions 0.1.0 through 0.33.0
- Planning PRDs 01-15 and CRs 17-29 (in `planning/`)
- Core workflow files, agent prompts, and integration templates
- Alignment session outputs from the v0.10.0-v0.25.0 roadmap
  execution and the Phase 2 design philosophy session
