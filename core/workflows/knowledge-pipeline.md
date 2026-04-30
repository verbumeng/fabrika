# Knowledge Pipeline

The five-phase pipeline that transforms raw project artifacts into
structured, continuously updated wiki knowledge. This is the
reference specification — the practical step-by-step procedure is in
`core/workflows/knowledge-synthesis.md`.

---

## Pipeline Overview

```
Phase 1: Extract    → Pull content from source artifacts
Phase 2: Index      → Score salience, produce batch index JSONs
Phase 3: Synthesize → Cluster by topic, write/update topic articles
Phase 4: Link       → Cross-reference related topics
Phase 5: Glossary   → Feed new terms back to Domain Language
```

Phases 1-2 run frequently (every maintenance session or after task
delivery). Phases 3-4 run less frequently (every 2-3 sprints or
monthly, or on demand). Phase 5 is a lightweight check that runs
alongside Phases 3-4. All five phases run during quarterly
reintegration.

---

## Phase 1: Extract

**Input:** Source artifacts created or modified since the last
pipeline run.

**Process:**
1. Identify new or changed artifacts since the last batch index
   (compare file modification dates or `source_hash` from the
   previous batch)
2. For each artifact, extract: title, summary, key concepts,
   decisions, open questions, and related domains
3. Use Domain Language terms for key concepts when they exist
4. Write extractions as entries in a new batch index

**Output:** Extracted content entries (written to the batch index in
Phase 2).

**What to extract from:** All project documentation artifacts that
might contain synthesizable knowledge. This includes ADRs, evaluation
reports, retro findings, session logs, sprint progress files,
maintenance reports, research notes, PRDs, charters, stories, epics,
bug reports, and meeting notes.

---

## Phase 2: Index

**Input:** Extracted content from Phase 1.

**Process:**
1. Assign a salience score (S1/S2/S3) to each extracted artifact
   using the salience model below
2. Assign topic candidates — suggested topic article names this
   artifact might contribute to
3. Generate a dedup key for cross-batch deduplication
4. Compute the source hash for change detection
5. Write the complete batch index to
   `wiki/meta/batch-YYYY-MM-DD.json`

**Output:** Batch index JSON file (see
`core/templates/Batch-Index-Schema.md` for the schema).

---

## Phase 3: Synthesize

**Input:** All batch indexes since the last synthesis pass (or all
batch indexes during quarterly reintegration).

**Process:**
1. Read all batch indexes and collect topic candidates across
   artifacts
2. Cluster artifacts by topic — group entries whose topic candidates
   overlap or whose related domains align
3. Apply the single-source synthesis threshold: a topic requires
   content from at least 2 independent source artifacts. Skip topics
   with only one source.
4. For each topic that meets the threshold:
   - If the topic article already exists: update it with new
     information. Rewrite the Current State section entirely (do not
     append). Add new sources. Preserve the article's structure.
   - If the topic article does not exist: create it using the
     Wiki-Topic-Template (`core/templates/Wiki-Topic-Template.md`).
     Notify the owner inline: "Creating topic article: [name] (from
     [N] sources: [list])." Proceed unless the owner objects.
5. Update `wiki/index.md` with the narrative overview reflecting
   any new or updated topics (see Index Structure below)

**Output:** New or updated topic articles in `wiki/topics/`, updated
`wiki/index.md`.

**Notice-and-proceed model:** New topic articles are created
automatically with inline notification to the owner. The owner can
object in the moment, but the default action is proceed. This keeps
the wiki hands-off. Full owner review occurs only during quarterly
reintegration or when the agent encounters conflicting or ambiguous
sources.

---

## Phase 4: Link

**Input:** All topic articles in `wiki/topics/`.

**Process:**
1. Read all topic articles and identify relationships between them
   (shared key concepts, shared source artifacts, complementary
   domains)
2. Update the Related Topics section of each article with links to
   connected topics
3. Verify that all cross-references resolve (no links to
   non-existent topics)
4. Update `wiki/index.md` if the link pass reveals domain groupings
   that should be reflected in the overview

**Output:** Updated Related Topics sections across topic articles.

---

## Phase 5: Glossary

**Input:** Key concepts from Phase 1 extractions and topic articles
from Phase 3.

**Process:**
1. Collect all key concepts used across topic articles and batch
   indexes
2. Compare against the project's Domain Language document
   (`docs/00-Index/Domain-Language.md`)
