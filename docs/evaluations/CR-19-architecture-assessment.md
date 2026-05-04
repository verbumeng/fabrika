---
type: evaluation
status: complete
created: 2026-05-03
evaluator: context-architect
change-request: planning/CR-19-adhoc-workflow.md
plan: docs/plans/CR-19-plan.md
verdict: SOUND
---

# CR-19 Architecture Assessment

**Verdict: SOUND**

The structural design of CR-19 is well-executed. New content lands at
the right granularity, pointer patterns are clean, context budget
impact is proportionate to the value added, and the integration
templates are in full sync. One minor concern (stale CHANGELOG
language in the 0.29.0 entry) does not rise to CONCERNS because the
CHANGELOG is a historical record, not an active instruction document.

---

## 1. Instruction Decomposition

**Assessment: No issues.**

The plan explicitly prohibited new files, and the implementation
followed that constraint correctly. Every new concept lands inside an
existing file at a granularity appropriate to that file's role:

- **Domain-Language.md** gained seven new or reframed terms (Backlog
  type, Bug, Epic, Simple mode, Work type routing, Ad-hoc retirement,
  and reframed Universal complexity spectrum). Each term follows the
  established one-paragraph-per-term pattern. The Workflow section
  grew but remains within comfortable reading length — it was already
  the largest section and the new terms add roughly 80 lines, keeping
  the file well under the decomposition threshold (the file is a
  glossary, which naturally grows linearly with vocabulary).

- **task-workflow.md** gained two new sections (Simple Mode and Bug
  Tasks) placed after the existing Design Alignment section. Both
  sections follow the established pattern of the file: a concept
  heading, prose explanation, and concrete details. The Simple Mode
  section is thorough (scope assessment threshold, what it skips, what
  it keeps, reviewer behavior, promotion to standard mode) without
  being overlong at roughly 45 lines. Bug Tasks is appropriately
  brief at 20 lines. Neither section creates the need for extraction
  into a separate file.

- **development-workflow.md** gained a single clarifying paragraph at
  the top of the Tier-Conditional Workflow Branching section. This is
  the right granularity — it reframes the existing section without
  restructuring it. The paragraph includes a cross-reference to
  task-workflow.md for task/bug ceremony and Domain-Language.md for
  the full vocabulary. Clean.

- **Document-Catalog.md** gained a blockquote applicability note in
  the Base Documents section and a simple/standard mode split in the
  task-workspace Quick Reference. Both are inline additions that do
  not change the structure of the catalog. Correct placement.

- **Integration templates** gained a Work Type Routing subsection
  (~35 lines) and updated the Development Workflow summary and
  task-workspace agent table. The Work Type Routing section is well-
  scoped — it describes the routing question and signals without
  encoding decision trees.

No file now exceeds comfortable reading length. No section does
double duty that would warrant extraction.

---

## 2. Pointer Patterns

**Assessment: No issues.**

Single source of truth is maintained cleanly:

- **Domain-Language.md** is the authoritative definition of all new
  terms. The task-workflow.md Simple Mode section expands on the
  operational details that belong in a workflow file (what gets
  skipped, reviewer behavior, promotion rules) without redefining
  the concept. The integration templates point to task-workflow.md
  for details rather than restating the rules.

- **development-workflow.md** points to task-workflow.md for task and
  bug ceremony rather than explaining it inline. This is the correct
  pointer direction — story-internal tiers are defined in the
  development workflow, task/bug ceremony is defined in the task
  workflow, and neither duplicates the other.

- **Document-Catalog.md** references the task workflow for the
  authoritative simple mode definition rather than restating the
  scope assessment threshold. The Base Documents blockquote states
  what documents apply to which backlog types — it does not redefine
  the types themselves.

- **Integration templates** use "see Work Type Routing above" and
  `[FABRIKA_PATH]/core/workflows/types/task-workflow.md (Simple
  Mode)` as pointers rather than embedding the full rules.

No circular references. No contradictory definitions across files.

---

## 3. Context Budget

**Assessment: No issues.**

The Work Type Routing subsection adds approximately 35 lines to each
integration template. This is within the plan's target of 20-30 lines
of instructional content (it comes in slightly over due to the within-
type ceremony paragraph and the sprint-planned caveat, both of which
are necessary). The section is placed within the Workflow Composition
section, which is the right location because work type routing applies
across all workflow types.

The Development Workflow summary gained one bullet point rewrite
(Complexity Tiers renamed to "Complexity Tiers (story-internal)" with
a cross-reference to Work Type Routing). This is a net-zero context
budget change — the bullet existed before and was reworded, not
expanded.

The task-workspace agent table gained "Skipped in simple mode" and
"In simple mode, reviews against the orchestrator's inline plan"
annotations. These are inline additions to existing table cells, not
new rows or sections. Minimal context cost.

The always-loaded context growth is proportionate to the value: an
orchestrator that knows about backlog types and simple mode on first
load will make better routing decisions without needing to read the
full task-workflow.md file for every task.

---

## 4. Pattern Consistency

**Assessment: No issues.**

- **Domain-Language.md**: New terms follow the established pattern —
  bold term name, em-dash, definition paragraph, version annotation
  in brackets. The Ad-hoc entry follows the retirement pattern
  ("Historical term. ...resolves into...retired from active use as
  of..."). The reframed terms (Complexity tier, Patch, Story, Deep
  Story) append "Reframed as story-internal in 0.30.0" to their
  version brackets, consistent with how prior reframes were handled.

- **task-workflow.md**: The Simple Mode section uses the same
  structural pattern as the existing Design Alignment section —
  heading, prose explanation, then concrete details. The Bug Tasks
  section uses a bullet-list format for the brief structure fields,
  which is appropriate for its shorter content.

