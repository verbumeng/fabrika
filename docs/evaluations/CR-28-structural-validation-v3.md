# Structural Validation Report — v0.27.0 (CR-28 v3)

**Date:** 2026-05-03
**Verdict:** PASS

## Per-Check Results

### 1. File Existence

Every file referenced in the CHANGELOG 0.27.0 entry verified at
its stated path.

| # | File | Status |
|---|------|--------|
| 1.1 | `core/workflows/README.md` | EXISTS |
| 1.2 | `core/workflows/types/agentic-workflow.md` | EXISTS |
| 1.3 | `core/workflows/types/development-workflow.md` | EXISTS |
| 1.4 | `core/workflows/types/task-workflow.md` | EXISTS |
| 1.5 | `core/workflows/types/analytics-workspace.md` | EXISTS |
| 1.6 | `core/workflows/protocols/dispatch-protocol.md` | EXISTS |
| 1.7 | `core/workflows/protocols/design-alignment.md` | EXISTS |
| 1.8 | `core/workflows/protocols/sprint-coordination.md` | EXISTS |
| 1.9 | `core/workflows/protocols/doc-triggers.md` | EXISTS |
| 1.10 | `core/workflows/protocols/hooks-reference.md` | EXISTS |
| 1.11 | `core/workflows/protocols/knowledge-pipeline.md` | EXISTS |
| 1.12 | `core/workflows/protocols/knowledge-synthesis.md` | EXISTS |
| 1.13 | `core/workflows/protocols/progress-files.md` | EXISTS |
| 1.14 | `core/workflows/protocols/task-promotion.md` | EXISTS |
| 1.15 | `core/workflows/protocols/token-estimation.md` | EXISTS |
| 1.16 | `core/workflows/protocols/analytics-onboarding.md` | EXISTS |
| 1.17 | `core/agents/AGENT-CATALOG.md` | EXISTS |
| 1.18 | `core/agents/analysis-planner.md` | EXISTS |
| 1.19 | `core/agents/data-architect.md` | EXISTS |
| 1.20 | `core/agents/software-architect.md` | EXISTS |
| 1.21 | `core/agents/archetypes/architect.md` | EXISTS |
| 1.22 | `core/agents/structural-validator.md` | EXISTS |
| 1.23 | `core/Document-Catalog.md` | EXISTS |
| 1.24 | `core/maintenance-checklist.md` | EXISTS |
| 1.25 | `core/templates/Batch-Index-Schema.md` | EXISTS |
| 1.26 | `core/topologies/Sprint-Contract-Pipeline.md` | EXISTS |
| 1.27 | `integrations/claude-code/CLAUDE.md` | EXISTS |
| 1.28 | `integrations/copilot/copilot-instructions.md` | EXISTS |
| 1.29 | `BOOTSTRAP.md` | EXISTS |
| 1.30 | `ADOPT.md` | EXISTS |
| 1.31 | `ADD-WORKFLOW.md` | EXISTS |
| 1.32 | `Domain-Language.md` | EXISTS |
| 1.33 | `UPDATE.md` | EXISTS |
| 1.34 | `wiki/topics/workflow-design.md` | EXISTS |
| 1.35 | `wiki/topics/agent-model.md` | EXISTS |
| 1.36 | `wiki/topics/owner-preferences.md` | EXISTS |

Old flat paths confirmed absent — only `core/workflows/README.md`
remains at the root level; all 15 former flat workflow files have been
removed.

**Verdict: PASS**

### 2. Version Consistency

- VERSION file: `0.27.0`
- CHANGELOG latest entry header: `0.27.0`
- Match: exact

**Verdict: PASS**

### 3. Catalog Accuracy — AGENT-CATALOG

Agent Files table row count: 32 (lines 104-135 of AGENT-CATALOG.md).
Actual `.md` files in `core/agents/` (excluding `AGENT-CATALOG.md`,
`agent-frontmatter-spec.md`, and `archetypes/` subdirectory): 32.

Every row in the Agent Files table verified against files on disk. All
32 entries resolve. Mapping tables (Sprint-Based, Task-Based,
Methodology-Based) cross-checked — every agent named in mapping tables
has a corresponding Agent Files row.

Path references in AGENT-CATALOG: `core/workflows/types/agentic-workflow.md`
(line 44) and `core/workflows/protocols/dispatch-protocol.md` (line 98)
both use new paths and both targets exist.

**Verdict: PASS**

