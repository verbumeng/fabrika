---
type: verification-report
change-request: planning/CR-29-unified-document-hierarchy.md
plan: docs/plans/CR-29-plan.md
verdict: PASS
created: 2026-05-04
---

# CR-29 Structural Validation Report

**Verdict: PASS**

All 11 verification criteria pass. No stale references to retired
concepts found in active canonical files. Template paths resolve.
Dispatch contract field names are consistent with agent prompts.
Integration templates are substantively aligned.

---

## Per-Criterion Findings

### 1. Files exist at stated paths

**PASS**

New files exist:
- `core/templates/Task-Template.md` — exists
- `core/templates/Roadmap-Template.md` — exists

Renamed file exists at new path:
- `core/templates/Analysis-Outcome-Template.md` — exists

Deleted files are gone:
- `core/templates/Brief-Template.md` — confirmed absent
- `core/templates/Analysis-Brief-Template.md` — confirmed absent
- `core/templates/Outcome-Report-Template.md` — confirmed absent

### 2. VERSION matches CHANGELOG

**PASS**

- `VERSION` contains `0.33.0` (line 1)
- `CHANGELOG.md` latest entry is `## 0.33.0 — Unified document
  hierarchy: brief -> task, decomposition = alignment` (line 9)

### 3. Template references match actual files

**PASS**

Verified all template paths referenced in key consumer-facing files
against the actual contents of `core/templates/`:

**Document-Catalog.md** — references Task-Template.md (line 601),
Plan-Template.md (line 607), Outcome-Template.md (line 613),
Analysis-Plan-Template.md (line 722), Analysis-Outcome-Template.md
(lines 613, 727, 901), Roadmap-Template.md (line 887),
Task-Contract-Template.md (line 902), Platform-Connection-Template.md
(line 896), Source-Connection-Template.md (line 897),
System-Update-Plan-Template.md (line 903), and all other templates
listed in the Templates section (lines 869-903). All resolve to actual
files in `core/templates/`.

**BOOTSTRAP.md** — references Task-Template.md (lines 464, 508),
Analysis-Plan-Template.md (line 509), Analysis-Outcome-Template.md
(line 510), Task-Contract-Template.md (line 511), and standard sprint
templates. All resolve.

**ADOPT.md** — references Sprint-Retro-Template.md (line 75). No
stale Brief-Template reference found.

**ADD-WORKFLOW.md** — references Task-Template.md (line 41),
Plan-Template.md (line 42), Outcome-Template.md (line 43). All
resolve.

**Integration templates** — CLAUDE.md and copilot-instructions.md
reference template paths via `[FABRIKA_PATH]/core/templates/` (not
hardcoded filenames in the templates section), so they resolve
correctly through the Document Catalog and workflow files.

### 4. No stale "brief.md" paths in active canonical files

**PASS**

Grep for `brief\.md` returned 6 files. All are in excluded
directories:
- `CHANGELOG.md` — excluded
- `MIGRATIONS.md` — excluded
- `docs/plans/CR-29-plan.md` — excluded (docs/plans/)
- `planning/CR-29-unified-document-hierarchy.md` — excluded (planning/)
- `planning/CR-17-task-workspace-project-type.md` — excluded (planning/)
- `planning/PRD-12-plan-persistence-alignment.md` — excluded (planning/)

Zero hits in active canonical files.

### 5. No stale "Brief-Template" references

**PASS**

Grep for `Brief-Template` returned 7 files. Categorized:
- `CHANGELOG.md` — excluded
- `MIGRATIONS.md` — excluded
- `docs/plans/CR-29-plan.md` — excluded (docs/plans/)
- `docs/plans/CR-17-plan.md` — excluded (docs/plans/)
- `planning/CR-29-unified-document-hierarchy.md` — excluded (planning/)
- `planning/ROADMAP-v2.md` — excluded (planning/)
- `docs/evaluations/CR-19-structural-validation.md` — historical
  evaluation report from a prior CR. Line 224 references
  `Brief-Template.md` in a verification table documenting what existed
  at CR-19 validation time. This is archival data, not an active
  instruction. Acceptable.

Zero hits in active canonical instruction files.

### 6. No stale "brief-check" references

**PASS**

Grep for `brief-check` returned 3 files:
- `CHANGELOG.md` — excluded
- `MIGRATIONS.md` — excluded
- `docs/plans/CR-29-plan.md` — excluded (docs/plans/)

Zero hits in active canonical files.

### 7. No stale "MEETS BRIEF" references

**PASS**

Grep for `MEETS BRIEF` returned 2 files:
- `CHANGELOG.md` — excluded
- `docs/plans/CR-29-plan.md` — excluded (docs/plans/)

Zero hits in active canonical files.

### 8. No stale "Outcome-Report-Template" references

**PASS**

Grep for `Outcome-Report-Template` returned 5 files:
- `CHANGELOG.md` — excluded
- `MIGRATIONS.md` — excluded
- `docs/plans/CR-29-plan.md` — excluded (docs/plans/)
- `docs/plans/CR-17-plan.md` — excluded (docs/plans/)
- `planning/CR-29-unified-document-hierarchy.md` — excluded (planning/)

Zero hits in active canonical files.

### 9. Dispatch contract field names match agent prompts

**PASS**

Verified field name consistency for "Task document" across all base
agents:

