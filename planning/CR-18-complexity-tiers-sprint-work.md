# CR-18: Complexity Tiers for Sprint-Based Work

**Version target:** TBD (minor bump — workflow and template changes)
**Dependencies:** CR-13 (review-revise loop — tier definitions depend
on the evaluation cycle structure)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

In sprint-based projects, every work item is a "story" that flows
through the full development-workflow: spec creation → (optional
architect review) → implementation → full evaluation cycle
(code-reviewer + test-writer + planner validation). A 1-point typo
fix gets the same ceremony as an 8-point feature introducing a new
module.

This creates two failure modes:

1. **Ceremony drag.** Simple changes that any competent developer
   would just *do* instead spend 3–5 agent dispatches producing spec
   documents, evaluation reports, and planner validations that add no
   value. The overhead discourages using the framework for small work,
   pushing it off-process entirely.

2. **Under-scoping complex work.** Conversely, highly complex changes
   (new modules, cross-cutting refactors, unfamiliar subsystems) get
   the same treatment as medium-complexity features. They would
   benefit from an explicit research phase and architect review, but
   those are currently "optional" with no systematic trigger.

The analytics-workspace solved a parallel problem with its Tier 1 /
Tier 2 distinction (local data vs. production data determines review
intensity). Sprint-based projects need an equivalent.

Dex Horthy's framing (AI Engineer, "No Vibes Allowed"): "You don't
always need a full research plan implement. Sometimes you need more,
sometimes you need less. If you're changing the color of a button,
just talk to the agent and tell it what to do."

The key insight: graduated complexity is not about skipping quality
control — it's about matching the ceremony to the risk.

## Solution Direction

Introduce three complexity tiers for sprint-based work items. Each
tier defines which workflow gates are required and which can be
skipped.

### Tier Definitions

| Tier | Name | Typical Points | Signals |
|------|------|---------------|---------|
| **Patch** | Quick fix, single-concern change | 1–2 | Single file or tightly scoped set of files; obvious intent; no new patterns; no architectural decisions; fix is smaller than a spec would be |
| **Story** | Standard feature or refactor | 3–5 | Multiple files; bounded scope; known patterns; clear acceptance criteria; no new modules or boundaries |
| **Deep Story** | Cross-cutting, novel, or high-risk | 8–13 | New modules or abstractions; crosses existing boundaries; unfamiliar subsystem; multiple integration points; design decisions with long-term consequences |

### Workflow Per Tier

