# Methodology Review: CR-28 — Workflow Folder and Terminology Cleanup

**Reviewer:** methodology-reviewer
**Plan:** `docs/plans/CR-28-plan.md`
**Version:** 0.27.0
**Date:** 2026-05-03

---

## Verdict: PASS WITH NOTES

The change is a clean structural reorganization with no behavioral
modifications. All 15 workflow files moved to the correct
subdirectories (`types/` and `protocols/`), all cross-references
across 25+ canonical files were updated, historical entries were
correctly preserved, and the VERSION/CHANGELOG/MIGRATIONS triad is
consistent. One minor completeness gap in the consumer update
instructions does not rise to FAIL.

---

## Per-Criterion Findings

### 1. All files referenced in the CHANGELOG entry actually exist

**PASS.**

Every file listed in the CHANGELOG 0.27.0 entry was verified:
- `core/workflows/README.md` -- exists (new file, 30 lines)
- All 4 files under `core/workflows/types/` -- exist (agentic-workflow.md, development-workflow.md, task-workflow.md, analytics-workspace.md)
- All 11 files under `core/workflows/protocols/` -- exist (dispatch-protocol.md, design-alignment.md, sprint-coordination.md, doc-triggers.md, hooks-reference.md, knowledge-pipeline.md, knowledge-synthesis.md, progress-files.md, task-promotion.md, token-estimation.md, analytics-onboarding.md)
- All 19 changed files listed in the "Changed files" section -- verified present

No files remain in the flat `core/workflows/` directory (only
`README.md`, `types/`, and `protocols/`).

### 2. New agents follow the established archetype structure

**N/A.** No new agents in this change.

### 3. AGENT-CATALOG agent file table matches actual files in core/agents/

**PASS.**

The Agent Files table (lines 102-135) lists 32 agent prompt files.
The `core/agents/` directory contains exactly 32 `.md` files
excluding `AGENT-CATALOG.md` and `agent-frontmatter-spec.md`
(reference documents, not agent prompts). Every file listed in the
table exists in the directory. No unlisted files in the directory.

### 4. Document-Catalog Quick Reference sections include any newly added documents

**PASS.**

No new document types were added by CR-28. The existing Document
Catalog references to workflow paths have been correctly updated
(e.g., `core/workflows/protocols/design-alignment.md` at lines 80
and 96).

### 5. doc-triggers table entries reference documents/workflows that exist

**PASS.**

Verified all workflow references in `core/workflows/protocols/doc-triggers.md`:
- Line 7: `core/workflows/protocols/design-alignment.md` -- exists
- Line 31: `core/workflows/protocols/knowledge-synthesis.md` -- exists
- All template references (`core/templates/*`) -- unchanged, not affected by this CR

### 6. VERSION file matches the version in the latest CHANGELOG entry

**PASS.**

`VERSION` contains `0.27.0`. The latest CHANGELOG entry header is
`## 0.27.0 — Workflow folder reorganization`. Match confirmed.

### 7. No smell test violations

**PASS.**

Checked all new and modified canonical files for:
- LifeOS/Obsidian/Motion/PARA assumptions: none found
- User-specific assumptions: none found
- Downstream product names (Notnomo, Hearthen, MNEMOS, Opifex, edw labs, VerbumEng): none found
- Stranger-cloning test: the new `core/workflows/README.md` is clear and self-contained; all changes make sense to someone with no prior context

### 8. Cross-references between files are consistent

**PASS.**

Comprehensive grep across the entire repo for old flat-path patterns
(`core/workflows/agentic-workflow-lifecycle`,
`core/workflows/sprint-lifecycle`,
`core/workflows/dispatch-protocol.md` without `protocols/`, etc.)
confirmed that stale references appear ONLY in allowed historical
files:
- `CHANGELOG.md` (historical version entries)
- `MIGRATIONS.md` (historical migration entries)
- `planning/` (historical planning documents)
- `docs/plans/` (historical plan files)
- `docs/evaluations/` (historical evaluation reports)

Zero stale references in any canonical file.

Internal cross-references verified between:
- Workflow type files referencing protocol files (correct `protocols/` paths)
- Protocol files referencing each other (knowledge-pipeline <-> knowledge-synthesis, sprint-coordination -> design-alignment, etc.)
- Agent prompts referencing dispatch-protocol and task-promotion (correct `protocols/` paths)
- Integration templates referencing all workflow paths (13 references each, all correct)
- Root-level docs (BOOTSTRAP, ADOPT, ADD-WORKFLOW, Domain-Language, UPDATE) all using correct new paths
- Core non-workflow files (Document-Catalog, maintenance-checklist, Batch-Index-Schema, Sprint-Contract-Pipeline) all using correct new paths
- Wiki topic articles (workflow-design, agent-model, owner-preferences) all using correct new paths

