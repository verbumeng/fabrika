# CR-18 Structural Validation Report

**Verdict: PASS**

All checklist items verified. No structural defects found.

---

## Per-Check Results

### 1. All files referenced in the CHANGELOG entry actually exist

**PASS.** All 11 changed files listed in the 0.29.0 CHANGELOG entry
exist at their stated paths. Verified by file existence check:

- `core/workflows/types/development-workflow.md` — exists
- `core/workflows/protocols/sprint-coordination.md` — exists
- `core/templates/Story-Template.md` — exists
- `core/topologies/Sprint-Contract-Pipeline.md` — exists
- `core/topologies/Sprint-Contract-Mesh.md` — exists
- `core/topologies/Sprint-Contract-Hierarchical.md` — exists
- `core/Document-Catalog.md` — exists
- `core/workflows/protocols/dispatch-protocol.md` — exists
- `integrations/claude-code/CLAUDE.md` — exists
- `integrations/copilot/copilot-instructions.md` — exists
- `Domain-Language.md` — exists

### 2. VERSION file matches the latest CHANGELOG entry

**PASS.** `VERSION` contains `0.29.0` (line 1). The CHANGELOG's latest
entry header is `## 0.29.0 — Universal complexity tiers` (CHANGELOG.md
line 9). They match.

### 3. AGENT-CATALOG agent file table matches actual files in core/agents/

**PASS.** No new agents were expected (CR-18 does not add agents). The
Agent Files table in `core/agents/AGENT-CATALOG.md` (lines 104-135)
lists 32 agent files. The actual directory `core/agents/` contains
exactly 32 `.md` files (excluding `AGENT-CATALOG.md` and
`agent-frontmatter-spec.md`). Every file listed in the table has a
corresponding file on disk, and vice versa.

### 4. Document-Catalog Quick Reference sections are current

**PASS.** The Document-Catalog was updated with two tier notes:

- **evaluations/ section** (line 701-707): Tier note block specifying
  Patch produces only code review, Story/Deep Story produce full
  evaluation artifacts, Deep Story additionally produces mandatory
  architect review.
- **plans/ section** (line 730): Tier note in the `[TICKET]-spec.md`
  entry specifying Patch skips spec, Deep Story produces research
  document before spec.

No new document types were added that would require Quick Reference
updates. The existing Quick Reference sections (lines 856-925) list
documents by project type — no new document types were introduced by
CR-18, only behavioral notes on existing types.

### 5. Cross-references between files resolve

**PASS.** All cross-references verified:

- `development-workflow.md` line 34 references
  `core/workflows/protocols/sprint-coordination.md` — exists
- `sprint-coordination.md` line 59 references
  `core/workflows/types/development-workflow.md` — exists
- All three sprint contract templates reference
  `core/workflows/types/development-workflow.md` (Tier-Conditional
  Workflow Branching) — the section exists at line 31
- `dispatch-protocol.md` Tier-Conditional Dispatch section (line 64)
  is self-contained with references to per-agent contracts below —
  those contracts exist in the same file
- Both integration templates reference
  `[FABRIKA_PATH]/core/workflows/types/development-workflow.md`
  (Tier-Conditional Workflow Branching) — valid path template
- `development-workflow.md` line 157 cross-references "Tier-Conditional
  Workflow Branching" above from Starting a Story step 7 — section
  exists at line 31
- `development-workflow.md` line 244 cross-references "Tier-Conditional
  Workflow Branching" above from Completing a Story step 8 — section
  exists at line 31
- `development-workflow.md` lines 273-274 cross-reference the Patch
  Path from the max retry note — Patch Path exists at line 39

### 6. No tier-specific logic leaked into agent prompts in core/agents/

**PASS.** Grep of all files in `core/agents/` for "patch", "tier",
and "deep-story" found only these categories of matches — none are
complexity tier references:

- **Dispatch tier** (strict/contextual): AGENT-CATALOG line 88,
  analysis-planner line 97, agentic-engineer line 186,
  methodology-reviewer line 177, implementer line 127,
  context-architect line 221, planner line 205, reviewer line 125,
  validator line 129, workflow-planner line 193,
  structural-validator line 232. These reference the dispatch tier
  system (strict vs. contextual), not complexity tiers.
- **Model tier** (low/mid/high for token estimation):
  ai-engineer line 165, agent-frontmatter-spec lines 20-21, 51.
- **Analytics-workspace data tier** (Tier 1/Tier 2):
  logic-reviewer line 71, data-analyst lines 45, 52,
  performance-reviewer lines 23, 25, 32.
- **Version patch** (semver): workflow-planner lines 52, 99,
  structural-validator line 77.

Zero references to complexity tiers (patch-as-complexity-tier,
deep-story, or "complexity tier" as a term) exist in any agent prompt.
The scrum-master prompt (`core/agents/scrum-master.md`) does NOT
contain complexity tier logic — it learns about tier assignment from
`sprint-coordination.md` at dispatch time, which is correct per the
plan's design (agents are tier-unaware; the orchestrator and protocols
handle routing).

### 7. Integration templates reflect the tier system changes

**PASS.** Both integration templates contain the Complexity Tiers
bullet in their Development Workflow summary:

