---
type: system-update-plan
change-request: planning/CR-19-adhoc-workflow.md
status: executed
created: 2026-05-03
---

# System Update Plan: Universal Backlog Types and Ceremony Graduation

## Design Decision Recommendations

Four design decisions from the CR, addressed here so the owner can
approve them alongside the file inventory.

### DD-1: Should simple task mode get a formal name in Domain-Language?

**Recommendation: Yes, define it.** Simple mode is orchestrator
behavior, but naming it in Domain-Language makes it a shared concept
that the user and orchestrator can reference unambiguously ("I'll
handle this in simple mode"). One paragraph under a "Simple mode"
term in the Workflow section, cross-referenced from the task workflow
file. Keep it light — definition, what it skips, scope assessment
threshold.

### DD-2: Should bugs get their own brief template section now?

**Recommendation: Defer to CR-29.** This CR defines bugs as tasks
with reproduction context. CR-29 (unified document hierarchy) handles
template unification. Trying to do both here creates scope creep.
The only change: Domain-Language defines "Bug" as a backlog type,
task-workflow.md mentions bugs use this workflow with
reproduction-context briefs, Document-Catalog notes that bug briefs
include reproduction fields. No template file changes.

### DD-3: How explicit should routing logic be in integration templates?

**Recommendation: Describe the routing question and signals, trust
orchestrator judgment.** Add a "Work Type Routing" subsection to both
integration templates that presents the four backlog types, the
routing question ("Is this a task, a bug, a story, or an epic?"),
the signals for each type, and then within-type ceremony assessment.
Do NOT add decision trees or rigid rules — the orchestrator uses
judgment on edge cases. Roughly 20-30 lines of instructional content.

### DD-4: Should "epic" be formally defined now?

**Recommendation: Define as backlog type, defer coordination
mechanics.** Epic gets a Domain-Language entry as a backlog type (what
it IS — a coordination envelope grouping tasks and stories toward a
larger goal). The entry explicitly notes that coordination mechanics
(how epics span workflows, how items are tracked within an epic) are
CR-24 scope. This gives CR-24 a clean term to reference without
forcing premature design of the coordination layer.

---

## File Change Inventory

### New files

None. The CR explicitly prohibits new workflow files, agent prompts,
and templates.

### Modified files

| File | Change |
|------|--------|
| `Domain-Language.md` | (1) Replace "Universal complexity spectrum" term: redefine from a single linear scale to a model where backlog types are categories with internal ceremony graduation. Remove the "ad-hoc -> task -> patch -> story -> deep story -> epic" linear spectrum language. (2) Add four new terms: "Backlog type" (the category concept), "Bug" (task with reproduction context), "Epic" (coordination envelope), "Simple mode" (orchestrator plans inline for trivial tasks). (3) Reframe existing "Complexity tier" definition to clarify tiers are internal to stories, not points on a universal linear spectrum. (4) Reframe existing "Patch", "Story", "Deep Story" definitions: add "within stories" framing language — these are story-internal ceremony tiers. (5) Add historical note: "Ad-hoc" as a concept resolves into simple task mode; the term is retired from active use. (6) Add "Work type routing" term defining the orchestrator's type-first assessment question. |
| `core/workflows/types/task-workflow.md` | (1) Add a "Simple Mode" section after the existing "Design Alignment for Complex Tasks" section. Documents: what simple mode is (orchestrator conceives plan inline, dispatches implementer directly with embedded plan), what it skips (no task folder, no plan.md artifact, no planner subagent), scope assessment threshold (judgment-based — if the orchestrator can fully conceive the plan in a sentence or two, it's simple mode), reviewer behavior in simple mode (receives the inline plan and the diff). (2) Add a "Bug Tasks" subsection clarifying that bugs use this workflow with reproduction-context briefs (observed vs. expected behavior, reproduction steps, fix verification focus in review). No template changes — just document the intent. (3) Update the introductory paragraph to mention simple mode as a ceremony option within the task workflow. |
| `core/workflows/types/development-workflow.md` | (1) Add a brief clarifying paragraph at the top of the "Tier-Conditional Workflow Branching" section stating that Patch, Story, and Deep Story are ceremony tiers internal to story-type work, not points on a universal linear spectrum. One paragraph, not a restructure. (2) No changes to the actual tier paths — Patch, Story, Deep Story behavior is unchanged. |
| `integrations/claude-code/CLAUDE.md` | (1) Add a "Work Type Routing" subsection within or after the "Workflow Composition" section. Content: the four backlog types (task, bug, story, epic), the routing question ("What kind of work is this?"), signals for each type, and within-type ceremony assessment (simple/standard for tasks and bugs, patch/story/deep-story for stories, coordination-only for epics). (2) Update the "Development Workflow" summary section to note that story tiers are internal to story-type work. (3) Update the task-workspace agent table description to mention simple mode. |
| `integrations/copilot/copilot-instructions.md` | Same three changes as the CLAUDE.md integration template. |
| `core/Document-Catalog.md` | (1) Add a "Backlog Type Applicability" note to the "Base Documents" section clarifying which document types apply to which backlog types: briefs for tasks and bugs, plans for standard-mode tasks and bugs (not simple mode), story specs for stories, no execution documents for epics (coordination layer). (2) Add a note to the task-workspace Quick Reference that simple-mode tasks produce no plan.md or task folder — the commit message is the documentation artifact. (3) Light touch — no structural reorganization of the catalog (that is CR-22 scope). |
| `VERSION` | Bump from `0.29.0` to `0.30.0` |
| `CHANGELOG.md` | Add 0.30.0 entry (see CHANGELOG Draft below) |

### Deleted files

None.

---

## Integration Point Analysis

| Changed file | References from | Sync required |
|-------------|----------------|---------------|
| `Domain-Language.md` | `integrations/claude-code/CLAUDE.md` (references Domain Language terms), `integrations/copilot/copilot-instructions.md` (same), `core/Document-Catalog.md` (references project types which are being reframed), all agent prompts (use Domain Language vocabulary), `wiki/topics/` (Fabrika wiki articles reference Domain Language) | New terms (backlog type, bug, epic, simple mode, work type routing) must be used consistently in all modified files. Reframed terms (complexity tier, patch, story, deep story, universal complexity spectrum) must use updated framing language everywhere they appear in the modified files. |
| `core/workflows/types/task-workflow.md` | `integrations/claude-code/CLAUDE.md` (Task-based types agent table references task workflow), `integrations/copilot/copilot-instructions.md` (same), `core/Document-Catalog.md` (Base Documents section references task workflow), `core/workflows/protocols/dispatch-protocol.md` (defines dispatch contracts used by task workflow agents), `core/agents/AGENT-CATALOG.md` (maps agents to workflows) | Simple mode changes must be reflected in integration template descriptions of the task workflow. Document-Catalog must note which artifacts simple mode skips. Dispatch protocol is NOT changed — simple mode uses the same contextual dispatch to the implementer, just with the plan embedded in the dispatch context rather than in a file. |
| `core/workflows/types/development-workflow.md` | `integrations/claude-code/CLAUDE.md` (Development Workflow section), `integrations/copilot/copilot-instructions.md` (same), `core/workflows/protocols/sprint-coordination.md` (references tiers), `core/workflows/protocols/dispatch-protocol.md` (tier-conditional dispatch) | Clarifying paragraph only — no behavioral change. Integration templates should use "story-internal tiers" language when describing complexity tiers. Sprint coordination and dispatch protocol are NOT changed (no behavioral change to tiers). |
| `integrations/claude-code/CLAUDE.md` | Consumer projects copy this template. `CLAUDE.md` (Fabrika project — references integration templates in verification checklist). | New Work Type Routing section must match Domain-Language definitions exactly. |
| `integrations/copilot/copilot-instructions.md` | Consumer projects copy this template. | Must stay in sync with CLAUDE.md integration template — same routing logic content. |
| `core/Document-Catalog.md` | `integrations/claude-code/CLAUDE.md` (points to Document-Catalog), `integrations/copilot/copilot-instructions.md` (same), `core/workflows/protocols/doc-triggers.md` (references documents from catalog) | Backlog type applicability notes must be consistent with Domain-Language definitions and task-workflow simple mode behavior. |
| `VERSION` | `CHANGELOG.md` (latest entry version must match), structural-validator checks VERSION matches CHANGELOG | Must match 0.30.0 in CHANGELOG. |
| `CHANGELOG.md` | Consumer projects read CHANGELOG during UPDATE. | Must list every changed file. Consumer update instructions must be complete. |

---

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Terminology inconsistency between Domain-Language and other files | All modified files | Domain-Language redefines the universal complexity spectrum and adds new terms. If integration templates or workflow files use old language ("linear spectrum", "ad-hoc tier", "points on a scale"), the framework sends contradictory signals to orchestrators. |
| 2 | Simple mode described inconsistently across task-workflow and integration templates | `task-workflow.md`, `CLAUDE.md`, `copilot-instructions.md`, `Document-Catalog.md` | If the scope assessment threshold is described differently in the task workflow vs. the integration templates, orchestrators will apply inconsistent judgment. If Document-Catalog doesn't reflect that simple mode skips plan.md, agents may look for artifacts that don't exist. |
| 3 | "Bug" definition in Domain-Language diverges from task-workflow bug section | `Domain-Language.md`, `task-workflow.md` | If Domain-Language says bugs are "tasks with reproduction context" but task-workflow doesn't document what reproduction context means in practice, the definition is hollow. If task-workflow implies bugs need different agents, it contradicts the CR. |
| 4 | Development workflow clarification accidentally changes tier behavior | `development-workflow.md` | Adding a clarifying paragraph to the Tier-Conditional Workflow Branching section must not alter the actual branching logic. If the paragraph is ambiguous, orchestrators may think story tiers changed. |
| 5 | Integration templates diverge from each other | `CLAUDE.md`, `copilot-instructions.md` | CLAUDE.md and copilot-instructions.md must contain the same routing logic content. If one gets updated and the other doesn't, consumers on different tools get different behavior. |
| 6 | Stale "ad-hoc" references remain in files not in scope | Files outside the modified set | Other files (ROADMAP-v2.md, existing CRs, wiki articles) may reference "ad-hoc workflow" or the linear spectrum. These are planning/meta files, not canonical — acceptable as historical references. But if any canonical file outside the modified set uses "ad-hoc" as an active concept, that's a stale reference. |
| 7 | CHANGELOG consumer update instructions incomplete | `CHANGELOG.md` | If the consumer update instructions don't list every file a consumer needs to update, consumers applying the update will have inconsistent frameworks. |

---

## Mitigations

| Risk # | Mitigation |
|--------|-----------|
| 1 | After drafting Domain-Language changes, grep all modified files for: "ad-hoc" (as a tier name), "linear spectrum", "single scale", "6-point", "ad-hoc -> task -> patch". Replace with updated language. Use "backlog type" and "ceremony graduation within types" consistently. |
| 2 | Write the simple mode description in `task-workflow.md` first. Copy the scope assessment threshold language verbatim into integration templates. Document-Catalog references task-workflow for the authoritative definition — it does not restate. |
| 3 | Domain-Language "Bug" definition must include: "A task with reproduction context — observed vs. expected behavior, reproduction steps. Uses the task workflow. Reviewer additionally verifies the fix." Task-workflow "Bug Tasks" section must mirror this language. Cross-check both after drafting. |
| 4 | The development-workflow clarification paragraph must begin with "These tiers are unchanged from 0.29.0" or equivalent language. It must not use conditional language ("may", "should consider") that implies behavioral change. |
| 5 | Write the CLAUDE.md Work Type Routing section first. Copy it verbatim to copilot-instructions.md. Adjust only tool-specific references (e.g., "Claude Code" vs. "the agent"). After drafting both, diff the routing sections to confirm they match. |
| 6 | After all changes, grep canonical files (core/, integrations/, Domain-Language.md, BOOTSTRAP.md, ADOPT.md, UPDATE.md, ADD-WORKFLOW.md, HARVEST.md, MANIFEST_SPEC.md) for "ad-hoc" used as an active concept (not historical reference). Fix any hits. Planning files (planning/) and wiki files are exempt — they are historical. |
| 7 | CHANGELOG consumer update instructions must list every file in the "Modified files" inventory above with specific copy/update instructions per file. Cross-check against the file inventory before finalizing. |

---

## Version Bump Determination

**Bump type:** minor
**New version:** 0.30.0
**Reasoning:** Changes include `core/workflows/types/task-workflow.md`
and `core/workflows/types/development-workflow.md` — both in `core/**`,
which requires a minor bump per the bump rules. Additionally,
`Domain-Language.md` introduces new framework concepts (backlog types,
simple mode, work type routing) which are conceptually significant.
The `integrations/**` changes would only require a patch bump, but
the most impactful change wins — core/** changes dominate.

---

## CHANGELOG Draft

```markdown
## 0.30.0 — Universal backlog types and ceremony graduation

Introduces four universal backlog types (task, bug, story, epic) as
workflow-agnostic categories that replace the linear complexity
spectrum. Ceremony graduates within each type, not across types:
tasks have simple and standard modes, stories have patch/story/deep
story tiers (unchanged from 0.29.0), bugs use the task workflow with
reproduction-context briefs, and epics are a coordination envelope
(mechanics deferred to CR-24). Adds simple task mode to the task
workflow for trivially scoped work where the orchestrator plans inline
and dispatches the implementer directly. The orchestrator's routing
question is now "What kind of work is this?" followed by "How much
ceremony does it need within that kind?"

### Changed files
- `Domain-Language.md` — redefined "Universal complexity spectrum"
  from linear scale to type-based model with internal ceremony
  graduation; added terms: Backlog type, Bug (as backlog type),
  Epic (as backlog type), Simple mode, Work type routing; reframed
  Complexity tier, Patch, Story, Deep Story as story-internal tiers;
  retired "ad-hoc" as active terminology
- `core/workflows/types/task-workflow.md` — added Simple Mode section
  (orchestrator plans inline for trivially scoped work, no task folder
  or plan.md artifact), added Bug Tasks subsection (bugs use task
  workflow with reproduction-context briefs)
- `core/workflows/types/development-workflow.md` — added clarifying
  paragraph that Patch/Story/Deep Story are ceremony tiers internal to
  story-type work, not points on a universal spectrum (no behavioral
  change to tiers)
- `integrations/claude-code/CLAUDE.md` — added Work Type Routing
  subsection (four backlog types, routing question, signals, within-
  type ceremony assessment); updated Development Workflow summary to
  note story-internal tiers; updated task-workspace description to
  mention simple mode
- `integrations/copilot/copilot-instructions.md` — same changes as
  CLAUDE.md integration template
- `core/Document-Catalog.md` — added backlog type applicability notes
  to Base Documents section (which documents apply to which backlog
  types); added simple mode note to task-workspace Quick Reference
  (no plan.md or task folder for simple-mode tasks)

### Consumer update instructions
1. Copy updated `Domain-Language.md` from Fabrika source (redefined
   complexity spectrum, new backlog type terms, retired ad-hoc)
2. Copy updated `core/workflows/types/task-workflow.md` (new Simple
   Mode and Bug Tasks sections)
3. Copy updated `core/workflows/types/development-workflow.md` (new
   clarifying paragraph in Tier-Conditional Workflow Branching — no
   behavioral change)
4. Update your project instruction file (CLAUDE.md or
   copilot-instructions.md) from the integration template — add the
   Work Type Routing subsection and update Development Workflow and
   task-workspace references
5. Copy updated `core/Document-Catalog.md` (backlog type
   applicability notes)
6. Update your project's Domain Language with the new backlog type
   terms if your project maintains its own Domain Language
```

---

## Owner Decision Points

1. **DD-1 through DD-4 (above).** All four design decisions have
   recommendations that align with the CR's own leanings. If the owner
   agrees with all four, no further discussion is needed. If any
   recommendation is rejected, the planner will revise the affected
   file changes.

2. **Work Type Routing placement in integration templates.** The plan
   places it within or after the "Workflow Composition" section. An
   alternative is placing it in the "Development Workflow" summary
   section. The Workflow Composition location is recommended because
   work type routing applies across ALL workflow types (task, sprint,
   agentic), not just development workflow. Owner can override.

3. **"Ad-hoc" retirement language.** The plan retires "ad-hoc" from
   active use with a historical note in Domain-Language. The
   alternative is removing the term entirely. Recommendation: keep
   the historical note so that readers of older CRs and the Phase 2
   roadmap can trace the concept's evolution. The note is one sentence.

4. **Scope of canonical "ad-hoc" grep.** Risk #6 mitigation greps
   canonical files for stale "ad-hoc" references. If hits are found
   in files outside the modified set (e.g., BOOTSTRAP.md, ADOPT.md,
   ADD-WORKFLOW.md), should the implementer fix them in this CR or
   defer? Recommendation: fix them in this CR if they use "ad-hoc"
   as an active concept (not historical/explanatory). Flag any found
   to the owner before changing.

---

## Alignment History

- **v1:** Initial plan. 2026-05-03. No revisions yet.
- **v2:** Owner approved. 2026-05-03. All four design decisions
  accepted as recommended. Owner clarified: routing is primarily for
  unplanned/ad-hoc work that comes in outside sprint planning — sprint-
  planned work already has its type determined. Epic definition
  formalizes what already exists, not a new concept.