3. For each concept that appears in wiki content but is not in
   Domain Language: flag it for addition
4. Do NOT define terms in the wiki that belong in Domain Language —
   the wiki is a consumer of Domain Language, not a parallel
   vocabulary
5. If the Domain Language document does not exist, note the flagged
   terms in the synthesis log but do not create the document (that
   is a Design Alignment concern)

**Output:** List of terms flagged for Domain Language addition (logged
in the maintenance report or synthesis summary).

---

## Salience Model

Salience determines how important each piece of extracted content is
for synthesis. Higher salience content is synthesized first and given
more weight in topic articles.

### Scoring Criteria

Salience is assigned based on the artifact type and its review state
(whether it has been through an approval or evaluation cycle).

| Salience | Criteria | Artifact Types |
|----------|----------|----------------|
| **S1 (high)** | Owner-approved foundational documents and explicitly promoted content | Project Charter, PRDs, accepted ADRs, Domain Language, Phase Definitions, Architecture Overview, Data Model, Data Pipeline Design, Transformation Logic, Source System Contracts, Ingestion Design, Storage Architecture, Serving Contracts, Orchestration Design, Model Design, Training Data Spec, Model Evaluation Criteria, Prompt Library, Model Configuration, RAG Architecture, Evaluation Strategy, API Design Guide, Dashboard Spec, approved topic articles, evaluation reports with PASS verdicts, implemented retro action items |
| **S2 (medium)** | Standard workflow output that has been through at least one review cycle | Stories, Epics, sprint contracts, sprint files, evaluation reports (all), session logs, sprint progress files, retro findings, maintenance reports, Testing Strategy, Canonical Patterns, Structural Constraints, cost models, threat models, Security & Privacy, Guardrails Spec, DataOps Runbook, Data Dictionary, Data Quality Rules, Deployment Guide, rubrics |
| **S3 (foundational)** | Unvalidated raw material — inputs and working documents not yet through a review cycle | Research notes, data source research, brain dump notes, draft specs before approval, bug reports before triage, Someday-Maybe items, meeting notes, decision records, Feature Specs (before approval) |

### Scoring Rules

1. **Default by type:** Use the table above to assign a default
   salience based on artifact type.
2. **State override:** An artifact's salience can shift based on its
   current state:
   - A superseded ADR drops from S1 to S3
   - A bug report that has been triaged and has a fix rises from S3
     to S2
   - A retro action item that was implemented rises from S2 to S1
3. **Owner override:** During quarterly reintegration, the owner can
   promote or demote any artifact's salience. The override is
   recorded in the batch index entry's `salience_reason` field.

### How Salience Affects Synthesis

- S1 content is always included in topic articles when it matches
  the topic
- S2 content is included when it adds substance beyond what S1
  sources already cover
- S3 content is included only during quarterly reintegration or when
  S1+S2 sources are insufficient to meet the 2-source threshold
- The synthesis step should bias toward S1 content for the Key
  Decisions and Current State sections of topic articles

---

## Cadence

### Sprint-based projects

| Cadence | Pipeline Phases | What Happens |
|---------|----------------|--------------|
| Per sprint (during maintenance) | Phases 1-2 (Extract + Index) | Scan artifacts created since last maintenance, produce batch index |
| Every 2-3 sprints or on demand | Phases 3-4 (Synthesize + Link) | Write/update topic articles, run cross-reference pass. Triggered when 3+ batch indexes exist without a synthesis pass, or on owner request. |
| Quarterly or on demand | All phases (full reintegration) | Re-score salience, rewrite stale articles, merge/retire topics, rebuild index narrative, clean up stale batch entries. Triggered when 3+ months since last reintegration (tracked in `wiki/meta/last-reintegration.md`). |

### Analytics-workspace projects

| Cadence | Pipeline Phases | What Happens |
|---------|----------------|--------------|
| After each task delivery | Phases 1-2 | Index the task's brief, plan, and outcome as a batch |
| Monthly or on demand | Phases 3-4 | Synthesize recurring themes across tasks |
| Quarterly | All phases | Full reintegration (same as sprint-based) |

### Agentic-workflow projects

Cadence is driven by the structural update lifecycle, not a fixed
schedule:

- **After each system update (Ship step):** The orchestrator reviews
  the changes and their rationale, updates relevant wiki topic
  articles, and flags any conversation-level design rationale worth
  capturing. This is the primary wiki update trigger.
