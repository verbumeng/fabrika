# PRD-14 Structural Validation (v2)

**Plan:** `docs/plans/PRD-14-plan.md` (revised after owner feedback)
**Version:** 0.23.0
**Verdict:** PASS

---

## Check 1: All files referenced in CHANGELOG actually exist on disk

**Verdict:** PASS

Files referenced in the 0.23.0 CHANGELOG entry and their on-disk
status:

| File | Status |
|------|--------|
| `core/workflows/analytics-onboarding.md` | Exists (NEW) |
| `core/templates/Platform-Connection-Template.md` | Exists (NEW) |
| `core/workflows/analytics-workspace.md` | Exists (CHANGED) |
| `core/Document-Catalog.md` | Exists (CHANGED) |
| `BOOTSTRAP.md` | Exists (CHANGED) |
| `ADOPT.md` | Exists (CHANGED) |
| `integrations/claude-code/CLAUDE.md` | Exists (CHANGED) |
| `integrations/copilot/copilot-instructions.md` | Exists (CHANGED) |

All referenced files confirmed present.

---

## Check 2: VERSION content matches latest CHANGELOG version header

**Verdict:** PASS

- `VERSION` file content: `0.23.0`
- Latest CHANGELOG header: `## 0.23.0`

Match confirmed.

---

## Check 3: analytics-onboarding.md exists and is self-contained (has all four question groups)

**Verdict:** PASS

File exists at `core/workflows/analytics-onboarding.md`. Contains:

- Question Group 1: Platforms and Technology (line 21)
- Question Group 2: Cost Model (Cloud Platforms) (line 43)
- Question Group 3: Source Registry Scaffolding (line 66)
- Question Group 4: Data Governance (line 81)

All four groups present with skip instructions and output
descriptions. The file is self-contained with its own Prerequisites
section and does not depend on inline content from BOOTSTRAP.md.

---

## Check 4: Platform-Connection-Template.md exists with cost model section

**Verdict:** PASS

File exists at `core/templates/Platform-Connection-Template.md`.
Contains:

- `## Cost Model` section (line 13)
- Pricing model, cost basis, rate, cost model source fields
- `### Default Pricing Reference` subsection (line 25) with a table
  matching the rates in analytics-workspace.md's Platform-Specific
  EXPLAIN Mechanisms table (BigQuery $6.25/TB, Snowflake $2-4/credit-
  hour, Databricks $0.07-0.22/DBU, SQL Server N/A, PostgreSQL N/A,
  MySQL N/A)
- `## EXPLAIN Mechanism` section (line 39)
- `## Platform Type` section (line 8) with environment field
  (cloud/on-prem/local)

The template structure matches what analytics-workspace.md expects to
read at `sources/connections/[platform]/README.md`.

---

## Check 5: BOOTSTRAP.md 2W.1a contains a pointer to analytics-onboarding.md (not inline content)

**Verdict:** PASS

BOOTSTRAP.md line 455: `### 2W.1a Platform onboarding (optional)`

Lines 457-461 read:
> Run the analytics onboarding protocol at
> `[FABRIKA_PATH]/core/workflows/analytics-onboarding.md`. This asks
> the user about platforms, cost models, source connections, and data
> governance tooling. All questions are skippable. Answers produce
> pre-populated platform connection stubs in the source registry.

This is a pointer to the extracted file, not inline content. Consistent
with the revised plan's decision to extract onboarding questions from
BOOTSTRAP.md.

---

## Check 6: BOOTSTRAP.md template copy list includes Platform-Connection-Template.md

**Verdict:** PASS

BOOTSTRAP.md line 444:
`- `Platform-Connection-Template.md` -> `docs/Templates/Platform-Connection-Template.md``

Present in the Phase 2W.1 template copy list alongside the existing
Source-Connection-Template.md, Source-Tool-Template.md, etc.

---

## Check 7: ADOPT.md references analytics-onboarding.md

**Verdict:** PASS

ADOPT.md lines 151-167 contain a new section titled "Analytics
Workspace Onboarding (Existing Workspaces)" that reads:
> Run: `[FABRIKA_PATH]/core/workflows/analytics-onboarding.md`

The section explains retroactive onboarding for existing workspaces
and notes that existing source registry files are not affected.

---

## Check 8: Document-Catalog Quick Reference for analytics-workspace includes Platform Connection

**Verdict:** PASS

