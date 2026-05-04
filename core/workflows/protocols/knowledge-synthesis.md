# Knowledge Synthesis Workflow

**Procedure classification:** Cross-cutting. Companion to the
knowledge pipeline. All workflow types invoke it at their delivery
and maintenance points.

The practical step-by-step procedure for maintaining a project's wiki
knowledge layer. This workflow is called from the maintenance
checklist (for domain workflow projects) or after task delivery (for
analytics workflow projects). For the pipeline reference
specification, see `core/workflows/protocols/knowledge-pipeline.md`.

---

## Prerequisites

- A `wiki/` directory exists in the project (created during bootstrap
  or adoption when the owner opts in)
- The project has at least some artifacts to synthesize (ADRs,
  evaluation reports, retro findings, session logs, etc.)

If no `wiki/` directory exists, skip this workflow entirely.

---

## Incremental Synthesis (Normal Maintenance)

This runs as a checklist step during maintenance sessions. It covers
Phases 1-2 (Extract + Index) every time, and Phases 3-5 (Synthesize
+ Link + Glossary) when the synthesis trigger is met.

### Step 1: Identify new artifacts

Determine what has changed since the last pipeline run:
1. Read the most recent batch index in `wiki/meta/`
2. Scan for artifacts created or modified since that batch's
   timestamp
3. If no previous batch exists, treat all artifacts as new

**What counts as an artifact:** ADRs, evaluation reports, retro
files, session logs, sprint progress files, maintenance reports,
research notes, PRDs, charters, stories, epics, bug reports, meeting
notes. Essentially, any file in `docs/` that contains project
knowledge (not templates, not scaffolding).

### Step 2: Extract and Index (Phases 1-2)

For each new or changed artifact:
1. Read the artifact
2. Extract: title, summary, key concepts, decisions, open questions,
   related domains
3. Assign salience (S1/S2/S3) using the salience model in
   `core/workflows/protocols/knowledge-pipeline.md`
4. Assign topic candidates
5. Generate a dedup key

Write all entries to a new batch index at
`wiki/meta/batch-YYYY-MM-DD.json` following the schema in
`core/templates/Batch-Index-Schema.md`.

### Step 3: Check synthesis trigger

Determine whether to run Phases 3-5:
- Count batch indexes that exist since the last synthesis pass
  (check `wiki/meta/` for batch files newer than the most recent
  topic article update)
- **Trigger:** 3+ batch indexes without a synthesis pass, OR owner
  requests synthesis, OR quarterly reintegration is due

If the trigger is not met, stop here. Phases 1-2 are complete.

### Step 4: Synthesize (Phase 3)

If the synthesis trigger is met:
1. Read all batch indexes since the last synthesis pass
2. Cluster artifacts by topic candidate overlap and domain alignment
3. For each topic that meets the 2-source threshold:
   - **Existing topic:** Update with new information. Rewrite
     Current State entirely. Add new sources. Preserve structure.
   - **New topic:** Create using `core/templates/Wiki-Topic-Template.md`.
     Notify the owner: "Creating topic: [name] (from [N] sources)."
     Proceed unless the owner objects.
4. Update `wiki/index.md` to reflect new or updated topics

**Writing guidelines:**
- Write as if explaining to a colleague who just joined the project
- Use Domain Language terms — do not define terms that belong in
  Domain Language
- Lead with context, not jargon
- The Summary section of each article should be self-contained:
  readable without following any links
- The Current State section reflects NOW, not history — rewrite it
  on each pass, do not append
- The Key Decisions section is cumulative — add new decisions, do
  not remove old ones unless they were superseded (and note the
  supersession)

### Step 5: Link (Phase 4)

After synthesis:
1. Read all topic articles
2. Update Related Topics sections with cross-references
3. Verify all links resolve

### Step 6: Glossary check (Phase 5)

1. Collect key concepts from the articles written or updated in
   this pass
2. Check each against Domain Language
   (`docs/00-Index/Domain-Language.md`)
3. Flag any concepts not in Domain Language for addition
4. Log flagged terms in the maintenance report

### Step 7: Record the pass

Log the synthesis in the maintenance summary:
```
- Knowledge synthesis: X topics proposed, Y created, Z updated,
  W terms flagged for Domain Language / skipped — trigger not met
```

---

## Quarterly Reintegration

A deeper pass that runs when 3+ months have elapsed since the last
reintegration. Tracked in `wiki/meta/last-reintegration.md`.

