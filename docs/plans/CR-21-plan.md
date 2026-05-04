---
type: system-update-plan
change-request: planning/CR-21-freshness-aware-context.md
status: executed
created: 2026-05-03
version_target: 0.31.0
bump_type: minor
---

# System Update Plan: CR-21 — Freshness-Aware Context Loading

Introduces a freshness signal for Tier 1 context documents. Each
Tier 1 doc gets a `last-validated` frontmatter field recording when a
human or agent last confirmed the document reflects the current
codebase. The orchestrator checks this against a staleness threshold
during story/task start. Fresh docs load normally; stale docs are
loaded with a caveat (Strategy B, universal default). Strategy A
(skip and research) exists only as an explicit owner override for docs
the owner knows are seriously wrong. Freshness validation happens
during sprint maintenance (for sprint projects), on-demand sweeps
(for non-sprint projects), optionally post-story/task, and on demand.

This is the "context quality" principle in the Phase 2 workflow
composition model — CR-21 sits alongside CR-20 (compaction) as a
named cross-cutting principle. Compaction governs what agents produce
at phase boundaries; freshness governs what the orchestrator loads
before a phase begins. The freshness check is universal — it applies
whenever an orchestrator loads Tier 1 docs, regardless of workflow
type. Only the periodic sweep mechanism is workflow-specific.

## Scope Boundary

CR-21 adds freshness metadata, conditional loading logic, and a
maintenance sweep step. The freshness CHECK at story/task start is
universal — it applies whenever an orchestrator loads Tier 1 docs,
regardless of workflow type. The periodic SWEEP is workflow-specific
(sprint maintenance for sprint projects, on-demand for non-sprint
projects).

CR-21 does NOT:

- Change agent prompt files (freshness is an orchestrator concern —
  agents receive whatever context the orchestrator decides to load)
- Change Tier 1 document content (only adds metadata to templates and
  catalog guidance)
- Apply to agentic-workflow lifecycle (wiki articles have their own
  lifecycle)
- Apply to wiki articles (separate lifecycle — extract, index,
  synthesize)
- Apply to sprint contract templates (freshness is per-story context
  loading, not per-sprint)
- Auto-generate or auto-update documentation (validation is
  human-confirmed accuracy, not machine-generated updates)
- Create any new files (all changes go into existing files)

## Design Decision Resolutions

1. **`last-validated` as a date, not a commit hash.** A date is
   simpler and sufficient — if the doc was validated yesterday, it is
   probably still accurate regardless of how many commits landed today.
   Commit hashes would be more precise but less human-readable and
   harder to reason about during maintenance sweeps.

2. **Global freshness threshold with per-document override.** The
   project declares a global threshold in its instruction file (e.g.,
   `freshness-threshold: 2-sprints`). Individual documents can override
   this in their own frontmatter (`freshness-threshold: 4-sprints`)
   for docs that drift slowly (like Domain Language). This balances
   simplicity with flexibility.

3. **Stale docs highlighted in sprint retro.** Yes. The retro is a
   natural place to surface "these N docs went stale this sprint — are
   any worth refreshing?" The scrum-master already reads maintenance
   outputs during retro; stale doc data from the maintenance sweep
   feeds into that.

4. **Newly bootstrapped projects set `last-validated` to bootstrap
   date.** On day one, all docs are freshly created and accurate. The
   threshold only starts mattering after a few sprints. Bootstrap
   writes the current date as `last-validated` for all initial Tier 1
   docs.

5. **Wiki articles excluded from freshness.** Wiki articles have their
   own lifecycle (extract, index, synthesize, reintegrate) and are not
   context-loaded at story start. Freshness applies to Tier 1 project
   docs only.

6. **Strategy B (load with caveat) is the universal default.** Stale
   docs are loaded with a caveat note for all tiers — Patch, Story,
   and Deep Story alike. Stale-but-mostly-accurate context is almost
   always cheaper than reconstructing from scratch, which burns the
   context window and may produce worse results. Strategy A (skip and
   research) exists only as an explicit owner override for docs the
   owner knows are seriously wrong — it is never an automatic default.