- **development-workflow.md**: The clarifying paragraph follows the
  established pattern of the Tier-Conditional Workflow Branching
  section — opening context, then per-tier paths below. The paragraph
  does not accidentally alter the branching logic.

- **Document-Catalog.md**: The Base Documents blockquote follows the
  established pattern of the section — introductory blockquote
  followed by per-document entries. The task-workspace Quick
  Reference uses the same format (bold label, description) as other
  Quick Reference entries.

- **Integration templates**: The Work Type Routing subsection uses
  the same structure as the existing Workflow Composition section —
  prose introduction, bullet list of options, and a closing
  contextual note. The Complexity Tiers bullet in the Development
  Workflow summary uses the same multi-line format as the Deep Story
  bullet it replaced.

- **CHANGELOG**: The 0.30.0 entry follows the established pattern —
  summary paragraph, Changed files section with per-file bullets,
  Consumer update instructions as a numbered list. The entry is
  well-structured and complete.

---

## 5. Integration Surface Completeness

**Assessment: One minor observation, not blocking.**

**Files that were correctly updated:**
- Domain-Language.md — new terms defined
- task-workflow.md — Simple Mode and Bug Tasks sections added
- development-workflow.md — clarifying paragraph added
- integrations/claude-code/CLAUDE.md — Work Type Routing, Complexity
  Tiers rewrite, task-workspace agent table updated
- integrations/copilot/copilot-instructions.md — same changes, in sync
- Document-Catalog.md — backlog type applicability, task-workspace
  Quick Reference
- VERSION — bumped to 0.30.0
- CHANGELOG.md — 0.30.0 entry with complete consumer update
  instructions

**Files correctly NOT updated (per the plan):**
- Dispatch protocol — Simple mode uses the same contextual dispatch
  to the implementer with the plan embedded in the dispatch context
  rather than in a file. This is consistent with how lightweight
  dispatch already works (inline plan text in the dispatch payload,
  documented in the dispatch-protocol.md lightweight dispatch
  section). No new dispatch contract needed.
- Agent prompts — No new agents; existing base agents (planner,
  implementer, reviewer, validator) are unchanged in behavior. Simple
  mode is an orchestrator routing decision, not an agent behavior
  change.
- Sprint-coordination — Tiers are unchanged. Backlog types are
  assigned during sprint planning only for stories; tasks and bugs
  arrive outside sprint planning. No coordination protocol change
  needed.
- Doc-triggers — No new document types were introduced. Simple mode
  reduces documents (no plan.md, no task folder), which does not
  require a trigger change.
- AGENT-CATALOG.md — No new agents, no roster changes.

**Cross-reference consistency verified:**
- Integration templates' Work Type Routing sections are character-for-
  character identical between CLAUDE.md and copilot-instructions.md.
- Integration templates' Development Workflow summaries are identical.
- Integration templates' task-workspace agent tables are functionally
  identical (minor whitespace difference in the prose paragraph below
  the table — CLAUDE.md includes "The task workflow is the base
  lifecycle: brief -> plan -> implement -> review -> validate ->
  deliver." while copilot-instructions.md omits this sentence; this
  is a pre-existing difference, not introduced by CR-19).
- Domain-Language definitions are consistent with task-workflow.md
  operational descriptions.
- Document-Catalog backlog type applicability is consistent with
  Domain-Language backlog type definitions.

**Observation (not blocking):** The CHANGELOG 0.29.0 entry still
reads "the tiers are points on a universal complexity spectrum
spanning ad-hoc through epic." This language describes the now-retired
linear spectrum model. However, the CHANGELOG is a historical record —
it documents what 0.29.0 introduced at the time, not the current
conceptual framework. Updating historical CHANGELOG entries would be
revisionism. The 0.30.0 entry immediately following it reframes the
model, which provides adequate context for any reader scanning
chronologically.

**"Ad-hoc" references in canonical files:** The plan's Risk #6
mitigation required grepping canonical files for stale "ad-hoc"
references. I verified the following:
- BOOTSTRAP.md uses "ad hoc" in the analytics-workspace type signal
  table ("ad hoc analysis, investigation...") — this is a description
  of the analytics workflow's purpose, not the retired "ad-hoc" as a
  backlog type or tier. Correct usage.
- Agent prompts (data-architect, software-architect archetypes) use
  "ad hoc mode" to describe the architect's third operating mode.
  This is an agent capability mode, not the retired backlog type
  concept. Correct usage.
- hooks-reference.md uses "ad hoc" to describe non-session commits.
  This is a general English usage, not the retired concept. Correct
  usage.
- Document-Catalog.md uses "ad hoc analysis" in the analytics-
  workspace type description. Same as BOOTSTRAP.md — correct usage.
- Domain-Language.md's "Ad-hoc" entry properly marks the term as
  historical and explains what it resolves into. Correct.

No stale references found in canonical files that use "ad-hoc" as an
active backlog type or tier concept.

---

## Summary

The CR-19 implementation demonstrates disciplined structural design:

1. New content at the right granularity — no decomposition needed, no
   file doing double duty.
2. Clean pointer patterns — single source of truth maintained for
   every concept, no content duplication.
3. Proportionate context budget impact — ~35 lines added to always-
   loaded templates, justified by the routing value they provide.
4. Consistent patterns — every new section follows the structural
   conventions of its host file.
5. Complete integration surface — all cross-references verified, both
   integration templates in sync, no files missed.

The implementation correctly navigated the "ad-hoc" retirement by
distinguishing between the retired backlog type concept and the
legitimate English-language uses of "ad hoc" throughout the codebase.
