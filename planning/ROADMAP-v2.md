# Fabrika Phase 2 Roadmap: Workflow Composition

**Produced:** 2026-05-02, design philosophy session
**Covers:** CRs 17-23 (v0.26.0+)
**Previous phase:** [ROADMAP-v1.md](ROADMAP-v1.md) (PRDs 01-16,
v0.10.0-0.25.0)

## The Design Shift

Phase 1 (PRDs 01-16) built Fabrika's foundation: the agent model,
workflow lifecycles, project types, design alignment, the wiki
knowledge layer, and cross-cutting principles like implementer-reviewer
pairing. It produced a framework that works well when a project fits
cleanly into one project type with one workflow.

Phase 2 evolves the framework's fundamental abstraction. The insight:
what Fabrika calls "project types" are really **workflow types** —
reusable multi-agent patterns that can be composed by any project.

### Old Model (Taxonomic)

Pick a project type at bootstrap. Get a fixed workflow and agent
roster. Work within that lane. One project, one workflow family.

This works for simple cases but breaks when real projects need
multiple kinds of work: a data engineering project that needs sprint
planning for pipeline builds AND ad-hoc fixes for quick SQL changes
AND a lightweight task flow for routine single-layer transforms. The
taxonomic model forces a choice that real work does not present.

### New Model (Compositional)

A project declares which **workflow types** it needs. Each workflow
type is a reusable multi-agent pattern built from composable skills.
A project might compose:

- The **base workflow** for routine bounded tasks
- The **sprint workflow** (with complexity tiers) for planned
  multi-story work
- The **ad-hoc workflow** for quick fixes outside sprint ceremony
- **Domain-specific parameterization** (cost guardrails, environment
  gates, specialized review criteria) applied as context to any of
  the above

The analytics workflow already built in Phase 1 is a mature example
of a specialized workflow type. The task workflow (CR-17) is the
generic base that everything else specializes from. Each specialized
workflow adds domain knowledge on top of the same engineering
patterns: dispatch contracts, implementer-reviewer pairing,
validation, compaction at phase boundaries.

### The Abstraction Stack

```
Skills (CR-22)        — single agent capabilities, parameterized
                        by workflow context
Workflows (CR-17-19)  — multi-agent patterns composing skills
Principles (CR-20-21) — govern how workflows operate internally
Projects              — compose multiple workflow types as needed
```

## Phase 1 Status

Phase 1 is substantially complete. All 10 core PRDs (01-10) shipped
(v0.10.0-0.19.0). Follow-up PRDs 12-15 shipped (v0.21.0-0.24.0).
PRD-16 shipped as v0.25.0 (context-engineer renamed to
agentic-engineer).

**Outstanding from Phase 1:**

| Item | Status | Phase 2 Relationship |
|---|---|---|
| PRD-11: Analytics Pre-Execution Review | Needs Design Alignment | Independent — analytics-specific gate. Can execute in Phase 2 as a standalone or integrate with CR-23's cost guardrails. |

## CRs as a Coherent Unit

CRs 17-23 are not independent features. They form a coherent whole
where each CR addresses one facet of the workflow composition model:

| CR | Role in the Model | Summary |
|---|---|---|
| [CR-17](CR-17-task-workspace-project-type.md) | **Base workflow** | The most generic multi-agent pattern: brief, plan, implement, review, validate, deliver. Zero domain assumptions. Agents are BASE agents, not domain-specific. All specialized workflows are parameterized versions of this. |
| [CR-18](CR-18-complexity-tiers-sprint-work.md) | **Ceremony dial** | Three complexity tiers (Patch, Story, Deep Story) matching ceremony to risk. Applies within sprint-based workflows but the principle — graduated ceremony — is universal. |
| [CR-19](CR-19-adhoc-workflow.md) | **Lightest workflow** | Ad-hoc work outside sprints: brief, implement, review, commit. Proves workflows exist on a spectrum of ceremony from zero (just do it) to full (Deep Story with research and architect review). |
| [CR-20](CR-20-context-compaction-principle.md) | **Internal principle** | Context compaction as a named design principle. Each phase transition produces a compressed artifact self-contained for the next phase. Governs how ALL workflows hand off between phases. |
| [CR-21](CR-21-freshness-aware-context.md) | **Context quality** | Freshness-aware context loading. Prevents stale Tier 1 docs from polluting workflow phases with outdated information. |
| [CR-22](CR-22-agents-as-composable-skills.md) | **The mechanism** | Agents as composable skills — capability separated from invocation context. The structural change that makes workflow composition work. A skill is what the agent knows how to do; a workflow invocation supplies what context it does it in. |
| [CR-23](CR-23-data-engineering-workflow-realism.md) | **Validation case** | Enterprise data engineering as proof that the taxonomic model breaks and the compositional model resolves it. Environment progression, external gates, layer ownership — all handled by composing existing workflows with DE-specific parameterization. |

