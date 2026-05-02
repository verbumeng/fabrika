---
status: approved (revised after owner feedback in Step 5)
identifier: PRD-14
version_target: 0.23.0
---

# PRD-14 Plan: Analytics Workspace Onboarding Protocol

## Summary

Adds a structured onboarding questionnaire to the analytics-workspace
bootstrap process (BOOTSTRAP.md Phase 2W). After directory
scaffolding and agent installation, the orchestrator asks the user
about platforms/technology, cost models, source connections, and data
governance tooling. All questions are skippable. Answers produce
pre-populated template files in the source registry (Level 1 stubs at
most). Also adds two new template files to `core/templates/` for the
platform connection README and the onboarding questionnaire reference,
and updates the analytics-workspace workflow to reference onboarding
as the source of platform configuration.

## File Change Inventory

### New files

| File | Purpose |
|------|---------|
| `core/templates/Platform-Connection-Template.md` | Template for `sources/connections/[platform]/README.md` — platform overview with cost model section, default pricing reference, connection notes. Used during onboarding to scaffold platform-level stubs. Distinct from `Source-Connection-Template.md` which is for Level 1 project/instance connections beneath a platform. |
| ~~`core/templates/Onboarding-Questionnaire-Reference.md`~~ | **DROPPED (alignment decision).** Onboarding questions stay inline in BOOTSTRAP.md Phase 2W. BOOTSTRAP.md is read once in a session whose purpose is bootstrapping — no context budget concern. Eliminates a sync obligation. |

### Modified files

| File | What changes |
|------|-------------|
| `BOOTSTRAP.md` | Phase 2W gets a new section **2W.1a** (after agent setup, before source inventory conversation) containing the onboarding questionnaire: four question groups (platforms/technology, cost model, source registry scaffolding, data governance). Each group has skip instructions and describes what output it produces. The existing 2W.2 source inventory conversation is updated to note that onboarding answers pre-populate some of the information it would otherwise ask for — if onboarding was completed, 2W.2 starts from what's already scaffolded rather than from scratch. The Phase 2W readiness checklist at the end of BOOTSTRAP.md gets a new item for platform connection stubs. |
| `core/workflows/analytics-workspace.md` | Two changes: (1) The Plan phase for both Tier 1 and Tier 2 workflows gains a note that platform configuration comes from onboarding-scaffolded files at `sources/connections/[platform]/README.md` (cost model, platform type). This replaces the current implicit assumption that cost model info just exists in those files. (2) The Platform-Specific EXPLAIN Mechanisms table gains a note referencing onboarding as the point where cost model is initially captured. |
| `core/Document-Catalog.md` | Three changes: (1) New entry under the analytics-workspace Documents section for `sources/connections/[platform]/README.md` (Platform Connection) — Tier 1, populated during onboarding. (2) The existing `sources/connections/*.md` entry is clarified to describe Level 1 project/instance stubs beneath the platform README. (3) Quick Reference analytics-workspace section updated: the Onboarding line gains "sources/connections/[platform]/README.md (Platform Connection)" alongside the existing sources/README.md. (4) Templates section gains `Platform-Connection-Template.md` for analytics-workspace. |
| `integrations/claude-code/CLAUDE.md` | The Analytics Workspace Workflow summary section gets one additional sentence noting that workspace onboarding pre-populates platform configuration and cost model info from user input during bootstrap. No structural changes to the template. |
| `integrations/copilot/copilot-instructions.md` | Parallel change to the CLAUDE.md integration template. Same one-sentence addition to the Analytics Workspace Workflow summary. |
| `VERSION` | `0.22.0` -> `0.23.0` |
| `CHANGELOG.md` | New entry for 0.23.0 following established format: summary paragraph, new files table, core changed files with descriptions, integration changed files, consumer update instructions. |

## Integration Point Analysis

### BOOTSTRAP.md <-> core/workflows/analytics-workspace.md
BOOTSTRAP.md Phase 2W creates the `sources/connections/[platform]/README.md`
files during onboarding. The analytics-workspace workflow references
those files for cost model data during the Plan and Performance Review
phases. The two files must agree on:
- The path convention: `sources/connections/[platform]/README.md`
- The cost model section structure within that file
- The fallback behavior when cost model is unknown

Both files already use this path convention (analytics-workspace.md
lines 164-165, 211, 286). The onboarding formalizes how those files
get created.

### BOOTSTRAP.md <-> core/templates/Platform-Connection-Template.md
The new Phase 2W.1a section tells the orchestrator to use this
template when scaffolding platform connections. The template must
match the structure that `analytics-workspace.md` expects to read
(cost model section, platform type, default pricing reference).

