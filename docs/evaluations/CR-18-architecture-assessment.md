---
type: architecture-assessment
change-request: planning/CR-18-complexity-tiers-sprint-work.md
plan: docs/plans/CR-18-plan.md
verdict: CONCERNS
created: 2026-05-03
---

# CR-18 Architecture Assessment: Universal Complexity Tiers

**Verdict: CONCERNS**

The structural design is fundamentally sound. The tier system is
correctly distributed across the right files, uses clean pointers, and
keeps integration templates lean. Two concerns warrant attention before
shipping: a missing standalone catalog entry for the research document
artifact, and the development-workflow.md Tier-Conditional Workflow
Branching section exceeding the context decomposition threshold at
approximately 120 lines of dense instructional content.

---

## 1. Instruction Decomposition

**Finding: CONCERN — the Tier-Conditional Workflow Branching section
exceeds the decomposition threshold.**

The new section in `core/workflows/types/development-workflow.md`
(lines 31-146) is approximately 116 lines of dense procedural content
containing three complete execution paths (Patch: 22 steps, Deep
Story: 9 steps, plus tier promotion rules). The context decomposition
principle in CLAUDE.md says to extract when a section exceeds roughly
30-50 lines of instructional content.

This section does triple duty: it defines three distinct execution
paths (Patch, Story, Deep Story), specifies promotion rules, and
documents demotion policy. A reader working on a Patch does not need
the Deep Story path in their context window.

However, there is an argument for keeping the section together: the
orchestrator needs to see all three paths in one place to make the
routing decision, and the tier promotion rules reference behavior
across tiers. Splitting would create three files for what is
conceptually one decision tree.

**Recommendation:** This is a judgment call for the owner. The current
design is functional and not broken, but it stretches the
decomposition principle. If context budget pressure emerges in
consumer projects (orchestrator context windows filling up), the
natural split point would be extracting the three paths into
`core/workflows/protocols/tier-paths.md` and leaving a routing table
plus pointer in development-workflow.md. Not urgent, but worth
tracking.

The Tier-Conditional Dispatch section in
`core/workflows/protocols/dispatch-protocol.md` (lines 64-122) is
approximately 58 lines — at the upper bound but acceptable given that
the three per-tier tables are structured reference data (tables), not
prose instructions. An orchestrator can scan a table faster than it
can parse 58 lines of prose.

---

## 2. Pointer Pattern Cleanliness

**Finding: SOUND.**

The implementation consistently uses clean pointers rather than
duplicating content:

- **Sprint coordination -> development workflow.** The tier assignment
  section in `core/workflows/protocols/sprint-coordination.md`
  (lines 47-60) adds tier assignment guidance to sprint planning and
  ends with a pointer: "see
  `core/workflows/types/development-workflow.md`, Tier-Conditional
  Workflow Branching." Assignment logic is in sprint-coordination;
  routing logic is in development-workflow. No duplication.

- **Sprint contract templates -> development workflow.** All three
  topology templates
  (`core/topologies/Sprint-Contract-Pipeline.md` lines 52-64,
  `Sprint-Contract-Mesh.md` lines 76-83,
  `Sprint-Contract-Hierarchical.md` lines 94-101) add
  Tier-Conditional Gates sections that point to development-workflow.md
  for the full specification. The Pipeline template includes a brief
  per-tier summary (Patch/Story/Deep Story behavior in 3 bullet
  points) while Mesh and Hierarchical just point. The Pipeline summary
  is appropriate because Pipeline is a single-story template where
  the tier gates map directly to its three stages.

- **Dispatch protocol -> development workflow.** The Tier-Conditional
  Dispatch section in dispatch-protocol.md is additive and
  self-contained. It references development-workflow.md indirectly
  through the established dispatch contract structure but does not
  duplicate the execution paths. The distinction is clear:
  development-workflow.md says WHAT happens at each tier,
  dispatch-protocol.md says WHICH AGENTS get invoked.

- **Development workflow internal cross-references.** The existing
  "Starting a Story" step 7 (line 156-157) and "Completing a Story"
  step 8 (lines 243-244) and step 14 (lines 273-274) all add
  back-references to the Tier-Conditional Workflow Branching section
  using "see above" language. These are clean intra-file pointers.

---

## 3. Context Budget Balance