### Process

1. **Re-score salience:** Read all batch indexes and re-evaluate
   salience scores. Superseded ADRs drop from S1. Implemented retro
   items rise to S1. Apply any owner overrides from previous passes.

2. **Rebuild the topic set:** Read all topic articles. For each:
   - Is this topic still relevant? (Do its source artifacts still
     exist? Has the topic been superseded by project evolution?)
   - Should any topics be merged? (Two topics that have converged
     over time)
   - Should any topics be retired? (Relevance has faded, no new
     sources in 2+ quarters)

3. **Rewrite stale articles:** For topics that remain active, do a
   full rewrite of the Current State section using all available
   sources (not just recent batches).

4. **Full link pass:** Rebuild all cross-references.

5. **Rebuild the narrative:** Rewrite `wiki/index.md` from scratch
   as a progressive overview of the project's current knowledge
   state.

6. **Clean up batch indexes:** Remove batch entries for artifacts
   that no longer exist. Archive old batch files to
   `wiki/meta/archive/` if desired.

7. **Update the reintegration record:**
   Write `wiki/meta/last-reintegration.md`:
   ```markdown
   Last reintegration: YYYY-MM-DD
   Topics: X active, Y retired, Z merged
   Batch indexes cleaned: N entries removed
   Terms flagged for Domain Language: [list]
   ```

### Presentation

Present a brief summary to the owner:
- How many topics are active, retired, merged
- Any surprises (topics that grew significantly, topics that became
  irrelevant)
- Terms flagged for Domain Language
- Any owner overrides to confirm (salience promotions/demotions)

---

## Backfill (Phase 0)

A one-time retrospective sweep for projects adopting the wiki with
existing artifacts. Runs during bootstrap (for projects with brain
dump content), adoption (all tiers), or Fabrika update (when
upgrading to 0.18.0+).

### Chat-size assessment

Before running backfill, count artifacts:
- Under ~30 artifacts: run in the current chat
- 30+ artifacts: recommend a dedicated chat. Tell the owner: "This
  project has N existing artifacts. I recommend running the wiki
  backfill in a new chat to keep context clean. After we finish this
  [bootstrap/adoption/update], start a new chat and ask me to run
  the wiki backfill."

### Backfill process

1. **Inventory:** List all artifacts in `docs/` that contain project
   knowledge (ADRs, evaluation reports, retros, session logs, PRDs,
   charters, stories, research notes, maintenance reports, etc.)

2. **Extract + Index:** Run Phases 1-2 on all artifacts in a single
   batch. Write the batch index to `wiki/meta/batch-YYYY-MM-DD.json`.

3. **Synthesize + Link:** Run Phases 3-4. Create topic articles for
   all themes that meet the 2-source threshold. Use the
   notice-and-proceed model (notify, create unless owner objects).

4. **Write the index:** Create `wiki/index.md` as a progressive
   narrative overview:
   - Project overview (from Charter or README)
   - Knowledge domains (from the topic articles just created)
   - Key decisions (from S1 topic articles)
   - Current state (from recent sprint progress or STATUS.md)
   - Active questions (from topic article Open Questions)
   - Sources summary (artifact count and topic count)

5. **Glossary check:** Run Phase 5 — flag concepts not in Domain
   Language.

6. **Present summary:** "Created X topic articles from Y existing
   artifacts across Z knowledge domains."

---

## Wiki Knowledge in Agent Context

Wiki topics are available for on-demand reading by any agent. They
are not dispatched automatically. The primary use cases:

1. **Orchestrator ↔ owner communication:** During brainstorming,
   alignment, or design sessions, the orchestrating agent draws on
   wiki topics to surface relevant project history, past decisions,
   and open questions. Example: "Based on what we've learned about
   caching [wiki/topics/caching-decisions.md], the approach you're
   describing would conflict with ADR-007..."

2. **Human ↔ human communication:** The owner can point someone to
   `wiki/index.md` and they get a progressive narrative from zero
   understanding — no need to read dozens of individual artifacts.

3. **Agent reference:** Planners and implementers can read relevant
   wiki topics when working in unfamiliar domain areas, similar to
   how they read Architecture Overview or Domain Language on demand.
   Reviewers typically do not need wiki topics — they review against
   rubrics, not domain knowledge.

Agents that need domain context for a specific task should read
`wiki/index.md` first for orientation, then the relevant topic
article for depth.
