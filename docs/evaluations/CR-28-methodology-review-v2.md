# Methodology Review (v2): CR-28 — Workflow Folder and Terminology Cleanup

**Reviewer:** methodology-reviewer
**Plan:** `docs/plans/CR-28-plan.md`
**Version:** 0.27.0
**Date:** 2026-05-03

---

## Verdict: PASS

---

## Checklist Results

### 1. All files referenced in the CHANGELOG entry actually exist

PASS. Every file listed in the 0.27.0 CHANGELOG entry was verified:

- New: `core/workflows/README.md` -- exists
- Moved (types/): `agentic-workflow.md`, `development-workflow.md`,
  `task-workflow.md`, `analytics-workspace.md` -- all exist in
  `core/workflows/types/`
- Moved (protocols/): `dispatch-protocol.md`, `design-alignment.md`,
  `sprint-coordination.md`, `doc-triggers.md`, `hooks-reference.md`,
  `knowledge-pipeline.md`, `knowledge-synthesis.md`,
  `progress-files.md`, `task-promotion.md`, `token-estimation.md`,
  `analytics-onboarding.md` -- all exist in
  `core/workflows/protocols/`
- No flat .md files remain in `core/workflows/` besides README.md

### 2. AGENT-CATALOG agent file table matches actual files

PASS. All 32 agent files listed in the Agent Files table exist in
`core/agents/`. All 7 archetype files exist in
`core/agents/archetypes/`. The mapping tables (Sprint-Based,
Task-Based, Methodology-Based) reference only agents that appear in
the Agent Files table.

### 3. Document-Catalog Quick Reference sections

N/A. No new document types were added in CR-28.
`core/workflows/README.md` is an organizational file, not a document
type.

### 4. doc-triggers table entries reference documents/workflows that exist

PASS. Checked `core/workflows/protocols/doc-triggers.md`. All
workflow path references use the new `protocols/` and `types/` paths.
References to `design-alignment.md` (line 7),
`knowledge-synthesis.md` (line 31) point to the correct new
locations.

### 5. VERSION file matches the version in the latest CHANGELOG entry

PASS. VERSION contains `0.27.0`. CHANGELOG leads with
`## 0.27.0 — Workflow folder reorganization`.

### 6. No smell test violations

PASS. Searched `core/workflows/` for LifeOS, Obsidian, Motion, PARA,
Notnomo, Hearthen, MNEMOS, Opifex, edw labs, VerbumEng. Zero hits.
No assumptions about specific downstream products or personal
workflow tools in any canonical file touched by CR-28.

### 7. Cross-references between files are consistent

PASS. This is the critical check for a cross-reference-heavy change.
Verification method: grepped the entire repo for every old flat-path
pattern, excluding known-historical files (CHANGELOG.md,
MIGRATIONS.md, `planning/`, `docs/plans/`, `docs/evaluations/`,
CLAUDE.md project file which is gitignored).

**Result: zero stale references in canonical files.**

Specific cross-reference chains verified:

- `core/agents/AGENT-CATALOG.md` line 44 -> `core/workflows/types/agentic-workflow.md` (correct)
- `core/agents/AGENT-CATALOG.md` line 98 -> `core/workflows/protocols/dispatch-protocol.md` (correct)
- `core/agents/analysis-planner.md` line 67 -> `core/workflows/protocols/task-promotion.md` (correct)
- `core/agents/data-architect.md` line 237 -> `core/workflows/protocols/dispatch-protocol.md` (correct)
- `core/agents/software-architect.md` line 223 -> `core/workflows/protocols/dispatch-protocol.md` (correct)
- `core/agents/archetypes/architect.md` line 105 -> `core/workflows/protocols/dispatch-protocol.md` (correct)
- Internal workflow cross-refs (types referencing protocols and vice versa): all 26 internal references verified via grep, all use new paths
- Integration templates: 13 references each in CLAUDE.md and copilot-instructions.md, all updated
- Root-level docs: BOOTSTRAP.md (4), ADOPT.md (2), ADD-WORKFLOW.md (1), Domain-Language.md (8), UPDATE.md (1) -- all updated
- Core non-workflow files: Document-Catalog.md, maintenance-checklist.md, Batch-Index-Schema.md, Sprint-Contract-Pipeline.md -- all updated
- Wiki files: workflow-design.md (9+ refs), agent-model.md (4 refs), owner-preferences.md (1 ref) -- all updated

### 8. Integration templates reflect structural changes

PASS. Both `integrations/claude-code/CLAUDE.md` and
`integrations/copilot/copilot-instructions.md` have all 13 workflow
path references updated to new `types/` and `protocols/` paths. No
stale references remain. The templates do not mention the
reorganization in prose (appropriate -- they are consumed by agents,
not humans reading release notes).

### 9. Consumer update instructions complete

PASS. The CHANGELOG 0.27.0 consumer update instructions list 6
steps covering: directory restructure, renames, cross-reference
updates, Fabrika source file re-copy (10 files listed by name),
integration template update, and README.md copy. The MIGRATIONS.md
0.27.0 entry provides the complete 15-row path mapping table and 6
detailed migration steps with specific file lists.

Both the CHANGELOG and MIGRATIONS entries list every file a consumer
would need to update. The MIGRATIONS entry is more detailed (includes
the complete path mapping table and lists all files to re-copy),
which is appropriate for its role as the detailed migration guide.

### 10. Dispatch and output contracts are consistent

PASS. No behavioral changes to dispatch or output contracts were made
in CR-28. The dispatch-protocol.md file moved to
`core/workflows/protocols/dispatch-protocol.md` with path-only
changes to its internal cross-references. All agent prompt files that
reference dispatch-protocol.md point to the new location.

### 11. README.md accurately reflects current framework state

PASS. README.md contains no direct workflow path references (only
high-level descriptions and root-level file links). The agent count
(32 specialized agents), project type categories, feature list, and
workflow description remain accurate. CR-28 is a structural
reorganization that does not change the feature set or agent count.

---

## Methodology Assessment

The execution follows the plan faithfully. The plan's design
decisions are sound:

- **types/ vs. protocols/ split:** The distinction is clear and
  well-documented in the new README.md. Workflow type definitions
  (complete lifecycle specifications) go in types/. Supporting
  processes (reusable cross-cutting concerns) go in protocols/. The
  README is concise (30 lines) and actionable.

- **Rename decisions:** `agentic-workflow-lifecycle.md` ->
  `agentic-workflow.md` (drop redundant "-lifecycle" suffix) and
  `sprint-lifecycle.md` -> `sprint-coordination.md` (clarify role) are
  consistent with the types-vs-protocols model.
  `development-workflow.md` was correctly left without rename,
  deferring the domain-specific workflow split to CR-22.

- **Historical file preservation:** CHANGELOG and MIGRATIONS
  historical entries were correctly left untouched. Wiki narrative
  prose referencing old filenames in historical context (e.g., the
  v0.7.0 provenance description in workflow-design.md) was correctly
  preserved -- these describe what files were called at that version,
  not current paths.

- **MIGRATIONS entry completeness:** The 0.27.0 migration entry
  provides a complete path mapping table (15 rows), step-by-step
  instructions, and a full list of files consumers need to re-copy.
  This is thorough enough that a consumer could execute the migration
  without reading the CHANGELOG.

No methodology gaps, contract inconsistencies, or structural defects
found.