## Execution Order

CRs execute in dependency order. Each CR runs in a fresh chat using
[EXECUTION-PROMPT-v2.md](EXECUTION-PROMPT-v2.md). Design alignment
happens within the execution chat for CRs that need it — all CRs in
this phase have "Design Decisions to Align" sections, and some have
"Alignment Notes" from this design session that capture decisions
already made.

| Order | CR | Provisional Version | Key Dependency | Notes |
|---|---|---|---|---|
| 1 | CR-17: Base Workflow | 0.26.0 | — | Creates the foundational workflow pattern and base agents (planner.md, implementer.md, reviewer.md, validator.md). Informed by CR-22's insight but does not require CR-22 to ship first. |
| 1.5 | CR-28: Workflow Folder Cleanup | 0.26.1 | CR-17 | Reorganizes core/workflows/ into types/ and protocols/ subdirectories. Renames agentic-workflow-lifecycle → agentic-workflow, sprint-lifecycle → sprint-coordination. Execute immediately after CR-17 so subsequent CRs use clean paths. |
| 2 | CR-20: Context Compaction | 0.27.0 | — | Foundational design principle for all workflows. Extends core/design-principles.md. Best codified early so subsequent CRs reference it. |
| 3 | CR-18: Universal Complexity Tiers | 0.28.0 | CR-17 | Universal ceremony spectrum: ad-hoc → task → patch → story → deep story → epic. No longer sprint-only — the complexity assessment determines both alignment ceremony and execution ceremony for ALL work. |
| 4 | CR-19: Ad-Hoc Workflow | 0.29.0 | CR-18 | Lightest point on the ceremony spectrum. Distinguished from CR-18's Patch tier: Patch is light ceremony for scoped changes, ad-hoc is for one-off immediate work. |
| 5 | CR-21: Freshness | 0.30.0 | CR-20 | Context quality principle. Benefits from compaction being codified first. |
| 6 | CR-22: Composable Skills | 0.31.0 | CR-17, 18 | Formal restructuring of the agent model AND dissolution of the three project type categories. Base agents from CR-17 become the formal skill foundation. May execute as design alignment + partial restructuring, with full restructuring deferred if scope warrants. |
| 7 | CR-23: DE Realism | 0.32.0 | CR-17, 18, 19, 22 | Validation case. All workflow foundations in place. Expected to resolve as Option D (compose existing workflows) + DE-specific parameterization layer. |

Version targets are provisional — each CR determines its actual
version during execution. Minor bumps expected for all (new workflow
files, agent definitions, or design principles in core/).

## Execution Protocol

Same as Phase 1: each CR executes in a fresh chat following the
agentic-workflow structural update protocol (plan, align, execute,
verify, incorporate, present, ship). The execution prompt
(EXECUTION-PROMPT-v2.md) provides the starting context.

Key differences from Phase 1:

- **CRs, not PRDs.** CRs have "Design Decisions to Align" sections
  that are resolved during execution. Some also have "Alignment
  Notes" from this design session — those decisions are already
  resolved.
- **Through-line awareness.** Each CR's execution should maintain
  awareness of the broader workflow composition model. The executing
  chat reads this roadmap and understands how the specific CR fits
  the whole.
- **Composition mindset.** When making design choices during
  execution, prefer choices that support workflow composition over
  choices that optimize for standalone use. The base workflow (CR-17)
  should be designed so specialized workflows can parameterize it,
  not so it handles every case itself.

## Between CRs

After each CR completes (merged to main), verify version bump and
CHANGELOG. Each subsequent chat sees prior CR changes in the codebase.

If a CR execution reveals something that changes a downstream CR,
update the downstream CR file in the planning/ directory before
starting that chat. This happened frequently in Phase 1 and should
be expected in Phase 2.

## Post-Phase 2: Identified Future Work

These items are captured but explicitly deferred until Phase 2 ships
and real-world usage generates concrete patterns:

