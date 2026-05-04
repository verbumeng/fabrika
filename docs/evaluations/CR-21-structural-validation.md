# CR-21 Structural Validation Report

**Verdict: PASS**

All 30 checks pass. No structural issues found.

---

## Per-Check Results

### Check 1: Document-Catalog contains Freshness Metadata subsection under How to Use This Catalog

**PASS.** Lines 65-86 of `core/Document-Catalog.md` contain a subsection titled "### Freshness Metadata" under "## How to Use This Catalog", after the Audience Markers table.

---

### Check 2: Freshness Metadata section describes `last-validated` field, lists which documents carry it, and provides bootstrap guidance

**PASS.** The section:
- Describes the field: "the date when a human or agent last confirmed that the document accurately reflects the current codebase. This field is not auto-updated on every edit; it is explicitly set during validation."
- Lists documents: "Architecture Overview, Data Model, Canonical Patterns, Testing Strategy, Phase Definitions, Domain Language, Project Charter, PRD, and domain-specific Tier 1 docs for the project type."
- Provides bootstrap guidance: "For Tier 1 documents created during bootstrap that do not have a canonical template (Architecture Overview, Data Model, Canonical Patterns, Testing Strategy, etc.), add `last-validated: [bootstrap date]` to the frontmatter during creation."

---

### Check 3: Freshness Metadata section references development-workflow.md for behavioral logic

**PASS.** Lines 82-86: "see `core/workflows/types/development-workflow.md` (Freshness-Aware Context Loading) for the behavioral protocol and `core/workflows/protocols/sprint-coordination.md` for the periodic freshness sweep."

---

### Check 4: development-workflow.md contains Freshness-Aware Context Loading section BEFORE Starting a Story

**PASS.** The section "## Freshness-Aware Context Loading" appears at line 154, after "Tier-Conditional Workflow Branching" (which ends with "Tier Promotion" subsection) and before "## Starting a Story" at line 205. Placement is correct.

---

### Check 5: Strategy B (load with caveat) is described as universal default; Strategy A as owner override only

**PASS.** Lines 181-193 of development-workflow.md:
- "**Strategy B: Load with caveat (universal default).** Load the stale document with a caveat note prepended. This is the default for ALL tiers -- Patch, Story, and Deep Story alike."
- "**Strategy A: Skip and research (owner override only).** Do not load the stale document. Strategy A exists only as an explicit owner override for docs the owner knows are seriously wrong. It is never an automatic default."

---

### Check 6: Freshness check is described as passive (one-line warning, no blocking, no triage at start)

**PASS.** Lines 170-179: "The freshness check at story/task start is passive. When the orchestrator detects a stale document during orientation, it emits a one-line warning in its orientation output (e.g., 'Note: Architecture Overview last validated 6 weeks ago') and proceeds with Strategy B -- load the document with a caveat. No blocking, no user interaction, no triage at start."

---

### Check 7: Triage is limited to periodic sweeps only

**PASS.** Lines 195-200: "**Triage belongs to sweeps, not story start.** The three-option triage (re-validate, mark for refresh, accept staleness) is NOT performed at story/task start. It belongs only in periodic sweeps -- maintenance sessions for sprint projects, on-demand sweeps for non-sprint projects."

---

### Check 8: Freshness check is described as universal (not limited to sprint-based)

**PASS.** Lines 156-160: "This applies to all workflow types that load Tier 1 docs -- development-workflow, task-workflow, and any future workflow that reads structural context at start."

---

### Check 9: Starting a Story step 2 includes a freshness qualifier

**PASS.** Line 207 (step 2 under Starting a Story): "Read relevant project docs on demand, applying the freshness check described above: Architecture Overview, Data Model, relevant ADRs, research notes"

Patch path step 2 also includes the freshness qualifier (line 56-57): "Read relevant project docs on demand, applying the freshness check described above (architecture, data model)"

---

### Check 10: Patch path step 2 includes a freshness qualifier

**PASS.** Line 56-57 (Patch Path step 2): "Read relevant project docs on demand, applying the freshness check described above (architecture, data model)"

---

### Check 11: Default threshold is stated (2 completed sprints / ~4 weeks)

**PASS.** Lines 162-164: "Default: 2 completed sprints (~4 weeks). If no threshold is configured, use the default."

---

### Check 12: task-workflow.md includes a freshness check cross-reference to development-workflow.md

