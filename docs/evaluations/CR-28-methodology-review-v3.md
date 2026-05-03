# Methodology Review Report -- CR-28 v3

**Date:** 2026-05-03
**Verdict:** PASS

## Review Scope

This is a fresh verification of CR-28 (Workflow Folder and Terminology
Cleanup) after scope expansion in Alignment Rounds 1 and 2. The
review covers the full plan at `docs/plans/CR-28-plan.md` including
both the original folder reorganization and the Round 2 addition
(structural-validator path reference checking for project CLAUDE.md).

## Verification Checklist Results

### 1. All files referenced in the CHANGELOG entry actually exist

Every file listed in the CHANGELOG 0.27.0 entry was verified against
the filesystem:

- `core/workflows/types/` contains: agentic-workflow.md,
  development-workflow.md, task-workflow.md, analytics-workspace.md
  (4 files, all present)
- `core/workflows/protocols/` contains: dispatch-protocol.md,
  design-alignment.md, sprint-coordination.md, doc-triggers.md,
  hooks-reference.md, knowledge-pipeline.md, knowledge-synthesis.md,
  progress-files.md, task-promotion.md, token-estimation.md,
  analytics-onboarding.md (11 files, all present)
- `core/workflows/README.md` exists
- No stale .md files remain at the flat `core/workflows/` level
  (only README.md, which is intentional)
- All 21 changed files listed in the CHANGELOG exist at their
  stated paths

**Verdict:** PASS

### 2. AGENT-CATALOG agent file table matches actual files in core/agents/

The Agent Files table in AGENT-CATALOG.md lists 32 agent files. The
filesystem contains 34 .md files in core/agents/ -- the two extras
are AGENT-CATALOG.md itself and agent-frontmatter-spec.md, which are
not agent prompt files. All 32 listed agents have corresponding files.
The archetypes table lists 7 archetypes, matching the 7 files in
core/agents/archetypes/.

**Verdict:** PASS

### 3. Document-Catalog Quick Reference sections include any newly added documents

No new document types were added in CR-28. The only new file is
`core/workflows/README.md`, which is a directory guide, not a
document type. No Document-Catalog update required.

**Verdict:** PASS (N/A -- no new document types)

### 4. Doc-triggers table entries reference documents/workflows that exist

The doc-triggers table references two workflow files:
- `core/workflows/protocols/design-alignment.md` (line 7) -- exists
- `core/workflows/protocols/knowledge-synthesis.md` (line 31) -- exists

**Verdict:** PASS

### 5. VERSION file matches the version in the latest CHANGELOG entry

VERSION contains `0.27.0`. CHANGELOG latest entry is `0.27.0`.

**Verdict:** PASS

### 6. No smell test violations

Checked `core/workflows/README.md` (new file) and
`core/agents/structural-validator.md` (modified file) for personal
names, product names, tool-specific assumptions. No violations found.
The structural-validator references to LifeOS, Obsidian, Motion, etc.
appear in its search-target instructions (telling it what to look
for) -- appropriate, not violations.

**Verdict:** PASS

### 7. Cross-references between files are consistent

Comprehensive grep for all 15 old flat-path patterns across the
entire repo. Every hit was in an expected exclusion zone (CHANGELOG,
MIGRATIONS, planning/, docs/plans/, docs/evaluations/). Zero stale
references in any canonical file:

- Internal workflow cross-references (types/ referencing protocols/
  and vice versa): all updated
- Agent prompt files (AGENT-CATALOG, analysis-planner,
  data-architect, software-architect, archetypes/architect): all
  updated
- Integration templates (CLAUDE.md: 13 references, copilot-
  instructions.md: 13 references): all updated
- Root-level documents (BOOTSTRAP.md, ADOPT.md, ADD-WORKFLOW.md,
  Domain-Language.md, UPDATE.md): all updated
- Core non-workflow files (Document-Catalog, maintenance-checklist,
  Batch-Index-Schema, Sprint-Contract-Pipeline): all updated
- Wiki files (workflow-design, agent-model, owner-preferences): all
  updated

