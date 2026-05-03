---
type: system-update-plan
change-request: planning/PRD-16-rename-context-engineer.md
status: executed
created: 2026-05-02
---

# System Update Plan: Rename Context Engineer to Agentic Engineer

## File Change Inventory

### New files

| File | Purpose |
|------|---------|
| `core/agents/agentic-engineer.md` | Renamed agent prompt file (replaces `core/agents/context-engineer.md`). Same content with all self-references updated: heading, identity paragraph, and every occurrence of "context engineer" / "context-engineer" changed to "agentic engineer" / "agentic-engineer". No behavioral changes. |

### Deleted files

| File | Reason |
|------|--------|
| `core/agents/context-engineer.md` | Replaced by `core/agents/agentic-engineer.md` |

### Modified files

| File | Change |
|------|--------|
| `core/agents/AGENT-CATALOG.md` | (1) Methodology-Based Types mapping table row: change "context-engineer" to "agentic-engineer" in the implementer column. (2) Agent Files table: change Agent column from "context-engineer" to "agentic-engineer", File column from "context-engineer.md" to "agentic-engineer.md", update Description to say "agentic engineer" instead of "context engineer". |
| `core/agents/workflow-planner.md` | Two references: line 56 ("plans that the context-engineer executes") and line 120 ("context-engineer implements against"). Change both to "agentic-engineer". |
| `core/agents/methodology-reviewer.md` | Line 57 ("context-engineer was working against"). Change to "agentic-engineer". |
| `core/agents/context-architect.md` | Line 147 ("`core/agents/context-engineer.md` is 140 lines"). Change file path to `core/agents/agentic-engineer.md` and "context-engineer" to "agentic-engineer". |
| `core/workflows/agentic-workflow-lifecycle.md` | Five references: (1) Lines 139, 141 — "context engineer" in Step 5 revision dispatch description, change to "agentic engineer". (2) Line 146 — "context engineer executes fixes", change to "agentic engineer". (3) Line 224 — agent roster table "context-engineer" in Implementer row, change to "agentic-engineer". (4) Line 236 — maturity note listing "context-engineer", change to "agentic-engineer". |
| `core/workflows/dispatch-protocol.md` | Four locations: (1) Lines 579-581 — paragraph referencing "context-engineer" and "Context Engineer contract", change to "agentic-engineer" and "Agentic Engineer contract". (2) Line 719 — section heading "### Context Engineer", change to "### Agentic Engineer". (3) Line 731 — dispatch contract table description "The context engineer reads these directly", change to "The agentic engineer reads these directly". |
| `core/design-principles.md` | Line 30 — "context engineer reads verification reports directly during revision". Change "context engineer" to "agentic engineer". |
| `core/workflows/token-estimation.md` | Line 200 — "context-engineer" in agentic-workflow example agent listing. Change to "agentic-engineer". |
| `Domain-Language.md` | Update the "context engineer" term definition: rename the term to "agentic engineer", update the definition text to use the new name, note the old name for backward-compatibility awareness. |
| `integrations/claude-code/CLAUDE.md` | Line 505 — Subagents table row: "context-engineer -- writes methodology artifacts". Change "context-engineer" to "agentic-engineer". |
| `integrations/copilot/copilot-instructions.md` | Line 322 — Subagents table row: "context-engineer -- writes methodology artifacts". Change "context-engineer" to "agentic-engineer". |
| `BOOTSTRAP.md` | Three locations: (1) Lines 556, 560 — agent file lists in Phase 2A.1 installation instructions, change "context-engineer.md" / "context-engineer.agent.md" to "agentic-engineer.md" / "agentic-engineer.agent.md". (2) Line 834 — readiness checklist item listing "context-engineer", change to "agentic-engineer". |
| `wiki/topics/agent-model.md` | Five references: (1) Lines 27, 29 — context within longer lines describing the agent model, change "context-engineer" to "agentic-engineer". (2) Line 62 — implementer list "(plus context-engineer for agentic-workflow)", change to "(plus agentic-engineer for agentic-workflow)". (3) Line 68 — methodology-based types list, change "context-engineer" to "agentic-engineer". (4) Line 103 — version history note "context-engineer, context-architect stubs", change "context-engineer" to "agentic-engineer". |
| `planning/EXECUTION-PROMPT.md` | Line 58 — "context-engineer for execution" in dispatch instructions. Change to "agentic-engineer". |
| ~~`planning/PRD-12-plan-persistence-alignment.md`~~ | **REMOVED from scope.** Owner decision: treat as historical record, do not retroactively rename. |
| `MIGRATIONS.md` | Add new entry under version 0.25.0 with consumer migration instructions: old filename to new filename, old term to new term, grep pattern for consumers to find their own references. |
| `CHANGELOG.md` | Add entry under version 0.25.0 listing all changed files, the rename rationale, and consumer update instructions. |
| `VERSION` | Change `0.24.0` to `0.25.0`. |

