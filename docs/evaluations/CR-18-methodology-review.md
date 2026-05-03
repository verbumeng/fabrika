# CR-18 Methodology Review — Universal Complexity Tiers

**Verdict: PASS WITH NOTES**

**Reviewer:** methodology-reviewer agent
**Plan:** `docs/plans/CR-18-plan.md`
**CHANGELOG entry:** 0.29.0 in `CHANGELOG.md`
**Date:** 2026-05-03

---

## 1. Cross-Reference Consistency

**Assessment: PASS WITH NOTES**

All primary cross-references are consistent:

- `core/workflows/types/development-workflow.md` references
  `core/workflows/protocols/sprint-coordination.md` for tier
  assignment, and sprint-coordination references back to
  development-workflow for the tier branching logic. Both files exist
  and the references are bidirectional.
- `core/workflows/protocols/dispatch-protocol.md` Tier-Conditional
  Dispatch section (lines 64-122) aligns with development-workflow's
  three paths. Agent invocation tables match: Patch skips planner and
  architect; Story follows existing gates; Deep Story mandates
  architect at both design and review.
- Sprint contract templates (Pipeline line 16, Mesh lines 24/45,
  Hierarchical lines 41/59) all include `Complexity tier` field and
  reference `core/workflows/types/development-workflow.md`
  (Tier-Conditional Workflow Branching) in their Tier-Conditional
  Gates sections.
- Integration templates (CLAUDE.md line 328, copilot-instructions.md
  line 237) both include identical Complexity Tiers summaries pointing
  to `[FABRIKA_PATH]/core/workflows/types/development-workflow.md`.
- Domain-Language.md defines all six new terms (Complexity tier, Patch,
  Story, Deep Story, Universal complexity spectrum, Tier promotion)
  with correct cross-references to each other and to version 0.29.0.
- Retry cap numbers are consistent across all three authoritative
  documents: Patch = 2 cycles (development-workflow.md lines 68, 273;
  dispatch-protocol.md line 84; Sprint-Contract-Pipeline.md line 59),
  Story/Deep Story = 3 cycles (development-workflow.md line 265;
  dispatch-protocol.md lines 98, 112).

**Notes:**

1. **Stale references in wiki and MIGRATIONS not fixed.** The plan's
   "Additional Scope" section (lines 700-716) explicitly scoped fixing
   stale `agentic-workflow-lifecycle` references in
   `wiki/topics/workflow-design.md` and `MIGRATIONS.md`. These files
   were NOT modified. `wiki/topics/workflow-design.md` line 167 still
   references `agentic-workflow-lifecycle.md`. `MIGRATIONS.md` contains
   11 stale references to `agentic-workflow-lifecycle.md` (lines 15,
   22, 45, 156, 216, 259, 287, 355). The CHANGELOG entry mentions the
   integration template header fix but does not list these two files in
   the changed files section — they were dropped from execution despite
   being in the approved plan.

2. **`[TICKET]-research.md` lacks its own Document Catalog entry.** The
   plan's Risk #4 identified this gap and the mitigation stated "Add
   `[TICKET]-research.md` as a new entry in Document Catalog under
   `plans/`." However, the plan's change spec (section 7) only added a
   tier note inline to the existing `[TICKET]-spec.md` entry (line
   730). The research document is a distinct artifact type (produced by
   the orchestrator, not the planner; Deep Story tier only; separate
   creation trigger) and warrants its own catalog entry with Purpose,
   Types, Tier, and Audience markers. This is a plan-spec gap that
   carried through to execution — the implementation correctly followed
   the change spec, but the change spec was incomplete relative to its
   own risk mitigations.

---

## 2. Prompt Pattern Adherence

**Assessment: PASS**

No tier-specific routing logic leaked into agent prompts. A search of
all files in `core/agents/` for "patch", "tier", "deep-story", and
"deep story" found only pre-existing references to `model_tier`
(token estimation metadata) and generic `dispatch` contract references.
No agent prompt contains conditional logic based on complexity tiers.

The design principle is correctly maintained: agents are tier-unaware.
The orchestrator handles all tier routing via the development workflow
and dispatch protocol. The scrum-master learns about tier assignment
from `sprint-coordination.md` (which it already reads during planning),
not from its own prompt.

---

## 3. Instruction Decomposition Quality

**Assessment: PASS**

The Tier-Conditional Workflow Branching section in
`development-workflow.md` (lines 31-146) is well-sized at
approximately 115 lines. It sits logically between the Dispatch
Protocol reference and "Starting a Story," which is the correct
reading order for an orchestrator entering a story chat. Each path
(Patch, Story, Deep Story) is clearly delineated with its own
subsection and step numbering.

The Tier-Conditional Dispatch section in `dispatch-protocol.md`
(lines 64-122) is a clean additive section with per-tier agent
invocation tables. It correctly notes the orthogonality between
tier-conditional dispatch (WHICH agents) and dispatch tiers (HOW
agents are dispatched).

