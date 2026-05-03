# CR-28 Structural Validation Report

**CR:** CR-28 — Workflow Folder and Terminology Cleanup
**Version:** 0.27.0
**Plan:** `docs/plans/CR-28-plan.md`
**Validator:** structural-validator
**Date:** 2026-05-03

---

## Checklist Results

### 1. All files referenced in the CHANGELOG entry exist at their stated paths

**Result: PASS**

Every file listed in the 0.27.0 CHANGELOG entry was verified:

New files:
- `core/workflows/README.md` -- EXISTS

Moved/renamed files (all 15 verified at new locations):
- `core/workflows/types/agentic-workflow.md` -- EXISTS
- `core/workflows/types/development-workflow.md` -- EXISTS
- `core/workflows/types/task-workflow.md` -- EXISTS
- `core/workflows/types/analytics-workspace.md` -- EXISTS
- `core/workflows/protocols/dispatch-protocol.md` -- EXISTS
- `core/workflows/protocols/design-alignment.md` -- EXISTS
- `core/workflows/protocols/sprint-coordination.md` -- EXISTS
- `core/workflows/protocols/doc-triggers.md` -- EXISTS
- `core/workflows/protocols/hooks-reference.md` -- EXISTS
- `core/workflows/protocols/knowledge-pipeline.md` -- EXISTS
- `core/workflows/protocols/knowledge-synthesis.md` -- EXISTS
- `core/workflows/protocols/progress-files.md` -- EXISTS
- `core/workflows/protocols/task-promotion.md` -- EXISTS
- `core/workflows/protocols/token-estimation.md` -- EXISTS
- `core/workflows/protocols/analytics-onboarding.md` -- EXISTS

Changed files (all 19 verified):
- `core/agents/AGENT-CATALOG.md` -- EXISTS
- `core/agents/analysis-planner.md` -- EXISTS
- `core/agents/data-architect.md` -- EXISTS
- `core/agents/software-architect.md` -- EXISTS
- `core/agents/archetypes/architect.md` -- EXISTS
- `core/Document-Catalog.md` -- EXISTS
- `core/maintenance-checklist.md` -- EXISTS
- `core/templates/Batch-Index-Schema.md` -- EXISTS
- `core/topologies/Sprint-Contract-Pipeline.md` -- EXISTS
- `integrations/claude-code/CLAUDE.md` -- EXISTS
- `integrations/copilot/copilot-instructions.md` -- EXISTS
- `BOOTSTRAP.md` -- EXISTS
- `ADOPT.md` -- EXISTS
- `ADD-WORKFLOW.md` -- EXISTS
- `Domain-Language.md` -- EXISTS
- `UPDATE.md` -- EXISTS
- `wiki/topics/workflow-design.md` -- EXISTS
- `wiki/topics/agent-model.md` -- EXISTS
- `wiki/topics/owner-preferences.md` -- EXISTS

Old flat files completely removed. `core/workflows/` root contains
only `README.md`, `types/`, and `protocols/`.

### 2. VERSION file matches the latest CHANGELOG entry

**Result: PASS**

- VERSION file content: `0.27.0`
- CHANGELOG latest entry header: `## 0.27.0 — Workflow folder reorganization`
- Match confirmed.

### 3. AGENT-CATALOG agent file table matches actual files in core/agents/

**Result: PASS**

The AGENT-CATALOG lists 32 agent files in its Agent Files table
(lines 102-135). The actual `core/agents/` directory contains exactly
32 `.md` files (excluding AGENT-CATALOG.md, agent-frontmatter-spec.md,
and the archetypes/ subdirectory). Every file listed in the catalog
exists on disk; every file on disk is listed in the catalog. No
agents were added or removed in this CR -- this is a spot-check
confirming no corruption during cross-reference updates.

### 4. doc-triggers table entries reference documents/workflows that exist at correct paths

**Result: PASS**

Verified the two workflow path references in
`core/workflows/protocols/doc-triggers.md`:
- Line 7: `core/workflows/protocols/design-alignment.md` -- EXISTS
- Line 31: `core/workflows/protocols/knowledge-synthesis.md` -- EXISTS

All other doc-triggers entries reference document folders (01-Product/,
02-Engineering/, etc.) or templates, which are outside the scope of
this CR's path changes.

### 5. Cross-references between ALL changed files resolve correctly

**Result: PASS**

Verified every `core/workflows/` reference in every changed file.
All references use the new path structure (`types/` or `protocols/`
prefix). Specific verification by file category:

**Workflow type files (4 files):** All internal cross-references
updated to `protocols/` paths. Verified: agentic-workflow.md (2 refs),
development-workflow.md (3 refs), task-workflow.md (4 refs),
analytics-workspace.md (8 refs).

**Protocol files (checked 5 files with cross-refs):**
sprint-coordination.md (4 refs), knowledge-synthesis.md (2 refs),
knowledge-pipeline.md (2 refs), design-alignment.md (1 ref),
doc-triggers.md (2 refs). All correct.

**Agent prompt files (5 files):** AGENT-CATALOG.md (2 refs),
analysis-planner.md (1 ref), data-architect.md (1 ref),
software-architect.md (1 ref), archetypes/architect.md (1 ref).
All correct.

