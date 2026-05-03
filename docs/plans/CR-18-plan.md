---
type: system-update-plan
change-request: planning/CR-18-complexity-tiers-sprint-work.md
status: executed
created: 2026-05-03
---

# System Update Plan: Universal Complexity Tiers

## File Change Inventory

### New files

None.

### Modified files

| File | Change |
|------|--------|
| `core/workflows/types/development-workflow.md` | Add "Tier-Conditional Workflow Branching" section between "Design Alignment" and "Starting a Story" defining three execution paths (Patch, Story, Deep Story) with unambiguous branching logic and tier promotion rules |
| `core/workflows/protocols/sprint-coordination.md` | Add tier assignment to sprint planning phase; tier appears in sprint contract metadata per story |
| `core/templates/Story-Template.md` | Add `tier` field to YAML frontmatter with valid values `patch`, `story`, `deep-story` |
| `core/topologies/Sprint-Contract-Pipeline.md` | Add `tier` field to Overview section; add tier-conditional gate notes |
| `core/topologies/Sprint-Contract-Mesh.md` | Add `tier` field per story section; add tier-conditional gate notes |
| `core/topologies/Sprint-Contract-Hierarchical.md` | Add `tier` field per story section; add tier-conditional gate notes |
| `core/Document-Catalog.md` | Add note under `plans/` and `evaluations/` sections that Patch tier does not produce spec or full evaluation docs |
| `core/workflows/protocols/dispatch-protocol.md` | Add "Tier-Conditional Dispatch" section specifying which agents the orchestrator invokes per tier |
| `integrations/claude-code/CLAUDE.md` | Add tier system summary to Development Workflow section |
| `integrations/copilot/copilot-instructions.md` | Add tier system summary to Development Workflow section |
| `Domain-Language.md` | Add Patch, Story, Deep Story tier definitions and universal complexity spectrum term |
| `VERSION` | Bump to `0.29.0` |
| `CHANGELOG.md` | Add 0.29.0 entry |

---

## Detailed Change Specifications

### 1. `core/workflows/types/development-workflow.md`

Add a new top-level section **"Tier-Conditional Workflow Branching"**
immediately after the "Dispatch Protocol" section and before "Starting
a Story." This section becomes the routing logic the orchestrator
reads before entering any story execution path.

**Content to add:**

```markdown
## Tier-Conditional Workflow Branching

Every story has a complexity tier assigned during sprint planning (see
`core/workflows/protocols/sprint-coordination.md`). The tier
determines which workflow gates apply. The orchestrator reads the
story's `tier` frontmatter field and routes to the appropriate path
below. If no tier is set, default to Story.

### Patch Path (tier: patch)

Patches are small, single-concern changes where the story file IS the
spec. The orchestrator skips spec creation and runs a reduced
evaluation cycle.

```
story file → implementer → code-reviewer → commit
```

1. Read the story file and sprint contract
2. Read relevant project docs on demand (architecture, data model)
3. Skip spec creation — the story's acceptance criteria are the spec
4. Create feature branch: `feature/[PROJECT_KEY]-S-042-description`
5. Update story: `status: In Progress`
6. Dispatch the **implementer** — contextual dispatch per the dispatch
   protocol. Testing approach defaults to test-after for Patches.
7. Confirm the implementer's output: review implementation summary,
   verify files were created/modified as expected
8. Run tests — all pass (no regressions)
9. Run linter — no errors
10. Commit with conventional format
11. Invoke the **code-reviewer** — strict dispatch with story file
    (as the spec), file paths, and rubric pointer. Single reviewer
    only.
12. **If the code-reviewer fails the implementation:**
    - Dispatch the implementer for revision with the story file and
      the review report path
    - Re-invoke the code-reviewer with fresh dispatch
    - **Maximum 2 retry cycles.** If a Patch needs 3 rounds of
      review, the orchestrator promotes it to Story tier and presents
      the promotion to the owner before continuing
13. **If the code-reviewer passes:**
    - Update story: `status: In Review`, add `## Completion Summary`
    - Present session summary to the owner