## PRD Verification: Additional Files Found

The PRD lists 16 files. Independent search found 28 files containing
"context engineer" references. Here is the disposition of every file
not in the PRD's list:

| File | Disposition | Reasoning |
|------|------------|-----------|
| `core/design-principles.md` | **ADD TO PLAN** | Canonical file under `core/`. Line 30 references "context engineer" in the agentic-workflow review protocol description. Must be updated. |
| `core/workflows/token-estimation.md` | **ADD TO PLAN** | Canonical file under `core/`. Line 200 references "context-engineer" in an agentic-workflow example. Must be updated. |
| `planning/ROADMAP.md` | Skip | References PRD-16 itself, which describes the rename. The ROADMAP entry will naturally use the new name once PRD-16 is marked complete, but the entry text describes what the rename IS — not an operational reference to the agent. No change needed. |
| `planning/PRD-15-token-cost-estimation.md` | Skip | Line 227 uses "context-engineer" in a general statement about workflow agents. This is a completed PRD (historical record). Retroactive rename of past planning documents rewrites history. |
| `planning/PRD-16-rename-context-engineer.md` | Skip | This is the PRD being executed. It necessarily uses the old name to describe what is being renamed. |
| `planning/CR-19-adhoc-workflow.md` | Skip | Planning artifact. References "context engineering" as a general concept (Dex Horthy framing), not the agent name. |
| `planning/CR-17-task-workspace-project-type.md` | Skip | Planning artifact. Historical reference to agent roster using old name. |
| `docs/plans/PRD-15-plan.md` | Skip | Historical execution plan. Line 51 references `core/agents/context-engineer.md` as a file that received YAML frontmatter in a past version. Retroactive edit would misrepresent what happened. |
| `docs/plans/PRD-13-plan.md` | Skip | Historical execution plan with extensive context-engineer references throughout. Records what was planned and executed at the time. |
| `docs/evaluations/PRD-13-architecture-assessment.md` | Skip | Historical evaluation report. Records verification findings from PRD-13 execution. |
| `docs/evaluations/PRD-13-methodology-review.md` | Skip | Historical evaluation report. |
| `docs/evaluations/PRD-13-structural-validation.md` | Skip | Historical evaluation report. |

**Net result:** The PRD listed 16 files. Two additional canonical files
were found (`core/design-principles.md`, `core/workflows/token-estimation.md`).
The plan covers **18 files** that need modification plus 1 file deletion
and 1 file creation.

## Integration Point Analysis