- `integrations/claude-code/CLAUDE.md` lines 328-336: Complexity
  Tiers summary with correct content (Patch/Story/Deep Story,
  max 2 retries for Patch, mandatory research and architect review
  for Deep Story, pointer to development-workflow.md).
- `integrations/copilot/copilot-instructions.md` lines 237-245:
  Identical summary content.

Both summaries are consistent with `development-workflow.md` and do
not contradict the authoritative workflow file.

### 8. Sprint contract templates all have tier field

**PASS.**

- `Sprint-Contract-Pipeline.md` line 16: `- **Complexity tier:**
  [patch | story | deep-story]`
- `Sprint-Contract-Mesh.md` lines 24, 45: `- **Complexity tier:**
  [patch | story | deep-story]` (per story section)
- `Sprint-Contract-Hierarchical.md` lines 42, 59: `- **Complexity
  tier:** [patch | story | deep-story]` (per story section)

### 9. Story template has tier field in frontmatter

**PASS.** `core/templates/Story-Template.md` line 10: `tier: <%
tp.system.prompt("Complexity tier (patch / story / deep-story)",
"story") %>`. Positioned after `priority` (line 9) and before
`created` (line 11). Default value is "story". Enum values match the
valid set (patch, story, deep-story).

### 10. Development workflow has three distinct paths

**PASS.** `core/workflows/types/development-workflow.md` contains
three named paths under "Tier-Conditional Workflow Branching":

- `### Patch Path (tier: patch)` — line 39
- `### Story Path (tier: story)` — line 79
- `### Deep Story Path (tier: deep-story)` — line 85

Plus `### Tier Promotion (Mid-Execution)` at line 125.

### 11. Dispatch protocol has tier-conditional section

**PASS.** `core/workflows/protocols/dispatch-protocol.md` contains
`## Tier-Conditional Dispatch` at line 64, positioned after
"Lightweight Dispatch" and before "Per-Agent Dispatch Contracts"
(line 125). The section contains three sub-sections with agent
invocation tables (Patch Tier at line 72, Story Tier at line 86,
Deep Story Tier at line 100) plus the Planner Dispatch Research
Document Field (line 114).

### 12. Sprint coordination mentions tier assignment

**PASS.** `core/workflows/protocols/sprint-coordination.md` lines
47-60 contain the tier assignment paragraph under the Sprint Planning
phase description. Content specifies: story point thresholds (1-2 =
Patch, 3-5 = Story, 8-13 = Deep Story), scope indicators, owner
override, and that the tier is recorded in story frontmatter and
sprint contract. Cross-references `development-workflow.md`
Tier-Conditional Workflow Branching.

### 13. Domain Language has tier definitions

**PASS.** `Domain-Language.md` contains six new definitions in the
Workflow section, positioned after "Graduated testing" (line 326)
and before "Spec-first" (line 387):

- **Complexity tier** — line 331
- **Patch** — line 341
- **Story** — line 349
- **Deep Story** — line 355
- **Universal complexity spectrum** — line 364
- **Tier promotion** — line 378

All definitions include `[Introduced in 0.29.0.]` or
`[Conceptualized in 0.29.0; ...]` version tags.

### 14. Retry caps are consistent across all documents

**PASS.** Retry caps verified across all documents that mention them:

| Document | Patch cap | Story/Deep Story cap |
|----------|-----------|---------------------|
| `development-workflow.md` line 68 | "Maximum 2 retry cycles" | Line 265: "Maximum 3 retry cycles" |
| `development-workflow.md` line 273 | "the maximum is 2 retry cycles" | (same line 265) |
| `dispatch-protocol.md` line 84 | "Retry cap: 2 cycles" | Lines 98, 112: "Retry cap: 3 cycles" |
| `Sprint-Contract-Pipeline.md` line 59 | "Max 2 retry cycles" | Line 48: "max 3 cycles" |
| `Sprint-Contract-Mesh.md` line 74 | (not explicit per tier, general "max 3 cycles") | "max 3 cycles" |
| `Sprint-Contract-Hierarchical.md` line 92 | (not explicit per tier, general "max 3 cycles") | "max 3 cycles" |

Patch = 2 and Story/Deep Story = 3 are consistent wherever stated.
The Mesh and Hierarchical templates mention the general "max 3 cycles"
in their Rollback Protocol sections but defer to the Tier-Conditional
Gates section for per-tier behavior (which references
development-workflow.md). This is not an inconsistency — the Rollback
Protocol describes the default, and Tier-Conditional Gates overrides
for Patch.

### 15. Stale "Agentic-Workflow Lifecycle" header fixed in both integration templates

**PASS.**

- `integrations/claude-code/CLAUDE.md` line 363: `## Agentic Workflow
  (agentic-workflow type only)` — "Lifecycle" removed.
- `integrations/copilot/copilot-instructions.md` line 272:
  `## Agentic Workflow (agentic-workflow type only)` — "Lifecycle"
  removed.

---

## Summary

All 15 checklist items pass. The CR-18 implementation is structurally
consistent: files exist at stated paths, version numbers match,
cross-references resolve, retry caps are consistent, no complexity
tier logic leaked into agent prompts, and integration templates
accurately reflect the tier system. The stale "Agentic-Workflow
Lifecycle" header was cleaned up as part of the additional scope.