### 4. Catalog Accuracy — Document-Catalog

Document-Catalog was modified (design-alignment path reference
updated). Checked lines 80 and 96 — both now reference
`core/workflows/protocols/design-alignment.md`. Target exists.

**Verdict: PASS**

### 5. Pattern Compliance

No new agent files were created. `structural-validator.md` was
modified but is an existing agent with established structure.
Confirmed it retains all expected validator archetype sections:
role/identity opening, orientation, verification procedures, output
format, calibration, context window hygiene.

**Verdict: PASS (no new agents to check)**

### 6. Cross-Reference Resolution

Comprehensive grep for all old flat workflow path patterns across the
entire repo. Every pattern was searched:

| Old path pattern | Hits in canonical files | Hits in historical files |
|-----------------|------------------------|-------------------------|
| `core/workflows/agentic-workflow-lifecycle` | 0 | 69 (CHANGELOG, MIGRATIONS, planning/, docs/plans/, docs/evaluations/) |
| `core/workflows/sprint-lifecycle` | 0 | 26 (same categories) |
| `core/workflows/development-workflow` (flat) | 0 | 65 (same categories) |
| `core/workflows/dispatch-protocol` (flat) | 0 | 80+ (same categories) |
| `core/workflows/design-alignment` (flat) | 0 | 47 (same categories) |
| `core/workflows/token-estimation` (flat) | 0 | 38 (same categories) |
| `core/workflows/knowledge-pipeline.md` (flat) | 0 | 7 (same categories) |
| `core/workflows/knowledge-synthesis.md` (flat) | 0 | 7 (same categories) |
| `core/workflows/doc-triggers.md` (flat) | 0 | 10 (same categories) |
| `core/workflows/hooks-reference.md` (flat) | 0 | 6 (same categories) |
| `core/workflows/progress-files.md` (flat) | 0 | 6 (same categories) |
| `core/workflows/task-promotion.md` (flat) | 0 | 7 (same categories) |
| `core/workflows/analytics-onboarding.md` (flat) | 0 | 9 (same categories) |
| `core/workflows/task-workflow.md` (flat) | 0 | 6 (same categories) |
| `core/workflows/analytics-workspace.md` (flat) | 0 | 24 (same categories) |

Zero stale references in any canonical file. All historical file hits
are in allowed exclusion categories (CHANGELOG, MIGRATIONS, planning/,
docs/plans/, docs/evaluations/).

New path references verified in all changed files:

- **Workflow files (types/ and protocols/):** All internal
  cross-references use `core/workflows/types/` or
  `core/workflows/protocols/` paths. Verified: agentic-workflow.md,
  development-workflow.md, task-workflow.md, analytics-workspace.md,
  sprint-coordination.md, knowledge-synthesis.md,
  knowledge-pipeline.md, design-alignment.md, doc-triggers.md.
- **Agent prompt files:** analysis-planner.md, data-architect.md,
  software-architect.md, archetypes/architect.md all reference
  `protocols/dispatch-protocol.md` or `protocols/task-promotion.md`.
- **Integration templates:** claude-code/CLAUDE.md has 13 workflow
  references, all using new paths. copilot/copilot-instructions.md
  has 13 workflow references, all using new paths.
- **Root-level docs:** BOOTSTRAP.md (4 refs), ADOPT.md (2 refs),
  ADD-WORKFLOW.md (1 ref), Domain-Language.md (8 refs), UPDATE.md
  (1 ref) — all use new paths.
- **Core non-workflow files:** Document-Catalog.md,
  maintenance-checklist.md, Batch-Index-Schema.md,
  Sprint-Contract-Pipeline.md — all use new paths.
- **Wiki files:** workflow-design.md Core files listing (lines
  172-180), agent-model.md, owner-preferences.md — all path
  references use new paths.

**Verdict: PASS**

### 7. Integration Template Currency

Both integration templates verified:

- `integrations/claude-code/CLAUDE.md` — 13 workflow path references
  checked, all use new `types/` or `protocols/` paths.
- `integrations/copilot/copilot-instructions.md` — 13 workflow path
  references checked, all use new `types/` or `protocols/` paths.

No new agents were added, so subagent table checks are not applicable.
Workflow summaries and phase descriptions remain consistent with
workflow content (no behavioral changes in this version).

**Verdict: PASS**

### 8. Smell Test Compliance

