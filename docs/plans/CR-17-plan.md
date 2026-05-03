---
type: system-update-plan
change-request: planning/CR-17-task-workspace-project-type.md
status: executed
created: 2026-05-02
---

# System Update Plan: CR-17 — Base Workflow (Task Workflow Type)

CR-17 introduces the base workflow type and base agents — the generic,
domain-agnostic foundation that all specialized workflows parameterize.
This is the first CR in Phase 2's shift from taxonomic project types
to composable workflow types.

## Scope Boundary

CR-17 creates the base workflow and base agents within Fabrika's
existing structure. It uses "workflow type" language in new content
but does NOT:
- Dissolve the three project type categories (CR-22's scope)
- Implement universal complexity tiers (CR-18's scope)
- Reorganize the workflows folder (CR-28's scope)
- Unify the document hierarchy (CR-29's scope)

## File Change Inventory

### New files

| File | Purpose |
|------|---------|
| `core/agents/planner.md` | Base planner agent — domain-agnostic planning. Reads brief, produces plan with deliverables, acceptance criteria, sequencing. No domain assumptions. The unparameterized planner that all specialized planners (product-manager, analysis-planner, workflow-planner) are domain-specific versions of. |
| `core/agents/implementer.md` | Base implementer agent — executes plans, produces any artifact type. The unparameterized implementer that all specialists (software-engineer, data-analyst, data-engineer, etc.) extend with domain expertise. |
| `core/agents/reviewer.md` | Base reviewer agent — reviews against plan's acceptance criteria and general quality signals (completeness, consistency, clarity, correctness). No predefined rubric — criteria come from the plan. The unparameterized reviewer that code-reviewer, logic-reviewer, etc. specialize. |
| `core/agents/validator.md` | Base validator agent — validates deliverables against brief. Checks acceptance criteria coverage, completeness, internal consistency. Produces validation report. The unparameterized validator that test-writer, data-validator, etc. specialize. |
| `core/workflows/task-workflow.md` | Workflow definition for the base (task) workflow type. Documents the full lifecycle (brief -> plan -> implement -> review -> [revise -> re-review]* -> validate -> deliver) with phase details, folder structure, Design Alignment triggers, review-revise loop, and wiki knowledge pipeline cadence. |
| `core/templates/Brief-Template.md` | Base brief template — what is needed, who needs it, deadline, desired output format. Domain-agnostic base that Analysis-Brief-Template specializes. |
| `core/templates/Plan-Template.md` | Base plan template — deliverables, acceptance criteria, sequencing, constraints. Domain-agnostic base that Analysis-Plan-Template specializes. |
| `core/templates/Outcome-Template.md` | Base outcome template — results, methodology, deliverable summary, follow-up recommendations. Domain-agnostic base that Outcome-Report-Template specializes. |
| `ADD-WORKFLOW.md` | On-demand workflow addition mechanism. Documents how to add a workflow type to an existing project after initial bootstrap — the workflow-level equivalent of ADOPT.md's tiered adoption. Referenced from integration templates. |

### Modified files

| File | Change |
|------|--------|
| `core/agents/AGENT-CATALOG.md` | Add task-workspace row to Task-Based Types table with base agents. Add base agent files to Agent Files table. Add "Workflow Type" language note. |
| `core/Document-Catalog.md` | Add "Base Documents" section for documents available to all workflow types (brief, plan, outcome, validation report). Add task-workspace to Quick Reference. No separate task-workspace documents section — base documents are universal, not workflow-specific. |
| `core/workflows/dispatch-protocol.md` | Add dispatch contracts for all four base agents in task-workflow context: planner (planning mode + validation mode), implementer, reviewer, validator. |
| `core/workflows/doc-triggers.md` | Add doc-trigger entries for task-workflow documents (brief on new task, plan after brief approval, outcome on delivery, validation report during validation). |
| `BOOTSTRAP.md` | Add task-workspace to Phase 1.2 type alignment table. Add Phase 2T (task-workspace onboarding). Add on-demand workflow addition section pointing to ADD-WORKFLOW.md. |
| `ADOPT.md` | Add task-workspace as an adoptable type. Add note about workflow type composability. |
| `MANIFEST_SPEC.md` | Add `task-workspace` as a valid `project_type` value. |
| ~~`UPDATE.md`~~ | *(Not modified — migration content placed in MIGRATIONS.md instead.)* |
| `Domain-Language.md` | Add definitions: "task-workspace," "workflow type" (first-class, with "project type" as legacy alias), "base workflow," "base agent," "on-demand workflow addition." |
| `integrations/claude-code/CLAUDE.md` | Add task-workspace to Project Type options. Add base agents to subagents table. Add prominent note about on-demand workflow composition. |
| `integrations/copilot/copilot-instructions.md` | Same changes as CLAUDE.md template. |
| `README.md` | Update agent count (28 -> 32). Add task-workspace to Task-based types table. |
| `MIGRATIONS.md` | Add migration entry for consumers updating to 0.26.0. |
| `VERSION` | 0.25.0 -> 0.26.0 |
| `CHANGELOG.md` | Full entry for 0.26.0 with consumer update instructions. |

## Integration Point Analysis

| Changed file | References from | Sync required |
|-------------|----------------|---------------|
| `core/agents/planner.md` | AGENT-CATALOG (Agent Files table, Task-Based mapping), dispatch-protocol.md (dispatch contracts), task-workflow.md (workflow phases) | Agent name, role, archetype must be consistent across all three references |
| `core/agents/implementer.md` | Same as planner.md | Same consistency requirement |
| `core/agents/reviewer.md` | Same as planner.md | Same consistency requirement |
| `core/agents/validator.md` | Same as planner.md | Same consistency requirement |
| `core/workflows/task-workflow.md` | BOOTSTRAP.md (Phase 2T references), Document-Catalog (task-workspace documents), integration templates (workflow type listing), AGENT-CATALOG (workflow reference) | Phase names and folder structure must match between workflow file, Document Catalog, and bootstrap instructions |
| `ADD-WORKFLOW.md` | BOOTSTRAP.md (on-demand section points to it), integration templates (orchestrator references it), ADOPT.md (conceptual parallel) | Mechanism described must be consistent with bootstrap and integration template instructions |
| `Domain-Language.md` | All canonical files use these terms | "Workflow type" terminology must be used consistently in new content added by this CR |
| `AGENT-CATALOG.md` | Integration templates (subagent tables reference catalog), BOOTSTRAP.md (agent installation lists), dispatch-protocol.md | Agent names, roles, file paths must match actual files |
| `core/templates/Brief-Template.md`, `Plan-Template.md`, `Outcome-Template.md` | BOOTSTRAP.md Phase 2T (copies templates to consumer), task-workflow.md (references templates), Document-Catalog (lists templates) | Template names must match references in bootstrap and workflow files |

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Agent file count mismatch | AGENT-CATALOG, README, integration templates | README says "32 agents" but catalog or actual files disagree |
| 2 | Dispatch contract missing or incomplete | dispatch-protocol.md, task-workflow.md, agent prompts | Orchestrator doesn't know what to provide when dispatching a base agent |
| 3 | Bootstrap Phase 2T references wrong template names | BOOTSTRAP.md, core/templates/ | Bootstrap copies templates that don't exist or have different names |
| 4 | Document Catalog and doc-triggers out of sync | Document-Catalog, doc-triggers | Catalog lists documents that doc-triggers don't create, or vice versa |
| 5 | Integration templates don't communicate paradigm shift | CLAUDE.md template, copilot-instructions.md | Orchestrator doesn't know projects can add workflow types on demand |
| 6 | Domain Language terms inconsistent with usage | Domain-Language.md, all new content | New files use "workflow type" inconsistently |
| 7 | Task folder structure mismatch | task-workflow.md, Document-Catalog, BOOTSTRAP.md Phase 2T | Workflow says deliverables go to `tasks/[date-name]/work/` but bootstrap creates different structure |
| 8 | MANIFEST_SPEC doesn't list task-workspace | MANIFEST_SPEC.md | Consumer projects can't declare task-workspace in their manifest |

## Mitigations

| Risk # | Mitigation |
|--------|-----------|
| 1 | After creating agent files, count `core/agents/*.md` (exclude archetypes/ and AGENT-CATALOG.md). Verify README and AGENT-CATALOG match. |
| 2 | Write dispatch contracts following analytics-workspace pattern. Cross-reference each contract against the agent prompt's Orientation section. |
| 3 | Use exact template file names in BOOTSTRAP.md Phase 2T and core/templates/. Verify by listing after creation. |
| 4 | Write doc-trigger for every document in Document Catalog's task-workspace section. Cross-reference both directions. |
| 5 | Add dedicated, prominent section to both integration templates about workflow composition. Reference ADD-WORKFLOW.md. |
| 6 | Use "workflow type" in all new sections. Do NOT rewrite existing sections. Search new content for "project type" used where "workflow type" is meant. |
| 7 | Use identical folder structure in task-workflow.md, Document-Catalog, and BOOTSTRAP.md Phase 2T. |
| 8 | Add `task-workspace` to MANIFEST_SPEC's valid project_type list. |

## Version Bump Determination

**Bump type:** Minor
**New version:** 0.26.0
**Reasoning:** New agent prompt files in `core/agents/` and new
workflow file in `core/workflows/` — both are `core/**` changes,
which require a minor bump per the bump rules.

## CHANGELOG Draft

```
## 0.26.0 — Base workflow type and base agents

Introduces the task workflow type — the domain-agnostic base workflow
that all specialized workflows parameterize — and four base agents
(planner, implementer, reviewer, validator). First step in Fabrika's
Phase 2 shift from taxonomic project types to composable workflow
types.

### New files
- core/agents/planner.md — base planner agent
- core/agents/implementer.md — base implementer agent
- core/agents/reviewer.md — base reviewer agent
- core/agents/validator.md — base validator agent
- core/workflows/task-workflow.md — task workflow definition
- core/templates/Brief-Template.md — base brief template
- core/templates/Plan-Template.md — base plan template
- core/templates/Outcome-Template.md — base outcome template
- ADD-WORKFLOW.md — on-demand workflow addition mechanism

### Changed files
- core/agents/AGENT-CATALOG.md — base agent roster and files added
- core/Document-Catalog.md — task-workspace documents and quick
  reference added
- core/workflows/dispatch-protocol.md — base agent dispatch contracts
- core/workflows/doc-triggers.md — task-workflow document triggers
- BOOTSTRAP.md — type alignment, Phase 2T, on-demand workflow section
- ADOPT.md — task-workspace adoption support
- MANIFEST_SPEC.md — task-workspace as valid project_type
- UPDATE.md — migration guidance for workflow composition shift
- Domain-Language.md — workflow type, base workflow, base agent terms
- integrations/claude-code/CLAUDE.md — task-workspace availability,
  paradigm shift message
- integrations/copilot/copilot-instructions.md — same
- README.md — agent count (28 -> 32), task-workspace in type table
- MIGRATIONS.md — consumer migration entry
- VERSION — 0.25.0 -> 0.26.0

### Consumer update instructions
1. Copy new base agent files: planner.md, implementer.md,
   reviewer.md, validator.md
2. Copy new templates: Brief-Template.md,
   Plan-Template.md, Outcome-Template.md
3. Copy ADD-WORKFLOW.md to your project root
4. Update from Fabrika source: AGENT-CATALOG.md,
   Document-Catalog.md, dispatch-protocol.md, doc-triggers.md,
   Domain-Language.md, BOOTSTRAP.md, ADOPT.md, MANIFEST_SPEC.md,
   UPDATE.md, MIGRATIONS.md
5. Update your project instruction file from integration template
6. Key change: projects can now compose multiple workflow types on
   demand via ADD-WORKFLOW.md
```

## Owner Decision Points

All decisions resolved during alignment (2026-05-02/03):

1. **No rubric** — base reviewer derives criteria from the plan's
   acceptance criteria + four general quality signals (completeness,
   consistency, clarity, correctness). Revisit if too loose.
2. **Design Alignment yes** — same triggers as analytics-workspace.
   Produces enhanced brief. Trigger mechanism connects to universal
   complexity spectrum (CR-18) but CR-17 uses the analytics-workspace
   pattern for now.
3. **Wiki knowledge pipeline yes** — extract+index on delivery,
   synthesize monthly or on demand. Same cadence as analytics-
   workspace.
4. **Task promotion deferred** — analytics-specific concern, not a
   base workflow concern.
5. **Workflow file named `task-workflow.md`** — not task-workspace.md.
   The "-workflow" suffix is correct in the compositional model.
   Folder cleanup deferred to CR-28.
6. **ADD-WORKFLOW.md as separate file** — context decomposition
   principle. BOOTSTRAP.md points to it.

## Alignment History

- **v1:** Initial plan. 2026-05-02.
- **v2:** Agent names changed to base names (planner.md, not
  task-planner.md). Workflow file renamed from task-workspace.md to
  task-workflow.md. All six design decisions resolved. Scope boundary
  added to clarify what CR-17 does NOT do. 2026-05-03.
- **v3:** Templates renamed from Task-* to generic base names
  (Brief-Template.md, Plan-Template.md, Outcome-Template.md) — these
  are base templates, not task-workflow-specific. Document-Catalog
  change revised: base documents go in an "All Workflow Types"
  section, not a task-workspace-specific section. Dispatch protocol
  decomposition flagged for CR-28 scope. 2026-05-03.