One historical narrative reference to "sprint-lifecycle.md" in
`wiki/topics/workflow-design.md` line 13 describes what happened at
v0.7.0 and correctly preserves the name as it was at that time. This
is not a stale reference.

### 9. Integration templates reflect any new capabilities, agents, workflows, or structural changes

**PASS.**

Both integration templates updated:
- `integrations/claude-code/CLAUDE.md`: all 13 workflow path references updated to new `types/` or `protocols/` paths
- `integrations/copilot/copilot-instructions.md`: all 13 workflow path references updated to new `types/` or `protocols/` paths

No new capabilities were added by CR-28, so no structural additions
to the templates were needed.

### 10. Consumer update instructions in the CHANGELOG are complete

**PASS WITH NOTE.**

The CHANGELOG consumer update instructions cover the structural
reorganization (step 1), renames (step 2), cross-reference search-
and-replace (step 3), source file updates (step 4), integration
template refresh (step 5), and new README copy (step 6).

**Note:** Step 4 lists 5 files to update from Fabrika source:
`AGENT-CATALOG.md`, `Document-Catalog.md`, `dispatch-protocol.md`,
`maintenance-checklist.md`, `Batch-Index-Schema.md`. However, the
following changed files with updated cross-references are omitted
from this explicit list:
- `core/topologies/Sprint-Contract-Pipeline.md`
- `core/agents/analysis-planner.md`
- `core/agents/data-architect.md`
- `core/agents/software-architect.md`
- `core/agents/archetypes/architect.md`

A consumer who copied these files would retain stale cross-references
unless they independently notice them in the "Changed files" section
of the CHANGELOG. Step 3 ("Update all cross-references in your local
copies") partially mitigates this since a global search for
`core/workflows/` would catch these, but the explicit file list in
step 4 should ideally be complete.

Similarly, `MIGRATIONS.md` step 5 lists the same 5 files (plus "All
workflow files") but omits the topology and agent prompt files.

This is a minor completeness gap, not a correctness error -- the
changed files section documents what changed, and step 3 provides the
catch-all search-and-replace instruction.

### 11. Dispatch and output contracts are consistent between workflow documentation and agent prompts

**PASS.**

CR-28 made no changes to dispatch or output contracts. The only
changes to agent prompts were path updates:
- `analysis-planner.md`: task-promotion path updated
- `data-architect.md`: dispatch-protocol path updated
- `software-architect.md`: dispatch-protocol path updated
- `archetypes/architect.md`: dispatch-protocol path updated

All path references in agent prompts now point to files that exist at
the referenced locations.

### 12. README.md accurately reflects current framework state

**PASS.**

`README.md` does not contain any workflow path references and was
correctly excluded from modifications. Its content (32 agents, 7
archetypes, 11 project types, feature descriptions) remains accurate
after CR-28. The change was purely structural (file organization) and
did not add/remove agents, project types, or features that would
require README updates.

---

## Summary of Notes

1. **Consumer update instruction completeness (minor).** The
   CHANGELOG step 4 and MIGRATIONS step 5 should explicitly list
   `Sprint-Contract-Pipeline.md` and the four agent prompt files that
   had cross-reference updates. The catch-all search instruction in
   step 3 mitigates the gap, making this advisory rather than
   blocking.

---

## Methodology Quality Assessment

The change executes the plan faithfully. The types/protocols
directory split is well-motivated and clearly documented in the new
`core/workflows/README.md`. The two renames (agentic-workflow-
lifecycle -> agentic-workflow, sprint-lifecycle -> sprint-
coordination) improve naming consistency. The decision to defer
renaming development-workflow (documented in the plan's Alignment
History) shows appropriate restraint -- the design tension between
"one file serves 8 project types" and "each domain needs its own
workflow" is real, and CR-22 is the right place to resolve it.

Historical files (CHANGELOG, MIGRATIONS, planning/, docs/plans/,
docs/evaluations/) were correctly left untouched, preserving the
accuracy of past version records.

The scope boundary was respected throughout: no behavioral changes,
no content modifications, only structural reorganization and cross-
reference updates.
