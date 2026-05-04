---
type: evaluation
status: complete
created: 2026-05-03
evaluator: methodology-reviewer
change-request: planning/CR-19-adhoc-workflow.md
plan: docs/plans/CR-19-plan.md
verdict: PASS WITH NOTES
---

# CR-19 Methodology Review

**Verdict: PASS WITH NOTES**

The implementation is well-executed. Terminology is consistent across
all modified files, the backlog type model is coherent, integration
templates are in sync, and the Document-Catalog correctly documents
simple mode artifact behavior. Two notes are raised: one about stale
language in the prior CHANGELOG entry (0.29.0) and one about wiki
topic articles that now contain outdated framing. Neither blocks
shipping.

---

## 1. Cross-Reference Consistency

**Finding: PASS**

Terminology alignment is strong across all eight modified files. The
key terms introduced or redefined in Domain-Language.md -- backlog
type, bug, epic, simple mode, work type routing, and the reframing of
complexity tier/patch/story/deep story as story-internal -- are used
consistently everywhere they appear.

Specific checks performed:

- **"Backlog type" usage.** Domain-Language.md (line 385) defines it.
  Integration templates CLAUDE.md (line 35) and copilot-instructions.md
  (line 35) both use "backlog types" in the routing section. The
  development workflow (line 35) cross-references task and bug ceremony
  via task-workflow.md and Domain-Language.md. Document-Catalog (line
  554) uses "Backlog type applicability" in the Base Documents
  blockquote. Consistent.

- **"Simple mode" usage.** Domain-Language.md (line 411) defines it.
  Task-workflow.md (lines 57-101) documents it fully. Integration
  templates both reference it in the Work Type Routing subsection
  (CLAUDE.md line 39, copilot line 39) and in the task-workspace agent
  table (CLAUDE.md lines 550-558, copilot lines 370-377).
  Document-Catalog task-workspace Quick Reference (lines 926-930)
  correctly documents that simple mode produces no task folder or
  plan.md. Consistent.

- **"Story-internal tiers" framing.** Domain-Language.md (lines
  331-341) reframes complexity tier with "internal to story-type work."
  Development-workflow.md (lines 33-37) states "Patch, Story, and Deep
  Story are ceremony tiers internal to story-type work." Integration
  templates both use "Complexity Tiers (story-internal)" in the
  Development Workflow summary (CLAUDE.md line 364, copilot line 273)
  and "they do not apply to tasks, bugs, or epics" (CLAUDE.md line
  366, copilot line 275). Consistent.

- **"Work type routing" as orchestrator question.** Domain-Language.md
  (line 421) defines it. Both integration templates present the same
  routing question and signals (CLAUDE.md lines 31-65, copilot lines
  31-65). Task-workflow.md does not repeat the routing question (it
  documents the workflow itself, not how to arrive at it). Appropriate
  decomposition.

- **"Bug" definition.** Domain-Language.md (lines 395-400) defines bug
  as "task with reproduction context." Task-workflow.md Bug Tasks
  section (lines 107-124) mirrors the definition with the four brief
  fields (observed, expected, reproduction steps, environment).
  Integration templates (CLAUDE.md line 42, copilot line 42) summarize
  consistently. Document-Catalog Base Documents blockquote (lines
  550-551) mentions "bugs include reproduction context fields."
  Consistent.

- **"Epic" definition.** Domain-Language.md (lines 402-409) defines it
  as a coordination envelope with mechanics deferred to CR-24.
  Integration templates (CLAUDE.md lines 48-50, copilot lines 48-50)
  use the same "coordination envelope" language. Document-Catalog Base
  Documents blockquote (lines 555-557) correctly notes "Epics have no
  execution documents -- they are a coordination envelope." Consistent.

- **"Ad-hoc" retirement.** Domain-Language.md (lines 431-435)
  documents ad-hoc as a historical term. No modified file uses "ad-hoc"
  as an active concept. The uses that remain in modified files are
  appropriate: CHANGELOG 0.30.0 entry (line 29, 52) documents the
  retirement itself, and Architect role description in
  Domain-Language.md (line 162) uses "ad hoc mode" correctly (this is
  an architect operating mode, not the retired complexity concept).

---

## 2. Prompt Pattern Adherence

**Finding: PASS**

