# Methodology Review — CR-21: Freshness-Aware Context Loading

**Reviewer:** methodology-reviewer
**Version under review:** 0.31.0
**Plan:** `docs/plans/CR-21-plan.md`
**Date:** 2026-05-03

---

## Verdict: PASS WITH NOTES

All six criteria satisfied. The implementation faithfully executes the
approved plan across all 12 changed files. Cross-references form a
coherent chain: Document-Catalog defines the field, development-workflow
defines the behavior, task-workflow cross-references it, sprint-coordination
defines the maintenance sweep, integration templates point to
development-workflow, and Domain Language defines the terms. One minor
note regarding README.md coverage of the new capability. Detailed
findings below.

---

## Criterion 1: Cross-reference consistency

**Result: PASS**

All cross-references between changed files resolve correctly and form
coherent bidirectional chains. The freshness signal, Strategy A/B, and
staleness threshold are described consistently across all files.

Evidence:

- **development-workflow.md -> Document-Catalog.md:** The
  Freshness-Aware Context Loading section's closing paragraph
  references `core/Document-Catalog.md` for "which documents carry
  the `last-validated` field" (line 202). The Document-Catalog
  Freshness Metadata subsection at line 65 confirms this content
  exists with the correct list of documents.

- **development-workflow.md -> sprint-coordination.md:** The "Triage
  belongs to sweeps, not story start" paragraph references
  `core/workflows/protocols/sprint-coordination.md` for the sprint
  maintenance sweep (line 199-200). Sprint-coordination contains the
  freshness sweep at line 76. Path resolves.

- **Document-Catalog.md -> development-workflow.md:** The Freshness
  Metadata section references
  `core/workflows/types/development-workflow.md` (Freshness-Aware
  Context Loading) for the behavioral protocol (line 83). The
  section exists at line 154 of development-workflow.md.

- **Document-Catalog.md -> sprint-coordination.md:** The Freshness
  Metadata section references
  `core/workflows/protocols/sprint-coordination.md` for the periodic
  freshness sweep (lines 85-86). Sprint-coordination contains this
  content.

- **task-workflow.md -> development-workflow.md:** The freshness check
  note at line 134 references
  `core/workflows/types/development-workflow.md` (Freshness-Aware
  Context Loading) for the full protocol. Path and section name
  resolve correctly.

- **sprint-coordination.md -> Document-Catalog.md:** The maintenance
  freshness sweep paragraph references "the Freshness Metadata section
  in `core/Document-Catalog.md`" for which documents carry the field
  (line 76). The section exists at line 65.

- **Integration templates -> development-workflow.md:** Both
  `integrations/claude-code/CLAUDE.md` (lines 299 and 681) and
  `integrations/copilot/copilot-instructions.md` (lines 212 and 598)
  reference `[FABRIKA_PATH]/core/workflows/types/development-workflow.md`
  and its Freshness-Aware Context Loading section. Both references
  use the correct `[FABRIKA_PATH]` placeholder pattern.

- **Domain-Language.md -> Document-Catalog.md:** The "Freshness
  signal" entry references `core/Document-Catalog.md` for which
  documents carry the field (line 319). Path resolves.

- **Strategy consistency across files:** Strategy B is consistently
  described as "load with caveat" and identified as the universal
  default in: development-workflow.md (line 181), CLAUDE.md (line
  681), copilot-instructions.md (line 598), and CHANGELOG (line 14).
  Strategy A is consistently described as "skip and research" and
  identified as an owner override only in: development-workflow.md
  (line 188), CLAUDE.md (line 299), copilot-instructions.md (line
  212), and CHANGELOG (lines 14-15). No contradictions.

- **Default threshold consistency:** The default freshness threshold
  "2 completed sprints (~4 weeks)" is stated consistently in:
  development-workflow.md (line 164), Domain-Language.md staleness
  threshold entry (line 323), and CHANGELOG consumer update step 8
  (line 76). No contradictions.

No orphaned or broken references found.

---

## Criterion 2: Prompt pattern adherence

**Result: PASS**

New sections follow the established writing patterns of their host
files in heading levels, paragraph style, and cross-reference format.

Evidence:

- **Document-Catalog.md — Freshness Metadata subsection:** Placed
  under "How to Use This Catalog" after the Audience Markers table
  (line 65), matching the plan's specified location. Uses the same
  subsection heading level (###) as Project Types, Priority Tiers,
  and Audience Markers. Content is concise at ~20 lines, within the
  plan's guidance of 10-15 lines (slightly over but not
  over-expanded). Paragraph style matches the catalog's direct,
  functional prose.

- **development-workflow.md — Freshness-Aware Context Loading
  section:** Uses a `##` heading (line 154) consistent with other
  major sections like "Design Alignment" (line 6), "Tier-Conditional
  Workflow Branching" (line 33), and "Starting a Story" (line 205).
  Placed between Tier-Conditional Workflow Branching and Starting a
  Story, matching the plan. Internal structure uses bold-lead
  paragraphs (**Freshness threshold.**, **Passive freshness note.**,
  **Strategy B.**, **Strategy A.**, **Triage belongs to sweeps.**)
  which is the same style used in the Tier-Conditional section above
  (bold path names as lead phrases).

- **sprint-coordination.md — Maintenance and retro additions:** The
  freshness sweep paragraph is embedded in the Maintenance chat
  description (line 76) as a continuation paragraph, matching how
  the existing maintenance description flows. The retro addition is
  embedded in the Sprint Retro chat description (line 80) in the
  same inline style. The non-sprint sweep note follows immediately
  after the maintenance sweep (line 78). All three additions are
  integrated into existing paragraphs rather than creating new
  subsections, which matches sprint-coordination.md's dense
  single-paragraph-per-phase style.