**Finding: SOUND.**

The integration templates (`integrations/claude-code/CLAUDE.md`
lines 328-336, `integrations/copilot/copilot-instructions.md`
lines 237-245) add identical 7-line summaries of the tier system to
the Development Workflow section. The summaries are appropriately
brief for always-loaded context:

- Names the three tiers
- States the key behavioral difference of each (one sentence each)
- States how the orchestrator reads the tier
- Points to development-workflow.md for the full specification

The summaries do not duplicate the execution paths, agent invocation
tables, promotion rules, or retry caps. An orchestrator reading only
the integration template knows the tier system exists, knows to read
the `tier` frontmatter field, and knows where to find the full
specification. This is exactly the right level of detail for
always-loaded context.

The Domain Language entries (6 new terms, approximately 56 lines in
`Domain-Language.md` lines 331-386) are more detailed than the
integration template summaries, which is appropriate — Domain Language
is loaded on demand, not always-loaded. The entries provide the
conceptual definitions that the integration template summaries
reference.

---

## 4. Pattern Consistency

**Finding: SOUND with one minor note.**

- **Dispatch section pattern.** The new Tier-Conditional Dispatch
  section in `core/workflows/protocols/dispatch-protocol.md`
  (lines 64-122) follows the same structural pattern as the existing
  Lightweight Dispatch section (lines 35-61): a concept introduction,
  followed by conditions/tables, followed by behavioral notes. The
  section is placed between Lightweight Dispatch and Per-Agent
  Dispatch Contracts, which is the right location — it controls
  WHICH agents are dispatched (between the HOW tiers and the
  per-agent details). The plan's specification that "tier-conditional
  dispatch is orthogonal to dispatch tiers (strict vs. contextual)"
  is stated explicitly in the section header paragraph, preventing
  confusion between the two "tier" concepts.

- **Domain Language term format.** The six new entries follow the
  established format: bold term name, em-dash, definition paragraph,
  cross-references to related terms using bold text, version
  attribution in brackets. The terms reference each other correctly
  (Patch -> Story promotion, Deep Story -> compaction, Universal
  complexity spectrum -> CR cross-references).