Each file's new content follows the established patterns of that file.

- **Domain-Language.md.** New terms follow the established format:
  bold term name, em-dash, definition, bracketed version attribution.
  The reframed terms (Complexity tier, Patch, Story, Deep Story) retain
  their existing structure and add "[reframed as story-internal in
  0.30.0]" attributions. The historical note for "Ad-hoc" follows a
  lighter format (no bracketed version -- just inline context), which
  is appropriate for a retired term that is not a definition but a
  redirect.

- **Task-workflow.md.** The Simple Mode section (lines 57-101) follows
  the existing section pattern: bold subsection headers ("What it is,"
  "Scope assessment threshold," etc.) with explanatory paragraphs. The
  Bug Tasks section (lines 105-124) uses the same format. The
  introductory paragraph (lines 7-8) was updated to mention simple
  mode, matching the file's convention of front-loading key concepts.

- **Development-workflow.md.** The clarifying paragraph (lines 33-37)
  is placed at the top of the Tier-Conditional Workflow Branching
  section, before the existing tier path definitions. It does not alter
  any behavioral logic -- it only adds framing. The paragraph
  explicitly states tiers "are unchanged from 0.29.0," following the
  plan's Risk #4 mitigation.

- **Integration templates.** The Work Type Routing subsection is
  placed under Workflow Composition in both CLAUDE.md (line 31) and
  copilot-instructions.md (line 31). This placement follows the plan's
  recommendation (applies across all workflow types, not just
  development). The Development Workflow summary updates use the
  parenthetical "story-internal" label consistently.

- **Document-Catalog.** The backlog type applicability note is placed
  as a blockquote within the Base Documents section (lines 539-557),
  following the catalog's existing convention of using blockquotes for
  section-level commentary. The task-workspace Quick Reference (lines
  925-930) adds "standard mode" and "simple mode" sub-entries, which
  follows the analytics-workspace pattern of distinguishing artifact
  sets by mode.

---

## 3. Instruction Decomposition Quality

**Finding: PASS**

Content is placed at the right level of detail in each file, without
duplication.

