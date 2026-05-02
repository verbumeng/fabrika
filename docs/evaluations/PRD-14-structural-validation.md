# PRD-14 Structural Validation Report

**Validator:** structural-validator
**Date:** 2026-05-02
**Plan:** `docs/plans/PRD-14-plan.md`
**CHANGELOG entry:** 0.23.0

---

## Verdict: PASS

All 10 checks pass. No broken references, no missing files, no
version mismatches, no catalog gaps.

---

## Per-Check Results

### Check 1: All files referenced in the CHANGELOG entry actually exist on disk

**PASS.**

Files referenced in the CHANGELOG 0.23.0 entry and their disk status:

| File | Referenced as | Exists |
|------|-------------|--------|
| `core/templates/Platform-Connection-Template.md` | NEW | Yes (confirmed via `ls`) |
| `core/workflows/analytics-workspace.md` | CHANGED | Yes (read successfully) |
| `core/Document-Catalog.md` | CHANGED | Yes (read successfully) |
| `BOOTSTRAP.md` | CHANGED | Yes (read successfully) |
| `integrations/claude-code/CLAUDE.md` | CHANGED | Yes (read successfully) |
| `integrations/copilot/copilot-instructions.md` | CHANGED | Yes (read successfully) |

The CHANGELOG also references `Source-Connection-Template.md` (as a
contrast point, not a changed file). Confirmed on disk:
`core/templates/Source-Connection-Template.md` exists.

### Check 2: VERSION file content matches the version in the latest CHANGELOG entry

**PASS.**

- `VERSION` file content: `0.23.0` (line 1, single line)
- Latest CHANGELOG heading: `## 0.23.0` (line 9)
- Match confirmed.

### Check 3: Document-Catalog Quick Reference for analytics-workspace includes the new Platform Connection document

**PASS.**

Document-Catalog lines 824-825 (Quick Reference, analytics-workspace
section):

```
**Onboarding:** sources/README.md (Source Registry Index), sources/connections/[platform]/README.md (Platform Connection), sources/connections/[platform]/[instance]/*.md, sources/tools/*.md, Domain Language
```

"Platform Connection" appears explicitly in the Onboarding line with
the correct path `sources/connections/[platform]/README.md`.

### Check 4: Document-Catalog Templates section lists Platform-Connection-Template.md

**PASS.**

