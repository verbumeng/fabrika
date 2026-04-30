# PRD-09: Wiki Knowledge Layer — Consumer Projects

**Version target:** 0.18.0
**Dependencies:** PRD-06 (Domain Language — the wiki glossary phase
builds on it)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

Software projects generate knowledge continuously — ADRs, retro
findings, evaluation reports, meeting notes, design decisions, research
docs — but store it as disconnected, time-stamped artifacts. When
someone (human or agent) needs to answer "what do we know about X?",
they have to mentally stitch together information scattered across
dozens of files. Knowledge gets created during sprints but never
consolidated into a queryable, topic-organized form.

This is the write-once-read-never problem: content gets produced during
workflow steps but is never synthesized, so project institutional
knowledge degrades into a pile of files that neither humans nor agents
efficiently search.

The wiki knowledge layer concept (drawn from MyVitaOraOS's decision
records on this topic) proposes a multi-phase pipeline that transforms
raw project artifacts into structured, continuously updated knowledge.

## Solution

Implement the wiki knowledge layer for consumer projects in three
levels, each as a distinct unit of work within this PRD. The three
levels build on each other — Level 1 is the foundation, Level 2 adds
synthesis, Level 3 adds the full pipeline.

### Level 1: Domain Language as Living Document

**Already delivered by PRD-06.** Domain Language document is Tier 1,
maintained during design alignment, implementation, and maintenance.
This PRD builds on that foundation.

### Level 2: Knowledge Synthesis During Maintenance

Add a knowledge synthesis step to maintenance sessions. During
maintenance, the agent:

1. **Scans recent artifacts** — ADRs created since last maintenance,
   evaluation reports, retro findings, research docs, session logs
