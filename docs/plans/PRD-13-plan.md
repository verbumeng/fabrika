---
type: system-update-plan
change-request: planning/PRD-13-review-revise-loop-redesign.md
status: executed
created: 2026-05-01
---

# System Update Plan: Review-Revise Loop Redesign

## File Change Inventory

### New files

| File | Purpose |
|------|---------|
| `core/design-principles.md` | Codifies implementer-reviewer pairing and implementer-validator pairing as cross-cutting framework principles. Standalone file for discoverability — these principles affect every project type and every agent interaction pattern. |

### Modified files

| File | Change |
|------|--------|
| `core/workflows/dispatch-protocol.md` | Rewrite Retry Protocol section (lines 906-939): remove orchestrator-as-translator pattern, replace with implementer-reads-reviews-directly pattern. Change cycle cap from 2 to 3. Add orchestrator diagnosis protocol after 3 failed cycles. Remove the analytics-workspace variant paragraph (the variant becomes the universal pattern). Add a new conditional field to all implementer dispatch contracts for revision: `Review report paths`. |
| `core/workflows/development-workflow.md` | Rewrite Completing a Story feedback loop (steps 10-14): implementer receives review file paths instead of orchestrator-synthesized fix instructions. All evaluators re-check after revision (not just failing ones). Cap changes from 2 to 3. Add orchestrator diagnosis and user intervention protocol after 3 failed cycles. |
| `core/workflows/agentic-workflow-lifecycle.md` | Rewrite Step 5 (Incorporate Feedback): context engineer reads verification reports directly. All three verifiers re-check after revision (not just failing ones). Cap changes from 2 to 3. Add orchestrator diagnosis and user intervention protocol. |
| `core/workflows/analytics-workspace.md` | Verify consistency with universal pattern. The Review-Revise Loop section (lines 450-469) already matches the target design. Changes needed: add cross-reference to `core/design-principles.md` and verify the re-review scope after performance-triggered revision paragraph still aligns. Minor wording alignment if needed. |
| `core/agents/archetypes/implementer.md` | Rewrite "What NOT to include in dispatch" note (lines 88-91) and "Evaluation Feedback Loop" section (lines 154-169). Implementer now reads review reports directly. Add orientation step for revision mode: "When invoked for revision, read the review report(s) at the provided paths alongside the original plan." Cap changes from 2 to 3. |
| `core/agents/context-engineer.md` | Rewrite "Do not provide" note (lines 192-195). Context engineer now reads verifier reports directly during revision. Add revision orientation step parallel to the implementer archetype change. |
| `core/agents/data-analyst.md` | Verify consistency — revision mode (lines 55-59) already says "read the review report yourself." No changes expected, but confirm wording aligns with the universal pattern language. |
| `integrations/claude-code/CLAUDE.md` | Update "Completing a Story (Evaluation Cycle)" summary line (line 312): change "rollback protocol (max 2 retries)" to "review-revise loop (max 3 cycles)". Update Agentic-Workflow Lifecycle summary if it references the retry cap. Add mention of `core/design-principles.md` in the Subagents section or Key Constraints. |
| `integrations/copilot/copilot-instructions.md` | Parallel changes to CLAUDE.md: update "Completing a Story" summary line (line 223), agentic-workflow summary, and add design-principles reference. |
| `core/topologies/Sprint-Contract-Pipeline.md` | Update Rollback Protocol section (line 47): change "max 2 retries" to "max 3 cycles" and update the post-cap behavior to reference orchestrator diagnosis rather than just escalation. |
| `core/topologies/Sprint-Contract-Mesh.md` | Update Rollback Protocol (line 72): change "max 2 retries" to "max 3 cycles" and update post-cap behavior. |
| `core/topologies/Sprint-Contract-Hierarchical.md` | Update Rollback Protocol (line 90): change "max 2 retries" to "max 3 cycles" and update post-cap behavior. |
| `Domain-Language.md` | Update "Evaluation cycle" definition (lines 265-269): remove "synthesizes findings into fix instructions," replace with implementer-reads-reviews-directly, change cap from 2 to 3. Update "Retry protocol" definition (lines 271-276): same changes. Add new terms: "Implementer-reviewer pairing," "Implementer-validator pairing," "Orchestrator diagnosis." |
| `VERSION` | Bump to `0.22.0` |
| `CHANGELOG.md` | Add 0.22.0 entry |
| `MIGRATIONS.md` | Add 0.22.0 migration entry |

