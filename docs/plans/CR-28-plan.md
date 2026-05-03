---
status: executed
cr: CR-28
version: 0.27.0
---

# System Update Plan: CR-28 — Workflow Folder and Terminology Cleanup

CR-28 reorganizes `core/workflows/` into `types/` and `protocols/`
subdirectories, renames inconsistent files, and updates all cross-
references across the repo. This is a structural cleanup — no
behavioral changes to any workflow, agent, or protocol. The goal is
to make the distinction between workflow type definitions and
supporting processes visible in the file system, ahead of Phase 2
CRs that will add more workflow types.

## Scope Boundary

CR-28 moves and renames files. It does NOT:
- Change any workflow content or behavior
- Add new workflow types (CR-18, CR-19's scope)
- Formalize cross-cutting concern attachment (CR-22's scope)
- Unify the document hierarchy (CR-29's scope)
- Change agent prompts beyond path references
- Modify CHANGELOG historical entries (they describe past state)

## Version Bump Determination

**0.27.0 (minor bump).** Per CLAUDE.md versioning rules, `core/**`
changes trigger a minor bump. Although the changes are purely
structural (renames, moves, cross-reference updates), the files live
under `core/` and the directory structure is a consumer-facing
contract. Consumers need explicit migration instructions for the new
paths.

## File Change Inventory

### New files

| File | Purpose |
|------|---------|
| `core/workflows/types/` (directory) | Contains workflow type definitions |
| `core/workflows/protocols/` (directory) | Contains supporting processes and protocols |
| `core/workflows/README.md` | Documents the types vs. protocols distinction |

### Moved/renamed files

| Current path | New path | Change type |
|-------------|----------|-------------|
| `core/workflows/agentic-workflow-lifecycle.md` | `core/workflows/types/agentic-workflow.md` | Move + rename (drop "-lifecycle") |
| `core/workflows/development-workflow.md` | `core/workflows/types/development-workflow.md` | Move only (rename deferred to CR-22, which will split into domain-specific workflows) |
| `core/workflows/task-workflow.md` | `core/workflows/types/task-workflow.md` | Move only |
| `core/workflows/analytics-workspace.md` | `core/workflows/types/analytics-workspace.md` | Move only |
| `core/workflows/dispatch-protocol.md` | `core/workflows/protocols/dispatch-protocol.md` | Move only |
| `core/workflows/design-alignment.md` | `core/workflows/protocols/design-alignment.md` | Move only |
| `core/workflows/sprint-lifecycle.md` | `core/workflows/protocols/sprint-coordination.md` | Move + rename |
| `core/workflows/doc-triggers.md` | `core/workflows/protocols/doc-triggers.md` | Move only |
| `core/workflows/hooks-reference.md` | `core/workflows/protocols/hooks-reference.md` | Move only |
| `core/workflows/knowledge-pipeline.md` | `core/workflows/protocols/knowledge-pipeline.md` | Move only |
| `core/workflows/knowledge-synthesis.md` | `core/workflows/protocols/knowledge-synthesis.md` | Move only |
| `core/workflows/progress-files.md` | `core/workflows/protocols/progress-files.md` | Move only |
| `core/workflows/task-promotion.md` | `core/workflows/protocols/task-promotion.md` | Move only |
| `core/workflows/token-estimation.md` | `core/workflows/protocols/token-estimation.md` | Move only |
| `core/workflows/analytics-onboarding.md` | `core/workflows/protocols/analytics-onboarding.md` | Move only |

### Deleted files

All 15 original files in `core/workflows/` are deleted after their
content moves to subdirectories. No content is lost.

### Modified files (cross-reference updates)

The complete list of files requiring cross-reference updates, grouped
by category. For each file, every reference that must change is
listed.

---

#### 1. Workflow files (internal cross-references)

These files reference other workflow files and need their internal
pointers updated after the move.

**`core/workflows/types/agentic-workflow.md`** (was agentic-workflow-lifecycle.md)

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/dispatch-protocol.md` (line 9) | `core/workflows/protocols/dispatch-protocol.md` |
| `core/workflows/token-estimation.md` (line 66) | `core/workflows/protocols/token-estimation.md` |

**`core/workflows/types/development-workflow.md`** (was development-workflow.md)

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/design-alignment.md` (line 11) | `core/workflows/protocols/design-alignment.md` |
| `core/workflows/dispatch-protocol.md` (line 29) | `core/workflows/protocols/dispatch-protocol.md` |
| `core/workflows/token-estimation.md` (line 36) | `core/workflows/protocols/token-estimation.md` |

**`core/workflows/types/task-workflow.md`**

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/design-alignment.md` (line 36) | `core/workflows/protocols/design-alignment.md` |
| `core/workflows/token-estimation.md` (line 100) | `core/workflows/protocols/token-estimation.md` |
| `core/workflows/knowledge-pipeline.md` (line 223) | `core/workflows/protocols/knowledge-pipeline.md` |
| `core/workflows/knowledge-synthesis.md` (line 224) | `core/workflows/protocols/knowledge-synthesis.md` |

**`core/workflows/types/analytics-workspace.md`**

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/design-alignment.md` (line 10) | `core/workflows/protocols/design-alignment.md` |
| `core/workflows/token-estimation.md` (lines 95, 175) | `core/workflows/protocols/token-estimation.md` |
| `core/workflows/task-promotion.md` (lines 100, 514) | `core/workflows/protocols/task-promotion.md` |
| `core/workflows/dispatch-protocol.md` (line 135) | `core/workflows/protocols/dispatch-protocol.md` |
| `core/workflows/knowledge-pipeline.md` (line 527) | `core/workflows/protocols/knowledge-pipeline.md` |
| `core/workflows/knowledge-synthesis.md` (line 529) | `core/workflows/protocols/knowledge-synthesis.md` |

**`core/workflows/protocols/sprint-coordination.md`** (was sprint-lifecycle.md)

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/design-alignment.md` (lines 26, 43) | `core/workflows/protocols/design-alignment.md` |
| `core/workflows/knowledge-pipeline.md` (line 83) | `core/workflows/protocols/knowledge-pipeline.md` |
| `core/workflows/knowledge-synthesis.md` (line 84) | `core/workflows/protocols/knowledge-synthesis.md` |

**`core/workflows/protocols/knowledge-synthesis.md`**

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/knowledge-pipeline.md` (lines 7, 49) | `core/workflows/protocols/knowledge-pipeline.md` |

**`core/workflows/protocols/knowledge-pipeline.md`**

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/knowledge-synthesis.md` (lines 6, 314) | `core/workflows/protocols/knowledge-synthesis.md` |

**`core/workflows/protocols/design-alignment.md`**

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/token-estimation.md` (line 46) | `core/workflows/protocols/token-estimation.md` |

**`core/workflows/protocols/doc-triggers.md`**

| Old reference | New reference |
|--------------|--------------|
| `core/workflows/design-alignment.md` (line 7) | `core/workflows/protocols/design-alignment.md` |
| `core/workflows/knowledge-synthesis.md` (line 31) | `core/workflows/protocols/knowledge-synthesis.md` |

---

#### 2. Agent prompt files

**`core/agents/AGENT-CATALOG.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/agentic-workflow-lifecycle.md` (line 44) | `core/workflows/types/agentic-workflow.md` | Methodology-based types description |
| `core/workflows/dispatch-protocol.md` (line 98) | `core/workflows/protocols/dispatch-protocol.md` | Dispatch contracts pointer |

**`core/agents/analysis-planner.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/task-promotion.md` (line 67) | `core/workflows/protocols/task-promotion.md` | Promotion conversation reference |

**`core/agents/data-architect.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/dispatch-protocol.md` (line 237) | `core/workflows/protocols/dispatch-protocol.md` | Per-mode dispatch reference |

**`core/agents/software-architect.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/dispatch-protocol.md` (line 223) | `core/workflows/protocols/dispatch-protocol.md` | Per-mode dispatch reference |

**`core/agents/archetypes/architect.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/dispatch-protocol.md` (line 105) | `core/workflows/protocols/dispatch-protocol.md` | Dispatch protocol reference |

---

#### 3. Integration templates

**`integrations/claude-code/CLAUDE.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/sprint-lifecycle.md` (line 299) | `core/workflows/protocols/sprint-coordination.md` | Phase transitions pointer |
| `core/workflows/design-alignment.md` (line 314) | `core/workflows/protocols/design-alignment.md` | Design alignment pointer |
| `core/workflows/development-workflow.md` (line 322) | `core/workflows/types/development-workflow.md` | Story/sprint/bug pointer |
| `core/workflows/token-estimation.md` (line 324) | `core/workflows/protocols/token-estimation.md` | Token estimation pointer |
| `core/workflows/analytics-workspace.md` (line 350) | `core/workflows/types/analytics-workspace.md` | Analytics workflow pointer |
| `core/workflows/agentic-workflow-lifecycle.md` (line 360) | `core/workflows/types/agentic-workflow.md` | Agentic workflow pointer |
| `core/workflows/progress-files.md` (line 388) | `core/workflows/protocols/progress-files.md` | Progress files pointer |
| `core/workflows/hooks-reference.md` (line 399) | `core/workflows/protocols/hooks-reference.md` | Hooks reference pointer |
| `core/workflows/knowledge-synthesis.md` (line 435) | `core/workflows/protocols/knowledge-synthesis.md` | Wiki synthesis pointer |
| `core/workflows/knowledge-pipeline.md` (line 436) | `core/workflows/protocols/knowledge-pipeline.md` | Wiki pipeline pointer |
| `core/workflows/doc-triggers.md` (line 458) | `core/workflows/protocols/doc-triggers.md` | Doc triggers pointer |
| `core/workflows/dispatch-protocol.md` (line 476) | `core/workflows/protocols/dispatch-protocol.md` | Dispatch protocol pointer |
| `core/workflows/development-workflow.md` (line 597) | `core/workflows/types/development-workflow.md` | Second development workflow reference |

**`integrations/copilot/copilot-instructions.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/sprint-lifecycle.md` (line 208) | `core/workflows/protocols/sprint-coordination.md` | Phase transitions pointer |
| `core/workflows/design-alignment.md` (line 223) | `core/workflows/protocols/design-alignment.md` | Design alignment pointer |
| `core/workflows/development-workflow.md` (line 231) | `core/workflows/types/development-workflow.md` | Story/sprint/bug pointer |
| `core/workflows/token-estimation.md` (line 233) | `core/workflows/protocols/token-estimation.md` | Token estimation pointer |
| `core/workflows/analytics-workspace.md` (line 259) | `core/workflows/types/analytics-workspace.md` | Analytics workflow pointer |
| `core/workflows/agentic-workflow-lifecycle.md` (line 269) | `core/workflows/types/agentic-workflow.md` | Agentic workflow pointer |
| `core/workflows/progress-files.md` (line 297) | `core/workflows/protocols/progress-files.md` | Progress files pointer |
| `core/workflows/dispatch-protocol.md` (line 305) | `core/workflows/protocols/dispatch-protocol.md` | Dispatch protocol pointer |
| `core/workflows/knowledge-synthesis.md` (line 453) | `core/workflows/protocols/knowledge-synthesis.md` | Wiki synthesis pointer |
| `core/workflows/knowledge-pipeline.md` (line 454) | `core/workflows/protocols/knowledge-pipeline.md` | Wiki pipeline pointer |
| `core/workflows/doc-triggers.md` (line 462) | `core/workflows/protocols/doc-triggers.md` | Doc triggers pointer |
| `core/workflows/hooks-reference.md` (line 474) | `core/workflows/protocols/hooks-reference.md` | Hooks reference pointer |
| `core/workflows/development-workflow.md` (line 518) | `core/workflows/types/development-workflow.md` | Second development workflow reference |

---

#### 4. Root-level documents

**`BOOTSTRAP.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/knowledge-synthesis.md` (line 190) | `core/workflows/protocols/knowledge-synthesis.md` | Wiki backfill pointer |
| `core/workflows/design-alignment.md` (line 386) | `core/workflows/protocols/design-alignment.md` | Design alignment pointer |
| `core/workflows/analytics-onboarding.md` (line 535) | `core/workflows/protocols/analytics-onboarding.md` | Analytics onboarding pointer |
| `core/workflows/agentic-workflow-lifecycle.md` (line 635) | `core/workflows/types/agentic-workflow.md` | Agentic workflow protocol reference |

**`ADOPT.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/knowledge-synthesis.md` (line 57) | `core/workflows/protocols/knowledge-synthesis.md` | Backfill pointer |
| `core/workflows/analytics-onboarding.md` (line 176) | `core/workflows/protocols/analytics-onboarding.md` | Onboarding pointer |

**`ADD-WORKFLOW.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/task-workflow.md` (line 40) | `core/workflows/types/task-workflow.md` | Workflow definition source path |

**`Domain-Language.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/dispatch-protocol.md` (line 87) | `core/workflows/protocols/dispatch-protocol.md` | Dispatch contract definition |
| `core/workflows/agentic-workflow-lifecycle.md` (line 187) | `core/workflows/types/agentic-workflow.md` | Agentic workflow definition |
| `core/workflows/sprint-lifecycle.md` (line 220) | `core/workflows/protocols/sprint-coordination.md` | Sprint lifecycle definition |
| `core/workflows/analytics-workspace.md` (line 229) | `core/workflows/types/analytics-workspace.md` | Analytics workspace definition |
| `core/workflows/dispatch-protocol.md` (line 280) | `core/workflows/protocols/dispatch-protocol.md` | Dispatch tier definition |
| `core/workflows/knowledge-pipeline.md` (line 507) | `core/workflows/protocols/knowledge-pipeline.md` | Knowledge pipeline definition |
| `core/workflows/doc-triggers.md` (line 679) | `core/workflows/protocols/doc-triggers.md` | Doc triggers definition |
| `core/workflows/task-workflow.md` (line 720) | `core/workflows/types/task-workflow.md` | Task workflow definition |

**`UPDATE.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/token-estimation.md` (line 115) | `core/workflows/protocols/token-estimation.md` | Token estimation pointer |

**`MIGRATIONS.md`**

MIGRATIONS.md contains historical migration instructions for past
versions. These references describe what consumers needed to do at
the time of each version — they are accurate to that version's file
state. **These should NOT be updated** (same rationale as CHANGELOG).

However, a new 0.27.0 migration entry must be added with the new
paths. See the CHANGELOG/MIGRATIONS section below.

---

#### 5. Core non-workflow files

**`core/Document-Catalog.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/design-alignment.md` (line 80 area) | `core/workflows/protocols/design-alignment.md` | Document Catalog design alignment reference |
| `core/workflows/design-alignment.md` (line 96) | `core/workflows/protocols/design-alignment.md` | Charter creation notes |

**`core/maintenance-checklist.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/knowledge-synthesis.md` (line 130) | `core/workflows/protocols/knowledge-synthesis.md` | Knowledge synthesis pointer |

**`core/templates/Batch-Index-Schema.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/knowledge-pipeline.md` (line 63) | `core/workflows/protocols/knowledge-pipeline.md` | Salience model reference |

**`core/topologies/Sprint-Contract-Pipeline.md`**

| Old reference | New reference | Context |
|--------------|--------------|---------|
| `core/workflows/development-workflow.md` (line 28) | `core/workflows/types/development-workflow.md` | Testing approach reference |

---

#### 6. Wiki files

**`wiki/topics/workflow-design.md`**

This file contains extensive workflow references in both prose and
the Core files listing. All references need updating:

| Old reference | New reference | Location |
|--------------|--------------|----------|
| `core/workflows/agentic-workflow-lifecycle.md` | `core/workflows/types/agentic-workflow.md` | Lines 13, 15, 17, 31, 172 |
| `core/workflows/development-workflow.md` | `core/workflows/types/development-workflow.md` | Lines 13, 173 |
| `core/workflows/sprint-lifecycle.md` | `core/workflows/protocols/sprint-coordination.md` | Line 174 |
| `core/workflows/task-workflow.md` | `core/workflows/types/task-workflow.md` | Line 175 |
| `core/workflows/analytics-workspace.md` | `core/workflows/types/analytics-workspace.md` | Line 176 |
| `core/workflows/dispatch-protocol.md` | `core/workflows/protocols/dispatch-protocol.md` | Lines 17, 31, 177 |
| `core/workflows/knowledge-pipeline.md` | `core/workflows/protocols/knowledge-pipeline.md` | Line 178 |
| `core/workflows/knowledge-synthesis.md` | `core/workflows/protocols/knowledge-synthesis.md` | Line 179 |
| `core/workflows/design-alignment.md` | `core/workflows/protocols/design-alignment.md` | Line 180 |

**`wiki/topics/agent-model.md`**

| Old reference | New reference | Location |
|--------------|--------------|----------|
| `core/workflows/dispatch-protocol.md` | `core/workflows/protocols/dispatch-protocol.md` | Lines 17, 23, 78, 132 |

**`wiki/topics/owner-preferences.md`**

| Old reference | New reference | Location |
|--------------|--------------|----------|
| `core/workflows/design-alignment.md` | `core/workflows/protocols/design-alignment.md` | Line 104 |

---

#### 7. Files NOT modified

**CHANGELOG.md** — Historical entries describe file state at that
version. Leave all old references as-is. Add a new 0.27.0 entry.

**MIGRATIONS.md** — Historical migration instructions describe what
consumers needed to do at past versions. Leave old entries as-is. Add
a new 0.27.0 entry.

**planning/** — Planning documents (PRDs, CRs) are historical
records of what was planned. They reference the file state at
planning time. Leave as-is.

**docs/plans/** — Executed plan files are historical. Leave as-is.

**docs/evaluations/** — Evaluation reports are historical. Leave
as-is.

**README.md** — No workflow path references found. No changes needed.

**MANIFEST_SPEC.md** — No workflow path references found. No changes
needed.

**HARVEST.md** — No workflow path references found. No changes
needed.

**core/design-principles.md** — No workflow path references found.
No changes needed.

**core/rubrics/** — No workflow path references found. No changes
needed.

**core/briefings/** — No workflow path references found. No changes
needed.

---

#### 8. New content: VERSION, CHANGELOG, MIGRATIONS

**`VERSION`** — Update from `0.26.0` to `0.27.0`.

**`CHANGELOG.md`** — Add 0.27.0 entry. Lists every moved/renamed
file with old and new paths. Consumer update instructions must cover
every file a consumer might have copied.

**`MIGRATIONS.md`** — Add 0.27.0 entry documenting the complete
path mapping for consumers. Consumers need to:
1. Rename their local copies to match new paths
2. Update their project instruction files (CLAUDE.md/copilot-
   instructions.md) from the new integration templates

**`core/workflows/README.md`** — New file documenting the types vs.
protocols distinction. Brief (under 30 lines): what goes in types/,
what goes in protocols/, and the naming rationale.

## Integration Point Analysis

| Changed file | Referenced by | Sync requirement |
|-------------|-------------|-----------------|
| `core/workflows/types/agentic-workflow.md` | AGENT-CATALOG (methodology-based types), BOOTSTRAP.md (agentic-workflow setup), Domain-Language.md (agentic workflow term), integration templates (agentic workflow pointer), wiki/topics/workflow-design.md | All must reference `types/agentic-workflow.md`, not the old path |
| `core/workflows/types/development-workflow.md` | Integration templates (story/sprint/bug pointer), wiki/topics/workflow-design.md, Sprint-Contract-Pipeline.md | All must reference `types/development-workflow.md`. Note the file is RENAMED — references to "development-workflow" must become "sprint-workflow" |
| `core/workflows/types/task-workflow.md` | ADD-WORKFLOW.md, Domain-Language.md, wiki/topics/workflow-design.md | Path changes but filename stays the same |
| `core/workflows/types/analytics-workspace.md` | Integration templates (analytics pointer), Domain-Language.md, wiki/topics/workflow-design.md | Path changes but filename stays the same |
| `core/workflows/protocols/dispatch-protocol.md` | AGENT-CATALOG (dispatch pointer), agent prompts (data-architect, software-architect, architect archetype), Domain-Language.md, integration templates, wiki/topics/agent-model.md, wiki/topics/workflow-design.md | The most heavily referenced protocol file. Must be updated everywhere. |
| `core/workflows/protocols/sprint-coordination.md` | Integration templates (phase transitions), Domain-Language.md, wiki/topics/workflow-design.md | Both PATH and NAME change. Old references to "sprint-lifecycle" must become "sprint-coordination" |
| `core/workflows/protocols/design-alignment.md` | BOOTSTRAP.md, Document-Catalog.md, integration templates, Domain-Language.md, wiki/topics/owner-preferences.md, wiki/topics/workflow-design.md, plus internal workflow cross-refs | Heavily referenced. Path changes but filename stays the same |
| `core/workflows/protocols/knowledge-pipeline.md` | Domain-Language.md, integration templates, Batch-Index-Schema.md, wiki/topics/workflow-design.md, plus internal workflow cross-refs | Path changes but filename stays the same |
| `core/workflows/protocols/knowledge-synthesis.md` | BOOTSTRAP.md, ADOPT.md, integration templates, maintenance-checklist.md, wiki/topics/workflow-design.md, plus internal workflow cross-refs | Path changes but filename stays the same |
| `core/workflows/protocols/doc-triggers.md` | Domain-Language.md, integration templates | Path changes but filename stays the same |
| `core/workflows/protocols/hooks-reference.md` | Integration templates | Path changes but filename stays the same |
| `core/workflows/protocols/progress-files.md` | Integration templates | Path changes but filename stays the same |
| `core/workflows/protocols/token-estimation.md` | UPDATE.md, integration templates, plus internal workflow cross-refs | Path changes but filename stays the same |
| `core/workflows/protocols/task-promotion.md` | analysis-planner.md agent prompt, plus internal analytics-workspace cross-refs | Path changes but filename stays the same |
| `core/workflows/protocols/analytics-onboarding.md` | BOOTSTRAP.md, ADOPT.md | Path changes but filename stays the same |

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Missed cross-reference | Any file in the repo | A file still references an old `core/workflows/[name].md` path that no longer exists. Reader or agent follows the path and gets a file-not-found error. |
| 2 | Inconsistent rename | Files referencing sprint-lifecycle or development-workflow | Some references updated to new name, others left with old name. Partial rename is worse than no rename. |
| 3 | Internal workflow cross-refs missed | Workflow files that reference each other | After move, a workflow file references another workflow file at the old flat path instead of the new subdirectory path. |
| 4 | CHANGELOG/MIGRATIONS historical corruption | CHANGELOG.md, MIGRATIONS.md | Historical entries accidentally updated to new paths, making them inaccurate for their stated version. |
| 5 | Consumer instruction incompleteness | CHANGELOG 0.27.0, MIGRATIONS.md 0.27.0 | Consumer follows update instructions but misses a file that moved. Their project breaks silently. |
| 6 | Planning file contamination | planning/*.md, docs/plans/*.md | Historical planning documents accidentally updated, changing the record of what was planned. |
| 7 | Wiki prose stale after renames | wiki/topics/workflow-design.md | Core files listing updated but prose paragraphs still reference old names like "development-workflow" or "sprint-lifecycle" in narrative text. |

## Mitigation

| # | Mitigation | How it catches the risk |
|---|-----------|----------------------|
| 1 | After all changes, grep the entire repo for every old path pattern: `core/workflows/agentic-workflow-lifecycle`, `core/workflows/development-workflow`, `core/workflows/sprint-lifecycle`, `core/workflows/analytics-workspace.md` (flat, not in types/), `core/workflows/task-workflow.md` (flat, not in types/), `core/workflows/dispatch-protocol.md` (flat, not in protocols/), and all other flat-path patterns. Any hits outside CHANGELOG, MIGRATIONS, planning/, and docs/plans/ or docs/evaluations/ are bugs. | Catches risk 1, 2, 3 |
| 2 | Structural validator dispatched in Step 4 checks all cross-references between files. | Catches risk 1, 2, 3 |
| 3 | Explicitly exclude CHANGELOG.md, MIGRATIONS.md (historical entries), planning/, docs/plans/, and docs/evaluations/ from the cross-reference update scope. Only modify the new CHANGELOG/MIGRATIONS entries. | Catches risk 4, 6 |
| 4 | The CHANGELOG 0.27.0 entry must list EVERY moved file with old path and new path. The MIGRATIONS 0.27.0 entry must include the complete path mapping table. Review these for completeness against the Moved/renamed table above. | Catches risk 5 |
| 5 | Read wiki/topics/workflow-design.md prose (not just Core files listing) and check for narrative references to old filenames in the prose sections. | Catches risk 7 |

## Execution Sequence

The agentic-engineer should execute changes in this order to
minimize risk of partial-update states.

### Phase 1: Create directories and move files

1. Create `core/workflows/types/` directory
2. Create `core/workflows/protocols/` directory
3. Move all 4 workflow type files to `types/`, applying renames:
   - `agentic-workflow-lifecycle.md` -> `types/agentic-workflow.md`
   - `development-workflow.md` -> `types/development-workflow.md`
   - `task-workflow.md` -> `types/task-workflow.md`
   - `analytics-workspace.md` -> `types/analytics-workspace.md`
4. Move all 11 protocol files to `protocols/`, applying renames:
   - `sprint-lifecycle.md` -> `protocols/sprint-coordination.md`
   - All other protocol files keep their names, just move to
     `protocols/`

### Phase 2: Create README

5. Create `core/workflows/README.md` documenting the types vs.
   protocols distinction.

### Phase 3: Update internal workflow cross-references

6. Update all cross-references within workflow files (both types/
   and protocols/) — these files reference each other extensively.
   Do types/ first, then protocols/.

### Phase 4: Update agent prompt files

7. Update `core/agents/AGENT-CATALOG.md` (2 references)
8. Update `core/agents/analysis-planner.md` (1 reference)
9. Update `core/agents/data-architect.md` (1 reference)
10. Update `core/agents/software-architect.md` (1 reference)
11. Update `core/agents/archetypes/architect.md` (1 reference)

### Phase 5: Update integration templates

12. Update `integrations/claude-code/CLAUDE.md` (13 references)
13. Update `integrations/copilot/copilot-instructions.md`
    (13 references)

### Phase 6: Update root-level documents

14. Update `BOOTSTRAP.md` (4 references)
15. Update `ADOPT.md` (2 references)
16. Update `ADD-WORKFLOW.md` (1 reference)
17. Update `Domain-Language.md` (8 references)
18. Update `UPDATE.md` (1 reference)

### Phase 7: Update core non-workflow files

19. Update `core/Document-Catalog.md` (2 references)
20. Update `core/maintenance-checklist.md` (1 reference)
21. Update `core/templates/Batch-Index-Schema.md` (1 reference)
22. Update `core/topologies/Sprint-Contract-Pipeline.md`
    (1 reference)

### Phase 8: Update wiki

23. Update `wiki/topics/workflow-design.md` (9+ references across
    prose and Core files listing)
24. Update `wiki/topics/agent-model.md` (4 references)
25. Update `wiki/topics/owner-preferences.md` (1 reference)

### Phase 9: Version, changelog, migrations

26. Update `VERSION` to `0.27.0`
27. Add `CHANGELOG.md` entry for 0.27.0 with:
    - Complete moved/renamed file table (old path -> new path)
    - New file: `core/workflows/README.md`
    - All modified files listed
    - Consumer update instructions
28. Add `MIGRATIONS.md` entry for 0.27.0 with:
    - Complete path mapping table
    - Step-by-step consumer instructions

### Phase 10: Verification grep

29. Grep entire repo for each old flat path pattern. Confirm all
    hits are in excluded historical files (CHANGELOG, MIGRATIONS,
    planning/, docs/plans/, docs/evaluations/). Any hit in a
    canonical file is a bug — fix it before proceeding.

## CHANGELOG Entry (Draft)

```
## 0.27.0 — Workflow folder reorganization

Reorganizes `core/workflows/` into two subdirectories — `types/` for
workflow type definitions and `protocols/` for supporting processes.
Renames two inconsistent files: `agentic-workflow-lifecycle.md`
becomes `agentic-workflow.md`, `sprint-lifecycle.md` becomes
`sprint-coordination.md`. Moves `development-workflow.md` without
renaming (domain-specific workflow split deferred to CR-22). No
behavioral changes to any workflow or agent.

### New files
- `core/workflows/README.md` — documents the types vs. protocols
  directory structure

### Moved/renamed files
- `core/workflows/agentic-workflow-lifecycle.md` ->
  `core/workflows/types/agentic-workflow.md`
- `core/workflows/development-workflow.md` ->
  `core/workflows/types/development-workflow.md`
- `core/workflows/task-workflow.md` ->
  `core/workflows/types/task-workflow.md`
- `core/workflows/analytics-workspace.md` ->
  `core/workflows/types/analytics-workspace.md`
- `core/workflows/dispatch-protocol.md` ->
  `core/workflows/protocols/dispatch-protocol.md`
- `core/workflows/design-alignment.md` ->
  `core/workflows/protocols/design-alignment.md`
- `core/workflows/sprint-lifecycle.md` ->
  `core/workflows/protocols/sprint-coordination.md`
- `core/workflows/doc-triggers.md` ->
  `core/workflows/protocols/doc-triggers.md`
- `core/workflows/hooks-reference.md` ->
  `core/workflows/protocols/hooks-reference.md`
- `core/workflows/knowledge-pipeline.md` ->
  `core/workflows/protocols/knowledge-pipeline.md`
- `core/workflows/knowledge-synthesis.md` ->
  `core/workflows/protocols/knowledge-synthesis.md`
- `core/workflows/progress-files.md` ->
  `core/workflows/protocols/progress-files.md`
- `core/workflows/task-promotion.md` ->
  `core/workflows/protocols/task-promotion.md`
- `core/workflows/token-estimation.md` ->
  `core/workflows/protocols/token-estimation.md`
- `core/workflows/analytics-onboarding.md` ->
  `core/workflows/protocols/analytics-onboarding.md`

### Changed files (cross-reference updates)
- `core/agents/AGENT-CATALOG.md` — workflow file path references
- `core/agents/analysis-planner.md` — task-promotion path
- `core/agents/data-architect.md` — dispatch-protocol path
- `core/agents/software-architect.md` — dispatch-protocol path
- `core/agents/archetypes/architect.md` — dispatch-protocol path
- `core/Document-Catalog.md` — design-alignment path
- `core/maintenance-checklist.md` — knowledge-synthesis path
- `core/templates/Batch-Index-Schema.md` — knowledge-pipeline path
- `core/topologies/Sprint-Contract-Pipeline.md` — development-
  workflow path
- `integrations/claude-code/CLAUDE.md` — all workflow path
  references
- `integrations/copilot/copilot-instructions.md` — all workflow
  path references
- `BOOTSTRAP.md` — workflow path references
- `ADOPT.md` — workflow path references
- `ADD-WORKFLOW.md` — task-workflow path
- `Domain-Language.md` — workflow path references
- `UPDATE.md` — token-estimation path
- `wiki/topics/workflow-design.md` — all workflow path references
- `wiki/topics/agent-model.md` — dispatch-protocol path
- `wiki/topics/owner-preferences.md` — design-alignment path

### Consumer update instructions
1. Reorganize your local workflow files to match the new structure:
   - Create `types/` and `protocols/` subdirectories in your
     workflows directory
   - Move workflow type definitions to `types/`
   - Move supporting processes to `protocols/`
2. Apply renames:
   - `agentic-workflow-lifecycle.md` -> `agentic-workflow.md`
   - `sprint-lifecycle.md` -> `sprint-coordination.md`
3. Update all cross-references in your local copies to use new
   paths (search for `core/workflows/` and update to
   `core/workflows/types/` or `core/workflows/protocols/` as
   appropriate)
4. Update from Fabrika source: `AGENT-CATALOG.md`,
   `Document-Catalog.md`, `dispatch-protocol.md`,
   `maintenance-checklist.md`, `Batch-Index-Schema.md`
5. Update your project instruction file from integration template
6. Copy `core/workflows/README.md` to your workflows directory
```

## Reference Counts Summary

Total files requiring modification: 25 canonical files + VERSION +
CHANGELOG + MIGRATIONS = 28 files

| Category | File count | Reference count |
|----------|-----------|----------------|
| Workflow files (internal) | 10 | 26 |
| Agent prompt files | 5 | 6 |
| Integration templates | 2 | 26 |
| Root-level documents | 5 | 16 |
| Core non-workflow files | 4 | 5 |
| Wiki files | 3 | 14+ |
| **Total** | **29** | **93+** |

## Alignment History

### Round 1 (2026-05-03)

**Decision: development-workflow.md is NOT renamed to sprint-workflow.md.**
The owner identified a design tension: `development-workflow.md`
currently serves as a single workflow for all sprint-based project
types (software-engineering, data-engineering, ML-engineering,
AI-engineering, analytics-engineering, data-app, automation, library).
These are fundamentally different domains with different agents and
will eventually need separate workflow definitions. Renaming to
"sprint-workflow" would paper over this tension by implying a clean
abstraction that doesn't exist yet.

The file moves to `types/development-workflow.md` without rename.
CR-22 (Composable Skills) picks up the scope of splitting
development-workflow into domain-specific workflows — the owner's
design philosophy is that workflows are tools in a toolbox, and each
domain will diverge as real usage drives specialization.

**All other plan elements approved:**
- Option A (subdirectory split) — confirmed
- sprint-lifecycle.md → protocols/sprint-coordination.md — confirmed
- agentic-workflow-lifecycle.md → types/agentic-workflow.md — confirmed
- CHANGELOG historical references left as-is — confirmed
- Execute immediately after CR-17 — confirmed

### Round 2 (2026-05-03)

**Scope expansion: project CLAUDE.md and structural-validator fix.**

During verification, the context-architect flagged stale H1 titles
(fixed in Step 5). Owner review then uncovered a systemic problem:
the project-level CLAUDE.md was being excluded from structural
updates, causing path references to go stale. Investigation found
two root causes:

1. CLAUDE.md line 67 said "When it does NOT apply: Editing this
   CLAUDE.md file" — intended to mean the lifecycle ceremony isn't
   needed to edit CLAUDE.md, but agents read it as "don't update
   CLAUDE.md during structural changes."
2. `core/agents/structural-validator.md` line ~169 said "Do not
   check the project's own CLAUDE.md" for smell tests — agents
   over-generalized this to skip all CLAUDE.md checks including
   path references.

**Changes added to CR-28 scope:**

1. **CLAUDE.md restructured.** "How you work on this project
   (MANDATORY)" is now the first section — points to the agentic
   workflow as the single source of truth without restating its
   steps. Ambiguous exclusion language replaced with clear scoping.
   New "Files that must stay current" section explicitly lists
   CLAUDE.md and SYNC-AGENTFLOW.md as mandatory update targets.

2. **`core/agents/structural-validator.md` updated.** Smell test
   exclusion preserved (personal paths are expected in a gitignored
   file), but explicit instruction added that path reference checks
   still apply to the project CLAUDE.md.

3. **All stale path references in CLAUDE.md fixed** (5 references
   to old workflow paths).

Owner direction: CLAUDE.md should not restate the workflow steps —
it should point to the workflow file as the single source of truth.
If the workflow needs to change, change the workflow file, not
CLAUDE.md.