| Item | Description |
|---|---|
| [CR-24: Workflow Chaining](CR-24-workflow-chaining-orchestration.md) | Cross-workflow orchestration — how epics span multiple workflow types, how backlogs work with mixed workflows, how the orchestrator routes to the right workflow type at task level. Closely related to CR-18's universal complexity spectrum — may partially merge. Requires all Phase 2 workflow types to be in place first. |
| [CR-25: Obsidian Wiki Link Graph](CR-25-obsidian-wiki-link-graph.md) | Make the implicit knowledge graph explicit through Obsidian-compatible wiki links across all Fabrika documents (canonical and consumer-generated). Reduces agent navigation cost by making document relationships traversable. |
| [CR-26: Formal Knowledge Graph](CR-26-formal-knowledge-graph.md) | Open-source knowledge graph system for agent navigation — structured, queryable index of all project documents so agents find information at low token cost instead of exploratory file reads. Builds on CR-25's document-level link graph. |
| [CR-27: Sandcastle Analysis](CR-27-sandcastle-framework-analysis.md) | Distill Matt Pocock's Sandcastle framework (TypeScript sandbox coding agents) and harvest applicable patterns into Fabrika. May produce zero or multiple follow-on CRs depending on findings. |
| [CR-29: Unified Document Hierarchy](CR-29-unified-document-hierarchy.md) | Brief as base alignment artifact. Brief, story, PRD, project charter, and roadmap are points on the same spectrum of orchestrator-to-owner alignment, not separate document types per project category. Complexity level determines which artifact, same as the execution ceremony spectrum (CR-18). |
| PRD-11: Analytics Pre-Execution Review | Phase 1 carryover. Can execute standalone or integrate with CR-23's cost guardrails. |

## Themes

- **Workflow patterns** (CRs 17, 28, 18, 19): The base workflow,
  folder organization, universal ceremony graduation, and the
  lightest workflow — establishing the spectrum from zero-ceremony to
  full-ceremony multi-agent work
- **Design principles** (CRs 20, 21): Compaction and freshness as
  named cross-cutting principles that govern workflow internals
- **Agent model evolution** (CR-22): Skills as the unit of agent
  capability, separated from workflow invocation context — the
  structural mechanism for composition. Also dissolves the three
  project type categories (sprint-based, task-based, methodology-
  based) into a unified model
- **Real-world validation** (CR-23): Enterprise data engineering as
  the test case proving the compositional model works where the
  taxonomic model fails

## Design Evolution Notes (CR-17 Execution, 2026-05-02/03)

The CR-17 execution session produced several insights that
strengthened the Phase 2 through-line:

1. **The three categories dissolve.** Sprint-based, task-based, and
   methodology-based are artifacts of the taxonomic model. With
   workflow composition, they don't constrain. Any project composes
   whatever workflow types it needs. This affects CR-22's scope
   (structural removal of the categories from AGENT-CATALOG,
   Document-Catalog, BOOTSTRAP, integration templates).

2. **Universal complexity spectrum.** CR-18's complexity tiers are
   not sprint-only — they're the universal ceremony dial:
   ad-hoc → task → patch → story → deep story → epic (→ sprint).
   The orchestrator dynamically assesses complexity and routes to the
   right ceremony level.

3. **Base agents, not domain agents.** CR-17 creates `planner.md`,
   `implementer.md`, `reviewer.md`, `validator.md` — the
   unparameterized versions that all specialized agents extend.
   CR-22 formalizes this as skill-parameterization.

4. **Unified document hierarchy.** Brief, story, PRD, project
   charter, and roadmap are the same concept at different complexity
   levels — orchestrator-to-owner alignment artifacts. Captured in
   CR-29 (post-Phase 2).

5. **CR-28 added.** Workflow folder reorganization: `types/` vs
   `protocols/` subdirectories, naming cleanup. Executes immediately
   after CR-17 to provide clean paths for all subsequent CRs.

6. **CR template created.** `core/templates/Change-Request-Template.md`
   formalizes the organic CR pattern from Phase 2.

7. **Cross-cutting concerns must not be workflow-bound.** Token
   estimation, compaction, freshness, design alignment triggers — these
   are procedures/SOPs that apply to all workflows. Currently they're
   copy-pasted as references in each workflow file. CR-20 should
   formalize how cross-cutting concerns attach to workflows without
   duplication, and CR-22 should assess which procedures are universal
   vs. workflow-specific.

8. **Execution prompt revised for subagent dispatch.** The orchestrator
   must use the Agent tool to spawn subagents (workflow-planner,
   agentic-engineer, verifiers) — it must never implement directly.
   EXECUTION-PROMPT-v2.md was revised to make this explicit. The
   original prompt said "execute this CR following the lifecycle" which
   the orchestrator interpreted as permission to do the work itself.

9. **Base templates are generic, not workflow-specific.** Brief, Plan,
   and Outcome templates are named generically (Brief-Template.md, not
   Task-Brief-Template.md) because they are the base templates all
   workflow types can use. Analytics-specific templates
   (Analysis-Brief-Template.md, etc.) are domain specializations. This
   aligns with CR-29's unified document hierarchy direction.
