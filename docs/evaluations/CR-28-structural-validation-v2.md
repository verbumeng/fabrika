# CR-28 Structural Validation (v2)

**CR:** CR-28 — Workflow Folder and Terminology Cleanup
**Version:** 0.27.0
**Validator:** structural-validator
**Date:** 2026-05-03
**Verdict:** PASS

---

## 1. File Existence

All files referenced in the CHANGELOG 0.27.0 entry exist at their
stated paths.

### New files

| File | Status |
|------|--------|
| `core/workflows/README.md` | EXISTS (29 lines, under 30-line cap) |

### Moved/renamed files (new locations)

| New path | Status |
|----------|--------|
| `core/workflows/types/agentic-workflow.md` | EXISTS |
| `core/workflows/types/development-workflow.md` | EXISTS |
| `core/workflows/types/task-workflow.md` | EXISTS |
| `core/workflows/types/analytics-workspace.md` | EXISTS |
| `core/workflows/protocols/dispatch-protocol.md` | EXISTS |
| `core/workflows/protocols/design-alignment.md` | EXISTS |
| `core/workflows/protocols/sprint-coordination.md` | EXISTS |
| `core/workflows/protocols/doc-triggers.md` | EXISTS |
| `core/workflows/protocols/hooks-reference.md` | EXISTS |
| `core/workflows/protocols/knowledge-pipeline.md` | EXISTS |
| `core/workflows/protocols/knowledge-synthesis.md` | EXISTS |
| `core/workflows/protocols/progress-files.md` | EXISTS |
| `core/workflows/protocols/task-promotion.md` | EXISTS |
| `core/workflows/protocols/token-estimation.md` | EXISTS |
| `core/workflows/protocols/analytics-onboarding.md` | EXISTS |

### Old flat directory

The `core/workflows/` directory contains only `README.md`,
`types/`, and `protocols/`. No stale files remain at the flat
level.

---

## 2. VERSION Match

VERSION file contains `0.27.0`. CHANGELOG latest entry is
`## 0.27.0 — Workflow folder reorganization`. Match confirmed.

---

## 3. AGENT-CATALOG Agent File Table

Cross-referenced the Agent Files table (32 agent entries) against
actual files in `core/agents/` (33 .md files: 32 agents +
`AGENT-CATALOG.md` + `agent-frontmatter-spec.md`). The two
non-agent files correctly do not appear in the table.

Every file listed in the table exists on disk. Every agent .md file
on disk appears in the table. Match is exact.

Workflow path references in AGENT-CATALOG:
- Line 44: `core/workflows/types/agentic-workflow.md` -- correct
- Line 98: `core/workflows/protocols/dispatch-protocol.md` -- correct

---

## 4. Doc-Triggers Table

All doc-triggers entries reference documents/workflows that exist
at correct paths:
- Line 7: `core/workflows/protocols/design-alignment.md` -- EXISTS
- Line 31: `core/workflows/protocols/knowledge-synthesis.md` -- EXISTS

---

## 5. Cross-Reference Resolution (All Changed Files)

### Method

Grepped every canonical file (excluding CHANGELOG.md, MIGRATIONS.md,
planning/, docs/plans/, docs/evaluations/, .claude/) for all 15 old
flat-path patterns. Also ran a broad regex
(`core/workflows/[a-z].*\.md`) filtered to exclude `types/`,
`protocols/`, and `README` matches.

### Result

Zero stale references in any canonical file. Every workflow path
reference across all changed files uses the new `types/` or
`protocols/` subdirectory paths.

### Files individually verified