## Version Bump Determination

**Bump type:** minor
**New version:** 0.31.0
**Reasoning:** Changes to `core/**` files (Document-Catalog.md,
development-workflow.md, sprint-coordination.md) trigger a minor
bump per CLAUDE.md versioning rules.

---

## File Change Inventory

### New files

None. All changes go into existing files.

### Modified files

| # | File | Change summary |
|---|------|---------------|
| 1 | `core/Document-Catalog.md` | Add `last-validated` field description to Tier 1 document guidance; add freshness validation paragraph |
| 2 | `core/workflows/types/development-workflow.md` | Add freshness check step to story/task-start context loading; Strategy B (load with caveat) as universal default; Strategy A as owner override only; passive one-line warning at start |
| 3 | `core/workflows/protocols/sprint-coordination.md` | Add freshness sweep step to maintenance phase; add stale doc surfacing to retro phase; add non-sprint on-demand sweep note |
| 4 | `core/templates/Domain-Language-Template.md` | Add `last-validated: YYYY-MM-DD` to frontmatter |
| 5 | `core/templates/Project-Charter-Template.md` | Add `last-validated: YYYY-MM-DD` to frontmatter |
| 6 | `core/templates/PRD-Template.md` | Add `last-validated: YYYY-MM-DD` to frontmatter |
| 7 | `integrations/claude-code/CLAUDE.md` | Add passive freshness orientation note to Session Lifecycle; add freshness bullet to Key Constraints (Strategy B universal default, orchestrator controls dispatch) |
| 8 | `integrations/copilot/copilot-instructions.md` | Same as CLAUDE.md |
| 9 | `Domain-Language.md` | Define freshness signal, staleness threshold, freshness validation |
| 10 | `core/workflows/types/task-workflow.md` | Add freshness check cross-reference to task-start context loading (passive one-line warning, Strategy B default) |
| 11 | `VERSION` | `0.30.0` -> `0.31.0` |
| 12 | `CHANGELOG.md` | Add 0.31.0 entry |

---

## Detailed Change Specifications

### 1. `core/Document-Catalog.md`

**What changes:**

Add a new subsection under the "How to Use This Catalog" header,
after the Audience Markers table, titled "Freshness Metadata." This
section describes:

- The `last-validated` frontmatter field — what it is, what it means,
  when to set it. Plain definition: the date when a human or agent
  last confirmed that the document accurately reflects the current
  codebase. Not auto-updated on every edit — explicitly set during
  validation.
- Which documents carry it: Tier 1 documents that the orchestrator
  loads into dispatch context at story/task start (Architecture
  Overview, Data Model, Canonical Patterns, Testing Strategy, Phase
  Definitions, Domain Language, and domain-specific Tier 1 docs for
  the project type).
- Guidance for consumers: "When creating Tier 1 documents during
  bootstrap, set `last-validated` to the current date. During
  maintenance sessions, re-validate docs that have gone stale."
- Cross-reference to the freshness check in development-workflow.md
  and the freshness sweep in sprint-coordination.md.

Keep this section concise (10-15 lines). The behavioral logic (what
the orchestrator does with the freshness signal) lives in
development-workflow.md, not here.

**Integration points:**
- Referenced by development-workflow.md (freshness check step points
  here for the field definition)
- Referenced by sprint-coordination.md (maintenance sweep points here
  for which docs carry the field)
- Read by agents during bootstrap and maintenance

---

### 2. `core/workflows/types/development-workflow.md`

**What changes:**

Add a "Freshness-Aware Context Loading" section before "Starting a
Story" (after "Tier-Conditional Workflow Branching" and before the
story-start steps). This placement is deliberate — the orchestrator
reads it before entering any story path.

The section covers:

- **When it applies:** During story/task start, whenever the
  orchestrator loads Tier 1 context documents. This applies to all
  workflow types that load Tier 1 docs — development-workflow,
  task-workflow, and any future workflow that reads structural context
  at start. The orchestrator checks each document's `last-validated`
  frontmatter against the project's freshness threshold.