## Integration Point Analysis

| Changed file | References from | Sync required |
|-------------|----------------|---------------|
| `core/design-principles.md` (new) | Will be referenced by: `core/workflows/dispatch-protocol.md`, `core/workflows/development-workflow.md`, `core/workflows/agentic-workflow-lifecycle.md`, `core/workflows/analytics-workspace.md`, `core/agents/archetypes/implementer.md`, integration templates | All referencing files must point to the correct path. The file must be listed in Document-Catalog.md if it qualifies as a document type. |
| `core/workflows/dispatch-protocol.md` | `core/workflows/development-workflow.md` (points here for dispatch details), `core/workflows/agentic-workflow-lifecycle.md` (points here for dispatch contracts), `core/workflows/analytics-workspace.md` (points here for dispatch contracts), `integrations/claude-code/CLAUDE.md` (points here for dispatch protocol), `integrations/copilot/copilot-instructions.md` (same), `core/agents/archetypes/implementer.md` (Evaluation Feedback Loop mirrors the retry protocol), `core/agents/context-engineer.md` (Do not provide note mirrors dispatch contract), all specialist implementer agents (inherit from archetype) | The Retry Protocol section is the single source of truth. development-workflow steps 10-14 must match. agentic-workflow Step 5 must match. implementer archetype Evaluation Feedback Loop must match. context-engineer Do not provide note must match. analytics-workspace Review-Revise Loop must match. |
| `core/workflows/development-workflow.md` | `integrations/claude-code/CLAUDE.md` (summary of workflows), `integrations/copilot/copilot-instructions.md` (summary of workflows) | Integration template summaries must reflect the updated feedback loop description — specifically the "max 2 retries" text must change to "max 3 cycles." |
| `core/workflows/agentic-workflow-lifecycle.md` | `integrations/claude-code/CLAUDE.md` (Agentic-Workflow Lifecycle section), `integrations/copilot/copilot-instructions.md` (same), `CLAUDE.md` project file (Structural update protocol references this) | Integration templates must reflect updated retry flow. |
| `core/agents/archetypes/implementer.md` | All specialist implementer agents (`software-engineer.md`, `data-engineer.md`, `data-analyst.md`, `ml-engineer.md`, `ai-engineer.md`, `context-engineer.md`) inherit from this archetype. `core/workflows/dispatch-protocol.md` specialist contracts reference the base contract. | Specialist agents that override or extend the feedback loop must be checked. `data-analyst.md` already has revision mode. `context-engineer.md` has its own Do not provide note. Other specialists inherit without override — they need no changes if the archetype is updated correctly. |
| `core/topologies/Sprint-Contract-*.md` | Sprint contracts are templates instantiated by consumer projects. `core/workflows/development-workflow.md` references the topology templates indirectly. | All three topology templates must be updated consistently. |
| `Domain-Language.md` | Referenced by agent prompts and wiki topics as the framework vocabulary. | Terms must match the actual behavior defined in the workflow files. |

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Inconsistent cycle cap across project types | `dispatch-protocol.md`, `development-workflow.md`, `agentic-workflow-lifecycle.md`, `analytics-workspace.md`, sprint contract templates, `Domain-Language.md`, integration templates | One file says "2 retries" while another says "3 cycles." An orchestrator following the wrong cap could either escalate too early (missing a fixable issue) or loop too long (burning context window). |
| 2 | Stale "orchestrator synthesizes" language in a file | `dispatch-protocol.md` (main + analytics variant paragraph), `development-workflow.md` (steps 10-14), `agentic-workflow-lifecycle.md` (Step 5), `implementer.md` (archetype + Evaluation Feedback Loop), `context-engineer.md` (Do not provide note), `Domain-Language.md` (two definitions) | An orchestrator reads the stale instruction and synthesizes fix instructions instead of routing review paths. Implementer receives mediated findings, losing nuance. |
| 3 | Missing revision dispatch field in specialist implementer contracts | `dispatch-protocol.md` specialist contracts (Software Engineer, Data Engineer, ML Engineer, AI Engineer sections) | Specialist contracts do not currently have a `Review report paths` field. If the Retry Protocol references this field but the contracts do not define it, the orchestrator has no explicit instruction on what to include during revision dispatch. |
| 4 | `design-principles.md` not discoverable | `core/design-principles.md`, integration templates, agent prompts | The new file exists but nothing points to it. Agents and orchestrators never read it, so the principles are documented but not operationalized. |
| 5 | Sprint contract templates say "max 2 retries" but orchestrator follows updated dispatch protocol | `Sprint-Contract-Pipeline.md`, `Sprint-Contract-Mesh.md`, `Sprint-Contract-Hierarchical.md` | Consumer projects copy these templates at sprint planning. If templates say "max 2 retries" but the retry protocol says "max 3 cycles," the sprint contract contradicts the workflow. |
| 6 | analytics-workspace variant paragraph in dispatch-protocol.md left as-is | `dispatch-protocol.md` lines 932-939 | The variant paragraph says "the analytics-workspace review-revise loop differs from the sprint-based retry protocol." After PRD-13, they no longer differ. Leaving this paragraph creates confusion about whether there are still two patterns. |
| 7 | Wiki topic articles reference old retry behavior | `wiki/topics/agent-model.md` (line 73), `wiki/topics/framework-philosophy.md` (line 45), `wiki/topics/workflow-design.md` (line 31) | Wiki articles describe the pre-PRD-13 divergence between project types. After PRD-13, the wiki would be stale — a reader would think there are still two retry patterns. |
| 8 | Document-Catalog does not list `core/design-principles.md` | `core/Document-Catalog.md` | If applicable as a document type, absence from the catalog means the structural-validator cannot verify its existence or cross-references. |
| 9 | README mentions "evaluation cycle" or retry behavior | `README.md` | If the README describes the retry protocol or evaluation cycle, it may reference the old "max 2 retries" pattern. |
| 10 | AGENT-CATALOG does not reference design-principles.md | `core/agents/AGENT-CATALOG.md` | The AGENT-CATALOG may need to note that all implementer archetypes reference design-principles.md, or it may not — depends on whether design-principles.md is an agent-consumed reference. |