- **During alignment sessions:** When design philosophy, cross-cutting
  decisions, or framework evolution rationale emerges from alignment
  conversations, the orchestrator captures relevant insights in topic
  articles during the Ship step.
- **When harvest findings arrive:** Consumer project harvest data
  flows into `wiki/topics/harvest-patterns.md` and may trigger
  updates to other topics (e.g., agent-model improvements driven by
  consumer feedback).
- **On demand:** The owner can request wiki synthesis at any time
  (e.g., "capture what we discussed about X in the wiki").
- **Reintegration:** Triggered manually or after a defined number of
  structural changes (e.g., every 5 version bumps) for consumer
  agentic-workflow projects that adopt the wiki.

The formal 5-phase pipeline (Extract, Index, Synthesize, Link,
Glossary) does not apply to agentic-workflow projects at the same
cadence as sprint-based projects. The wiki is maintained through
direct article updates during the Ship step rather than batch
processing.

---

## Wiki Structure

```
wiki/
  index.md              — Narrative project overview (dual audience)
  topics/
    [topic-name].md     — Synthesized topic articles
  meta/
    batch-YYYY-MM-DD.json  — Pipeline intermediates (agent-only)
    last-reintegration.md  — Timestamp + summary of last quarterly pass
```

### wiki/index.md Structure

The index is a **progressive narrative**, not a list of links. It
serves dual audiences: a human reading from zero understanding, and
an agent looking for a structured project overview.

**Sections (in order):**

1. **Project overview** — What is this project, why does it exist,
   who is it for. Two to four sentences.
2. **Knowledge domains** — The major topic areas that the wiki
   covers, with one-paragraph summaries and links to the relevant
   topic articles. Organized by domain, not alphabetically.
3. **Key decisions** — The most important project-wide decisions
   (drawn from S1 topic articles). Not a full list — the top 5-10
   that define the project's shape.
4. **Current state** — Where the project is right now: active phase,
   recent developments, upcoming work. Updated each synthesis pass.
5. **Active questions** — Open questions that span multiple topics.
   Drawn from the Open Questions sections of topic articles.
6. **Sources summary** — How many artifacts have been indexed, when
   the last synthesis ran, how many topic articles exist. Agent-facing
   metadata.

### Topic Article Template

See `core/templates/Wiki-Topic-Template.md`.

---

## Backfill (Phase 0)

A one-time retrospective sweep for projects with existing artifacts
that are adopting the wiki for the first time (via bootstrap, adopt,
or Fabrika update).

**Process:**
1. Inventory all existing artifacts across the project (ADRs, retros,
   eval reports, session logs, stories, PRDs, etc.)
2. Run Phases 1-2 (Extract + Index) on all artifacts in a single
   batch
3. Run Phases 3-4 (Synthesize + Link) to produce initial topic
   articles
4. Write `wiki/index.md` with the project narrative overview
5. Run Phase 5 (Glossary) to check for terms not yet in Domain
   Language
6. Present summary to the owner: "Created X topic articles from Y
   existing artifacts"

**Chat-size assessment:** Before running backfill, count the
artifacts to process:
- Under ~30 artifacts: run backfill in the current chat
- 30+ artifacts: recommend a dedicated chat session to keep context
  clean. Tell the owner: "This project has N existing artifacts. I
  recommend running the wiki backfill in a new chat to keep context
  clean. After we finish this [adoption/update], start a new chat
  and ask me to run the wiki backfill."

The backfill is documented in `core/workflows/knowledge-synthesis.md`
as a callable procedure.

---

## Design Properties

- **Batch indexes are stable intermediates** — decoupled from source
  file lifecycle. A batch index entry survives the source file being
  renamed, moved, or deleted.
- **Per-domain wikis for multi-domain projects** — projects with
  multiple bounded contexts can organize topic articles by domain
  using subdirectories under `wiki/topics/` (e.g.,
  `wiki/topics/payments/`, `wiki/topics/auth/`). Single-domain
  projects use a flat `wiki/topics/` directory.
- **Single-source synthesis threshold** — minimum 2 independent
  source artifacts per topic article. Prevents restating individual
  notes as topic articles.
- **Deduplication at index and synthesis levels** — see the
  Batch-Index-Schema for index-level dedup rules. At synthesis level,
  if two batch entries contribute the same decision or finding to
  a topic, the synthesis step merges them rather than duplicating.
