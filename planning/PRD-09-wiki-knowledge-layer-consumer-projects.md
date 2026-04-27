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

## Key Decisions (Already Aligned)

- Three levels, building on each other
- Level 1 already handled by PRD-06
- Level 2 is maintenance-integrated synthesis
- Level 3 is the full pipeline with cadence integration
- All levels should be planned out now, executed as separate units
  of work
- Owner approval required before topic articles are written (prevents
  unbounded wiki growth)
- Analytics-workspace gets its own cadence mapping

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
| `core/workflows/knowledge-pipeline.md` | Full 5-phase pipeline specification |
| `core/templates/Batch-Index-Schema.md` | JSON schema for batch index files |

#### Modified files
| File | Change |
|---|---|
| `core/workflows/knowledge-synthesis.md` | Expand to include extract and index phases |
| `core/maintenance-checklist.md` | Update knowledge synthesis step to use full pipeline |
| `core/workflows/sprint-lifecycle.md` | Add pipeline phase cadence mapping |
| `core/workflows/analytics-workspace.md` | Add pipeline phase cadence mapping for task-based work |
| `core/Document-Catalog.md` | Add wiki/meta/ (batch indexes) as Tier 3 |
| `VERSION` | 0.18.0 (covers both levels in single version) |
| `CHANGELOG.md` | Entry for 0.18.0 |
| `MIGRATIONS.md` | Consumer migration: create wiki/ directory, copy workflow + templates, update maintenance checklist and integration templates |

## Open Items (To Resolve During Execution)

- Whether Level 2 and Level 3 should be separate version bumps or
  combined (they're additive, Level 3 extends Level 2)
- How the knowledge synthesis step interacts with the architect's
  maintenance review (PRD-04) — do they run in the same maintenance
  session?
- Whether topic articles should be committed to git or treated as
  ephemeral (regeneratable from source artifacts)
- How the salience model maps to Fabrika's existing artifact types
  (what's S1 vs. S2 for evaluation reports, retro findings, ADRs?)
- Whether the full pipeline (Level 3) needs its own agent or if the
  orchestrator can manage it during maintenance
- How wiki knowledge interacts with agent context — do agents receive
  relevant wiki topics in their dispatch, or do they read on demand?

## Verification Criteria

### Level 2
- Knowledge synthesis workflow exists with clear steps
- Wiki topic template exists with all specified sections
- Maintenance checklist includes synthesis step
- Document-Catalog includes wiki document types
- Owner approval gate exists before topic articles are written
- Integration templates reflect wiki capability

### Level 3
- Full pipeline specification exists with all 5 phases
- Batch index schema exists
- Cadence mappings exist for sprint-based and analytics-workspace
- Salience model is defined with concrete examples
- Deduplication rules are documented
- No smell test violations for either level