**PASS.** Lines 134-140 of task-workflow.md (placed in the Lifecycle section before the Brief subsection): "When reading Tier 1 context documents at task start, the orchestrator checks the document's `last-validated` frontmatter against the project's freshness threshold. If stale, the orchestrator emits a one-line note (e.g., 'Note: Architecture Overview last validated 6 weeks ago') and loads the document with a caveat. See `core/workflows/types/development-workflow.md` (Freshness-Aware Context Loading) for the full protocol."

---

### Check 13: sprint-coordination.md maintenance phase includes freshness sweep with three-option triage

**PASS.** Line 76 of sprint-coordination.md (in the Maintenance chat section): "The maintenance session includes a freshness sweep: check each Tier 1 document's `last-validated` field against the project's freshness threshold. [...] For each stale document, the orchestrator presents three options to the owner: (1) Re-validate -- confirm the doc is still accurate, update `last-validated` to today. (2) Mark for refresh -- add a Patch-tier story to the backlog to update the doc. (3) Accept staleness -- acknowledge the staleness but take no action; the system continues treating the document as stale during story start context loading."

---

### Check 14: Sprint-coordination retro phase includes stale doc surfacing

**PASS.** Line 80 (Sprint Retro chat section): "The scrum-master includes stale document findings from the maintenance session's freshness sweep in the retro report. If any Tier 1 docs went stale during the sprint, the retro surfaces them: which docs, how long stale, and whether they were loaded with caveat during story chats."

---

### Check 15: Sprint-coordination includes non-sprint on-demand sweep note

**PASS.** Line 78 (paragraph after maintenance freshness sweep): "For non-sprint projects that do not use sprint-coordination, the freshness sweep is triggered on demand by the owner or via optional post-task prompts (e.g., 'This task changed [area]. [Doc] covers this area, last validated [date]. Want to re-validate?'). The three-option triage is the same; only the trigger mechanism differs."

---

### Check 16: Sprint-coordination freshness sweep references Document-Catalog for which docs carry the field

**PASS.** Line 76: "See the Freshness Metadata section in `core/Document-Catalog.md` for which documents carry the field."

---

### Check 17: All three templates have `last-validated: YYYY-MM-DD` in frontmatter, placed after `updated:`

**PASS.**
- `core/templates/Domain-Language-Template.md`: frontmatter lines 5-6 show `updated: YYYY-MM-DD` followed by `last-validated: YYYY-MM-DD`.
- `core/templates/Project-Charter-Template.md`: frontmatter lines 7-8 show `updated: YYYY-MM-DD` followed by `last-validated: YYYY-MM-DD`.
- `core/templates/PRD-Template.md`: frontmatter lines 7-8 show `updated: YYYY-MM-DD` followed by `last-validated: YYYY-MM-DD`.

All three templates place `last-validated` immediately after `updated:` with the consistent `YYYY-MM-DD` placeholder format.

---

### Check 18: Both integration templates have freshness orientation note in Session Lifecycle

**PASS.**
- `integrations/claude-code/CLAUDE.md` line 299: "When reading Tier 1 context documents (Architecture Overview, Data Model, Canonical Patterns, etc.), the orchestrator checks the document's `last-validated` frontmatter against the project's freshness threshold. If stale, the orchestrator emits a one-line note during orientation [...] Stale docs are never automatically skipped -- Strategy A (skip) is only used when the owner explicitly overrides. See `[FABRIKA_PATH]/core/workflows/types/development-workflow.md` (Freshness-Aware Context Loading)."
- `integrations/copilot/copilot-instructions.md` line 212: Identical content.

Both are placed in Session Start (Orientation), after step 2 (reading the sprint progress file).

---

### Check 19: Both integration templates have freshness bullet in Key Constraints, after Compaction

**PASS.**
- `integrations/claude-code/CLAUDE.md` line 681: "**Freshness-aware context loading.** Before loading Tier 1 context documents at story/task start, the orchestrator checks `last-validated` against the project's freshness threshold. Stale docs are loaded with a caveat (universal default). The orchestrator decides what to include in dispatch payloads -- the implementer receives whatever context the orchestrator gives it. See `[FABRIKA_PATH]/core/workflows/types/development-workflow.md`."
  Placed after the "Compaction at phase transitions" bullet (line 680).
- `integrations/copilot/copilot-instructions.md` line 598: Identical content. Placed after the "Compaction at phase transitions" bullet (line 597).

---

### Check 20: Integration templates describe Strategy B as universal default and note orchestrator controls dispatch

**PASS.** Both templates state in the freshness Key Constraints bullet: "Stale docs are loaded with a caveat (universal default). The orchestrator decides what to include in dispatch payloads -- the implementer receives whatever context the orchestrator gives it."

