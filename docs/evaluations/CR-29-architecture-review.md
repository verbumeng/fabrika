---
type: evaluation
change-request: planning/CR-29-unified-document-hierarchy.md
plan: docs/plans/CR-29-plan.md
evaluator: context-architect
verdict: SOUND
date: 2026-05-04
---

# CR-29 Architecture Review

**Verdict: SOUND**

The structural design of CR-29 is architecturally clean. The
decomposition hierarchy placement, Design Alignment boundary, template
patterns, and term architecture are all well-considered. One minor
observation (not blocking) on the "task document" phrasing in the
knowledge-pipeline reference.

---

## Criterion 1: Instruction Decomposition Appropriateness

**Assessment: Appropriate placement, right level of detail, no
duplication.**

The Decomposition Hierarchy section in Document-Catalog.md is the
correct location for this content. Reasoning:

1. **Document-Catalog is the structural map of Fabrika artifacts.**
   The decomposition hierarchy IS a structural map of those artifacts
   in relation to each other. Placing it before the per-folder
   listings gives the reader a mental model before the details.

2. **Level of detail is appropriate.** The section is 15 lines of
   prose plus a 7-row table. It does not over-explain. It states the
   hierarchy, names the documents at each level, notes that complexity
   assessment governs which levels are used, and moves on.

3. **No duplication with Domain-Language.md.** The Domain Language
   definition of "Decomposition hierarchy" is a term definition (what
   it IS, its version history). The Document-Catalog section is a
   structural reference (what documents exist at each level, when each
   is used). These serve different functions. The Domain Language
   definition correctly says "Charter -> Roadmap -> PRD -> Epic ->
   Story / Task / Bug" — the same list — but that is cross-reference
   consistency, not duplication. The domain term anchors the concept;
   the catalog section expands it into actionable guidance for
   bootstrapping and workflow routing.

4. **Placement within Document-Catalog.** After "How to Use This
   Catalog" and before the per-folder listings is correct. It
   provides the conceptual frame before the detail catalog begins.

---

## Criterion 2: Pointer Pattern Cleanliness

**Assessment: Clean pointers, no circular references, no dangling
pointers.**

Cross-reference chains verified:

- **Document-Catalog -> templates.** Task-Template.md and
  Roadmap-Template.md both exist in `core/templates/`. The template
  references in the catalog ("Base templates" section) point to real
  files. Analysis-Outcome-Template.md exists (the rename from
  Outcome-Report-Template.md was completed). Brief-Template.md and
  Analysis-Brief-Template.md no longer exist (deleted as planned).

- **Domain-Language -> Document-Catalog.** The "Decomposition
  hierarchy" term in Domain Language references the concept; Document-
  Catalog describes the structural reality. No explicit pointer from
  one to the other exists, but none is needed — they serve different
  audiences (vocabulary lookup vs. structural reference).

- **Design-alignment.md -> templates.** The Output section references
  `core/templates/Project-Charter-Template.md` and
  `core/templates/PRD-Template.md` — both exist.

- **Integration templates -> design-alignment.md.** CLAUDE.md and
  copilot-instructions.md both say "For the full protocol, read:
  `[FABRIKA_PATH]/core/workflows/protocols/design-alignment.md`" —
  clean pointer, no circularity.

- **Document-Catalog -> workflows.** The catalog's per-task entries
  reference the task/plan flow pattern that the task-workflow.md and
  analytics-workflow.md define. No explicit file path pointers from
  catalog entries to workflow files, which is correct — the catalog
  documents artifacts, workflows document processes.

No circular reference patterns detected. No dangling pointers to
deleted files.

---

## Criterion 3: Context Budget Balance

**Assessment: Good value for context cost. Roadmap-Template is
appropriately lean.**

**Document-Catalog addition.** The Decomposition Hierarchy section
adds approximately 15 lines plus a 7-row table (~22 lines total
including formatting). Document-Catalog is loaded during bootstrap and
occasionally during maintenance, not on every story/task start. The
addition provides high value (structural orientation for any agent
reading the catalog) at low cost (22 lines in a 980-line document).
This is a 2.2% increase. The section will be read once per bootstrap
and occasionally referenced — this is appropriate.

**Roadmap-Template.md.** 46 lines total. Lean. Frontmatter +
through-line + three phase tables + dependency graph + execution
protocol section. No bloat. The template follows the principle of
scaffolding structure without prescribing content. The comment-style
placeholder text is minimal and directive. Appropriate for a
sequence/index document.

**Task-Template.md.** 36 lines. Leanest template in the system
alongside Plan-Template (49 lines). Appropriate — the task document
captures the ask, nothing more.

---

## Criterion 4: Pattern Consistency

**Assessment: Consistent with established patterns.**

**Frontmatter conventions.** Checking against established templates:

| Template | Frontmatter fields |
|----------|-------------------|
| Plan-Template | type, task, status |
| Analysis-Plan-Template | type, task, status |
| Outcome-Template | type, task, status, completed |
| Story-Template | type, id, title, epic, sprint, status, points, priority, tier, created, updated, tags |
| Task-Template (new) | type, task, status, requested_by, deadline |
| Roadmap-Template (new) | type, title, status, created, updated |