## Mitigations

| Risk # | Mitigation |
|--------|-----------|
| 1 | Global search for "maximum 2", "max 2", "2 retry", "2 retries", "2 failed" across all `.md` files. Every hit must be updated to 3. Verification agent should run this search as a mechanical check. |
| 2 | Global search for "synthesize findings", "synthesizes findings", "summarizes what to fix", "orchestrator summarizes", "does NOT forward", "does not read raw evaluation reports" across all `.md` files. Every hit must be either removed or rewritten to the new pattern. |
| 3 | Add a conditional `Review report paths` field to each specialist implementer dispatch contract in `dispatch-protocol.md`. Description: "Paths to evaluation reports from the current review cycle — required when dispatching for revision after a failed review. The implementer reads these directly alongside the original plan." Also add it to the context engineer contract. |
| 4 | Add cross-references to `core/design-principles.md` from: the Retry Protocol section of `dispatch-protocol.md` (as the rationale for the pattern), the Evaluation Feedback Loop section of `implementer.md`, the Review-Revise Loop section of `analytics-workspace.md`, and both integration templates. |
| 5 | Update all three sprint contract template files: `Sprint-Contract-Pipeline.md`, `Sprint-Contract-Mesh.md`, `Sprint-Contract-Hierarchical.md`. Change "max 2 retries" to "max 3 cycles" and update the post-cap behavior to reference orchestrator diagnosis. |
| 6 | Remove the analytics-workspace variant paragraph entirely from the Retry Protocol section. The Retry Protocol is now universal. If analytics-workspace has additional re-review scope rules for performance-triggered revisions, those belong in the analytics-workspace workflow file, not as an exception paragraph in the dispatch protocol. |
| 7 | Update wiki topic articles: `agent-model.md`, `framework-philosophy.md`, `workflow-design.md`. Change language from "PRD-13 will extend" to reflecting the completed change. Update the retry protocol description to the universal pattern. |
| 8 | Assess whether `core/design-principles.md` qualifies for the Document-Catalog. It is a framework-level reference document, not a per-project document type. If it is more like `Domain-Language.md` (framework-level, not cataloged per-project), it does not need a Document-Catalog entry. Decision: skip Document-Catalog entry — this file lives in core/ and is a framework reference, not a consumer-created document type. |
| 9 | Read `README.md` during execution and verify no stale references. The README (first 20 lines read) does not mention retry counts or evaluation cycles specifically, so this is likely a non-issue. |
| 10 | The AGENT-CATALOG maps agents to project types — it does not track reference documents. `design-principles.md` is consumed by reading the archetype, not by agent dispatch. No AGENT-CATALOG change needed. |