One historical filename remains in wiki/topics/workflow-design.md
line 13 ("sprint-lifecycle.md" in narrative describing the v0.7.0
extraction). This is correct -- the prose describes what the file
was called at that version, not a navigable path reference. The
Core files listing on line 174 correctly uses the new path.

**Verdict:** PASS

### 8. Integration templates reflect structural changes

Both `integrations/claude-code/CLAUDE.md` and
`integrations/copilot/copilot-instructions.md` reference all 15
moved workflow files at their new paths. Verified all workflow
pointers use `types/` or `protocols/` prefixes as appropriate. No
flat-path references remain.

**Verdict:** PASS

### 9. Consumer update instructions in the CHANGELOG are complete

The CHANGELOG 0.27.0 consumer update instructions cover:
1. Directory reorganization (types/ and protocols/)
2. File renames (agentic-workflow-lifecycle, sprint-lifecycle)
3. Cross-reference updates in local copies
4. Source file updates (11 files listed, including the Round 2
   addition of structural-validator.md)
5. Integration template update
6. New README.md copy

The MIGRATIONS.md 0.27.0 entry provides the complete 15-row path
mapping table and 6-step migration procedure. Historical migration
entries for earlier versions are untouched.

Compared the consumer update list against all changed files in the
CHANGELOG: every modified file that a consumer would need is covered,
either explicitly by name or by the "update your project instruction
file" instruction.

**Verdict:** PASS

### 10. Dispatch and output contracts are consistent

CR-28 did not change any dispatch or output contracts -- only path
references within them. The dispatch-protocol.md moved to
`protocols/dispatch-protocol.md` without content changes. All agent
prompts that reference the dispatch protocol use the new path.

**Verdict:** PASS

### 11. README.md accurately reflects current framework state

README.md lists 32 specialized agents (matches AGENT-CATALOG), 7
archetypes (matches archetypes/), 3 project type categories (sprint-
based: 8 types, task-based: 2 types, methodology-based: 1 type --
matches AGENT-CATALOG mapping tables), 9 briefing formats. No
workflow path references appear in README.md, so no stale-path risk.

**Verdict:** PASS

### 12. structural-validator.md correctly scopes CLAUDE.md checks

Lines 165-176 of structural-validator.md:
- Smell test exclusion preserved: "Do not check ... the project's
  own CLAUDE.md (it is project-specific and contains personal paths
  by design -- smell test exclusions only)."
- Path reference checking explicitly added: "The project CLAUDE.md
  IS exempt from smell tests but is NOT exempt from path reference
  checks. If a structural update moves or renames files, verify that
  the project CLAUDE.md's file references are updated."

This correctly separates the two concerns. The smell test exclusion
for CLAUDE.md is preserved (personal paths are expected in a
gitignored file), while the path reference gap that caused stale
references is closed.

**Verdict:** PASS

### 13. CHANGELOG 0.27.0 entry mentions both scope items

The CHANGELOG entry lead paragraph explicitly mentions both:
- Folder reorganization: "Reorganizes `core/workflows/` into two
  subdirectories..."
- Structural-validator fix: "Also fixes a systemic issue where the
  project-level CLAUDE.md and structural-validator agent were not
  properly scoped for path reference checks during structural
  updates."

The changed files list includes `core/agents/structural-validator.md`
with the note "added path reference checking for project CLAUDE.md
(smell test exclusion preserved)".

**Verdict:** PASS

## Summary

All 13 verification checks pass. The CR-28 execution is complete and
consistent. The folder reorganization is clean -- 15 files moved to
correct subdirectories, 2 renamed, all 93+ cross-references updated,
no stale paths in any canonical file. The Round 2 scope expansion
(structural-validator CLAUDE.md path checking) is correctly
implemented with the smell test / path reference distinction properly
scoped. Historical files (CHANGELOG entries, MIGRATIONS entries,
planning docs, evaluation reports) were correctly left untouched.
The MIGRATIONS.md entry provides consumers with a complete path
mapping and step-by-step migration procedure.