- **task-workflow.md — Freshness cross-reference:** Added as a brief
  paragraph (lines 133-140) at the top of the Lifecycle section,
  after the ASCII lifecycle diagram and before the Brief subsection.
  This placement ensures it is read before task-start context loading
  occurs. The cross-reference style ("See `core/workflows/types/
  development-workflow.md` (Freshness-Aware Context Loading) for the
  full protocol") matches the existing cross-reference patterns in
  the file (e.g., line 38's reference to design-alignment.md).

- **Template frontmatter:** All three templates
  (Domain-Language-Template.md, Project-Charter-Template.md,
  PRD-Template.md) add `last-validated: YYYY-MM-DD` immediately
  after `updated: YYYY-MM-DD` with consistent placeholder format.
  Placement is identical across all three.

- **Integration templates — freshness note:** The Session Start
  orientation note is placed after step 2 in both templates,
  matching the plan. The Key Constraints freshness bullet is placed
  immediately after the "Compaction at phase transitions" bullet
  (CLAUDE.md line 681, copilot-instructions.md line 598), matching
  the plan's placement specification and the plan's rationale of
  reinforcing the sibling relationship between compaction and
  freshness.

- **Domain-Language.md — three new terms:** Placed in the Workflow
  section after the Compaction entry (lines 312-338), matching the
  plan. Each term follows the established format: bold term name em
  dash, definition, cross-references, version tag in brackets. All
  three include `[Introduced in 0.31.0.]` consistent with the
  convention used by other recent entries.

- **Voice:** All new content uses direct, lead-with-the-point style.
  No corporate-framework prose. No emojis. Matches VerbumEng writing
  voice.

---

## Criterion 3: Instruction decomposition quality

**Result: PASS**

The freshness protocol is defined once in development-workflow.md with
pointers from all other files. No material duplication.

Evidence:

- **Single source of truth:** development-workflow.md's
  "Freshness-Aware Context Loading" section (lines 154-203) is the
  only place that defines the full behavioral protocol: threshold
  defaults, passive note behavior, Strategy B as default, Strategy A
  as override, triage separation from story start, and the caveat
  note format.

- **Document-Catalog.md:** Defines WHAT the `last-validated` field
  is and WHICH documents carry it. Does not re-state behavioral
  logic. Points to development-workflow.md for "the behavioral
  protocol." Clean separation of field definition from usage logic.

- **sprint-coordination.md:** Defines WHEN periodic validation
  happens (maintenance phase) and the three-option triage mechanism.
  Does not re-state the story-start passive check behavior. Points
  to Document-Catalog.md for which documents carry the field.

- **task-workflow.md:** Brief 6-line cross-reference. States the
  passive check behavior in one sentence and defers to
  development-workflow.md for "the full protocol." Minimal enough
  to orient a reader without duplicating the source.

- **Integration templates:** Summarize in one paragraph (Session
  Lifecycle) and one bullet (Key Constraints). Both point to
  development-workflow.md. The Session Lifecycle note includes
  enough detail for an orchestrator to act on during orientation
  (check `last-validated`, emit one-line note if stale, load with
  caveat) without duplicating the full strategy definitions.

- **Domain-Language.md:** Defines the TERMS. Does not prescribe
  behavior. Points to Document-Catalog.md for field applicability.

The decomposition follows the existing pattern established by CR-20's
compaction principle: definition in a single authoritative file,
one-line awareness pointers in integration templates, and field/term
definitions in their respective homes (Document-Catalog and Domain
Language).

---

## Criterion 4: Smell test compliance

**Result: PASS**

- **No personal references.** No references to LifeOS, Obsidian,
  Motion, PARA, or any personal workflow tools in any changed file.
- **No downstream product names.** No references to Notnomo,
  Hearthen, MNEMOS, Opifex, edw labs, or VerbumEng in any changed
  canonical content.
- **No tool-specific assumptions.** The freshness protocol is
  described in generic terms applicable to any AI coding tool. The
  `last-validated` field uses standard YAML frontmatter conventions.
  The staleness threshold uses a relative measure ("2 completed
  sprints") rather than a tool-specific configuration format.
- **Stranger test.** All content would make sense to a stranger
  cloning the repo for a greenfield project. The freshness concept
  is self-explanatory: documents get stale, the system notices, and
  it loads them with a warning. No insider knowledge required.

---

## Criterion 5: Consumer update completeness

**Result: PASS**

The CHANGELOG 0.31.0 consumer update instructions list 9 actions:

1. Update `core/Document-Catalog.md` -- correct, Freshness Metadata
   subsection added
2. Update `core/workflows/types/development-workflow.md` -- correct,
   Freshness-Aware Context Loading section and story-start step
   updates
3. Update `core/workflows/types/task-workflow.md` (if used) -- correct,
   conditional based on project type
4. Update `core/workflows/protocols/sprint-coordination.md` -- correct,
   freshness sweep and retro additions
5. Update templates -- correct, lists all three templates by name
6. Update project instruction file from integration template --
   correct, covers both CLAUDE.md and copilot-instructions.md
7. Update Domain Language (if maintained) -- correct, conditional
8. Add `freshness-threshold` to instruction file -- correct,
   actionable instruction with default value
9. Add `last-validated` to existing Tier 1 docs -- correct, actionable
   instruction

All 10 changed canonical files are accounted for in the "Changed files"
section. All change descriptions are accurate. The consumer update
instructions are actionable -- each step tells the consumer what to
do and what changed. Step 8 (add freshness-threshold) and step 9 (add
last-validated to existing docs) are particularly important for
existing projects and correctly included. VERSION is not listed in
consumer update instructions (correct -- consumers track their own
versions).

---

## Criterion 6: Dispatch/output contract consistency

**Result: PASS**

The freshness check behavior described in development-workflow.md
aligns with how the integration templates describe it. No conflicts
in the dispatch flow.

Evidence:

- **Orchestrator-controlled dispatch:** development-workflow.md states
  that the orchestrator checks freshness and decides what to include
  in dispatch payloads (line 156-160). Both integration templates
  state the same: "The orchestrator decides what to include in
  dispatch payloads -- the implementer receives whatever context the
  orchestrator gives it" (CLAUDE.md line 681, copilot-instructions.md
  line 598). Consistent: freshness is an orchestrator concern, not
  an agent concern.

- **Passive check behavior:** development-workflow.md describes the
  passive check as "emits a one-line warning in its orientation
  output" and "proceeds with Strategy B" (lines 171-176). Both
  integration templates describe the same behavior: "emits a one-line
  note during orientation" and "loads the document with a caveat"
  (CLAUDE.md line 299, copilot-instructions.md line 212). The
  Session Lifecycle section describes it happening during step 2
  (reading sprint progress / context docs), which is the correct
  placement for orientation-time checks. Consistent.

- **Strategy A not automatic:** development-workflow.md (line 188),
  CLAUDE.md (line 299), and copilot-instructions.md (line 212) all
  state that Strategy A is only used when the owner explicitly
  overrides. No file describes Strategy A as automatic. Consistent.

- **Triage at sweep time only:** development-workflow.md explicitly
  separates the passive check (story/task start) from the three-option
  triage (periodic sweeps only, lines 195-200).
  Sprint-coordination.md defines the triage mechanism at maintenance
  time (line 76) and retro time (line 80). No integration template
  or workflow file suggests triage at story start. Consistent.

- **No agent prompt changes required:** The plan explicitly states
  that freshness is an orchestrator concern and no agent prompt files
  should change. Confirmed via `git diff HEAD~1 --name-only --
  core/agents/` which returned empty. The dispatch contract is
  unaffected -- agents receive whatever context the orchestrator
  gives them. This is consistent with the dispatch protocol's
  existing contract structure.

---

## Additional verification (from plan and CLAUDE.md checklists)

- [x] `core/Document-Catalog.md` contains Freshness Metadata
  subsection under How to Use This Catalog (line 65)
- [x] Freshness Metadata section describes `last-validated` field,
  lists which documents carry it, and provides bootstrap guidance
  (lines 66-86)
- [x] Freshness Metadata section references development-workflow.md
  for behavioral logic (line 83)
- [x] development-workflow.md contains Freshness-Aware Context Loading
  section before Starting a Story (line 154, before line 205)
- [x] Strategy B described as universal default for all tiers;
  Strategy A described as owner override only (lines 181-193)
- [x] Freshness check at story/task start is explicitly passive --
  one-line warning, no blocking, no triage (lines 170-179)
- [x] Three-option triage limited to periodic sweeps only (lines
  195-200)
- [x] Freshness check described as universal across all workflow types
  (lines 158-160)
- [x] Starting a Story step 2 includes freshness qualifier (line 207);
  Patch path step 2 includes freshness qualifier (line 57)
- [x] Default threshold stated: 2 completed sprints / ~4 weeks
  (line 164)
- [x] task-workflow.md includes freshness check cross-reference
  (lines 133-140)
- [x] sprint-coordination.md maintenance phase includes freshness
  sweep with three-option triage (line 76)
- [x] Sprint-coordination retro phase includes stale doc surfacing
  (line 80)
- [x] Sprint-coordination includes non-sprint on-demand sweep note
  (line 78)
- [x] Sprint-coordination freshness sweep references Document-Catalog
  for which docs carry the field (line 76)
- [x] All three templates have `last-validated: YYYY-MM-DD` in
  frontmatter, placed after `updated:`
  (Domain-Language-Template lines 5-6; Project-Charter-Template
  lines 7-8; PRD-Template lines 8-9)
- [x] Both integration templates have passive freshness orientation
  note in Session Lifecycle (CLAUDE.md line 299,
  copilot-instructions.md line 212)
- [x] Both integration templates have freshness bullet in Key
  Constraints, placed after Compaction bullet (CLAUDE.md line 681,
  copilot-instructions.md line 598)
- [x] Integration templates describe Strategy B as universal default
  and note orchestrator controls dispatch payloads (confirmed in
  both templates)
- [x] Domain-Language.md defines freshness signal (line 312),
  staleness threshold (line 321), and freshness validation (line
  330) in the Workflow section after Compaction (line 300)
- [x] All three Domain Language terms include `[Introduced in 0.31.0.]`
  tags (lines 319, 328, 338)
- [x] VERSION is 0.31.0 (confirmed)
- [x] CHANGELOG 0.31.0 entry exists and lists all changed files
  (confirmed, lines 9-52)
- [x] CHANGELOG consumer update instructions are complete -- all 9
  consumer actions listed (lines 54-79)
- [x] CHANGELOG describes Strategy B as universal default, not
  tier-based defaults (lines 13-15)
- [x] No agent prompt files were modified (confirmed via git diff)
- [x] No smell test violations (see Criterion 4 above)
- [x] Cross-references are consistent (see Criterion 1 above)

---

## Notes

**README.md coverage.** The project's verification checklist in
CLAUDE.md requires that "README.md accurately reflects current
framework state -- agent count, project type categories, feature
list, and workflow description match the actual contents of the repo."
The README's "What's in the box" feature list does not mention
freshness-aware context loading, which is a new cross-cutting
framework capability. The CR-21 plan's file change inventory does
not include README.md (and adding it would expand scope), so this
is not a FAIL condition for this change. However, the README should
be updated in a subsequent change to include freshness-aware context
loading alongside the existing mentions of compaction, graduated
testing, and token cost estimation. This is a maintenance item, not
a blocking issue.