- **Domain-Language.md** defines concepts. **Task-workflow.md**
  documents behavior. **Integration templates** teach routing. Each
  file serves its audience without restating the other. For example,
  simple mode's scope threshold is defined authoritatively in
  task-workflow.md (lines 68-76); integration templates reference the
  concept at summary level (CLAUDE.md line 59: "simple mode if the plan
  fits in a sentence or two") without duplicating the full guidance.

- **Document-Catalog** does not restate what simple mode IS -- it
  states what artifacts simple mode produces (or skips). This is the
  catalog's job.

- **Development-workflow.md** does not re-explain backlog types -- it
  cross-references task-workflow.md and Domain-Language.md for
  non-story work (line 36-37). Clean pointer, no duplication.

---

## 4. Smell Test Compliance

**Finding: PASS**

Checked all modified files against the four smell test questions:

- No LifeOS, Obsidian, Motion, or PARA assumptions.
- No assumption that the user is one specific person.
- No downstream product names (Notnomo, Hearthen, MNEMOS, Opifex,
  edw labs, VerbumEng) in canonical content.
- A stranger cloning the repo would understand the backlog type model
  without needing to know Fabrika's history. The "Ad-hoc" historical
  note in Domain-Language.md is minimal and self-contained -- it
  explains what the term was and where it went, without requiring
  prior context.

---

## 5. Consumer Update Completeness

**Finding: PASS**

The CHANGELOG consumer update instructions (lines 50-65) list all six
modified files with specific instructions per file:

1. Domain-Language.md -- copy
2. core/workflows/types/task-workflow.md -- copy
3. core/workflows/types/development-workflow.md -- copy
4. Integration template -- update from template (Work Type Routing
   subsection, Development Workflow references, task-workspace
   references)
5. core/Document-Catalog.md -- copy
6. Project Domain Language -- update with new backlog type terms

This covers every file a consumer needs to touch. Instruction #4
correctly tells consumers to update their own instruction file from
the template rather than blindly overwriting (consumers customize
their instruction files). Instruction #6 correctly reminds consumers
to update their own Domain Language if they maintain one.

---

## 6. Dispatch/Output Contract Consistency

**Finding: PASS**

No changes to dispatch-protocol.md or agent prompts -- the plan
explicitly prohibits new agents and templates. Simple mode uses
existing dispatch contracts: contextual dispatch to the implementer
(with the plan embedded in the dispatch context instead of a file
path) and strict dispatch to the reviewer (with the inline plan as
the spec equivalent). Task-workflow.md (lines 89-94) documents the
reviewer's strict dispatch in simple mode. This is consistent with the
dispatch protocol's existing reviewer contract -- the spec is provided
as a field, and whether it comes from a file or inline context does
not change the contract structure.

---

## Notes (Non-Blocking)

### Note 1: Stale language in the 0.29.0 CHANGELOG entry

The 0.29.0 CHANGELOG entry (line 77-78) reads: "the tiers are points
on a universal complexity spectrum spanning ad-hoc through epic." This
is now factually outdated -- 0.30.0 explicitly redefines the universal
complexity spectrum as a type-based model, not a linear scale.

**Why this is non-blocking:** CHANGELOG entries are historical records
of what was said at the time of that version. Retroactively editing a
prior version's description would undermine the CHANGELOG's integrity
as a versioned record. The 0.30.0 entry clearly communicates that the
model has changed. A consumer reading the CHANGELOG sequentially will
see the evolution naturally.

**Recommendation:** No action needed. Leave the 0.29.0 entry as-is.

### Note 2: Wiki topic articles contain pre-0.30.0 framing

Two wiki topic articles contain language that predates the backlog type
reframe:

- `wiki/topics/workflow-design.md` (line 47): "These tiers are the
  sprint-based portion of a universal complexity spectrum spanning
  ad-hoc (CR-19) through task (CR-17/v0.26.0) through
  patch/story/deep story through epic (CR-24) -- the ceremony dial
  that connects all workflow types into a graduated scale."

- `wiki/topics/workflow-design.md` (line 51): "Current State" section
  is "as of v0.29.0" and does not mention the 0.30.0 backlog type
  model.

- `wiki/topics/framework-philosophy.md` (line 33): Uses "ad-hoc fixes"
  in a general English sense (not as the retired framework term) and
  "the taxonomic model" framing that is being superseded.

**Why this is non-blocking:** Wiki articles are not canonical files --
they are synthesis artifacts updated during maintenance sessions and
quarterly reintegration. The plan's scope correctly excludes wiki
files. The normal knowledge pipeline will update these articles when
the wiki is next synthesized against the 0.30.0 CHANGELOG.

**Recommendation:** During the next maintenance session's knowledge
synthesis pass, update `wiki/topics/workflow-design.md` to reflect
the 0.30.0 backlog type model. The workflow-design article is the most
important wiki update because it explicitly describes the complexity
spectrum in terms that 0.30.0 redefines.

### Note 3: README.md not updated

The README.md (line 50) describes analytics-workspace as "Ad hoc
analysis" -- this is general English usage, not the retired framework
term, so it is not a smell test violation. The README was not in the
plan's file change inventory and does not need updating for this CR.

---

## Verification Checklist Results

| Check | Result |
|-------|--------|
| All files referenced in CHANGELOG entry exist | PASS -- all six modified files exist at their stated paths |
| No new agents (per CR scope) | PASS -- no agent files created or modified |
| AGENT-CATALOG matches actual agent files | N/A -- no agent changes |
| Document-Catalog Quick Reference includes new doc types | PASS -- task-workspace Quick Reference updated with simple mode entries (lines 925-930) |
| doc-triggers entries reference existing docs/workflows | N/A -- no doc-trigger changes |
| VERSION matches latest CHANGELOG entry | PASS -- VERSION is 0.30.0, CHANGELOG latest entry is 0.30.0 |
| No smell test violations | PASS -- see criterion 4 above |
| Cross-references consistent | PASS -- see criterion 1 above |
| Integration templates reflect new capabilities | PASS -- both templates have Work Type Routing, updated Development Workflow summary, updated task-workspace agent descriptions |
| Consumer update instructions complete | PASS -- all six files listed with specific instructions |
| Dispatch/output contracts consistent | PASS -- see criterion 6 above |
| README.md accuracy | NOT CHECKED -- README was not in scope for this CR; no new agents, project types, or features that would require README updates |