Document-Catalog line 763 (Templates section, "Included based on
project type"):

```
- Platform-Connection-Template.md — `analytics-workspace`
```

The template is listed with the correct project type tag.

### Check 5: The template file core/templates/Platform-Connection-Template.md exists on disk

**PASS.**

File exists at `core/templates/Platform-Connection-Template.md` (57
lines). Content includes the expected sections: Platform Type, Cost
Model, Default Pricing Reference table, EXPLAIN Mechanism, General
Notes, and Projects / Instances. The default pricing table values
match the Platform-Specific EXPLAIN Mechanisms table in
analytics-workspace.md (BigQuery $6.25/TB, Snowflake $2-4/credit-hour,
Databricks $0.07-0.22/DBU, SQL Server N/A).

### Check 6: Cross-references — BOOTSTRAP.md references to Platform-Connection-Template and Source-Connection-Template resolve to actual files

**PASS.**

BOOTSTRAP.md references:

1. Line 467-468: `Platform-Connection-Template from
   [FABRIKA_PATH]/core/templates/Platform-Connection-Template.md`
   -- File exists on disk (confirmed).

2. Line 507-508: `Source-Connection-Template from
   [FABRIKA_PATH]/core/templates/Source-Connection-Template.md`
   -- File exists on disk (confirmed).

3. Line 444: `Source-Connection-Template.md` listed in the Phase 2W.1
   template copy list -- File exists on disk.

4. Line 547: Both templates referenced in Phase 2W.2 context -- Both
   files exist on disk.

### Check 7: Cross-references — analytics-workspace.md references to sources/connections/[platform]/README.md path convention are consistent with BOOTSTRAP.md and Document-Catalog

**PASS.**

Path convention `sources/connections/[platform]/README.md` appears in
all three files with consistent usage:

- **analytics-workspace.md** (lines 93, 167, 215, 292): Used as the
  location where platform configuration and cost model live. Tier 1
  Plan phase (line 93): "Platform configuration ... comes from
  onboarding-scaffolded files at
  `sources/connections/[platform]/README.md`." Tier 2 Plan phase
  (line 167): "Platform configuration and cost model come from
  onboarding-scaffolded files at
  `sources/connections/[platform]/README.md`."

- **BOOTSTRAP.md** (lines 466, 874): Phase 2W.1a (line 466): creates
  `sources/connections/[platform]/README.md` using the template.
  Readiness checklist (line 874): checks for platform connection
  stubs at the same path.

- **Document-Catalog** (lines 577-582, 824-825): Platform Connection
  entry (line 577): path
  `sources/connections/[platform]/README.md`. Quick Reference (line
  825): same path.

All three files agree on the path convention. The Document-Catalog
entry (line 582) explicitly states the file is "Created during
workspace onboarding (BOOTSTRAP.md Phase 2W.1a)" and "The
analytics-workspace workflow reads the cost model from this file,"
which matches both source files.

### Check 8: Integration templates (CLAUDE.md and copilot-instructions.md) mention onboarding

**PASS.**

- **CLAUDE.md** (line 329): "Platform configuration and cost model
  info are pre-populated during workspace onboarding (BOOTSTRAP.md
  Phase 2W.1a) at `sources/connections/[platform]/README.md`."

- **copilot-instructions.md** (line 240): Identical sentence:
  "Platform configuration and cost model info are pre-populated during
  workspace onboarding (BOOTSTRAP.md Phase 2W.1a) at
  `sources/connections/[platform]/README.md`."

Both integration templates include the onboarding mention in the
Analytics Workspace Workflow summary section with consistent wording.

### Check 9: CHANGELOG consumer update instructions list every file that changed

**PASS.**

CHANGELOG 0.23.0 consumer update instructions list 5 items:

1. `core/templates/Platform-Connection-Template.md` (copy new)
2. `BOOTSTRAP.md` (replace Phase 2W section)
3. `core/workflows/analytics-workspace.md` (update)
4. `core/Document-Catalog.md` (update)
5. Integration template — CLAUDE.md or copilot-instructions.md (update)

Cross-referencing with the plan's file change inventory and the
CHANGELOG's file listings: all 7 changed files are accounted for
(VERSION and CHANGELOG.md are framework housekeeping, not consumer
files — consumers have their own VERSION/CHANGELOG if applicable).
Every consumer-facing changed file has a corresponding instruction.

### Check 10: No broken file path references in any changed file

**PASS.**

Verified all file path references in each changed file:

**Platform-Connection-Template.md:**
- References `Source-Connection-Template` in line 5 (contextual
  description, not a path). No file path references to verify.

**BOOTSTRAP.md:**
- `[FABRIKA_PATH]/core/templates/Platform-Connection-Template.md`
  (line 468) -- exists
- `[FABRIKA_PATH]/core/templates/Source-Connection-Template.md`
  (line 508) -- exists
- All other `[FABRIKA_PATH]` references are pre-existing and not part
  of this change.

**analytics-workspace.md:**
- `sources/connections/[platform]/README.md` (lines 93, 167, 215,
  292) -- convention path, not a literal file reference
- `core/design-principles.md` (referenced in Review-Revise Loop
  section) -- pre-existing reference, not changed
- All other references are pre-existing.

**Document-Catalog.md:**
- `core/templates/Platform-Connection-Template.md` (line 580) --
  exists
- `core/templates/Source-Connection-Template.md` (line 764) --
  exists
- All other template references in the Templates section are
  pre-existing.

**CLAUDE.md (integration):**
- `sources/connections/[platform]/README.md` (line 329) -- convention
  path, consistent with other files
- All other references are pre-existing.

**copilot-instructions.md:**
- `sources/connections/[platform]/README.md` (line 240) -- convention
  path, consistent with other files
- All other references are pre-existing.

No broken file path references found in any changed file.

---

## Summary

All 10 verification checks pass. The 0.23.0 change set is
structurally sound: files exist where referenced, VERSION matches
CHANGELOG, catalogs are updated with correct entries, cross-references
are consistent across all changed files, integration templates reflect
the onboarding addition, and consumer update instructions are complete.