No planner validation. No test-writer verification (unless the sprint
contract's testing strategy mandates it for the affected area). No
architect review.

### Story Path (tier: story)

The current full development workflow. Follow "Starting a Story" and
"Completing a Story (Evaluation Cycle)" below with no modifications.
All existing gates apply.

### Deep Story Path (tier: deep-story)

Deep Stories add a mandatory research phase and architect review. The
orchestrator must complete all Deep Story gates — none are optional.

```
research → planner (spec) → architect review → implementer →
full evaluation cycle + architect structural review → commit
```

1. **Research phase.** Before invoking the planner, the orchestrator
   conducts on-demand context research of the affected subsystems.
   Read architecture docs, relevant ADRs, data model, existing code
   in the affected area. Produce a research document at
   `docs/plans/[TICKET]-research.md` summarizing: subsystems affected,
   current state, constraints discovered, risks identified, and open
   questions. Compress the research findings before passing to the
   planner (compaction principle applies).
2. Invoke the **planner** in **planning mode** with the story content
   plus the research document path as an additional contextual field.
   The planner expands the story into a full spec at
   `docs/plans/[TICKET]-spec.md`.
3. After the spec is drafted, invoke the token cost estimation
   protocol.
4. Present the spec to the owner for approval.
5. **Mandatory architect review.** Invoke the appropriate architect
   (software-architect or data-architect) in **design mode** with the
   spec's module section. This is NOT optional for Deep Stories — the
   architect must review before implementation begins. Present the
   architect's findings alongside the spec for owner approval.
6. Proceed with "Starting a Story" steps 8-10 (branch creation,
   status update, testing approach branching).
7. After implementation, run the full evaluation cycle (steps 1-9 of
   "Completing a Story").
8. **Mandatory architect structural review.** After the evaluation
   cycle passes (or as part of it), invoke the architect in **review
   mode**. This is NOT optional for Deep Stories.
9. Proceed with story completion (steps 15-19 of "Completing a
   Story").

### Tier Promotion (Mid-Execution)

A Patch can be promoted to Story if:
- The code-reviewer flags scope creep
- The implementer discovers the change is more complex than expected
- The orchestrator detects the implementer touching >3 files
- The Patch fails 2 review cycles (automatic promotion)

A Story can be promoted to Deep Story if:
- The planner flags that the spec requires research into unfamiliar
  subsystems
- The architect (if optionally invoked) rates the structural risk as
  high
- The owner requests promotion

Promotion is one-way (up only) and triggers the orchestrator to
present the situation to the owner before continuing. Demotion
(Deep Story to Story) is owner-initiated only — if research reveals
the change is simpler than anticipated, the owner can demote, but
the architect review of the spec is already done at that point so
the practical difference is skipping the post-implementation architect
review.
```

Additionally, update the existing "Starting a Story" section step 7
(the optional architect review) to add a cross-reference:

In step 7, after the existing text about when to skip, add:
```
For Deep Story tier, architect review is mandatory — see
"Tier-Conditional Workflow Branching" above.
```

Update the "Completing a Story (Evaluation Cycle)" section step 8
(the optional architect structural evaluation) to add:
```
For Deep Story tier, architect structural evaluation is mandatory —
see "Tier-Conditional Workflow Branching" above.
```

Update the "Completing a Story (Evaluation Cycle)" step 14 (max 3
retry cycles) to add a note:
```
For Patch tier, the maximum is 2 retry cycles — see the Patch Path
above. If a Patch exceeds 2 cycles, promote to Story.
```

### 2. `core/workflows/protocols/sprint-coordination.md`

In the "What Each Phase Chat Does" subsection under **Sprint Planning
chat**, add tier assignment to the scrum-master's responsibilities.

After the existing sentence "Produces `Sprint-XX.md`,
`Sprint-XX-contract.md`, `Sprint-XX-progress.md`..." add:

```markdown
The scrum-master assigns a **complexity tier** to each story during
sprint planning based on:
- Story points (primary signal: 1-2 points = Patch, 3-5 = Story,
  8-13 = Deep Story)
- Scope indicators in the story description (file count, module
  boundaries, "refactor" or "introduce" language)
- Owner override (the user can always promote or demote)

The tier is recorded in each story file's frontmatter (`tier: patch |
story | deep-story`) and in the sprint contract per story. The
orchestrator reads the tier before entering the story chat to
determine which workflow path to follow (see
`core/workflows/types/development-workflow.md`, Tier-Conditional
Workflow Branching).
```

### 3. `core/templates/Story-Template.md`

Add `tier` field to the YAML frontmatter, after `priority` and before
`created`.

Current frontmatter:
```yaml
priority: <% tp.system.prompt("Priority (High / Medium / Low)", "Medium") %>
created: <% tp.date.now("YYYY-MM-DD") %>
```

Change to:
```yaml
priority: <% tp.system.prompt("Priority (High / Medium / Low)", "Medium") %>
tier: <% tp.system.prompt("Complexity tier (patch / story / deep-story)", "story") %>
created: <% tp.date.now("YYYY-MM-DD") %>
```

### 4. `core/topologies/Sprint-Contract-Pipeline.md`

In the Overview section, add a `tier` field after the testing approach
line:

```markdown
- **Testing approach:** [TDD | Test-informed | Test-after]
- **Complexity tier:** [patch | story | deep-story]
```

Add a new section after Rollback Protocol and before Acceptance
Criteria:

```markdown
## Tier-Conditional Gates

The complexity tier determines which workflow stages apply. See
`core/workflows/types/development-workflow.md` (Tier-Conditional
Workflow Branching) for the full specification.

- **Patch:** Stage 1 (Plan) is skipped — the story file IS the spec.
  Stage 3 (Evaluate) is reduced to code-reviewer only. Max 2 retry
  cycles.
- **Story:** All stages apply as documented above.
- **Deep Story:** Stage 1 (Plan) is preceded by a research phase.
  Architect review is mandatory at both plan and evaluate stages.
```

### 5. `core/topologies/Sprint-Contract-Mesh.md`

In each story section template, add a tier field after the testing
approach line:

```markdown
### Testing Approach
- **Testing approach:** [TDD | Test-informed | Test-after]
- **Complexity tier:** [patch | story | deep-story]
```

Add a section after Rollback Protocol and before Notes:

```markdown
## Tier-Conditional Gates

The complexity tier determines which workflow stages apply per story.
See `core/workflows/types/development-workflow.md` (Tier-Conditional
Workflow Branching) for the full specification. Each story in a Mesh
sprint can have a different tier — a Mesh sprint might contain two
Patches and one Deep Story.
```

### 6. `core/topologies/Sprint-Contract-Hierarchical.md`

In each story section template, add a tier field after the testing
approach line:

```markdown
### Testing Approach
- **Testing approach:** [TDD | Test-informed | Test-after]
- **Complexity tier:** [patch | story | deep-story]
```

Add a section after Rollback Protocol and before Notes:

```markdown
## Tier-Conditional Gates

The complexity tier determines which workflow stages apply per story.
See `core/workflows/types/development-workflow.md` (Tier-Conditional
Workflow Branching) for the full specification. In a Hierarchical
sprint, upstream stories may be Patches while downstream stories that
depend on them are Stories or Deep Stories. Tier is orthogonal to
dependency ordering.
```

### 7. `core/Document-Catalog.md`

In the `plans/` section (the `[TICKET]-spec.md` entry, line ~722),
add a note after the existing Notes:

```markdown
- **Notes:** [...existing text...] **Tier note:** Patch-tier stories
  do not produce spec documents — the story file IS the spec. Spec
  creation applies to Story and Deep Story tiers only. Deep Story
  tier additionally produces a research document at
  `docs/plans/[TICKET]-research.md` before spec creation.
```

In the `evaluations/` section header area (around line ~700), add a
note:

```markdown
> **Tier note:** Patch-tier stories produce only a code review report
> (`[TICKET]-code-review.md`). Test review, product review, and
> architect review are produced for Story and Deep Story tiers only.
> Deep Story tier additionally produces an architect review report
> (`[TICKET]-architecture-review.md`) as a mandatory (not optional)
> evaluation artifact.
```

### 8. `core/workflows/protocols/dispatch-protocol.md`

Add a new section **"Tier-Conditional Dispatch"** after the existing
"Lightweight Dispatch" section and before "Per-Agent Dispatch
Contracts."

```markdown
## Tier-Conditional Dispatch

Complexity tiers determine which agents the orchestrator invokes for a
given story. Tier-conditional dispatch is orthogonal to dispatch tiers
(strict vs. contextual) — it controls WHICH agents are dispatched, not
HOW they are dispatched. Each dispatched agent still receives its
standard payload per the per-agent contracts below.

### Patch Tier

| Agent | Invoked? | Notes |
|-------|----------|-------|
| Planner (planning mode) | No | Story file IS the spec |
| Implementer | Yes | Standard contextual dispatch |
| Code-reviewer | Yes | Strict dispatch; story file serves as the spec |
| Test-writer | No | Unless sprint contract testing strategy mandates it for the affected area |
| Planner (validation mode) | No | Acceptance criteria are trivially verifiable from the story |
| Architect (design mode) | No | |
| Architect (review mode) | No | |

Retry cap: 2 cycles. Promotion to Story if exceeded.

### Story Tier

| Agent | Invoked? | Notes |
|-------|----------|-------|
| Planner (planning mode) | Yes | Standard contextual dispatch |
| Implementer | Yes | Standard contextual dispatch |
| Code-reviewer | Yes | Standard strict dispatch |
| Test-writer | Yes | Mode depends on testing approach |
| Planner (validation mode) | Yes | Standard strict dispatch |
| Architect (design mode) | Optional | Per existing rules (new modules, restructuring) |
| Architect (review mode) | Optional | Per existing rules (structural concerns flagged) |

Retry cap: 3 cycles.

### Deep Story Tier

| Agent | Invoked? | Notes |
|-------|----------|-------|
| Planner (planning mode) | Yes | Contextual dispatch with research document path as additional field |
| Implementer | Yes | Standard contextual dispatch |
| Code-reviewer | Yes | Standard strict dispatch |
| Test-writer | Yes | Mode depends on testing approach |
| Planner (validation mode) | Yes | Standard strict dispatch |
| Architect (design mode) | **Mandatory** | Not optional — must review before implementation |
| Architect (review mode) | **Mandatory** | Not optional — must review after implementation |

Retry cap: 3 cycles.

### Planner Dispatch — Research Document Field

For Deep Story tier, the planner planning mode dispatch contract gains
one additional conditional field:

| Field | Required | Description |
|-------|----------|-------------|
| Research document | Conditional | Path to `docs/plans/[TICKET]-research.md` — required for Deep Story tier. Contains compressed findings from the research phase. |
```

### 9. `integrations/claude-code/CLAUDE.md`

In the "Development Workflow" section, after the existing summary list
item for "Starting a Story" and before "Completing a Story," add:

```markdown
- **Complexity Tiers** — each story has a tier (Patch / Story / Deep
  Story) assigned during sprint planning. Patch skips spec creation
  and uses reduced evaluation (code-reviewer only, max 2 retries).
  Story is the current full workflow. Deep Story adds mandatory
  research phase and architect review at both plan and evaluate
  stages. The orchestrator reads `tier` from the story frontmatter
  and routes to the appropriate path. See
  `[FABRIKA_PATH]/core/workflows/types/development-workflow.md`
  (Tier-Conditional Workflow Branching).
```

### 10. `integrations/copilot/copilot-instructions.md`

Same addition as the Claude Code template, in the corresponding
"Development Workflow" section:

```markdown
- **Complexity Tiers** — each story has a tier (Patch / Story / Deep
  Story) assigned during sprint planning. Patch skips spec creation
  and uses reduced evaluation (code-reviewer only, max 2 retries).
  Story is the current full workflow. Deep Story adds mandatory
  research phase and architect review at both plan and evaluate
  stages. The orchestrator reads `tier` from the story frontmatter
  and routes to the appropriate path. See
  `[FABRIKA_PATH]/core/workflows/types/development-workflow.md`
  (Tier-Conditional Workflow Branching).
```

### 11. `Domain-Language.md`

Add the following terms to the **Workflow** section, after the
existing "Graduated testing" entry and before "Spec-first":

```markdown
**Complexity tier** — A classification of work item complexity that
determines which workflow gates apply. Three tiers for sprint-based
work: **Patch** (reduced ceremony), **Story** (full ceremony), and
**Deep Story** (enhanced ceremony). Part of the **universal complexity
spectrum**. Assigned by the **coordinator** during sprint planning
based on story points, scope indicators, and owner override. Recorded
in the story file frontmatter (`tier: patch | story | deep-story`)
and in the **sprint contract**. The **orchestrator** reads the tier
and routes to the appropriate execution path. [Introduced in 0.29.0.]

**Patch** — The lightest complexity tier for sprint-based work.
Single-concern changes (1-2 points) where the story file IS the spec.
Skips spec creation and planner validation. Evaluation is reduced to
code-reviewer only (max 2 retry cycles). If a Patch exceeds 2 review
cycles or the code-reviewer flags scope creep, the orchestrator
promotes it to **Story**. Conventional commit format is the primary
documentation artifact. [Introduced in 0.29.0.]

**Story** — The standard complexity tier for sprint-based work.
Multi-file changes (3-5 points) with bounded scope. The current full
**development workflow** applies with no modifications: spec creation,
all evaluation gates, 3 retry cycles. This is the default tier when
none is specified. [Named in 0.29.0; behavior predates Fabrika.]

**Deep Story** — The highest complexity tier for sprint-based work.
Cross-cutting, novel, or high-risk changes (8-13 points). Adds a
mandatory research phase (producing
`docs/plans/[TICKET]-research.md`) before spec creation, mandatory
**architect** review of the spec before implementation, and mandatory
architect structural review after implementation. Research findings
are compressed before being passed to the planner (**compaction**
applies). [Introduced in 0.29.0.]

**Universal complexity spectrum** — The graduated scale of ceremony
levels that applies across all workflow types, not just sprint-based
work. The full spectrum: ad-hoc (near-zero ceremony) -> task (base
workflow) -> patch (reduced sprint ceremony) -> story (full sprint
ceremony) -> deep story (enhanced sprint ceremony) -> epic (multi-story
coordination). The **orchestrator** dynamically assesses where a piece
of work falls on this spectrum based on scope, risk, and coordination
needs — not by checking the project type. The three old project type
categories (sprint-based, task-based, methodology-based) are dissolving
into composable **workflow types** with the spectrum as the connecting
thread. [Conceptualized in 0.29.0; CR-18 implements the sprint-based
portion (patch, story, deep story). CR-19 covers ad-hoc. CR-17
covers task. CR-24 addresses epic-level orchestration.]

**Tier promotion** — The one-way escalation of a story's
**complexity tier** during execution. Patch can promote to Story;
Story can promote to Deep Story. Triggers: code-reviewer flags scope
creep, implementer discovers unexpected complexity, orchestrator
detects >3 files touched (Patch), or automatic promotion after
exceeding the tier's retry cap. The orchestrator presents the
promotion to the owner before continuing. Demotion (Deep Story to
Story) is owner-initiated only. [Introduced in 0.29.0.]
```

### 12. `VERSION`

Change content from `0.28.0` to `0.29.0`.

### 13. `CHANGELOG.md`

Add the following entry at the top, after the header and before the
0.28.0 entry:

```markdown
## 0.29.0 — Universal complexity tiers

Introduces three complexity tiers (Patch, Story, Deep Story) that
determine which workflow gates apply to each sprint story. Patches
skip spec creation and use reduced evaluation. Stories follow the
existing full workflow. Deep Stories add mandatory research and
architect review. The orchestrator reads the tier from each story's
frontmatter and routes to the appropriate execution path. Part of the
Phase 2 workflow composition model — the tiers are points on a
universal complexity spectrum spanning ad-hoc through epic.

### Changed files
- `core/workflows/types/development-workflow.md` — added
  Tier-Conditional Workflow Branching section defining Patch, Story,
  and Deep Story execution paths with branching logic and tier
  promotion rules; added tier cross-references to existing Starting a
  Story and Completing a Story sections
- `core/workflows/protocols/sprint-coordination.md` — added tier
  assignment to sprint planning phase description
- `core/templates/Story-Template.md` — added `tier` field to YAML
  frontmatter (patch / story / deep-story, default story)
- `core/topologies/Sprint-Contract-Pipeline.md` — added complexity
  tier field to Overview; added Tier-Conditional Gates section
- `core/topologies/Sprint-Contract-Mesh.md` — added complexity tier
  field per story section; added Tier-Conditional Gates section
- `core/topologies/Sprint-Contract-Hierarchical.md` — added
  complexity tier field per story section; added Tier-Conditional
  Gates section
- `core/Document-Catalog.md` — added tier notes to plans/ and
  evaluations/ sections specifying which tiers produce which artifacts
- `core/workflows/protocols/dispatch-protocol.md` — added
  Tier-Conditional Dispatch section specifying per-tier agent
  invocation tables and research document dispatch field for Deep
  Story
- `integrations/claude-code/CLAUDE.md` — added complexity tier
  summary to Development Workflow section
- `integrations/copilot/copilot-instructions.md` — added complexity
  tier summary to Development Workflow section
- `Domain-Language.md` — added definitions: Complexity tier, Patch,
  Story, Deep Story, Universal complexity spectrum, Tier promotion

### Consumer update instructions
1. Copy updated `core/workflows/types/development-workflow.md` (new
   Tier-Conditional Workflow Branching section plus cross-reference
   additions in existing sections)
2. Copy updated `core/workflows/protocols/sprint-coordination.md`
   (tier assignment in sprint planning)
3. Copy updated `core/templates/Story-Template.md` (new `tier`
   frontmatter field)
4. Copy updated sprint contract templates from `core/topologies/`
   (tier field and Tier-Conditional Gates section in all three)
5. Copy updated `core/Document-Catalog.md` (tier notes in plans/ and
   evaluations/)
6. Copy updated `core/workflows/protocols/dispatch-protocol.md` (new
   Tier-Conditional Dispatch section)
7. Update your project instruction file (CLAUDE.md or
   copilot-instructions.md) from the integration template — add the
   complexity tier summary to the Development Workflow section
8. Update your project's Domain Language with the new tier
   definitions if applicable
9. Add the `tier` field to any existing story files (default to
   `story` for existing stories)
```

---

## Integration Point Analysis

| Changed file | References from | Sync required |
|-------------|----------------|---------------|
| `core/workflows/types/development-workflow.md` | `integrations/claude-code/CLAUDE.md` (Development Workflow summary), `integrations/copilot/copilot-instructions.md` (same), `core/workflows/protocols/sprint-coordination.md` (references workflow for story execution), all agent prompts (agents read the workflow indirectly via orchestrator dispatch) | Integration templates must mention tier system; sprint-coordination must reference tier branching; agent prompts must NOT contain tier logic (agents are tier-unaware) |
| `core/workflows/protocols/sprint-coordination.md` | `integrations/claude-code/CLAUDE.md` (Sprint Lifecycle section), `integrations/copilot/copilot-instructions.md` (same), `core/workflows/types/development-workflow.md` (Sprint Planning section references sprint-coordination) | Sprint planning description in development-workflow.md should mention tier assignment; integration templates already point to sprint-coordination on demand |
| `core/templates/Story-Template.md` | Consumer projects copy this template to `docs/Templates/`; `core/Document-Catalog.md` lists Stories | Document Catalog's story entry does not need updating (the entry describes the template's purpose, not its schema); consumer update instructions must note the new field |
| `core/topologies/Sprint-Contract-*.md` | Consumer projects copy these to `docs/Templates/`; `core/workflows/types/development-workflow.md` references sprint contracts; `core/workflows/protocols/sprint-coordination.md` produces contracts | Development workflow and sprint coordination already reference contracts generically; no additional cross-references needed |
| `core/Document-Catalog.md` | `integrations/claude-code/CLAUDE.md` (Document Catalog pointer), `integrations/copilot/copilot-instructions.md` (same), bootstrap and adoption processes | Integration template pointers are path-based and unchanged; no sync needed |
| `core/workflows/protocols/dispatch-protocol.md` | All agent prompts (agents reference dispatch protocol for their contracts), `integrations/claude-code/CLAUDE.md` (Subagents section), `core/workflows/types/development-workflow.md` (Dispatch Protocol reference) | Existing references are path-based pointers and remain valid; new tier-conditional section is additive |
| `integrations/claude-code/CLAUDE.md` | Consumer projects customize from this template | Consumer update instructions cover this |
| `integrations/copilot/copilot-instructions.md` | Consumer projects customize from this template | Consumer update instructions cover this |
| `Domain-Language.md` | Wiki articles may reference these terms; CLAUDE.md references Domain Language; consumer projects maintain their own Domain Language | Consumer update instructions note this; wiki does not need updating (Fabrika's wiki is updated during Ship step) |

---

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Tier logic leaks into agent prompts | Any agent prompt in `core/agents/` | Agent becomes tier-aware and makes routing decisions that should be orchestrator's job. Breaks the principle that agents are tier-unaware. |
| 2 | Ambiguous tier default when `tier` field is missing from legacy stories | `core/workflows/types/development-workflow.md`, story files | Orchestrator does not know which path to follow for stories created before 0.29.0. Could default to wrong tier or error. |
| 3 | Patch retry cap inconsistency | `core/workflows/types/development-workflow.md`, `core/workflows/protocols/dispatch-protocol.md` | Development workflow says max 2 retries for Patch, dispatch protocol or sprint contract template says something different. Conflicting instructions. |
| 4 | Deep Story research document path not referenced in Document Catalog | `core/Document-Catalog.md` | New document type (`[TICKET]-research.md`) exists but is not cataloged. Agents and bootstrapping miss it. |
| 5 | Sprint contract templates reference tier but scrum-master agent prompt does not know to assign it | `core/agents/scrum-master.md` | Scrum master produces sprint contracts without tier fields. Templates have the field but it is never populated. |
| 6 | Tier field in Story Template uses Templater syntax that may not match the enum values exactly | `core/templates/Story-Template.md` | Prompt default or values may not match the valid enum (`patch`, `story`, `deep-story` with exact casing and hyphenation). |
| 7 | Integration template tier summary drifts from actual workflow | `integrations/claude-code/CLAUDE.md`, `integrations/copilot/copilot-instructions.md` | Summary in integration template describes tier behavior differently from development-workflow.md. Orchestrator follows wrong instructions depending on which file it reads first. |

---

## Mitigations

| Risk # | Mitigation |
|--------|-----------|
| 1 | Verification checklist explicitly checks: grep all files in `core/agents/` for the words "patch", "tier", "deep-story" — none should appear except in the scrum-master prompt (which assigns tiers during planning). This is a verification step, not an implementation step. |
| 2 | The Tier-Conditional Workflow Branching section in development-workflow.md explicitly states: "If no tier is set, default to Story." This covers legacy stories. Consumer update instructions note that existing stories should add `tier: story` to their frontmatter. |
| 3 | All three documents that mention retry caps (development-workflow.md Patch Path, dispatch-protocol.md Tier-Conditional Dispatch, sprint contract template Tier-Conditional Gates) must state the same numbers: Patch = 2 cycles, Story/Deep Story = 3 cycles. The plan specifies this consistently. Verifiers check cross-consistency. |
| 4 | Add `[TICKET]-research.md` as a new entry in Document Catalog under `plans/` with a note that it is Deep Story tier only. (Included in the change spec for Document Catalog above.) |
| 5 | The scrum-master agent prompt (`core/agents/scrum-master.md`) is OUT OF SCOPE for this CR per the "What does NOT change" section — agents are tier-unaware. The scrum-master learns about tier assignment from the sprint-coordination protocol, which it already reads during sprint planning. The tier assignment guidance added to sprint-coordination.md is sufficient. If the scrum-master prompt needs a pointer to the tier assignment section, that is a separate one-line addition that does not make the agent "tier-aware" in the routing sense. **Owner decision point: should we add a one-line pointer in the scrum-master prompt?** |
| 6 | Use exact enum values in the Templater prompt: `"patch / story / deep-story"` with default `"story"`. The frontmatter field uses lowercase with hyphens consistently across all files. |
| 7 | Integration template summaries are intentionally brief (3-4 lines) and point to the development-workflow.md file for full details via `[FABRIKA_PATH]` path. The summary states behavior; the workflow file is authoritative. Verifiers check that the summary does not contradict the workflow. |

---

## Version Bump Determination

**Bump type:** minor
**New version:** 0.29.0
**Reasoning:** Multiple `core/**` files are modified (development-workflow.md, sprint-coordination.md, Story-Template.md, Sprint-Contract templates, Document-Catalog.md, dispatch-protocol.md). Per bump rules, `core/**` changes require a minor bump. The `integrations/**` changes (CLAUDE.md, copilot-instructions.md) would only require a patch bump, but the most impactful change wins, so minor applies.

---

## CHANGELOG Draft

See the full CHANGELOG entry in section 13 of the Detailed Change
Specifications above.

---

## Owner Decision Points

### 1. Point thresholds: fixed or configurable?

**CR lean:** Fixed thresholds with owner override as escape valve.

**Recommendation:** Agree with the CR. Fixed thresholds (1-2 = Patch,
3-5 = Story, 8-13 = Deep Story) with owner override. Configurability
adds complexity, decision fatigue, and framework surface area for
minimal benefit. The override covers edge cases. No additional
framework machinery needed.

### 2. Patches still use conventional commit format?

**CR lean:** Yes, the commit IS the documentation.

**Recommendation:** Agree. Patches use `feat([PROJECT_KEY]-S-042): description` (or `fix:`, `refactor:`, etc.) like any other story.
The commit message for a Patch serves as spec + implementation +
review summary. No change needed to git conventions.

### 3. Can a Deep Story be demoted to Story mid-execution?

**CR lean:** Yes, owner can demote.

**Recommendation:** Agree, with the nuance the CR already identifies:
if architect review of the spec has already happened, demotion just
skips the post-implementation architect review. The research artifact
already exists and does not need to be discarded. Demotion is
owner-initiated only (no automatic demotion). Implemented in the
Tier Promotion section of development-workflow.md.

### 4. Velocity tracking unchanged?

**CR answer:** Yes.

**Recommendation:** Agree. Points count the same regardless of tier.
No changes to sprint progress files, features.json, or velocity
calculations. A 2-point Patch and a 2-point Story both contribute 2
points.

### 5. Research artifact for Deep Stories?

**CR lean:** Yes, at `docs/plans/[TICKET]-research.md`.

**Recommendation:** Agree. The research document lives alongside
specs in `docs/plans/` with a `-research` suffix. It is produced by
the orchestrator (not a sub-agent) during the research phase, then
compressed and passed to the planner as context. This aligns with the
compaction principle (CR-20/0.28.0). The Document Catalog gets an
entry for this artifact type.

### 6. Scrum-master prompt pointer (new — from Risk #5)

**Context:** The CR says agent prompts do not change (agents are
tier-unaware). But the scrum-master needs to assign tiers during
sprint planning. The sprint-coordination.md protocol (which the
scrum-master reads) will contain the tier assignment guidance. The
question is whether the scrum-master agent prompt also needs a
one-line pointer to this guidance.

**Recommendation:** Do NOT modify the scrum-master prompt. The
scrum-master already reads sprint-coordination.md during planning
(it is in its contextual dispatch). Adding tier assignment guidance
to sprint-coordination.md is sufficient. If real-world execution
shows the scrum-master missing tier assignment, add the pointer as a
follow-up patch.

---

## Additional Scope (from Alignment)

### Stale "Agentic-Workflow Lifecycle" header cleanup

CR-28 renamed `agentic-workflow-lifecycle.md` to `agentic-workflow.md`
and dropped "lifecycle" from the concept name, but the integration
template section headers still say "Agentic-Workflow Lifecycle." Since
we're already touching both integration templates for the tier system
summary, clean up these stale headers in the same change:

- `integrations/claude-code/CLAUDE.md` line 354: rename section from
  `## Agentic-Workflow Lifecycle (agentic-workflow type only)` to
  `## Agentic Workflow (agentic-workflow type only)`
- `integrations/copilot/copilot-instructions.md` line 263: same rename
- `wiki/topics/workflow-design.md`: fix any stale `agentic-workflow-lifecycle` references
- `MIGRATIONS.md`: fix any stale `agentic-workflow-lifecycle` path references

### CR-22 notes (out of scope, captured for future)

Two items surfaced during alignment that belong in CR-22's scope:
1. **Dispatch protocol decomposition.** At 1,097 lines,
   `core/workflows/protocols/dispatch-protocol.md` exceeds the context
   decomposition threshold. CR-22's agent model restructuring is the
   natural moment to decompose per-agent contracts into per-archetype
   base contracts with domain extensions.
2. **Analytics Workspace → Analytics Workflow rename.** CR-22 dissolves
   the three project type categories. The rename from
   "analytics-workspace" to "analytics workflow" (as a workflow type,
   not a project type) belongs in that restructuring.

---

## Alignment History

- **v1:** Initial plan. 2026-05-03.
- **v2:** Owner alignment. 2026-05-03. All 6 decision points approved
  as recommended. Added stale "Agentic-Workflow Lifecycle" header
  cleanup to scope (integration templates, wiki, MIGRATIONS). Added
  two CR-22 notes (dispatch protocol decomposition, analytics workspace
  rename). Owner confirmed research phase vs. Design Alignment
  distinction. Approved for execution.