Task-Template uses the `type` + `task` + `status` pattern consistent
with Plan-Template and Outcome-Template (the other per-task lifecycle
documents). The additional fields (`requested_by`, `deadline`) are
domain-appropriate for a task intake document and do not break the
pattern — they are analogous to Story-Template's `points` and
`priority` fields.

Roadmap-Template uses `type` + `title` + `status` + `created` +
`updated` — consistent with higher-level documents like Project
Charter and PRD which carry `created`/`updated` fields. Appropriate
for a living document that evolves over time.

**Section structure.** Both templates use the established
`# Title` heading pattern. Task-Template uses `##` subheadings for
each section. Roadmap-Template uses `##` subheadings with tables.
Both are consistent with existing templates.

**Comment style.** Both use `[bracketed placeholder text]` inside
sections, consistent with Plan-Template, Outcome-Template, and
Analysis-Plan-Template. No HTML comments, no inline code blocks for
placeholders — matches established convention.

**Analysis-Outcome-Template rename.** The naming convention
"specialized = descriptor + base name" is followed consistently:
Analysis-Plan-Template.md, Analysis-Outcome-Template.md. The prior
name (Outcome-Report-Template.md) violated this convention by using
a different base name ("Report" vs. "Outcome"). The rename corrects
this.

---

## Criterion 5: Design Alignment Protocol Coherence

**Assessment: Clean boundary. No gap for complex analytics work.**

The design-alignment.md now has a clear, simple boundary:

- **When to invoke:** New project, new phase, owner request, detected
  ambiguity.
- **What it produces:** Charter + PRD, or PRD only.
- **What it does NOT produce:** Task documents.

The question is whether complex analytics work (3+ data sources,
multiple stakeholders, novel domain, >2 day effort) falls through a
gap. Examining the implemented state:

1. **analytics-workflow.md retains complexity indicators.** The
   "Design Alignment for Complex Analyses" section now says Design
   Alignment fires at project/phase level per standard triggers, and
   lists complexity indicators that suggest work may be a new phase
   rather than a task. This is the routing mechanism.

2. **The gap does not exist.** The routing logic is:
   - Work IS a new phase/feature -> Design Alignment fires -> PRD
   - Work IS a bounded task (regardless of complexity) -> task/plan
     flow with standard or simple mode

   The former "enhanced brief" concept sat between these two — it was
   a third output type for work that was "too complex for a plain
   brief but not complex enough for a PRD." CR-29 resolves this by
   recognizing that the spectrum is already handled: if work needs
   module-level planning, it IS a phase/feature and gets a PRD. If
   it does not, the task/plan flow handles it regardless of how many
   data sources are involved. The complexity indicators in analytics-
   workflow.md serve as routing signals, not triggers for a third
   document type.

3. **task-workflow.md mirrors this correctly.** "Design Alignment for
   Complex Tasks" says the same thing: tasks use task/plan flow; if
   the work is a new phase/feature, Design Alignment fires per
   standard triggers.

4. **Integration templates are consistent.** Both CLAUDE.md and
   copilot-instructions.md describe Design Alignment as producing
   Charter + PRD or PRD only, with no mention of enhanced briefs or
   task-level outputs.

The boundary is clean. No work falls through.

---

## Criterion 6: Term Architecture in Domain-Language.md

**Assessment: Well-placed, correctly cross-referenced, consistent
with Document-Catalog.**

**New term: "Decomposition hierarchy."** Placed in the Workflow
section near "Universal complexity spectrum" — correct placement.
The universal complexity spectrum describes how ceremony graduates
across backlog types; the decomposition hierarchy describes how
documents layer. These are complementary structural concepts.

**Consistency check.** The Domain Language definition says:
> Charter -> Roadmap -> PRD -> Epic -> Story / Task / Bug.

The Document-Catalog table lists:
> Charter, Roadmap, PRD, Epic, Story, Task, Bug

Same hierarchy, same order. Consistent.

**Updated term: "Plan check."** Clean replacement of "Brief check."
The definition correctly:
- Names the output path (`docs/evaluations/[task-name]-plan-check.md`)
- Describes what it validates (requirements, not data)
- States the verdict options (MEETS / PARTIALLY MEETS / DOES NOT MEET
  REQUIREMENTS)
- Notes the rename history ("Formerly 'brief check.'")
- Includes version references ([Introduced in 0.20.0; renamed in
  0.33.0.])

**Updated term: "Design Alignment."** Clean removal of enhanced brief
reference. The definition now states what Design Alignment produces
(Charter + PRD) without mentioning what it does not produce. The
version note captures the removal: "enhanced brief concept removed
in 0.33.0."

**Cross-references in other terms.** The "Task lifecycle" definition
references "validate + plan check" (updated from "brief check"). The
"Bug" definition references "specific task document structure"
(updated from "brief structure"). The "Analytics workflow project"
definition references "task -> plan" (updated from "brief -> plan").
All consistent.

---

## Summary

The structural design is sound across all six criteria. The
decomposition hierarchy is correctly placed as the conceptual frame
for the Document-Catalog rather than scattered across template files.
The Design Alignment boundary is clean and coherent after enhanced
brief removal. The new templates follow established patterns. The
term architecture in Domain-Language.md is consistent with the
structural reality in Document-Catalog.md.

No blocking issues. No structural concerns that would require
revision before implementation proceeds to shipping.