Document-Catalog line 825:
> **Onboarding:** sources/README.md (Source Registry Index),
> sources/connections/[platform]/README.md (Platform Connection),
> sources/connections/[platform]/[instance]/*.md, sources/tools/*.md,
> Domain Language

"Platform Connection" is listed in the Onboarding line of the
analytics-workspace Quick Reference section.

---

## Check 9: Document-Catalog Templates section lists Platform-Connection-Template.md

**Verdict:** PASS

Document-Catalog line 763:
`- Platform-Connection-Template.md -- `analytics-workspace``

Present in the "Included based on project type" template list.

---

## Check 10: Both integration templates mention onboarding

**Verdict:** PASS

- `integrations/claude-code/CLAUDE.md` line 329 contains: "Platform
  configuration and cost model info are pre-populated during workspace
  onboarding (BOOTSTRAP.md Phase 2W.1a) at
  `sources/connections/[platform]/README.md`."

- `integrations/copilot/copilot-instructions.md` line 240 contains
  the identical sentence: "Platform configuration and cost model info
  are pre-populated during workspace onboarding (BOOTSTRAP.md Phase
  2W.1a) at `sources/connections/[platform]/README.md`."

Both integration templates include the onboarding reference in the
Analytics Workspace Workflow summary section.

---

## Check 11: Cross-references — path convention consistency

**Verdict:** PASS

The path convention `sources/connections/[platform]/README.md` is
used consistently across all files that reference it:

- **analytics-onboarding.md** (line 27): "create
  `sources/connections/[platform]/README.md` using the
  Platform-Connection-Template"
- **analytics-workspace.md** (lines 93, 167, 215, 292): Tier 1 Plan,
  Tier 2 Plan, execution manifest cost calculation, and default cost
  estimate note all reference the same path.
- **BOOTSTRAP.md** (lines 457-461, 477, 804): Phase 2W.1a pointer,
  Phase 2W.2 connection creation, readiness checklist.
- **ADOPT.md** (line 162): "produce
  `sources/connections/[platform]/README.md` files"
- **Document-Catalog** (lines 577, 825): Document entry heading and
  Quick Reference.
- **CLAUDE.md integration** (line 329): path in onboarding sentence.
- **copilot-instructions.md integration** (line 240): same path.
- **CHANGELOG** (lines 32, 43, 48, 89): new files, core changes,
  consumer instructions.
- **Platform-Connection-Template.md** (line 3): "Platform-level
  overview for `sources/connections/[platform]/`."

No inconsistencies found. All files use the identical path convention.

---

## Check 12: CHANGELOG consumer update instructions list every changed file

**Verdict:** PASS

Consumer update instructions (CHANGELOG lines 77-90) list:

1. Copy new: `core/workflows/analytics-onboarding.md` -- listed
2. Copy new: `core/templates/Platform-Connection-Template.md` -- listed
3. Replace `BOOTSTRAP.md` -- listed
4. Update `ADOPT.md` -- listed
5. Update `core/workflows/analytics-workspace.md` -- listed
6. Update `core/Document-Catalog.md` -- listed
7. Update integration template (CLAUDE.md or copilot-instructions.md)
   -- listed
8. Retroactive onboarding instructions for existing workspaces --
   listed

Every changed file from the dispatch list is accounted for. The new
workflow file `core/workflows/analytics-onboarding.md` is explicitly
listed as a file to copy (line 78) and also referenced in the
retroactive onboarding instruction (line 87). ADOPT.md is explicitly
listed (line 81).

---

## Check 13: No broken file path references

**Verdict:** PASS

All file paths referenced across the changed files resolve to actual
files or are runtime-generated paths (task folders, consumer project
paths using `[FABRIKA_PATH]` or `[platform]` placeholders):

- `core/workflows/analytics-onboarding.md` -- exists
- `core/templates/Platform-Connection-Template.md` -- exists
- `core/templates/Source-Connection-Template.md` -- referenced in
  analytics-onboarding.md prerequisites; pre-existing file
- `core/workflows/analytics-workspace.md` -- exists
- `core/Document-Catalog.md` -- exists
- `core/workflows/task-promotion.md` -- referenced in analytics-
  workspace.md; pre-existing file
- `core/workflows/dispatch-protocol.md` -- referenced in analytics-
  workspace.md; pre-existing file
- `core/briefings/task-outcome-briefing.md` -- referenced in
  analytics-workspace.md; pre-existing file
- `core/design-principles.md` -- referenced in analytics-workspace.md;
  pre-existing file

No dangling references found.

---

## Summary

All 13 verification checks pass. The implementation matches the
revised plan. The extraction of onboarding questions into
`core/workflows/analytics-onboarding.md` (the key revision after
owner feedback) is correctly implemented: BOOTSTRAP.md Phase 2W.1a
contains a pointer to the extracted file, and the onboarding file is
self-contained with all four question groups. Cross-references are
consistent across all changed files. Consumer update instructions are
complete.