**Patch tier:**
```
implementer → code-reviewer → commit
```
- No spec creation (the story file IS the spec — it's small enough)
- No planner validation (acceptance criteria are trivially verifiable)
- No test-writer verification (unless testing strategy mandates it
  for the affected area)
- Single reviewer only (code-reviewer)
- Retry cap: 2 cycles (not 3 — if a patch needs 3 rounds of review,
  it should be promoted to Story)

**Story tier:**
```
planner (spec) → implementer → full evaluation cycle → commit
```
- Current full development-workflow (no change)
- All existing gates apply
- Retry cap: 3 cycles (per CR-13)

**Deep Story tier:**
```
research phase → planner (spec) → architect review → implementer →
full evaluation cycle + architect structural review → commit
```
- Mandatory research phase before planning (on-demand context
  research of the affected subsystems)
- Architect review of the spec is mandatory (not optional)
- Architect structural review after implementation is mandatory
- Retry cap: 3 cycles (per CR-13)
- Research artifacts persist at `docs/plans/[TICKET]-research.md`

### Tier Assignment

The scrum-master agent assigns the tier during sprint planning based
on:
- Story points (primary signal — 1–2 is Patch, 3–5 is Story, 8–13 is
  Deep Story)
- Scope indicators in the story description (file count, module
  boundaries mentioned, "refactor" or "introduce" language)
- Owner override (the user can always promote or demote)

The tier is recorded in the story file frontmatter:
```yaml
tier: patch | story | deep-story
```

### Tier Promotion (Mid-Execution)

A Patch can be promoted to Story if:
- The code-reviewer flags scope creep
- The implementer discovers the change is more complex than expected
- The orchestrator detects the implementer touching >3 files

Promotion is one-way (up only) and triggers the orchestrator to
present the situation to the user before continuing.

### Sprint Contract Interaction

Sprint contracts continue to define topology (Pipeline / Mesh /
Hierarchical). Tier is orthogonal to topology — a Mesh sprint could
contain two Patches and one Deep Story. The contract records each
story's tier alongside its other metadata.

## Scope

### Modified files

| File | Change |
|------|--------|
| `core/workflows/development-workflow.md` | Add tier-conditional branching: Patch path, Story path (existing), Deep Story path |
| `core/workflows/sprint-lifecycle.md` | Sprint planning includes tier assignment; tier appears in contract |
| `core/templates/Story-Template.md` | Add `tier` field to frontmatter |
| `core/topologies/Sprint-Contract-Pipeline.md` | Record tier per story in contract; note reduced gates for Patch |
| `core/topologies/Sprint-Contract-Mesh.md` | Same |
| `core/topologies/Sprint-Contract-Hierarchical.md` | Same |
| `core/Document-Catalog.md` | Note that Patch tier does not produce spec or evaluation docs |
| `core/workflows/dispatch-protocol.md` | Add dispatch guidance for tier-conditional reviewer sets |
| `integrations/claude-code/CLAUDE.md` | Mention tier system in sprint workflow summary |
| `integrations/copilot/copilot-instructions.md` | Same |
| `Domain-Language.md` | Define Patch, Story, Deep Story tiers |
| `VERSION` | Bump |
| `CHANGELOG.md` | Entry |

### New files

None — this extends existing workflow files rather than creating new
ones.

### What does NOT change

- Agent prompts (implementer, code-reviewer, etc. are not
  tier-aware — the orchestrator decides what to dispatch, not the
  agents themselves)
- Analytics-workspace (already has its own tier system)
- Agentic-workflow lifecycle (structural changes follow their own
  protocol)
- Rubrics (reviewer rubrics apply regardless of tier — the difference
  is which reviewers get invoked, not what they check)
- Task-workspace (CR-17 — different project type entirely)

## Design Decisions to Align

1. **Should the point thresholds be configurable per project?** Some
   teams might consider 3-point stories simple enough for Patch
   treatment. Leaning toward: fixed thresholds in the framework with
   owner override as the escape valve. Configurability adds complexity
   and decision fatigue.

2. **Should Patches still produce a commit with conventional commit
   format?** Yes — the commit is the documentation. A well-written
   commit message for a Patch IS the spec + implementation + review
   summary. No additional artifacts needed.

3. **Can a Deep Story be demoted to Story mid-execution?** If research
   reveals the change is simpler than anticipated. Leaning toward: yes,
   owner can demote, but architect review of the spec is already done
   at that point so the practical difference is just skipping the
   post-implementation architect review.

4. **What happens to velocity tracking?** Points still count the same
   regardless of tier. A 2-point Patch and a 2-point Story (if such a
   thing exists) both contribute 2 points. The tier affects ceremony,
   not value.

5. **Should the research phase for Deep Stories produce a distinct
   artifact type?** Leaning toward: yes, a research document at
   `docs/plans/[TICKET]-research.md` that is compressed before being
   passed to the planner. This aligns with the compaction principle
   (CR-20).

## Alignment Notes (CR-17 Execution Session, 2026-05-02)

The following insight emerged during CR-17's execution and expands
CR-18's scope significantly:

1. **Complexity tiers should be UNIVERSAL, not sprint-only.** The
   original CR scoped tiers to "sprint-based work." But with the
   Phase 2 shift to composable workflow types, the three old
   categories (sprint-based, task-based, methodology-based) are
   dissolving. The complexity assessment becomes the mechanism that
   connects ALL workflow types into a unified spectrum:

   - **Ad-hoc** (CR-19): Just do it, near-zero ceremony
   - **Task** (CR-17 base workflow): Brief → plan → implement →
     review → validate → deliver
   - **Patch** (CR-18): Implementer → reviewer → commit. Light
     ceremony within an existing project
   - **Story** (CR-18): Spec → implement → full evaluation cycle
   - **Deep Story** (CR-18): Research → spec → architect → implement →
     full evaluation + architect review
   - **Epic**: Multiple stories/tasks coordinated together

   This spectrum applies to ANY project, regardless of its declared
   type. A data engineering project might need a task for a quick SQL
   fix, a story for a pipeline feature, and a deep story for a new
   architecture — in the same sprint or outside sprints entirely.

2. **The orchestrator dynamically assesses complexity.** When a user
   says "I need to do X," the orchestrator assesses what level of
   ceremony this work needs — not by checking the project type, but
   by evaluating the work itself (scope, risk, coordination needs).
   This replaces the current model where the project type determines
   the workflow.

3. **Backlog items become universal work units.** Tasks, stories,
   epics, and bugs are work units at different scales — not artifacts
   belonging to specific project type categories. Any project can
   use any of them. A task is the atomic unit (base workflow). A story
   adds spec and evaluation ceremony. An epic groups stories toward a
   larger goal.

4. **Sprint structure becomes optional ceremony.** Sprints are
   coordination ceremony that gets added when you have enough stories
   to need time-boxing, planning, and retros. But you can do stories
   without sprints. And you can do tasks without either.

5. **This changes CR-18's title and framing.** "Complexity Tiers for
   Sprint-Based Work" → something like "Universal Complexity
   Assessment" or "Graduated Ceremony Spectrum." The three tiers
   (Patch, Story, Deep Story) remain, but they're no longer
   sprint-only — they're points on a spectrum that starts at ad-hoc
   and task level and scales up through sprint-coordinated work.

6. **Connects to CR-22 and CR-24.** CR-22 (composable skills)
   provides the structural mechanism for this unification. CR-24
   (workflow chaining) addresses how epics span multiple ceremony
   levels and how the orchestrator routes work to the right level.

7. **Alignment ceremony scales with execution ceremony.** The
   complexity assessment determines both what alignment artifact to
   produce (brief, story, PRD) AND what execution workflow to use
   (base workflow, sprint workflow, etc.). The document hierarchy
   (CR-29) formalizes the alignment side; CR-18 formalizes the
   execution side. They are the same spectrum viewed from two angles.

8. **CR-18 and CR-24 may partially merge.** The orchestrator routing
   question (CR-24 #4: "how does the orchestrator decide which
   workflow type to invoke?") is answered by CR-18's universal
   complexity assessment. The backlog spanning question (CR-24 #1)
   is answered by work items being differentiated by ceremony level,
   not workflow type. Whether these remain separate CRs or merge
   should be assessed during CR-18 execution.

## Verification Criteria

- Development-workflow clearly documents three paths with
  unambiguous branching logic
- Story template frontmatter includes tier field with valid values
- Sprint contract templates record tier per story
- Dispatch protocol specifies which agents are invoked per tier
- No tier-specific logic leaks into agent prompts (agents are
  tier-unaware — orchestrator handles routing)
- A Patch-tier story demonstrably skips spec creation and reduced
  evaluation cycle
- A Deep Story demonstrably requires research and architect review
- Integration templates accurately describe the tier system
- Domain-Language.md defines all three tiers