| File | Stale refs | New refs correct |
|------|-----------|-----------------|
| `core/workflows/types/agentic-workflow.md` | 0 | Yes (2 protocol refs) |
| `core/workflows/types/development-workflow.md` | 0 | Yes (3 protocol refs) |
| `core/workflows/types/task-workflow.md` | 0 | Yes (4 protocol refs) |
| `core/workflows/types/analytics-workspace.md` | 0 | Yes (6 protocol refs) |
| `core/workflows/protocols/sprint-coordination.md` | 0 | Yes (3 protocol refs) |
| `core/workflows/protocols/knowledge-synthesis.md` | 0 | Yes (2 refs) |
| `core/workflows/protocols/knowledge-pipeline.md` | 0 | Yes (2 refs) |
| `core/workflows/protocols/design-alignment.md` | 0 | Yes (1 ref) |
| `core/workflows/protocols/doc-triggers.md` | 0 | Yes (2 refs) |
| `core/agents/AGENT-CATALOG.md` | 0 | Yes (2 refs) |
| `core/agents/analysis-planner.md` | 0 | Yes (1 ref) |
| `core/agents/data-architect.md` | 0 | Yes (1 ref) |
| `core/agents/software-architect.md` | 0 | Yes (1 ref) |
| `core/agents/archetypes/architect.md` | 0 | Yes (1 ref) |
| `core/Document-Catalog.md` | 0 | Yes (2 refs) |
| `core/maintenance-checklist.md` | 0 | Yes (1 ref) |
| `core/templates/Batch-Index-Schema.md` | 0 | Yes (1 ref) |
| `core/topologies/Sprint-Contract-Pipeline.md` | 0 | Yes (1 ref) |
| `integrations/claude-code/CLAUDE.md` | 0 | Yes |
| `integrations/copilot/copilot-instructions.md` | 0 | Yes |
| `BOOTSTRAP.md` | 0 | Yes |
| `ADOPT.md` | 0 | Yes |
| `ADD-WORKFLOW.md` | 0 | Yes |
| `Domain-Language.md` | 0 | Yes |
| `UPDATE.md` | 0 | Yes |
| `wiki/topics/workflow-design.md` | 0 | Yes |
| `wiki/topics/agent-model.md` | 0 | Yes |
| `wiki/topics/owner-preferences.md` | 0 | Yes |

---

## 6. Historical Entry Integrity

### CHANGELOG.md

Spot-checked entries at 0.26.0, 0.25.0, 0.22.0. All preserve old
flat paths (e.g., `core/workflows/agentic-workflow-lifecycle.md`,
`core/workflows/dispatch-protocol.md`,
`core/workflows/sprint-lifecycle.md`). No historical entries were
modified. Only the new 0.27.0 entry was added.

### MIGRATIONS.md

Spot-checked entries at 0.26.0 and 0.25.0. All preserve old flat
paths. No historical entries were modified. Only the new 0.27.0
entry was added.

---

## 7. Integration Templates

Both integration templates were verified via broad grep. No stale
references remain. All workflow path references use the new
`types/` or `protocols/` subdirectory paths.

---

## 8. core/workflows/README.md

The file exists (29 lines), documents the `types/` vs. `protocols/`
distinction clearly, explains what goes in each subdirectory, and
references `ADD-WORKFLOW.md` for the workflow addition process.

---

## 9. H1 Titles of Renamed Files

| File | H1 Title | Matches filename |
|------|----------|-----------------|
| `types/agentic-workflow.md` | `# Agentic Workflow` | Yes |
| `types/development-workflow.md` | `# Development Workflow` | Yes |
| `types/task-workflow.md` | `# Task Workflow` | Yes |
| `types/analytics-workspace.md` | `# Analytics Workspace Workflow` | Yes |
| `protocols/sprint-coordination.md` | `# Sprint Coordination` | Yes |

---

## 10. CHANGELOG 0.27.0 Completeness

The entry lists:
- 1 new file (README.md)
- 15 moved/renamed files (4 types + 11 protocols) -- matches plan
- 19 changed files -- matches dispatch payload
- 6-step consumer update instructions covering file reorganization,
  renames, cross-reference updates, Fabrika source file re-copy,
  integration template update, and README copy

The MIGRATIONS 0.27.0 entry includes the complete 15-row path
mapping table and 6 migration steps.

---

## 11. Narrative Prose Check

`wiki/topics/workflow-design.md` line 13 mentions old filenames
(sprint-lifecycle.md, development-workflow.md, etc.) in a historical
narrative about v0.7.0 ("Six workflow files were extracted to
core/workflows/"). This is a past-tense description of what happened
at that version, not an actionable path reference. The same file's
current source references (lines 15, 17, 31, 172-180) all use the
new paths. No update needed.

---

## Summary

All verification checks pass. Zero stale references in canonical
files. File existence, version match, agent catalog consistency,
doc-triggers validity, cross-reference resolution, historical entry
integrity, integration template correctness, README documentation,
H1 title alignment, and CHANGELOG/MIGRATIONS completeness are all
confirmed.