| Changed file | Referenced by | Sync required |
|-------------|--------------|---------------|
| `core/agents/agentic-engineer.md` (new) | `core/agents/AGENT-CATALOG.md`, `core/workflows/dispatch-protocol.md`, `core/workflows/agentic-workflow-lifecycle.md`, `core/agents/context-architect.md`, `BOOTSTRAP.md` | Agent name in catalog table, dispatch contract heading, lifecycle agent roster, architect cross-reference, and bootstrap installation list must all reference `agentic-engineer.md` (not `context-engineer.md`) |
| `core/agents/context-engineer.md` (deleted) | Same files as above | All references to the old filename must be removed — no dangling `context-engineer.md` paths anywhere in the repo |
| `core/agents/AGENT-CATALOG.md` | `core/workflows/agentic-workflow-lifecycle.md`, integration templates | The catalog is the source of truth for agent-to-file mappings. The lifecycle and integration templates list agents by name and must match the catalog. |
| `core/workflows/dispatch-protocol.md` | `core/agents/agentic-engineer.md` (dispatch contract section), `core/workflows/agentic-workflow-lifecycle.md` | The dispatch contract heading and field descriptions in dispatch-protocol.md must match the self-references in the agent prompt file and the agent name used in the lifecycle steps. |
| `core/workflows/agentic-workflow-lifecycle.md` | Integration templates, `BOOTSTRAP.md`, `planning/EXECUTION-PROMPT.md` | The lifecycle names agents by role. Integration templates and EXECUTION-PROMPT.md reference these same agent names when describing dispatch. |
| `core/design-principles.md` | Referenced by agent prompts and workflow files | Uses "context engineer" in the agentic-workflow review protocol description. Must match the agent name used everywhere else. |
| `core/workflows/token-estimation.md` | Referenced by `core/Document-Catalog.md` and integration templates | Uses "context-engineer" in an example scenario. Must use the current agent name. |
| `Domain-Language.md` | All canonical files use its terminology | The vocabulary definition is the normative source for the term. If the term says "context engineer" but all files say "agentic engineer", the vocabulary is wrong. |
| `integrations/claude-code/CLAUDE.md` | Consumer project instruction files | Integration templates are what consumers copy. If the template still says "context-engineer", every new consumer project gets the wrong name. |
| `integrations/copilot/copilot-instructions.md` | Consumer project instruction files | Same as above for Copilot users. |
| `BOOTSTRAP.md` | Consumer onboarding process | Lists agent files to install. If it says `context-engineer.md` but the file is now `agentic-engineer.md`, bootstrap fails — the file does not exist. |
| `wiki/topics/agent-model.md` | Wiki readers, no direct file references | Descriptive documentation. Stale name is confusing but not a breakage. Still must be updated for consistency. |
| `MIGRATIONS.md` | Consumers upgrading between versions | Must contain instructions for the rename so consumers know to update their own references. |
| `CHANGELOG.md` | Consumers and maintainers reviewing version history | Must document what changed and why, with consumer update instructions. |

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Dangling file path: old `context-engineer.md` referenced somewhere | Any file that references `core/agents/context-engineer.md` by path | Bootstrap installation fails ("file not found"), dispatch protocol points to nonexistent file, catalog lists a file that does not exist on disk |
| 2 | Inconsistent agent name: some files say "context engineer", others say "agentic engineer" | All files in change list | Confusing for consumers and maintainers. Agents dispatched by old name in one file but defined by new name in another. Verification agents flag inconsistency. |
| 3 | Context architect accidentally renamed | `core/agents/context-architect.md`, `Domain-Language.md`, anywhere "context architect" appears | PRD explicitly states context architect stays as-is. A careless find-replace on "context" could rename the architect too. This would be an unplanned behavioral change affecting verification workflows. |
| 4 | Integration template drift: one template updated, the other missed | `integrations/claude-code/CLAUDE.md`, `integrations/copilot/copilot-instructions.md` | Consumers using one tool get the right name, consumers using the other get the wrong name. Breaks the principle that both templates stay in sync. |
| 5 | CHANGELOG/MIGRATIONS incomplete: consumer update instructions miss a file | `CHANGELOG.md`, `MIGRATIONS.md` | Consumer follows upgrade instructions but still has stale references in files not listed. Their agent dispatch breaks or confuses. |
| 6 | Self-references inside the new agent file inconsistent | `core/agents/agentic-engineer.md` | The agent prompt references itself by name and role in ~10 places. If some say "agentic engineer" and others still say "context engineer", the agent's self-description is contradictory. |
| 7 | Historical files accidentally modified | `docs/plans/PRD-13-plan.md`, `docs/evaluations/PRD-13-*.md`, past PRDs | Retroactive renaming in historical records misrepresents what was planned and executed at the time. Breaks the integrity of the historical record. |
| 8 | Missed canonical file | Any `core/` file not in the change list | If a canonical file still says "context engineer" after the rename, structural-validator will flag the inconsistency. The two additional files found (`core/design-principles.md`, `core/workflows/token-estimation.md`) address this. |
| 9 | Domain-Language.md loses the old term entirely | `Domain-Language.md` | Consumers who learned the old term cannot find it. A note about the rename helps discoverability. |