- **Story Template frontmatter.** The `tier` field in
  `core/templates/Story-Template.md` (line 10) follows the
  established pattern of other frontmatter fields: Templater prompt
  with a descriptive label and default value. The default is `story`,
  which matches the development-workflow.md fallback ("If no tier is
  set, default to Story").

- **Sprint contract tier field placement.** The `tier` field is placed
  after the testing approach field in all three topology templates,
  which is consistent — both are per-story metadata assigned during
  sprint planning. The Pipeline template places it in the Overview
  section (appropriate for a single-story template); the Mesh and
  Hierarchical templates place it per story section (appropriate for
  multi-story templates).

- **Minor note:** The term "Tier" is overloaded in Fabrika's
  vocabulary. It already means (a) dispatch tier (strict vs.
  contextual), (b) analytics workspace data tier (Tier 1 vs. Tier 2),
  (c) document tier (Tier 1/2/3/4), (d) adoption tier (Tier 1/2/3),
  and now (e) complexity tier (patch/story/deep-story). The plan
  mitigates this by always qualifying — "complexity tier" not just
  "tier" — and the dispatch protocol section explicitly calls out the
  orthogonality between "dispatch tiers" and "complexity tiers." The
  Domain Language entry for "Complexity tier" also distinguishes from
  "Tier (analytics workspace)" which has its own existing entry. This
  is adequate mitigation but worth monitoring for confusion in
  consumer projects.

---

## 5. Integration Surface Completeness

**Finding: CONCERN — the research document artifact needs a
standalone Document Catalog entry.**

The integration surface is otherwise complete. Every file where
tiers are relevant has been connected:

| Integration point | Connected? | Notes |
|-------------------|-----------|-------|
| Development workflow (routing logic) | Yes | Lines 31-146 |
| Sprint coordination (tier assignment) | Yes | Lines 47-60 |
| Story template (frontmatter field) | Yes | Line 10 |
| Sprint contracts (all 3 topologies) | Yes | Tier field + Gates section |
| Dispatch protocol (agent invocation) | Yes | Lines 64-122 |
| Document Catalog (artifact rules) | Yes | evaluations/ tier note (lines 700-709), plans/ tier note (line 730) |
| Integration templates (both) | Yes | 7-line summary |
| Domain Language | Yes | 6 terms |
| CHANGELOG | Yes | Full entry with consumer instructions |
| VERSION | Yes | 0.29.0 |

**Concern: research document not independently cataloged.** The
`[TICKET]-research.md` artifact introduced by Deep Story tier is
mentioned only as a note appended to the `[TICKET]-spec.md` entry
in Document Catalog (line 730). It does not have its own standalone
catalog entry under `plans/`.

The plan's Risk #4 identified this exact issue: "Deep Story research
document path not referenced in Document Catalog." The mitigation
(plan section "Mitigations," Risk #4) says to "Add
`[TICKET]-research.md` as a new entry in Document Catalog under
`plans/` with a note that it is Deep Story tier only." However, the
Detailed Change Specification for Document Catalog (plan section 7)
only specifies appending a tier note to the existing `[TICKET]-spec.md`
entry. The mitigation and the change spec are inconsistent, and the
implementation followed the change spec (no standalone entry), not
the mitigation.

This matters because:
- An agent bootstrapping or adopting a project reads Document Catalog
  entries to understand which documents exist. A research document
  buried in another entry's notes is easy to miss.
- The development-workflow.md Deep Story path (line 99) specifies the
  research document as a distinct artifact at a specific path. The
  dispatch protocol (line 121) specifies it as a conditional field
  in the planner dispatch. These references imply a first-class
  document, not a footnote.

**Recommendation:** Add a standalone `### [TICKET]-research.md` entry
under `## plans/` in Document Catalog with purpose, types (sprint-based,
Deep Story tier only), tier, and audience. The existing note in the
spec entry should remain as a cross-reference.

---

## Additional Scope Check: Stale Header Cleanup

The plan's Additional Scope section specified cleaning up stale
"Agentic-Workflow Lifecycle" headers in integration templates, wiki,
and MIGRATIONS.md. Status:

- **Integration templates:** Both headers now read "Agentic Workflow"
  (verified at `integrations/claude-code/CLAUDE.md` line 363,
  `integrations/copilot/copilot-instructions.md` line 272). Clean.

- **Wiki:** `wiki/topics/workflow-design.md` line 43 still contains
  the string `agentic-workflow-lifecycle.md` in the body text of the
  v0.27.0 entry. However, this is historical narrative text describing
  the rename that happened in v0.27.0 — it is not a stale reference
  to a file that no longer exists. Line 167 similarly documents the
  rename. These are appropriate historical references, not stale
  pointers.

- **MIGRATIONS.md:** Contains `agentic-workflow-lifecycle` references
  at lines 15, 22, 45, 156, 216, 259, 287, 355. These are all in
  historical migration entries for versions 0.12.0 through 0.16.0
  where consumers were instructed to update files that were named
  `agentic-workflow-lifecycle.md` at the time of those versions. These
  are correct historical instructions — renaming them would make old
  migration instructions incorrect for consumers running sequential
  upgrades. The plan may have intended to check these, but no fix is
  needed.

- **CHANGELOG:** The 0.29.0 entry correctly documents the stale header
  fix alongside the tier system changes (lines 44-45, 47-48).

---

## Summary

| Criterion | Verdict | Key finding |
|-----------|---------|-------------|
| Instruction decomposition | Concern | Tier-Conditional Workflow Branching section is ~116 lines of procedural content, exceeding the 30-50 line guideline. Functional but stretches the principle. |
| Pointer pattern cleanliness | Sound | All cross-references use clean pointers. No content duplication between files. |
| Context budget balance | Sound | Integration template summaries are appropriately brief (7 lines) for always-loaded context. On-demand files carry the detail. |
| Pattern consistency | Sound | New sections follow established patterns. "Tier" overloading is mitigated by consistent qualification. |
| Integration surface completeness | Concern | Research document (`[TICKET]-research.md`) needs a standalone Document Catalog entry, not just a note appended to the spec entry. |

Neither concern is structural unsoundness — the tier system will
function correctly as implemented. The decomposition concern is a
judgment call on when to extract; the catalog concern is a gap between
the plan's mitigation section and its change spec that resulted in an
artifact being under-documented.