## Version Bump Determination

**Bump type:** minor
**New version:** 0.22.0
**Reasoning:** This changes files under `core/` (workflows, agent archetypes, design principles). Per Fabrika's bump rules, `core/**` changes trigger a minor bump. The integration template changes would normally trigger a patch bump, but the most impactful change wins, so minor prevails.

## CHANGELOG Draft

```
## 0.22.0

Review-Revise Loop Redesign. Converges all three project types
(sprint-based, analytics-workspace, agentic-workflow) on a single
review-revise loop pattern: the implementer reads review reports
directly (the orchestrator routes file paths, it does not synthesize
or interpret findings), all reviewers re-check after every revision
(not just failing ones), and the cycle cap is 3 failed cycles with
orchestrator diagnosis and user intervention. This replaces the
previous split where sprint-based and agentic-workflow used
orchestrator-as-translator (max 2 cycles) while analytics-workspace
used direct-read (max 3 cycles). Codifies implementer-reviewer
pairing and implementer-validator pairing as explicit cross-cutting
framework design principles.

### New files

- `core/design-principles.md` — **NEW.** Cross-cutting framework
  design principles. Codifies implementer-reviewer pairing (every
  implementer output gets independent review before downstream
  action) and implementer-validator pairing (every implementer
  output that produces observable results gets validated against
  expected outcomes). Referenced by workflow files, agent archetypes,
  and integration templates.

### Core (changed — consumer projects should update)

- `core/workflows/dispatch-protocol.md` — **CHANGED.** Retry
  Protocol section rewritten: implementer reads review reports
  directly (orchestrator routes paths, does not synthesize),
  mandatory re-review by all evaluators after every revision, cycle
  cap increased from 2 to 3, orchestrator diagnosis protocol added
  after 3 failed cycles. Analytics-workspace variant paragraph
  removed (pattern is now universal). Added conditional `Review
  report paths` field to all implementer dispatch contracts and the
  context engineer contract.
- `core/workflows/development-workflow.md` — **CHANGED.** Completing
  a Story feedback loop (steps 10-14) rewritten to match new retry
  protocol: implementer receives review file paths instead of
  orchestrator-synthesized instructions, all evaluators re-check
  after revision, cap changed from 2 to 3, orchestrator diagnosis
  and user intervention protocol added.
- `core/workflows/agentic-workflow-lifecycle.md` — **CHANGED.** Step
  5 (Incorporate Feedback) rewritten: context engineer reads
  verifier reports directly, all three verifiers re-check after
  revision, cap changed from 2 to 3, orchestrator diagnosis and
  user intervention protocol added.
- `core/workflows/analytics-workspace.md` — **CHANGED.** Minor
  wording alignment in Review-Revise Loop section. Added
  cross-reference to `core/design-principles.md`.
- `core/agents/archetypes/implementer.md` — **CHANGED.** "What NOT
  to include in dispatch" note rewritten: implementer now reads
  review reports directly during revision. Evaluation Feedback Loop
  section rewritten to match new universal pattern. Added revision
  orientation step. Cap changed from 2 to 3.
- `core/agents/context-engineer.md` — **CHANGED.** "Do not provide"
  note rewritten: context engineer now reads verifier reports
  directly during revision. Added revision orientation step.
- `core/topologies/Sprint-Contract-Pipeline.md` — **CHANGED.**
  Rollback Protocol updated: cap changed from 2 to 3 cycles,
  post-cap behavior updated to reference orchestrator diagnosis.
- `core/topologies/Sprint-Contract-Mesh.md` — **CHANGED.** Rollback
  Protocol updated: cap changed from 2 to 3, orchestrator diagnosis.
- `core/topologies/Sprint-Contract-Hierarchical.md` — **CHANGED.**
  Rollback Protocol updated: cap changed from 2 to 3, orchestrator
  diagnosis.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Completing a
  Story summary updated from "rollback protocol (max 2 retries)" to
  "review-revise loop (max 3 cycles)." Added reference to
  `core/design-principles.md`.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.**
  Parallel changes to CLAUDE.md.

### Domain Language (changed — optional update)

- `Domain-Language.md` — **CHANGED.** Updated "Evaluation cycle" and
  "Retry protocol" definitions to reflect direct-read pattern and
  3-cycle cap. Added new terms: "Implementer-reviewer pairing,"
  "Implementer-validator pairing," "Orchestrator diagnosis."

### Wiki (changed — no consumer action needed)

- `wiki/topics/agent-model.md` — **CHANGED.** Updated retry protocol
  description from split pattern to universal pattern.
- `wiki/topics/framework-philosophy.md` — **CHANGED.** Updated
  implementer-reviewer pairing from "planned" to "implemented."
- `wiki/topics/workflow-design.md` — **CHANGED.** Updated review-
  revise loop description.

### Consumer update instructions

1. Copy new file: `core/design-principles.md`
2. Update core workflow files: `core/workflows/dispatch-protocol.md`,
   `core/workflows/development-workflow.md`,
   `core/workflows/agentic-workflow-lifecycle.md`,
   `core/workflows/analytics-workspace.md`
3. Update agent files: `core/agents/archetypes/implementer.md`,
   `core/agents/context-engineer.md`
4. Update topology templates: `core/topologies/Sprint-Contract-Pipeline.md`,
   `core/topologies/Sprint-Contract-Mesh.md`,
   `core/topologies/Sprint-Contract-Hierarchical.md`
5. Update integration template (CLAUDE.md or copilot-instructions.md)
6. Update `Domain-Language.md` (optional but recommended)
7. Existing sprint contracts in active sprints: no change needed mid-
   sprint. New sprint contracts will pick up the updated templates.
```