**Planner (base):**
- Dispatch contract in `core/workflows/protocols/dispatch/planner-contracts.md`
  line 172: `| Task document | Yes |`
- Agent prompt `core/agents/planner.md` line 213: `| Task document | Yes |`
- Match confirmed.

**Reviewer (base):**
- Dispatch contract in `core/workflows/protocols/dispatch/reviewer-contracts.md`
  line 146: `| Task document | Yes |`
- Agent prompt `core/agents/reviewer.md` line 130: `| Task document | Yes |`
- Match confirmed.

**Validator (base):**
- Dispatch contract in `core/workflows/protocols/dispatch/validator-contracts.md`
  line 132: `| Task document | Yes |`
- Agent prompt `core/agents/validator.md` line 135: `| Task document | Yes |`
- Match confirmed.

**Implementer (base):**
- Dispatch contract in `core/workflows/protocols/dispatch/implementer-contracts.md`
  line 176: `| Task document | Yes |`
- Agent prompt `core/agents/implementer.md` line 132: `| Task document | Yes |`
- Match confirmed.

**Analysis Planner (validation mode):**
- Dispatch contract in `core/workflows/protocols/dispatch/planner-contracts.md`
  line 130: `| Task document | Yes |`
- Agent prompt `core/agents/analysis-planner.md` line 101:
  `| Task document | Yes |`
- Match confirmed.

**Logic Reviewer:**
- Dispatch contract in `core/workflows/protocols/dispatch/reviewer-contracts.md`
  line 37: `| Task document | Yes |`
- Consistent with "Task document" naming.

**Data Validator:**
- Dispatch contract in `core/workflows/protocols/dispatch/validator-contracts.md`
  line 113: `| Task document | Yes |`
- Consistent with "Task document" naming.

**Performance Reviewer (analytics):**
- Dispatch contract in `core/workflows/protocols/dispatch/reviewer-contracts.md`
  line 115: `| Task document | Yes |`
- Consistent with "Task document" naming.

**Visualization Designer:**
- Dispatch contract in `core/workflows/protocols/dispatch/designer-contracts.md`
  line 16: `| Requirements | Yes | Story acceptance criteria or task document |`
- Uses "task document" in the description. Consistent.

No instances of "Brief" as a field name found in any dispatch contract
or agent prompt dispatch table.

### 10. Document-Catalog Quick Reference sections

**PASS**

Verified the Quick Reference sections in `core/Document-Catalog.md`:

**Analytics workflow section** (lines 956-962):
- Per-task documents listed as: `task.md, plan.md, outcome.md,
  validation-report.md` — uses `task.md`, not `brief.md`
- Evaluations listed as: `[task-name]-plan-check.md` — not
  `brief-check.md`
- No reference to Brief-Template or Outcome-Report-Template

**Task-workspace section** (lines 964-969):
- Per-task documents listed as: `task.md, plan.md, outcome.md,
  validation-report.md` — uses `task.md`, not `brief.md`
- Evaluations listed as: `[task-name]-plan-check.md` — correct

**Base templates section** (lines 883-887):
- Lists `Task-Template.md` (not Brief-Template)
- Lists `Plan-Template.md`, `Outcome-Template.md`
- Lists `Roadmap-Template.md` (new)
- No stale references

**Analytics-specific templates section** (lines 900-901):
- Lists `Analysis-Plan-Template.md` and `Analysis-Outcome-Template.md`
  (not Outcome-Report-Template)

### 11. Integration template parity

**PASS**

Compared the Design Alignment sections of
`integrations/claude-code/CLAUDE.md` (lines 341-353) and
`integrations/copilot/copilot-instructions.md` (lines 250-261).

Both state:
- Alignment triggers: new project, new phase, ambiguity detected,
  owner request
- Produces: Project Charter (first time only), PRD (per phase/feature),
  Domain Language
- No mention of "enhanced brief" or "enhanced Analysis Brief" in
  either file
- Both reference `[FABRIKA_PATH]/core/workflows/protocols/design-alignment.md`

The Copilot version is slightly more compressed (fewer formatting
details) but substantively identical.

Work Type Routing sections also match (CLAUDE.md lines 35-66 vs.
copilot-instructions.md lines 33-66):
- Both define Task, Bug, Story, Epic backlog types
- Task references task workflow, not brief workflow
- Both use consistent "task/plan/implement/review/validate/deliver"
  lifecycle

Analytics Workflow sections match (CLAUDE.md lines 400-411 vs.
copilot-instructions.md lines 309-319):
- Both describe Tier 1 and Tier 2 workflows
- Both use `plan check` not `brief check`
- Both reference `analytics-workflow.md`

Task Workflow agent tables match (CLAUDE.md lines 559-573 vs.
copilot-instructions.md lines 379-390):
- Both describe planner as "reads task document"
- Both describe validator as "validates deliverables satisfy the task
  document"
- No "brief" references in either

---

## Summary

All 11 criteria pass. The brief-to-task rename was executed
comprehensively across all active canonical files. Stale references
exist only in the expected locations: CHANGELOG (historical entries),
MIGRATIONS (migration instructions referencing the old names), plan
files (describing the rename), and planning documents (historical CRs
and roadmaps). One historical evaluation report
(`docs/evaluations/CR-19-structural-validation.md`) contains a
reference to `Brief-Template.md` in an archival verification table,
which is acceptable.