2. **Identifies recurring themes** — topics that appear across multiple
   artifacts (e.g., "authentication keeps coming up in security
   reviews," "performance concerns around the data pipeline")
3. **Writes or updates topic articles** — consolidates knowledge from
   multiple sources into topic-organized articles in a `wiki/` directory
4. **Cross-references** — links related topic articles to each other
   and to the source artifacts they synthesize

**Wiki directory structure:**
```
wiki/
  index.md          — navigational entry point, lists all topics
  topics/
    [topic-name].md — synthesized article on a specific topic
```

**Topic article format:**
- Summary (what is this topic, why does it matter to this project)
- Key decisions (synthesized from ADRs and retro findings)
- Current state (what's true now, not what was true 3 sprints ago)
- Open questions (unresolved items across artifacts)
- Sources (links to the artifacts this was synthesized from)

**Maintenance integration:**
- Runs as a step in the existing maintenance checklist
- Only synthesizes when there are new artifacts since last synthesis
- The agent proposes topic articles to the owner — owner approves
  before they're written (prevents the wiki from growing unboundedly)
- Existing topic articles get updated, not duplicated

### Level 3: Full Pipeline with Cadence Integration

The complete 5-phase pipeline adapted from the MyVitaOraOS architecture:

1. **Extract** — Pull content from source artifacts into normalized
   format
2. **Index** — Triage extracted content, assign salience scores,
   produce structured batch index files (JSON) as stable intermediates
3. **Synthesize** — Cluster related indexed items by topic, write/update
   topic articles
4. **Link** — Cross-referencing pass connecting related topics within
   and across domain boundaries
5. **Glossary** — Maintain Domain Language (already in place from PRD-06)

**Cadence mapping for sprint-based projects:**
| Cadence | Pipeline Phases | What Happens |
|---|---|---|
| Per sprint (during maintenance) | Phases 1-2 (Extract + Index) | Triage sprint artifacts, create batch indexes, log what was promoted |
| Every 2-3 sprints or on demand | Phases 3-4 (Synthesize + Link) | Write/update topic articles, run cross-reference pass |
| Quarterly or on demand | Full reintegration | Review salience scores, rewrite stale articles, rebuild taxonomy |

**Cadence mapping for analytics-workspace:**
| Cadence | Pipeline Phases | What Happens |
|---|---|---|
| After each task delivery | Phases 1-2 | Index the task's artifacts (brief, plan, outcome) |
| Monthly or on demand | Phases 3-4 | Synthesize recurring themes across tasks |
| Quarterly | Full reintegration | Same as sprint-based |

**Salience model:**
- S1 (high): Content explicitly promoted during review
- S2 (medium): Standard workflow output (eval reports, session logs)
- S3 (foundational): Raw imports, not yet validated

**Key design properties:**
- Batch index JSONs are stable intermediates — decoupled from source
  file lifecycle
- Per-domain wikis for multi-domain projects (each bounded context
  gets its own wiki subdirectory)
- Single-source synthesis threshold: minimum 2 sources per topic
  article (prevents restating individual notes)
- Deduplication at index and synthesis levels

## Key Decisions (Aligned)

### Original alignment (design session)
- Three levels, building on each other
- Level 1 already handled by PRD-06
- Level 2 is maintenance-integrated synthesis
- Level 3 is the full pipeline with cadence integration
- All levels planned now, executed as separate units of work
- Analytics-workspace gets its own cadence mapping

### Execution alignment (Step 2 review, 2026-04-30)

- **Single version (0.18.0):** Levels 2 and 3 ship together. Level 3
  extends Level 2 — splitting into two versions creates double-migration
  for consumers and PRD-10 is already slotted for 0.19.0.
- **Notice-and-proceed model** replaces approval-gated topic creation.
  The agent creates topic articles automatically and notifies the owner
  inline during maintenance ("I'm creating a topic on X based on these
  sources"). The owner can object in the moment, but the default action
  is proceed. Full owner review only during quarterly reintegration or
  when the agent encounters conflicting/ambiguous sources. This keeps
  the wiki hands-off — automatic memory, not a review queue.
- **Topic articles committed to git.** They are project knowledge
  assets, not throwaway outputs. The notice-and-proceed model and
  single-source synthesis threshold (2+ sources per topic) prevent
  unbounded growth.
- **No new agent.** The orchestrator manages the pipeline during
  maintenance. If synthesis quality suffers from context overload, a
  dedicated agent is a future iteration.
- **On-demand read for agents.** Agents read wiki topics when they
  need domain context, like Architecture Overview or Domain Language.
  Not dispatched automatically. Primary use case: the orchestrating
  agent draws on wiki during brainstorming and alignment conversations
  to surface relevant project history; human readers use wiki/index.md
  to explain the project to others from zero understanding.
- **Wiki offered during bootstrap/adopt, default yes.** The
  orchestrator asks during bootstrap (all project types) and adoption
  (all tiers) whether the user wants a wiki, explains what it does
  and why, and defaults to creating it. Not silently created — but
  the recommendation is to have one.
- **Backfill mechanism (Phase 0).** For projects with existing
  artifacts (adopt, update), a one-time backfill pass runs
  Extract+Index+Synthesize+Link on all existing artifacts to populate
  the wiki. Includes chat-size assessment: under ~30 artifacts runs
  inline, 30+ artifacts recommends a dedicated chat session.
- **Domain Language alignment.** The wiki is a consumer of Domain
  Language, not a parallel vocabulary. Topic articles use Domain
  Language terms. The Glossary pipeline phase (Phase 5) checks for
  new concepts that emerged during synthesis and flags them for
  addition to Domain Language. The wiki does not define terms that
  belong in Domain Language.
- **Hierarchical wiki structure with narrative index.** wiki/index.md
  is a progressive narrative overview (project identity → major
  knowledge domains → per-domain summaries → current state → active
  questions), not just a list of links. Topic articles go deeper on
  specific subjects. wiki/meta/ is agent-only (batch indexes).
  Designed for dual audience: humans reading the narrative, agents
  parsing the structured sections.
- **Comprehensive salience mapping.** All document types from the
  Document Catalog are mapped:
  - S1 (high): Owner-approved foundational documents — Project
    Charter, PRDs, accepted ADRs, Domain Language, Phase Definitions,
    and all Tier 1 design/architecture documents per project type
    (Architecture Overview, Data Model, Data Pipeline Design, Source
    System Contracts, Model Design, Prompt Library, API Design Guide,
    Dashboard Spec, etc.), approved topic articles, PASS evaluation
    reports, implemented retro action items
  - S2 (medium): Reviewed workflow output — Stories, Epics, sprint
    contracts, evaluation reports (all), session logs, sprint progress
    files, retro findings, maintenance reports, Testing Strategy,
    Canonical Patterns, Structural Constraints, cost models, threat
    models, rubrics, and Tier 2 engineering docs (Data Dictionary,
    Deployment Guide, Guardrails Spec, DataOps Runbook, etc.)
  - S3 (foundational): Unvalidated raw material — research notes,
    data source research, brain dump notes, draft specs before
    approval, bug reports before triage, Someday-Maybe items,
    meeting notes/decision records
- **Knowledge Synthesis placement in maintenance checklist.** After
  Architecture Review (which is after Terminology Drift Check), before
  Token Usage Review. Architect findings get triaged first (trivial
  fixed, refactor stories created), then synthesis indexes the
  session's output.
- **Quarterly reintegration as conditional trigger.** For sprint-based
  projects, the maintenance checklist checks if 3+ months have passed
  since last reintegration. For analytics-workspace, same date-based
  check. For agentic-workflow projects, cadence is defined by PRD-10
  or manually triggered.
- **Integration templates tell agents to check wiki first.** Not just
  "wiki exists" — agents are told to check wiki/index.md for project
  narrative and wiki/topics/ for synthesized knowledge before grepping
  raw artifacts. During brainstorming and alignment, draw on wiki
  topics to surface relevant history and past decisions.

## Scope: What Changes

### Level 2 Changes

#### New files
| File | Purpose |
|---|---|
| `core/workflows/knowledge-synthesis.md` | Workflow for the maintenance-integrated synthesis step |
| `core/templates/Wiki-Topic-Template.md` | Template for topic articles |

#### Modified files
| File | Change |
|---|---|
| `core/maintenance-checklist.md` | Add knowledge synthesis step (scan recent artifacts → identify themes → propose topic articles → owner approves → write) |
| `core/Document-Catalog.md` | Add wiki/index.md and wiki/topics/ as Tier 2 documents (created during maintenance when themes emerge) |
| `integrations/claude-code/CLAUDE.md` | Add wiki section to project structure and maintenance description |
| `integrations/copilot/copilot-instructions.md` | Same |

### Level 3 Changes (Additive on top of Level 2)

#### New files
| File | Purpose |
|---|---|
| `core/workflows/knowledge-pipeline.md` | Full 5-phase pipeline specification with comprehensive salience mapping |
| `core/templates/Batch-Index-Schema.md` | JSON schema for batch index files |

#### Modified files
| File | Change |
|---|---|
| `core/workflows/knowledge-synthesis.md` | Expand to include extract/index phases, backfill (Phase 0), narrative writing guidelines, notice-and-proceed model |
| `core/maintenance-checklist.md` | Update knowledge synthesis step to use full pipeline; place after Architecture Review |
| `core/workflows/sprint-lifecycle.md` | Add pipeline phase cadence mapping with quarterly reintegration trigger |
| `core/workflows/analytics-workspace.md` | Add pipeline phase cadence mapping for task-based work |
| `core/Document-Catalog.md` | Add wiki/meta/ (batch indexes) as Tier 3 |

### Cross-Cutting Changes (both levels)

#### Modified files
| File | Change |
|---|---|
| `BOOTSTRAP.md` | Add wiki question to Phase 1.3 (folder structure), Phase 2/2W/2A (all project types). Default yes. Add wiki/ to directory trees. Add backfill trigger for projects with existing artifacts. Add to readiness checklist. |
| `ADOPT.md` | Add wiki question to all three tiers. Add backfill trigger with chat-size assessment (under 30 artifacts = inline, 30+ = dedicated chat). |
| `VERSION` | 0.18.0 (covers both levels in single version) |
| `CHANGELOG.md` | Entry for 0.18.0 |
| `MIGRATIONS.md` | Consumer migration: create wiki/ directory, copy workflow + templates, run backfill if existing artifacts, update maintenance checklist and integration templates |

## Resolved Items (from Step 2 alignment, 2026-04-30)

All open items have been resolved. See the "Execution alignment"
subsection under Key Decisions for the full rationale. Summary:

1. **Combined version (0.18.0)** — both levels ship together
2. **Independent, sequential** — synthesis runs after Architecture
   Review in the same maintenance session; architect findings get
   triaged first, then synthesis indexes the session's output
3. **Committed to git** — topic articles are project knowledge assets
4. **Comprehensive salience mapping** — all document types mapped
   (Charter/PRD = S1, Stories/Epics = S2, research/drafts = S3)
5. **No new agent** — orchestrator manages pipeline during maintenance
6. **On-demand read + orchestrator primary use** — agents read wiki
   topics when needed; primary value is orchestrator using wiki during
   brainstorming/alignment and humans using wiki/index.md to explain
   the project from zero understanding

## Verification Criteria

### Level 2
- Knowledge synthesis workflow exists with clear steps
- Wiki topic template exists with all specified sections (Summary,
  Key Decisions, Current State, Open Questions, Sources) and
  dual-audience writing guidance
- Maintenance checklist includes synthesis step after Architecture
  Review with conditional gate ("only runs when wiki/ exists")
- Document-Catalog includes wiki document types (index Tier 2,
  topics Tier 2, meta Tier 3)
- Notice-and-proceed model documented (not approval-gated)
- Integration templates tell agents to check wiki first and use it
  during brainstorming/alignment

### Level 3
- Full pipeline specification exists with all 5 phases
- Batch index schema exists
- Cadence mappings exist for sprint-based and analytics-workspace
- Salience model maps all Document Catalog artifact types to S1/S2/S3
  with explicit criteria
- Quarterly reintegration trigger is a date-based conditional in the
  maintenance checklist
- Glossary phase (Phase 5) references Domain Language maintenance —
  new terms flagged for DL addition, wiki does not define terms that
  belong in Domain Language
- Deduplication rules are documented

### Cross-cutting
- BOOTSTRAP.md offers wiki during setup (all project types), default
  yes, with explanation of what it does
- ADOPT.md offers wiki during adoption (all tiers), with backfill
  trigger and chat-size assessment
- Backfill (Phase 0) documented in knowledge-synthesis workflow
- wiki/index.md structure is a progressive narrative (not just links)
- Hierarchical depth: index → topics → sources
- Domain Language alignment enforced in template and workflow
- No smell test violations for any level