## Owner Decision Points

All three key decisions were resolved during alignment:

1. **Pairing philosophy location:** `core/design-principles.md`
   (standalone file) — resolved.
2. **3-cycle cap:** Fixed at 3 for all project types, no
   configurability — resolved.
3. **Copilot state limitation:** No special handling needed —
   resolved.

**No remaining decision points.** All changes are mechanical
consequences of the three resolved decisions plus the PRD-13 design.

## Execution Notes

### Change ordering

The context engineer should execute changes in this order to
maintain consistency at each step:

1. Create `core/design-principles.md` first (new file, no
   dependencies)
2. Rewrite `core/workflows/dispatch-protocol.md` Retry Protocol
   section (single source of truth for the pattern)
3. Update `core/workflows/development-workflow.md` steps 10-14 to
   match
4. Update `core/workflows/agentic-workflow-lifecycle.md` Step 5 to
   match
5. Verify and align `core/workflows/analytics-workspace.md`
6. Update `core/agents/archetypes/implementer.md` (archetype)
7. Update `core/agents/context-engineer.md` (specialist)
8. Verify `core/agents/data-analyst.md` (already correct)
9. Update sprint contract topology templates (all three)
10. Update integration templates (both)
11. Update `Domain-Language.md`
12. Update wiki topic articles
13. Bump `VERSION` to 0.22.0
14. Write `CHANGELOG.md` entry
15. Write `MIGRATIONS.md` entry

### What does NOT change

Per PRD-13's explicit scope:

- Reviewer and validator agent prompts (they already write
  independent reports — the change is in how reports are consumed)
- Strict dispatch for reviewers/validators (plan + file paths +
  rubric, no editorial — reinforced, not changed)
- The content or structure of evaluation reports
- `core/agents/AGENT-CATALOG.md` (no new agents, no removed agents)
- `core/Document-Catalog.md` (design-principles.md is a framework
  reference, not a consumer document type)
- `README.md` (does not describe retry mechanics at a level of
  detail that would be stale)

## Alignment History

- **v1:** Initial plan. 2026-05-01. No revisions yet.