## Mitigations

| Risk # | Mitigation |
|--------|-----------|
| 1 | After creating `agentic-engineer.md` and deleting `context-engineer.md`, run `rg "context-engineer\.md" --type md` across the entire repo. Zero matches expected (except in historical docs/plans/, docs/evaluations/, and planning/ files which are intentionally left unchanged). If any canonical file still references the old filename, fix it before committing. |
| 2 | After all edits, run `rg "context.engineer" -i --type md` and verify every remaining match is either (a) in a historical/planning file intentionally left unchanged, or (b) in `planning/PRD-16-rename-context-engineer.md` itself. No canonical file under `core/`, `integrations/`, `wiki/`, or at repo root should contain "context engineer" except as part of "context architect" (which is a different agent). |
| 3 | Do NOT use global find-replace on "context". Replace only the specific strings "context engineer", "context-engineer", "Context Engineer", and "Context-Engineer". After each file edit, visually confirm that "context architect" / "context-architect" references are untouched. The context architect file itself (`core/agents/context-architect.md`) has one reference to the old name that must change (line 147), but the architect's own name and role references must remain "context architect". |
| 4 | Edit both integration templates in the same batch. After editing, diff the agent-reference sections of both templates to confirm they list the same agents with the same names. |
| 5 | The CHANGELOG consumer update instructions must list every file a consumer needs to copy or update. Cross-check against the full file change inventory in this plan. The MIGRATIONS.md entry must include the grep pattern `context.engineer` so consumers can find their own references. |
| 6 | After creating `agentic-engineer.md`, run `rg "context.engineer" core/agents/agentic-engineer.md`. Zero matches expected. Every occurrence of "context engineer" in the original file must be replaced with "agentic engineer" (and "context-engineer" with "agentic-engineer"). |
| 7 | The context engineer explicitly does NOT modify any file under `docs/plans/`, `docs/evaluations/`, or `planning/` except for `planning/EXECUTION-PROMPT.md` and `planning/PRD-12-plan-persistence-alignment.md` (which are in the PRD's change list as actively-used reference documents). All other planning/docs files are historical records left as-is. |
| 8 | The two additional canonical files (`core/design-principles.md`, `core/workflows/token-estimation.md`) are included in this plan. After all edits, the verification search in Mitigation #2 serves as the final catch-all. |
| 9 | The Domain-Language.md entry for the new "agentic engineer" term should include a parenthetical note: "(formerly context engineer)" so the old term remains discoverable. |

## Execution Order

The agentic engineer should execute changes in this order to maintain
consistency at each step:

1. Create `core/agents/agentic-engineer.md` from `core/agents/context-engineer.md` with all internal references updated
2. Delete `core/agents/context-engineer.md`
3. Update `core/agents/AGENT-CATALOG.md` (agent-to-file mapping)
4. Update `core/workflows/dispatch-protocol.md` (dispatch contract heading and descriptions)
5. Update `core/workflows/agentic-workflow-lifecycle.md` (agent roster and step descriptions)
6. Update `core/design-principles.md` (review protocol description)
7. Update `core/workflows/token-estimation.md` (example scenario)
8. Update `core/agents/workflow-planner.md` (dispatch target references)
9. Update `core/agents/methodology-reviewer.md` (cross-reference)
10. Update `core/agents/context-architect.md` (cross-reference to old filename)
11. Update `Domain-Language.md` (term definition)
12. Update `integrations/claude-code/CLAUDE.md` (subagents table)
13. Update `integrations/copilot/copilot-instructions.md` (subagents table)
14. Update `BOOTSTRAP.md` (agent installation lists and readiness checklist)
15. Update `wiki/topics/agent-model.md` (agent descriptions and history)
16. Update `planning/EXECUTION-PROMPT.md` (dispatch instructions)
17. Update `VERSION` (0.24.0 -> 0.25.0)
18. Write `CHANGELOG.md` entry (under 0.25.0)
19. Write `MIGRATIONS.md` entry (under 0.25.0)
20. Run verification searches (Mitigations #1, #2, #3, #6)

## Version Bump Determination

**Bump type:** minor
**New version:** 0.25.0
**Reasoning:** The change affects `core/agents/context-engineer.md`
(a file under `core/`). Per Fabrika's versioning discipline:
`core/** changes -> minor bump`. Multiple other `core/` files are
also modified, reinforcing the minor bump. The most impactful change
wins, and a core agent file rename is clearly minor-level.

## CHANGELOG Draft

```
## 0.25.0 — Rename context engineer to agentic engineer

Renames the agentic-workflow implementer agent from "context engineer"
to "agentic engineer." The old name collided with the industry-generic
"context engineering" concept and shared a confusing prefix with the
context architect (a different archetype). No behavioral changes —
same orientation, output contracts, and archetype.

### New files
- `core/agents/agentic-engineer.md` — renamed from `context-engineer.md`

### Deleted files
- `core/agents/context-engineer.md` — replaced by `agentic-engineer.md`

### Changed files
- `core/agents/AGENT-CATALOG.md` — agent name, filename, description
  updated from context-engineer to agentic-engineer
- `core/agents/workflow-planner.md` — dispatch target references updated
- `core/agents/methodology-reviewer.md` — cross-reference updated
- `core/agents/context-architect.md` — cross-reference to agent file
  path updated
- `core/workflows/agentic-workflow-lifecycle.md` — agent name in step
  descriptions, agent roster table, and maturity note updated
- `core/workflows/dispatch-protocol.md` — section heading, contract
  description paragraph, and dispatch table field description updated
- `core/design-principles.md` — agentic-workflow review protocol
  description updated
- `core/workflows/token-estimation.md` — example scenario agent name
  updated
- `Domain-Language.md` — term renamed with backward-compatibility note
- `integrations/claude-code/CLAUDE.md` — subagents table updated
- `integrations/copilot/copilot-instructions.md` — subagents table
  updated
- `BOOTSTRAP.md` — agent file lists and readiness checklist updated
- `wiki/topics/agent-model.md` — agent name, implementer list, and
  version history updated
- `planning/EXECUTION-PROMPT.md` — dispatch instruction updated
- `MIGRATIONS.md` — consumer migration entry added
- `VERSION` — 0.24.0 -> 0.25.0

### Consumer update instructions
1. Rename your agent file: `core/agents/context-engineer.md` ->
   `core/agents/agentic-engineer.md` (or copy the new version from
   Fabrika source)
2. Update these files from the Fabrika source:
   `core/agents/AGENT-CATALOG.md`,
   `core/workflows/dispatch-protocol.md`,
   `core/workflows/agentic-workflow-lifecycle.md`,
   `core/design-principles.md`,
   `core/workflows/token-estimation.md`,
   `Domain-Language.md`
3. Update your project instruction file (CLAUDE.md or
   copilot-instructions.md) from the Fabrika integration template
4. Update `BOOTSTRAP.md` from the Fabrika source
5. Search your project for remaining references:
   `rg "context.engineer" -i --type md`
   Update any matches in your own project files (custom workflows,
   documentation, etc.)
```

## Owner Decision Points

All decisions were resolved during alignment:

1. **Context architect rename?** Owner confirmed: no. "Context" is
   accurate for the architect role. Only the implementer agent is
   renamed.
2. **Historical files?** Owner confirmed: no retroactive changes to
   past plans, evaluations, or completed PRDs. `EXECUTION-PROMPT.md`
   is updated (actively-used dispatch reference).
   `PRD-12-plan-persistence-alignment.md` is left as-is (historical).
3. **Additional canonical files found.** Two files not in the PRD's
   list (`core/design-principles.md`, `core/workflows/token-estimation.md`)
   contain references that must be updated. This is a mechanical
   addition consistent with the PRD's intent — no owner decision
   needed, but flagged for awareness.

## Alignment History

- **v1:** Initial plan. 2026-05-02. Independent codebase search found 2
  additional canonical files beyond the PRD's 16-file list. 12 files
  in planning/, docs/plans/, and docs/evaluations/ were identified as
  historical records and excluded from the change list.