### BOOTSTRAP.md <-> core/templates/Source-Connection-Template.md
The existing Source-Connection-Template.md is for Level 1
project/instance connections. Onboarding creates Level 1 stubs using
this existing template. No change needed to the template itself — but
BOOTSTRAP.md must be clear about which template is used at which
level (Platform-Connection-Template for the platform README,
Source-Connection-Template for the Level 1 stubs beneath it).

### core/Document-Catalog.md <-> BOOTSTRAP.md
The Document-Catalog lists what documents exist and when they're
created. Adding the Platform Connection entry and updating the Quick
Reference must match what BOOTSTRAP.md actually scaffolds.

### core/Document-Catalog.md <-> core/templates/
The Templates section of the Document-Catalog must list the new
`Platform-Connection-Template.md`. The template file must exist.

### integrations/ <-> core/workflows/analytics-workspace.md
Both integration templates (CLAUDE.md and copilot-instructions.md)
have an Analytics Workspace Workflow summary section that points
readers to the full workflow file. The summary must accurately
reflect that onboarding is now a source of platform config, but the
detail stays in the workflow file itself.

### BOOTSTRAP.md Phase 2W.1a <-> Phase 2W.2
The new onboarding step (2W.1a) scaffolds platform stubs. The
existing source inventory conversation (2W.2) asks the user about
connections, tools, and files. These must not conflict: 2W.2 should
build on what 2W.1a produced, not re-ask redundant questions. The
plan needs to update 2W.2's preamble to acknowledge pre-scaffolded
content.

## Risk Identification

1. **Template structure mismatch.** If the Platform-Connection-
   Template.md has a cost model section that doesn't match what
   `analytics-workspace.md` expects to read (section heading, field
   names, fallback note wording), the workflow will reference a
   structure that doesn't exist in scaffolded files.

2. **Redundant questioning.** If Phase 2W.1a asks about platforms and
   connections but 2W.2 also asks "What databases do you connect to?"
   without checking what onboarding already captured, the user
   answers the same questions twice.

3. **Quick Reference drift.** If the Document-Catalog Quick Reference
   for analytics-workspace doesn't include the new Platform
   Connection document, consumers using the catalog as their
   checklist will miss creating platform stubs.

4. **Template listing gap.** If `Platform-Connection-Template.md` is
   not added to the Document-Catalog's Templates section, the
   BOOTSTRAP.md instruction to "use the Platform-Connection-Template"
   will reference a template that the catalog doesn't know about.

## Mitigations

1. **Template structure mismatch.** Write the Platform-Connection-
   Template's cost model section to match the exact structure and
   fallback wording already used in `analytics-workspace.md` lines
   164-165, 211, 286. Use the same default pricing values from the
   Platform-Specific EXPLAIN Mechanisms table (lines 276-283).
   Structural validator checks both files reference the same path and
   section structure.

2. **Redundant questioning.** Update Phase 2W.2's opening instruction
   to say: "If onboarding (2W.1a) was completed, start from the
   scaffolded platform and connection stubs. Ask only about sources
   not yet documented." Add a check: "Read `sources/connections/` to
   see what already exists before asking."

3. **Quick Reference drift.** Include the Document-Catalog Quick
   Reference update in the file change inventory (done above).
   Structural validator verifies the Quick Reference matches actual
   BOOTSTRAP.md output.

4. **Template listing gap.** Include the template in the Document-
   Catalog's Templates section update (done above). Structural
   validator cross-checks template files on disk against the
   catalog's template list.

## Version Bump

**Type: minor (0.22.0 -> 0.23.0)**

Rationale: `core/workflows/analytics-workspace.md` is under `core/**`,
and the versioning rules state `core/** changes -> minor bump`. While
BOOTSTRAP.md changes alone would be a patch bump, the highest-impact
change wins. The workflow file change is the highest impact.

## Consumer Update Instructions

1. Copy new template file:
   - `core/templates/Platform-Connection-Template.md`
2. Update `BOOTSTRAP.md` (replace entire Phase 2W section)
3. Update `core/workflows/analytics-workspace.md`
4. Update `core/Document-Catalog.md`
5. Update integration template (CLAUDE.md or copilot-instructions.md)
6. Existing analytics-workspace consumer projects with already-
   bootstrapped workspaces: no retroactive onboarding needed. The
   source registry files created manually during 2W.2 serve the same
   purpose. To add platform-level cost model docs, create
   `sources/connections/[platform]/README.md` using the new
   Platform-Connection-Template.