The tier assignment guidance in `sprint-coordination.md` (lines 47-60)
is appropriately placed after the Sprint Planning chat description,
keeping it in the scrum-master's reading path.

Cross-references in "Starting a Story" (line 156-157) and "Completing
a Story" (lines 243-244, 273-274) are brief pointers, not duplicated
content. This follows the context decomposition principle.

---

## 4. Smell Test Compliance

**Assessment: PASS**

No personal, product-specific, or tool-specific assumptions detected:

- No references to LifeOS, Obsidian, Motion, or PARA
- No downstream product names (Notnomo, Hearthen, MNEMOS, Opifex, edw
  labs, VerbumEng)
- Point thresholds (1-2, 3-5, 8-13) are presented as defaults with
  owner override, not as assumptions about any specific project
- Tier assignment criteria use generic signals (story points, scope
  indicators, owner override)
- The universal complexity spectrum definition in Domain-Language.md
  references future CRs (17, 19, 24) by number, which is acceptable
  for framework-internal cross-referencing

The changes would make sense to a stranger cloning the repo for a
greenfield project.

---

## 5. Consumer Update Completeness

**Assessment: PASS**

The CHANGELOG's consumer update instructions (9 steps) cover every
file a consumer needs to update:

1. development-workflow.md -- new section + cross-references
2. sprint-coordination.md -- tier assignment guidance
3. Story-Template.md -- new frontmatter field
4. Sprint contract templates (all three) -- tier field + gates section
5. Document-Catalog.md -- tier notes
6. dispatch-protocol.md -- tier-conditional dispatch section
7. Integration template update -- tier summary
8. Domain Language update -- new definitions
9. Existing story files -- add `tier: story` default

Step 9 (adding `tier` field to existing stories) correctly addresses
legacy story compatibility. The default-to-Story fallback in
development-workflow.md (line 37) provides a safety net for stories
that are not immediately updated.

---

## 6. Dispatch/Output Contract Consistency

**Assessment: PASS**

The Tier-Conditional Dispatch section in `dispatch-protocol.md`
(lines 64-122) is fully consistent with the workflow documentation in
`development-workflow.md`:

- **Patch tier:** dispatch-protocol says planner (planning mode) = No,
  implementer = Yes, code-reviewer = Yes, test-writer = No (with
  sprint contract exception), planner (validation mode) = No, both
  architects = No. This matches the Patch Path in development-workflow
  (lines 39-77): "No planner validation. No test-writer verification
  (unless the sprint contract's testing strategy mandates it). No
  architect review."

- **Story tier:** dispatch-protocol says all agents invoked, architects
  optional. This matches the Story Path ("Follow Starting a Story and
  Completing a Story below with no modifications").

- **Deep Story tier:** dispatch-protocol says architects are
  **Mandatory**. This matches Deep Story Path steps 5 and 8 ("This is
  NOT optional for Deep Stories").

- **Research document field:** dispatch-protocol adds a conditional
  field for Deep Story planner dispatch (lines 114-121). This matches
  Deep Story Path step 2 ("plus the research document path as an
  additional contextual field").

The per-agent contracts in the dispatch protocol's Per-Agent Dispatch
Contracts section are unchanged, which is correct — tier-conditional
dispatch controls WHICH agents are invoked, not HOW they are invoked.
Each dispatched agent still receives its standard payload.

---

## Summary of Findings

### Issues requiring action

1. **Plan scope not fully executed: wiki and MIGRATIONS stale
   references.** The approved plan's Additional Scope section (lines
   700-716) included fixing stale `agentic-workflow-lifecycle`
   references in `wiki/topics/workflow-design.md` and `MIGRATIONS.md`.
   These changes were not implemented. Fix: apply the stale reference
   cleanup to both files and add them to the CHANGELOG's changed files
   list, or explicitly defer the cleanup to a follow-up patch with a
   documented reason.

2. **Missing Document Catalog entry for `[TICKET]-research.md`.** The
   plan's Risk #4 mitigation called for a separate entry. The change
   spec only appended a note to the spec entry. Fix: add a dedicated
   catalog entry under `plans/` for `[TICKET]-research.md` with
   purpose, types (all sprint-based), tier (Deep Story only), and
   audience (both).

### Observations (non-blocking)

- The README does not mention complexity tiers as a feature. This is a
  reasonable omission for an overview document, but could be added as a
  sub-bullet under the "sprint lifecycle" or "graduated testing" items
  in a future README update. Not a checklist violation since the README
  checklist item concerns "current framework state" and the tiers are
  an internal workflow mechanism, not a top-level feature.

- The CHANGELOG entry correctly documents the stale header fix in the
  integration templates (lines 44-48), which was part of the plan's
  Additional Scope. This partial execution (integration templates
  fixed, wiki/MIGRATIONS not fixed) suggests the implementer covered
  the files that were already being touched for the primary scope but
  missed the Additional Scope files that required separate edits.