**Integration templates (2 files):** CLAUDE.md (13 refs),
copilot-instructions.md (13 refs). All correct.

**Root-level documents (5 files):** BOOTSTRAP.md (4 refs), ADOPT.md
(2 refs), ADD-WORKFLOW.md (1 ref), Domain-Language.md (8 refs),
UPDATE.md (1 ref). All correct.

**Core non-workflow files (4 files):** Document-Catalog.md (2 refs),
maintenance-checklist.md (1 ref), Batch-Index-Schema.md (1 ref),
Sprint-Contract-Pipeline.md (1 ref). All correct.

**Wiki files (3 files):** workflow-design.md (9+ refs in prose and
Core files listing), agent-model.md (4 refs),
owner-preferences.md (1 ref). All correct.

### 6. No stale references to old flat paths remain in any canonical file

**Result: PASS**

Grepped the entire repo for every old flat path pattern. All 15
patterns checked:

| Old path pattern | Total hits | Canonical file hits |
|-----------------|-----------|-------------------|
| `core/workflows/agentic-workflow-lifecycle` | 69 | 0 |
| `core/workflows/sprint-lifecycle` | 26 | 0 |
| `core/workflows/dispatch-protocol.md` (flat) | 93 | 0 |
| `core/workflows/design-alignment.md` (flat) | 47 | 0 |
| `core/workflows/development-workflow.md` (flat) | 65 | 0 |
| `core/workflows/analytics-workspace.md` (flat) | 61 | 0 |
| `core/workflows/task-workflow.md` (flat) | 14 | 0 |
| `core/workflows/doc-triggers.md` (flat) | 27 | 0 |
| `core/workflows/hooks-reference.md` (flat) | 7 | 0 |
| `core/workflows/knowledge-pipeline.md` (flat) | 18 | 0 |
| `core/workflows/knowledge-synthesis.md` (flat) | 17 | 0 |
| `core/workflows/progress-files.md` (flat) | 7 | 0 |
| `core/workflows/task-promotion.md` (flat) | 8 | 0 |
| `core/workflows/token-estimation.md` (flat) | 38 | 0 |
| `core/workflows/analytics-onboarding.md` (flat) | 39 | 0 |

All hits are in expected historical/excluded files: CHANGELOG.md
(historical entries), MIGRATIONS.md (historical entries), planning/,
docs/plans/, docs/evaluations/.

A final broad sweep (`rg "core/workflows/[a-z]"` excluding types/,
protocols/, README, CHANGELOG, MIGRATIONS, planning/, docs/plans/,
docs/evaluations/) found hits only in the root `CLAUDE.md` file.
This file is gitignored (confirmed via `git check-ignore`) and is
explicitly listed in the project's CLAUDE.md as exempt from the
structural update protocol ("Editing this CLAUDE.md file
(project-level, gitignored)" under "When it does NOT apply"). Not a
canonical file. Not a failure.

### 7. Integration templates reference the new paths consistently

**Result: PASS**

Both integration templates verified exhaustively:

**integrations/claude-code/CLAUDE.md** -- 13 workflow path references,
all using new paths (types/ or protocols/ prefix). Zero stale flat
paths.

**integrations/copilot/copilot-instructions.md** -- 13 workflow path
references, all using new paths. Zero stale flat paths.

The two templates are consistent with each other: every workflow
path that appears in one also appears in the other (where the
sections overlap), and both use the same new path format.

### 8. CHANGELOG historical entries were NOT modified

**Result: PASS**

The 0.26.0 entry (lines 100-157) retains old flat paths such as
`core/workflows/task-workflow.md`, `core/workflows/dispatch-protocol.md`,
and `core/workflows/doc-triggers.md`. These are correct -- they
describe the file state at that version. Spot-checked entries for
0.25.0, 0.22.0, 0.20.0, 0.18.0, and 0.14.0 -- all retain their
original old-path references. Only the new 0.27.0 entry (lines 9-97)
was added.

### 9. MIGRATIONS historical entries were NOT modified

**Result: PASS**

The 0.26.0 migration entry (lines 74-119) retains old flat paths
such as `core/workflows/dispatch-protocol.md`,
`core/workflows/doc-triggers.md`, and
`core/workflows/task-workflow.md`. Spot-checked entries for 0.22.0,
0.20.0, 0.18.0, and 0.14.0 -- all retain original old-path
references. Only the new 0.27.0 entry (lines 7-71) was added.

### 10. core/workflows/README.md exists and documents the types vs. protocols distinction

**Result: PASS**

The file exists (30 lines). It documents:
- `types/` -- workflow type definitions (complete workflows an
  orchestrator can run)
- `protocols/` -- supporting processes (reusable across workflow
  types, never run standalone)
- Guidance for adding new workflow types and new protocols
- Cross-reference to ADD-WORKFLOW.md for the full addition process

The distinction is clear and accurately reflects the directory
contents.

---

## Verdict: PASS

All 10 checklist items pass. Zero stale references found in any
canonical file. All 15 moved/renamed files exist at their new
locations. All old flat files have been removed. Cross-references
across all 28+ changed files resolve correctly. Historical entries
in CHANGELOG and MIGRATIONS are intact.