All changed canonical files reviewed. No personal names, product
names, tool-specific assumptions, or downstream project references
found in canonical content.

**Project CLAUDE.md — path reference check (per Round 2 scope):**
CLAUDE.md references `core/workflows/types/agentic-workflow.md`
(line 14) and `core/workflows/protocols/dispatch-protocol.md`
(line 17) — both new paths, both targets exist. Integration point
map (lines 159-167) references new concept names
("development-workflow", "agentic-workflow", "sprint-coordination")
without old names. No stale path references found.

**Verdict: PASS**

### 9. CHANGELOG/MIGRATIONS Historical Preservation

CHANGELOG historical entries (0.26.0 and earlier) verified:
- 0.26.0 entry (line 108+) references `core/workflows/task-workflow.md`
  and `core/workflows/dispatch-protocol.md` — old flat paths preserved,
  NOT updated.
- 0.25.0 entry (line 167+) references
  `core/workflows/agentic-workflow-lifecycle.md` and
  `core/workflows/dispatch-protocol.md` — old paths preserved.

MIGRATIONS historical entries verified:
- 0.26.0 entry (line 79+) references `core/workflows/dispatch-protocol.md`
  and `core/workflows/doc-triggers.md` — old paths preserved.

**Verdict: PASS**

### 10. structural-validator.md Scoping (Round 2)

Verified at lines 165-176 of `core/agents/structural-validator.md`:

- Smell test exclusion preserved: "Do not check ... the project's own
  CLAUDE.md (it is project-specific and contains personal paths by
  design — smell test exclusions only)." (lines 167-170)
- Path reference checking added: "The project CLAUDE.md IS exempt from
  smell tests but is NOT exempt from path reference checks. If a
  structural update moves or renames files, verify that the project
  CLAUDE.md's file references are updated." (lines 172-176)

Scoping is correct — smell tests excluded, path checks included.

**Verdict: PASS**

### 11. CHANGELOG 0.27.0 Completeness

- structural-validator.md listed in Changed files: YES (line 81-82,
  "added path reference checking for project CLAUDE.md (smell test
  exclusion preserved)")
- Consumer update instructions include structural-validator.md: YES
  (line 102, listed in the files to update from Fabrika source)
- All 15 moved/renamed files listed with old and new paths: YES
- New file (core/workflows/README.md) listed: YES
- All 21 cross-reference-updated files listed: YES

**Verdict: PASS**

### 12. MIGRATIONS 0.27.0 Completeness

- Complete path mapping table with all 15 entries: YES (lines 21-36)
- Step-by-step consumer instructions covering reorganization, renames,
  cross-reference updates, project instruction file update, source
  file copying, and README copy: YES (lines 40-76)
- structural-validator.md not listed individually in MIGRATIONS step 5
  but is covered by the general instruction to re-copy all source
  files with updated cross-references (line 62-71 lists specific
  files including agent files). Verified: structural-validator.md is
  not in the explicit list. However, the CHANGELOG consumer update
  instructions (the primary consumer-facing update guide) DO list it.

**Verdict: PASS**

## Summary

- Checks passed: 12 / 12
- Blocking findings: 0

## Observations (Non-Blocking)

**Wiki prose historical filenames.** `wiki/topics/workflow-design.md`
line 13 uses bare filenames in historical narrative ("Six workflow
files were extracted to core/workflows/: sprint-lifecycle.md,
development-workflow.md..."). These describe the v0.7.0 state, not
current paths, and appear in a Key Decisions section that functions
as design history. The actual `core/workflows/...` path references
on lines 15, 17, and in the Core files listing (lines 172-180) all
use the correct new paths. This parallels the CHANGELOG/MIGRATIONS
treatment of historical references. Not a structural defect but
worth noting given the plan's Risk 7 mitigation.

**MIGRATIONS 0.27.0 step 5 agent file list.**
`structural-validator.md` is not individually named in the MIGRATIONS
0.27.0 step 5 file list (lines 62-67 list AGENT-CATALOG.md,
analysis-planner.md, data-architect.md, software-architect.md,
archetypes/architect.md, Document-Catalog.md, maintenance-checklist.md,
Batch-Index-Schema.md, Sprint-Contract-Pipeline.md). However, the
CHANGELOG consumer update instructions DO include it (line 102), and
the CHANGELOG is the primary consumer-facing update reference per
UPDATE.md. The MIGRATIONS entry supplements the CHANGELOG rather than
replacing it.