- **Freshness threshold:** Configurable per project, recorded in the
  project's instruction file (CLAUDE.md or equivalent). Default:
  2 completed sprints (~4 weeks). Per-document override possible via
  `freshness-threshold` in the document's own frontmatter.
- **Passive freshness note at story/task start.** The freshness check
  at story/task start is passive. When the orchestrator detects a stale
  document during orientation, it emits a one-line warning in its
  orientation output (e.g., "Note: Architecture Overview last validated
  6 weeks ago") and proceeds with Strategy B — load the document with
  a caveat. No blocking, no user interaction, no triage at start. The
  orchestrator includes the document in the dispatch payload with the
  caveat note prepended: "This document was last validated on [date].
  If your work touches areas described here, verify against the actual
  code before relying on it."
- **Strategy B: Load with caveat (universal default).** Load the stale
  document with a caveat note prepended. This is the default for ALL
  tiers — Patch, Story, and Deep Story alike. Rationale: stale-but-
  mostly-accurate context is almost always cheaper than reconstructing
  from scratch, which burns the context window and may produce worse
  results.
- **Strategy A: Skip and research (owner override only).** Don't load
  the stale document. Strategy A exists only as an explicit owner
  override for docs the owner knows are seriously wrong. It is never
  an automatic default. When the owner specifies Strategy A for a
  document, the orchestrator skips it and the implementer relies on
  research and on-demand file reads for that area.
- **Pointer to Document Catalog:** "See the Freshness Metadata section
  in Document-Catalog.md for which documents carry the
  `last-validated` field."
- **Triage belongs to sweeps, not story start.** The three-option
  triage (re-validate / mark for refresh / accept staleness) is NOT
  performed at story/task start. It belongs only in periodic sweeps
  — maintenance sessions for sprint projects, on-demand sweeps for
  non-sprint projects.

Update the "Starting a Story" step 2 to reference the freshness check:
change "Read relevant project docs on demand: Architecture Overview,
Data Model, relevant ADRs, research notes" to include a freshness
qualifier: "Read relevant project docs on demand, applying the
freshness check described above."

The Patch path step 2 gets the same freshness qualifier.

The Deep Story path step 1 (research phase) does not need a freshness
qualifier — research reads the actual codebase, which is always fresh.

**Integration points:**
- References Document-Catalog.md for the field definition
- Referenced by integration templates (CLAUDE.md, copilot-instructions.md)
- Referenced by task-workflow.md (same freshness check applies)
- Upstream of sprint-coordination.md (maintenance sweep validates;
  development-workflow consumes the validation result)

---

### 3. `core/workflows/protocols/sprint-coordination.md`

**What changes:**

Two additions:

**A. Freshness sweep in maintenance phase.** Add a paragraph to the
"Maintenance chat" description, after the existing maintenance
checklist reference. Content:

"The maintenance session includes a freshness sweep: check each
Tier 1 document's `last-validated` field against the project's
freshness threshold. For each stale document, the orchestrator
presents three options to the owner: (1) Re-validate — confirm the
doc is still accurate, update `last-validated` to today. (2) Mark for
refresh — add a Patch-tier story to the backlog to update the doc.
(3) Accept staleness — acknowledge the staleness but take no action;
the system continues treating the document as stale during story start
context loading."

This integrates with the existing maintenance-checklist.md reference
(the detailed checklist item would be added to consumer project
checklists during bootstrap/update, not to the canonical
sprint-coordination file).

**B. Stale doc surfacing in retro phase.** Add a sentence to the
"Sprint Retro chat" description, after the existing retro description.
Content:

"The scrum-master includes stale document findings from the
maintenance session's freshness sweep in the retro report. If any
Tier 1 docs went stale during the sprint, the retro surfaces them:
which docs, how long stale, and whether they were loaded with caveat
during story chats."

**C. Non-sprint project sweep note.** Add a brief paragraph after the
maintenance sweep paragraph noting: "For non-sprint projects that
do not use sprint-coordination, the freshness sweep is triggered
on demand by the owner or via optional post-task prompts (e.g., 'This
task changed [area]. [Doc] covers this area, last validated [date].
Want to re-validate?'). The three-option triage is the same; only the
trigger mechanism differs."

**Integration points:**
- References Document-Catalog.md for which docs carry the field
- Upstream of development-workflow.md (sweep validates, story start
  consumes)
- Referenced by the scrum-master agent prompt (but the agent prompt
  itself does NOT change — the scrum-master reads sprint-coordination
  for its protocol)

---

### 4. `core/templates/Domain-Language-Template.md`

**What changes:**

Add `last-validated: YYYY-MM-DD` to the existing YAML frontmatter,
after the `updated` field. This template represents a Tier 1 document
that is context-loaded at story start. The consumer fills in the
actual date during bootstrap or validation.

**Integration points:**
- Referenced by Document-Catalog.md (template pointer for Domain
  Language)
- Used by bootstrap to create consumer Domain Language docs

---

### 5. `core/templates/Project-Charter-Template.md`

**What changes:**

Add `last-validated: YYYY-MM-DD` to the existing YAML frontmatter,
after the `updated` field. The Project Charter is a Tier 1 document
used for agentic-workflow and sprint-based project types.

**Integration points:**
- Referenced by Document-Catalog.md (template pointer for Project
  Charter)
- Used by Design Alignment to create charters

---

### 6. `core/templates/PRD-Template.md`

**What changes:**

Add `last-validated: YYYY-MM-DD` to the existing YAML frontmatter,
after the `updated` field. PRDs are Tier 1 documents used for
agentic-workflow and sprint-based project types.

**Integration points:**
- Referenced by Document-Catalog.md (template pointer for PRD)
- Used by Design Alignment to create PRDs

---

### 7. `integrations/claude-code/CLAUDE.md`

**What changes:**

Two additions:

**A. Session Lifecycle — freshness note.** In the "Session Start
(Orientation)" section, after step 2 ("Read the current sprint's
progress file"), add a note: "When reading Tier 1 context documents
(Architecture Overview, Data Model, Canonical Patterns, etc.), the
orchestrator checks the document's `last-validated` frontmatter against
the project's freshness threshold. If stale, the orchestrator emits a
one-line note during orientation (e.g., 'Note: Architecture Overview
last validated 6 weeks ago') and loads the document with a caveat.
Stale docs are never automatically skipped — Strategy A (skip) is only
used when the owner explicitly overrides. See
`[FABRIKA_PATH]/core/workflows/types/development-workflow.md`
(Freshness-Aware Context Loading)."

**B. Key Constraints — freshness bullet.** Add a bullet to Key
Constraints after the "Compaction at phase transitions" bullet:
"**Freshness-aware context loading.** Before loading Tier 1 context
documents at story/task start, the orchestrator checks `last-validated`
against the project's freshness threshold. Stale docs are loaded with
a caveat (universal default). The orchestrator decides what to include
in dispatch payloads — the implementer receives whatever context the
orchestrator gives it. See
`[FABRIKA_PATH]/core/workflows/types/development-workflow.md`."

**Integration points:**
- References development-workflow.md for the full protocol
- Consumer projects copy this template — freshness awareness reaches
  all Claude Code consumer projects through this channel

---

### 8. `integrations/copilot/copilot-instructions.md`

**What changes:**

Same as CLAUDE.md changes — add a passive freshness note to Session
Lifecycle orientation (one-line warning, then load with caveat) and a
freshness bullet to Key Constraints (universal Strategy B default,
orchestrator controls dispatch payloads), with identical content and
placement.

**Integration points:**
- References development-workflow.md for the full protocol
- Consumer projects copy this template for Copilot

---

### 9. `Domain-Language.md`

**What changes:**

Add three new terms to the Workflow section, after the "Compaction"
entry (placing freshness concepts near compaction reinforces the
sibling relationship — both are cross-cutting principles governing
context quality):

**Freshness signal** — The `last-validated` frontmatter field on
Tier 1 context documents, recording the date when a human or agent
last confirmed that the document accurately reflects the current
codebase. Not auto-updated on every edit — explicitly set during
validation. The orchestrator reads this field during story/task start
to decide whether the document is fresh (load normally) or stale
(load with a caveat). See `core/Document-Catalog.md` for which
documents carry the field. [Introduced in 0.31.0.]

**Staleness threshold** — The configurable duration after which a
Tier 1 document's `last-validated` date is considered potentially
stale. Default: 2 completed sprints (~4 weeks). Recorded in the
project's instruction file (CLAUDE.md or equivalent) as
`freshness-threshold`. Individual documents can override the global
threshold via their own `freshness-threshold` frontmatter field. The
orchestrator compares `last-validated` against this threshold during
story/task start context loading. [Introduced in 0.31.0.]

**Freshness validation** — The process of confirming that a Tier 1
document still accurately reflects the current codebase and updating
its `last-validated` date. Happens during sprint maintenance (for
sprint projects), on-demand sweeps (for non-sprint projects),
optionally post-story/task (if the work significantly changed an area
covered by a doc), and on demand. Three sweep outcomes: re-validate
(update `last-validated`), mark for refresh (add Patch-tier story to
backlog), or accept staleness (take no action). [Introduced in
0.31.0.]

**Integration points:**
- Defines terms used in Document-Catalog.md, development-workflow.md,
  sprint-coordination.md, and integration templates
- Read by agents during orientation when Domain Language exists

---

### 10. `core/workflows/types/task-workflow.md`

**What changes:**

Add a brief freshness check note to the task-start context loading
section. The freshness check is universal — task-workflow projects
that load Tier 1 docs at task start apply the same passive freshness
check as development-workflow. Content:

"When reading Tier 1 context documents at task start, the orchestrator
checks the document's `last-validated` frontmatter against the
project's freshness threshold. If stale, the orchestrator emits a
one-line note (e.g., 'Note: Architecture Overview last validated 6
weeks ago') and loads the document with a caveat. See
`core/workflows/types/development-workflow.md` (Freshness-Aware
Context Loading) for the full protocol."

This is a brief cross-reference, not a full restatement of the
protocol. The development-workflow.md section is the single source
of truth for freshness behavior.

**Integration points:**
- References development-workflow.md for the full protocol
- Ensures freshness awareness is not limited to sprint-based projects

---

### 11. `VERSION`

`0.30.0` -> `0.31.0`

---

### 12. `CHANGELOG.md`

Add a new entry at the top (after the header, before the 0.30.0
entry):

```
## 0.31.0 — Freshness-aware context loading

Introduces a freshness signal for Tier 1 context documents across all
workflow types. Each Tier 1 doc gets a `last-validated` frontmatter
field. The orchestrator checks this against a configurable staleness
threshold during story/task start: fresh docs load normally, stale
docs are loaded with a caveat (Strategy B, universal default).
Strategy A (skip and research) exists only as an explicit owner
override. The freshness check at story/task start is passive — a
one-line warning during orientation, then proceed. The three-option
triage belongs only in periodic sweeps: sprint maintenance for sprint
projects, on-demand sweeps for non-sprint projects. This is the
context quality companion to CR-20's compaction principle — compaction
governs what agents produce, freshness governs what the orchestrator
loads.

### Changed files
- `core/Document-Catalog.md` — added Freshness Metadata subsection
  describing the `last-validated` field, which documents carry it, and
  consumer guidance
- `core/workflows/types/development-workflow.md` — added
  Freshness-Aware Context Loading section before Starting a Story;
  Strategy B (load with caveat) as universal default; Strategy A (skip
  and research) as owner override only; passive one-line warning at
  story start; freshness qualifier added to story-start context
  loading steps
- `core/workflows/types/task-workflow.md` — added freshness check
  cross-reference to task-start context loading
- `core/workflows/protocols/sprint-coordination.md` — added freshness
  sweep to maintenance phase (three-option triage); added stale doc
  surfacing to retro phase; added note on non-sprint on-demand sweeps
- `core/templates/Domain-Language-Template.md` — added
  `last-validated: YYYY-MM-DD` to frontmatter
- `core/templates/Project-Charter-Template.md` — added
  `last-validated: YYYY-MM-DD` to frontmatter
- `core/templates/PRD-Template.md` — added `last-validated: YYYY-MM-DD`
  to frontmatter
- `integrations/claude-code/CLAUDE.md` — added freshness note to
  Session Lifecycle orientation; added freshness bullet to Key
  Constraints
- `integrations/copilot/copilot-instructions.md` — same changes as
  CLAUDE.md
- `Domain-Language.md` — added terms: freshness signal, staleness
  threshold, freshness validation

### Consumer update instructions
1. Update `core/Document-Catalog.md` from Fabrika source (new
   Freshness Metadata subsection)
2. Update `core/workflows/types/development-workflow.md` from Fabrika
   source (new Freshness-Aware Context Loading section and
   story-start step updates)
3. If your project uses task-workflow, update
   `core/workflows/types/task-workflow.md` from Fabrika source
   (freshness check cross-reference at task start)
4. Update `core/workflows/protocols/sprint-coordination.md` from
   Fabrika source (freshness sweep in maintenance, stale docs in retro,
   non-sprint sweep note)
5. Update templates from Fabrika source — `Domain-Language-Template.md`,
   `Project-Charter-Template.md`, `PRD-Template.md` (new
   `last-validated` frontmatter field)
6. Update your project instruction file (CLAUDE.md or
   copilot-instructions.md) from integration template (freshness
   orientation note and Key Constraints bullet)
7. If your project maintains a Domain Language file, add the three
   new terms (freshness signal, staleness threshold, freshness
   validation) or update from Fabrika source
8. Add `freshness-threshold: 2-sprints` (or your preferred value) to
   your project's instruction file
9. For existing Tier 1 documents, add `last-validated: [today's date]`
   to their frontmatter — they are accurate as of now
```

---

## Integration Point Analysis

| Changed file | References from | Sync required |
|-------------|----------------|---------------|
| `core/Document-Catalog.md` | `development-workflow.md` (freshness check points here for field definition); `sprint-coordination.md` (sweep points here for which docs carry it); bootstrap protocols | Freshness Metadata section must accurately describe which docs carry `last-validated` |
| `core/workflows/types/development-workflow.md` | Integration templates (`CLAUDE.md`, `copilot-instructions.md`) point to this for the full protocol; `sprint-coordination.md` references this file for story-start behavior; `task-workflow.md` cross-references this for the full protocol | Strategy B as universal default and Strategy A as owner override must be consistent across all references |
| `core/workflows/types/task-workflow.md` | `development-workflow.md` (full protocol); `Document-Catalog.md` (field definition) | Cross-reference to development-workflow.md must match that file's section name |
| `core/workflows/protocols/sprint-coordination.md` | Integration templates reference this for phase transitions; scrum-master agent reads this for its protocol | Freshness sweep description must align with Document-Catalog field definition and development-workflow strategies; non-sprint sweep note must be present |
| `core/templates/Domain-Language-Template.md` | `Document-Catalog.md` lists this as the template for Domain Language docs | `last-validated` field placement must be consistent with other templates |
| `core/templates/Project-Charter-Template.md` | `Document-Catalog.md` lists this as the template for Project Charter | Same field placement consistency |
| `core/templates/PRD-Template.md` | `Document-Catalog.md` lists this as the template for PRD | Same field placement consistency |
| `integrations/claude-code/CLAUDE.md` | Consumer projects copy this template | References to development-workflow.md must use `[FABRIKA_PATH]` placeholder correctly |
| `integrations/copilot/copilot-instructions.md` | Consumer projects copy this template for Copilot | Same reference format as CLAUDE.md |
| `Domain-Language.md` | Referenced by all files using freshness terminology | Term definitions must match how the terms are used in all other changed files |

---

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Inconsistent strategy descriptions | `development-workflow.md`, `CLAUDE.md`, `copilot-instructions.md` | Strategy A/B described differently in the workflow file vs. integration templates. Orchestrators in consumer projects read the integration template first and may get a different understanding than what the workflow file specifies. |
| 2 | Template frontmatter inconsistency | `Domain-Language-Template.md`, `Project-Charter-Template.md`, `PRD-Template.md` | `last-validated` placed at different positions in the frontmatter across templates, or with different placeholder formats (some use `YYYY-MM-DD`, one uses a different format). Consumer confusion about field placement. |
| 3 | Missing templates for Tier 1 engineering docs | `Document-Catalog.md` | Document Catalog describes `last-validated` for Tier 1 docs (Architecture Overview, Data Model, Canonical Patterns, Testing Strategy), but no templates exist for these docs. Consumers may not know to add the field when creating them during bootstrap. |
| 4 | Maintenance sweep scope ambiguity | `sprint-coordination.md`, `Document-Catalog.md` | Sprint-coordination says "check each Tier 1 document" but does not list which specific documents. Without a cross-reference to Document-Catalog, the maintenance session may check the wrong docs or miss docs. |
| 5 | Staleness threshold not defined in project instruction file | `development-workflow.md`, `CLAUDE.md` | The freshness check references a `freshness-threshold` value from the project instruction file, but if the consumer never sets it, the orchestrator has no threshold to check against. |

---

## Mitigations

| Risk # | Mitigation |
|--------|-----------|
| 1 | Integration templates use a concise summary (one bullet each for orientation and constraints) and point to `development-workflow.md` for the full protocol. The templates state the universal default (Strategy B, load with caveat) and note that Strategy A is an owner override only, then defer to the workflow file for details. The workflow file is the single source of truth for strategy behavior. |
| 2 | All three templates place `last-validated: YYYY-MM-DD` immediately after the `updated:` field in frontmatter. Consistent position, consistent placeholder format. The implementer verifies this during execution. |
| 3 | The Document-Catalog Freshness Metadata section explicitly states: "For Tier 1 documents created during bootstrap that do not have a canonical template (Architecture Overview, Data Model, Canonical Patterns, Testing Strategy, etc.), add `last-validated: [bootstrap date]` to the frontmatter during creation." This is guidance, not a template change — the docs are created from project knowledge, and bootstrap adds the field. |
| 4 | Sprint-coordination's freshness sweep paragraph includes a pointer: "See the Freshness Metadata section in Document-Catalog.md for which documents carry the `last-validated` field." The Document Catalog is the single source of truth for the list. |
| 5 | The development-workflow Freshness-Aware Context Loading section states the default threshold: "Default: 2 completed sprints (~4 weeks). If no threshold is configured, use the default." The integration template CHANGELOG consumer update instructions explicitly tell consumers to add the threshold to their instruction file. |

---

## Owner Decision Points

All six design decisions from the CR were resolved above (see Design
Decision Resolutions). No remaining items require owner judgment
beyond standard plan approval.

One scope question worth confirming: **which templates get
`last-validated`?** The plan adds it to the three Tier 1 templates
that exist and are context-loaded at story start:
Domain-Language-Template, Project-Charter-Template, PRD-Template. The
engineering Tier 1 docs (Architecture Overview, Data Model, etc.) do
not have canonical templates — they are created from project knowledge
during bootstrap. The Document Catalog provides guidance for adding
the field to those docs. The backlog templates (Story-Template,
Epic-Template, Sprint-Template) are NOT context-loaded Tier 1 docs in
the freshness sense — they are workflow artifacts, not structural
knowledge documents. If the owner wants `last-validated` on additional
templates, the plan can be amended.

---

## Verification Checklist (for Step 4 agents)

- [ ] `core/Document-Catalog.md` contains a Freshness Metadata
  subsection under How to Use This Catalog
- [ ] Freshness Metadata section describes `last-validated` field,
  lists which documents carry it, and provides bootstrap guidance
- [ ] Freshness Metadata section references development-workflow.md
  for behavioral logic
- [ ] `core/workflows/types/development-workflow.md` contains a
  Freshness-Aware Context Loading section before Starting a Story
- [ ] Strategy B (load with caveat) is described as the universal
  default for all tiers; Strategy A (skip and research) is described
  as an owner override only, never an automatic default
- [ ] The freshness check at story/task start is explicitly passive —
  one-line warning during orientation, then load with caveat, no
  blocking, no user interaction, no triage at start
- [ ] The three-option triage is limited to periodic sweeps only, not
  story/task start
- [ ] The freshness check is described as universal (all workflow types
  that load Tier 1 docs), not limited to sprint-based projects
- [ ] Starting a Story steps 1-2 and Patch path step 2 include
  freshness qualifiers
- [ ] Default threshold is stated (2 completed sprints / ~4 weeks)
- [ ] `core/workflows/types/task-workflow.md` includes a freshness
  check cross-reference to development-workflow.md
- [ ] `core/workflows/protocols/sprint-coordination.md` maintenance
  phase includes freshness sweep with three-option triage
- [ ] Sprint-coordination retro phase includes stale doc surfacing
- [ ] Sprint-coordination includes non-sprint on-demand sweep note
- [ ] Sprint-coordination freshness sweep references Document-Catalog
  for which docs carry the field
- [ ] `Domain-Language-Template.md`, `Project-Charter-Template.md`,
  and `PRD-Template.md` all have `last-validated: YYYY-MM-DD` in
  frontmatter, placed after `updated:`
- [ ] Both integration templates have passive freshness orientation
  note in Session Lifecycle (one-line warning, load with caveat)
- [ ] Both integration templates have freshness bullet in Key
  Constraints, placed after "Compaction at phase transitions"
- [ ] Integration templates describe Strategy B as universal default
  and note that the orchestrator controls dispatch payloads
- [ ] `Domain-Language.md` defines freshness signal, staleness
  threshold, and freshness validation in the Workflow section after
  Compaction
- [ ] All three Domain Language terms include `[Introduced in 0.31.0.]`
  tags
- [ ] VERSION is 0.31.0
- [ ] CHANGELOG 0.31.0 entry exists and lists all changed files
- [ ] CHANGELOG consumer update instructions are complete — all 9
  consumer actions listed
- [ ] CHANGELOG describes Strategy B as universal default, not
  tier-based defaults
- [ ] No agent prompt files were modified
- [ ] No smell test violations (no personal references, no downstream
  product names, no tool-specific assumptions, makes sense to a
  stranger)
- [ ] Cross-references are consistent: Document-Catalog defines the
  field, development-workflow defines the behavior, task-workflow
  cross-references development-workflow, sprint-coordination defines
  the maintenance sweep, integration templates point to
  development-workflow, Domain Language defines the terms

---

## Alignment History

- **v1:** Initial plan. 2026-05-03. No revisions yet.
- **v2:** Owner-approved revision. 2026-05-03. Four amendments applied:
  (1) Strategy B (load with caveat) is now the universal default for
  all tiers — Strategy A exists only as an explicit owner override,
  never an automatic default. Owner rationale: stale-but-mostly-
  accurate context is almost always cheaper than reconstructing from
  scratch. (2) Freshness check at story/task start is passive — a
  one-line warning during orientation, then proceed with Strategy B.
  No blocking, no triage at start. The three-option triage belongs
  only in periodic sweeps. (3) Freshness check is universal across
  all workflow types that load Tier 1 docs (not limited to sprint
  projects). The periodic sweep cadence is workflow-specific: sprint
  maintenance for sprint projects, on-demand for non-sprint projects.
  Task-workflow.md added to file change inventory. Analytics-workspace
  exclusion removed from scope boundary. (4) Clarified throughout that
  the orchestrator checks freshness and decides what to include in
  dispatch payloads; the implementer receives whatever context the
  orchestrator gives it. Status changed to `approved`.