Both templates state in the Session Lifecycle note: "Stale docs are never automatically skipped -- Strategy A (skip) is only used when the owner explicitly overrides."

---

### Check 21: Domain-Language.md defines freshness signal, staleness threshold, and freshness validation in the Workflow section after Compaction

**PASS.** In `Domain-Language.md`, the three terms appear in the Workflow section:
- "**Freshness signal**" at line 312
- "**Staleness threshold**" at line 321
- "**Freshness validation**" at line 330

All three are placed after the "**Compaction**" entry (which ends at line 310). The placement is correct -- freshness concepts follow compaction.

---

### Check 22: All three Domain Language terms include `[Introduced in 0.31.0.]` tags

**PASS.**
- Freshness signal (line 319): "[Introduced in 0.31.0.]"
- Staleness threshold (line 328): "[Introduced in 0.31.0.]"
- Freshness validation (line 338): "[Introduced in 0.31.0.]"

---

### Check 23: VERSION file contains `0.31.0`

**PASS.** The VERSION file contains exactly `0.31.0`.

---

### Check 24: CHANGELOG 0.31.0 entry exists and lists all changed files

**PASS.** The CHANGELOG entry at the top of the file (lines 9-78) is titled "## 0.31.0 -- Freshness-aware context loading" and lists all 10 changed files in the "### Changed files" section:
1. `core/Document-Catalog.md`
2. `core/workflows/types/development-workflow.md`
3. `core/workflows/types/task-workflow.md`
4. `core/workflows/protocols/sprint-coordination.md`
5. `core/templates/Domain-Language-Template.md`
6. `core/templates/Project-Charter-Template.md`
7. `core/templates/PRD-Template.md`
8. `integrations/claude-code/CLAUDE.md`
9. `integrations/copilot/copilot-instructions.md`
10. `Domain-Language.md`

---

### Check 25: CHANGELOG consumer update instructions have all 9 items

**PASS.** The "### Consumer update instructions" section lists 9 numbered items:
1. Update Document-Catalog.md
2. Update development-workflow.md
3. Update task-workflow.md (conditional)
4. Update sprint-coordination.md
5. Update templates (3 templates)
6. Update project instruction file
7. Add Domain Language terms
8. Add freshness-threshold to instruction file
9. Add last-validated to existing Tier 1 docs

---

### Check 26: CHANGELOG describes Strategy B as universal default

**PASS.** Lines 15-16 of CHANGELOG: "stale docs are loaded with a caveat (Strategy B, universal default). Strategy A (skip and research) exists only as an explicit owner override."

---

### Check 27: No agent prompt files in core/agents/ were modified

**PASS.** Running `git diff HEAD -- core/agents/` produces no output. No agent prompt files were touched.

---

### Check 28: No new files were created (all changes are to existing files)

**PASS.** Running `git diff --diff-filter=A --name-only HEAD` produces no output. All changes modify existing files.

---

### Check 29: No smell test violations

**PASS.** Searched all changed files for: Notnomo, Hearthen, MNEMOS, Opifex, edw labs, VerbumEng, LifeOS, Obsidian, Motion, PARA. No matches found in any changed file. Content is generic and would make sense to a stranger cloning the repo.

---

### Check 30: Cross-references form a consistent chain

**PASS.** The full chain verified:

1. **Document-Catalog defines the field** -- Freshness Metadata section defines `last-validated`, lists which documents carry it, and points to development-workflow.md for behavioral logic and sprint-coordination.md for sweeps.

2. **development-workflow defines the behavior** -- Freshness-Aware Context Loading section defines Strategy A/B, passive check, threshold, and points back to Document-Catalog for which docs carry the field.

3. **task-workflow cross-references development-workflow** -- Lifecycle section explicitly references "See `core/workflows/types/development-workflow.md` (Freshness-Aware Context Loading) for the full protocol."

4. **sprint-coordination defines sweeps** -- Maintenance phase defines the three-option triage. References Document-Catalog for which docs carry the field. Retro phase surfaces stale doc findings. Non-sprint sweep note present.

5. **Integration templates point to development-workflow** -- Both CLAUDE.md and copilot-instructions.md reference `[FABRIKA_PATH]/core/workflows/types/development-workflow.md` in Session Lifecycle orientation and Key Constraints.

6. **Domain Language defines the terms** -- freshness signal, staleness threshold, and freshness validation are defined in the Workflow section. freshness signal references Document-Catalog. Terms are consistent with usage across all other files.

The chain is complete and all cross-references resolve correctly.
