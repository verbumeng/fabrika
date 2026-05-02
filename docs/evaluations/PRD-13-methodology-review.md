---
type: evaluation
agent: methodology-reviewer
plan: docs/plans/PRD-13-plan.md
version: 0.22.0
created: 2026-05-01
---

# Methodology Review: PRD-13 Review-Revise Loop Redesign

**Reviewer:** methodology-reviewer
**Plan:** `docs/plans/PRD-13-plan.md`
**Version under review:** 0.22.0

---

## Per-Criterion Findings

### 1. All files referenced in the CHANGELOG entry actually exist

**Result: PASS**

Every file path listed in the 0.22.0 CHANGELOG entry was verified to
exist on disk:

- `core/design-principles.md` -- exists (new file)
- `core/workflows/dispatch-protocol.md` -- exists
- `core/workflows/development-workflow.md` -- exists
- `core/workflows/agentic-workflow-lifecycle.md` -- exists
- `core/workflows/analytics-workspace.md` -- exists
- `core/agents/archetypes/implementer.md` -- exists
- `core/agents/context-engineer.md` -- exists
- `core/topologies/Sprint-Contract-Pipeline.md` -- exists
- `core/topologies/Sprint-Contract-Mesh.md` -- exists
- `core/topologies/Sprint-Contract-Hierarchical.md` -- exists
- `integrations/claude-code/CLAUDE.md` -- exists
- `integrations/copilot/copilot-instructions.md` -- exists
- `Domain-Language.md` -- exists
- `wiki/topics/agent-model.md` -- exists
- `wiki/topics/framework-philosophy.md` -- exists
- `wiki/topics/workflow-design.md` -- exists

No missing files.

---

### 2. New agents follow the established archetype structure

**Result: PASS (N/A)**

No new agents were created in this change. The plan explicitly states
that no new agents were added or removed. AGENT-CATALOG was not changed.

---

### 3. AGENT-CATALOG agent file table matches actual files in core/agents/

**Result: PASS**

The AGENT-CATALOG lists 28 agent files (lines 76-104). Glob of
`core/agents/*.md` (excluding AGENT-CATALOG.md itself) returns 28
files. Every file listed in the catalog exists on disk, and every
agent file on disk appears in the catalog. The plan correctly
determined that no AGENT-CATALOG changes were needed.

---

### 4. Document-Catalog Quick Reference sections include any newly added documents

**Result: PASS (N/A)**

The plan assessed this risk (Risk #8, Mitigation #8) and concluded
that `core/design-principles.md` is a framework-level reference
document (analogous to `Domain-Language.md`), not a per-project
document type. It does not belong in the Document-Catalog, which
catalogs consumer-created document types. This reasoning is sound.

---

### 5. doc-triggers table entries reference documents/workflows that exist

**Result: PASS (N/A)**

No changes were made to `core/workflows/doc-triggers.md`. No new
document types were introduced that would require trigger entries.

---

### 6. VERSION file matches the version in the latest CHANGELOG entry

**Result: PASS**

VERSION contains `0.22.0`. The latest CHANGELOG entry is headed
`## 0.22.0`. These match.

---

### 7. No smell test violations

**Result: PASS**

Checked all changed files for:

- Personal names (Notnomo, Hearthen, MNEMOS, Opifex, edw labs,
  VerbumEng): none found in any changed canonical file.
- Tool-specific assumptions: integration templates correctly scope
  tool-specific content to their own files. `core/design-principles.md`
  and workflow files are tool-agnostic.
- Stranger test: all changed files describe universal patterns
  (review-revise loops, pairing principles, cycle caps) that would
  make sense to any consumer project. No personal or product-specific
  context leaks.

---

### 8. Cross-references between files are consistent

**Result: PASS WITH NOTES**

The cross-reference chain for `core/design-principles.md` is well
connected. The following files reference it:

- `core/workflows/dispatch-protocol.md` (line 912) -- references it
  as rationale for the Retry Protocol
- `core/workflows/development-workflow.md` (line 133) -- references
  it in the feedback loop
- `core/workflows/agentic-workflow-lifecycle.md` (line 141) --
  references it in Step 5
- `core/workflows/analytics-workspace.md` (line 453) -- references
  it in the Review-Revise Loop section
- `core/agents/archetypes/implementer.md` (lines 98, 171) --
  references it in revision dispatch and Evaluation Feedback Loop
- `core/agents/context-engineer.md` (line 197) -- references it in
  revision dispatch
- `integrations/claude-code/CLAUDE.md` (line 603) -- references it
  in Key Constraints
- `integrations/copilot/copilot-instructions.md` (line 506) --
  references it in Key Constraints
- `Domain-Language.md` (lines 287, 296) -- references it in term
  definitions
- `wiki/topics/agent-model.md` (line 87) -- references it
- `wiki/topics/framework-philosophy.md` (line 45) -- references it
- `wiki/topics/workflow-design.md` (lines 31, 91, 101) -- references
  it

All references use the correct path `core/design-principles.md` and
the file exists at that path. The new file does not contain outbound
references that would need reciprocal links (it is a standalone
principles document).

**Note 1:** The `Review report paths` field is defined consistently
across all six implementer/context-engineer dispatch contracts in
`dispatch-protocol.md` (lines 600, 623, 643, 667, 692, 731). The
descriptions are consistent -- five use "evaluation reports" (for
implementers) and one uses "verification reports" (for the context
engineer), which is the correct domain-specific distinction.

**Note 2:** The Retry Protocol section in `dispatch-protocol.md`
(lines 906-941) references `core/design-principles.md` and its
pattern matches the descriptions in `development-workflow.md` (steps
10-14), `agentic-workflow-lifecycle.md` (Step 5), and
`analytics-workspace.md` (Review-Revise Loop). All four describe the
same pattern: implementer reads reports directly, all evaluators
re-review, 3-cycle cap, orchestrator diagnosis after cap.

---

### 9. Integration templates reflect new capabilities

**Result: PASS**

Both integration templates were updated:

**CLAUDE.md:**
- Line 312: "review-revise loop (max 3 cycles, implementer reads
  reviews directly -- see `core/design-principles.md`)" -- correct.
- Line 603: Implementer-reviewer pairing added to Key Constraints
  with reference to `core/design-principles.md` -- correct.

**copilot-instructions.md:**
- Line 223: Parallel change to CLAUDE.md line 312 -- correct.
- Line 506: Implementer-reviewer pairing added to Key Constraints
  with reference to `core/design-principles.md` -- correct.

Both templates are consistent with each other and with the underlying
workflow files.

---

### 10. Consumer update instructions are complete

**Result: PASS**

The CHANGELOG's consumer update instructions (lines 110-123) list
7 steps covering:

1. New file: `core/design-principles.md`
2. Core workflow files (4 files)
3. Agent files (2 files)
4. Topology templates (3 files)
5. Integration template (1 file)
6. Domain Language (optional)
7. Active sprint note

Cross-checked against the full file change list in the CHANGELOG:
every file marked as "changed -- consumer projects should update" or
"NEW" appears in the consumer update instructions. The wiki files are
correctly excluded (marked "no consumer action needed"). Domain
Language is marked optional, consistent with its "changed -- optional
update" header. The MIGRATIONS.md entry (lines 7-29) provides more
detailed migration steps including behavioral changes, consistent
with the CHANGELOG.

---

### 11. Dispatch and output contracts are consistent

**Result: PASS**

Checked consistency between:

**Retry Protocol in dispatch-protocol.md (lines 906-941)** vs.
**development-workflow.md (steps 10-14):**
- Both: implementer reads review reports directly via `Review report
  paths` field
- Both: orchestrator does not synthesize or interpret
- Both: all evaluators re-check after revision
- Both: max 3 retry cycles
- Both: orchestrator diagnosis after cap
- Consistent.

**Retry Protocol** vs. **agentic-workflow-lifecycle.md (Step 5):**
- Both: context engineer reads verification reports directly via
  `Review report paths` field
- Both: all three verifiers re-check
- Both: max 3 retry cycles
- Both: orchestrator diagnosis after cap
- Consistent.

**Retry Protocol** vs. **analytics-workspace.md (Review-Revise Loop):**
- Both: implementer reads reviews directly
- Both: mandatory re-review after every revision
- Both: 3-cycle cap with orchestrator diagnosis
- analytics-workspace adds re-review scope for performance-triggered
  revisions (both logic and performance reviewers re-check) -- this
  is an additive specialization, not a contradiction
- Consistent.

**Retry Protocol** vs. **implementer.md archetype (Evaluation
Feedback Loop, lines 162-182):**
- Both: implementer dispatched with original plan + `Review report
  paths`
- Both: reads reports directly, orchestrator does not synthesize
- Both: all evaluators re-check
- Both: max 3 cycles
- Consistent.

**Retry Protocol** vs. **context-engineer.md (Dispatch Contract +
Revision dispatch, lines 179-197):**
- Both: `Review report paths` as conditional field for revision
- Both: context engineer reads reports directly
- Both: orchestrator does not synthesize or interpret
- Consistent.

**Dispatch contracts for all implementers include `Review report
paths`:**
- Software Engineer (line 600): present
- Data Engineer (line 623): present
- Data Analyst (line 643): present
- ML Engineer (line 667): present
- AI Engineer (line 692): present
- Context Engineer (line 731): present
- All 6 contracts have the field. Consistent.

---

### 12. README.md accurately reflects current framework state

**Result: PASS WITH NOTES**

- Agent count: README says "28 specialized agents" (line 7). Actual
  count of agent files (excluding AGENT-CATALOG.md): 28. Correct.
- Project type categories: README lists 8 sprint-based, 1 task-based,
  1 methodology-based = 10 total. Matches AGENT-CATALOG. Correct.
- Feature list: README mentions dispatch protocol, sprint topologies,
  design alignment, domain language, wiki, briefings, graduated
  testing, document catalog, evaluation harness, sprint lifecycle,
  harvest loop, task promotion. These all exist. Correct.
- Workflow description (lines 67-74): describes the workflow at a
  high level without mentioning retry counts or evaluation cycle
  mechanics. No stale content.

**Note 3 (informational, not a deficiency):** The README does not
mention `core/design-principles.md` or the review-revise loop
convergence. This is appropriate -- the README describes capabilities
at a feature level, not implementation details. The plan correctly
determined that the README did not need changes (Mitigation #9).

---

## Additional Mechanical Checks

### Stale "max 2" / "2 retries" references

A global search for patterns `max 2`, `2 retr(y|ies)`, `maximum 2`,
`2 failed`, `2 cycles` across all `.md` files found:

- `CHANGELOG.md` line 898 (v0.9.0 entry): "maximum 2 retry cycles"
  -- this is a historical CHANGELOG entry describing what was
  introduced in v0.9.0. Historical CHANGELOG entries are never
  rewritten. NOT a deficiency.
- `CHANGELOG.md` line 660 (v0.13.0 entry): "max 2 refactor stories
  per review" -- this refers to spiral mitigation for architecture
  reviews, not the retry protocol. NOT a deficiency.
- `CHANGELOG.md` lines 19, 80 and `MIGRATIONS.md` line 11: describe
  what changed FROM (the old pattern) -- these correctly reference
  the old "max 2 cycles" as historical context. NOT a deficiency.
- `docs/plans/PRD-13-plan.md`: references "max 2" in the context of
  describing what the plan will change. NOT a deficiency.
- `wiki/topics/workflow-design.md` lines 31, 91: both describe the
  historical evolution ("replaced the orchestrator-as-translator
  approach," "replacing the split between... max 2 cycles"). These
  are historical narrative, correctly framed as past tense. NOT a
  deficiency.

No stale "max 2" references found in active instructional content.

### Stale "orchestrator synthesizes" references

A global search found:

- `Domain-Language.md` line 269: "it does not synthesize findings"
  -- this is the UPDATED text, confirming the orchestrator does NOT
  synthesize. Correct.
- `core/agents/data-analyst.md` line 57: "Do not wait for
  orchestrator-synthesized fix instructions" -- this tells the
  implementer to NOT wait for synthesis, which is the correct new
  behavior.
- `integrations/claude-code/CLAUDE.md` line 603 and
  `integrations/copilot/copilot-instructions.md` line 506: "it does
  not synthesize findings" -- correct updated language.
- `wiki/topics/framework-philosophy.md` lines 31, 45: "the
  orchestrator routes but does not interpret or synthesize" -- correct
  updated language.
- `core/agents/software-architect.md` line 166 and
  `core/agents/data-architect.md` line 177: "Synthesize findings" --
  this is step 7 in the architect's procedure, telling the architect
  to synthesize its own findings into an assessment report. This is
  about the architect writing its own report, NOT about the
  orchestrator synthesizing for the implementer. NOT a deficiency.
- `planning/PRD-13-review-revise-loop-redesign.md` line 18: describes
  the old pattern being replaced. This is the change request source
  document. NOT a deficiency.

No stale "orchestrator synthesizes" language found in active
instructional content.

---

## Findings Summary

### Notes (non-blocking)

**Note 1 (workflow-design.md Current State version tag):**
`wiki/topics/workflow-design.md` line 41 says "As of v0.19.0" but
the file was updated with v0.22.0 content (review-revise loop
convergence in the Key Decisions section, resolved open questions,
updated Sources). The Current State section itself includes the
updated review-revise loop description ("implementer reads reviews
directly, all evaluators re-review, max 3 cycles with orchestrator
diagnosis" at line 48) but the version header was not bumped from
v0.19.0 to v0.22.0. Similarly, `agent-model.md` says "As of v0.20.0"
(line 43) and `framework-philosophy.md` says "As of v0.20.0"
(line 35). The agent-model and framework-philosophy Current State
sections do contain updated v0.22.0 content (implementer-reviewer
pairing paragraph in framework-philosophy line 45, retry protocol in
agent-model line 73), but the version headers were not bumped.

This is cosmetic -- the content is correct and current, but the "As
of vX.Y.Z" labels are stale. A reader might think the Current State
predates PRD-13 when it actually includes PRD-13 changes.

**Note 2 (framework-philosophy.md versioning discipline count):**
`wiki/topics/framework-philosophy.md` line 47 says "21 releases from
v0.1.0 through v0.20.0." With v0.21.0 and v0.22.0 now shipped, this
count and range are stale. Should read "23 releases from v0.1.0
through v0.22.0" (or whatever the accurate count is). This is a minor
factual inaccuracy in wiki content.

**Note 3 (data-analyst.md revision mode wording):** The data-analyst
revision mode (lines 55-59) says "Do not wait for
orchestrator-synthesized fix instructions -- read the review report
yourself." While the meaning is correct (tells the implementer to
read directly), the phrasing differs from the universal pattern
language used in the implementer archetype and other files, which
frame it positively ("the orchestrator routes file paths, it does not
synthesize") rather than as a negative instruction ("do not wait
for"). The plan identified this file as "no changes expected" and the
wording is functionally correct, so this is informational only.

---

## Verdict

**PASS WITH NOTES**

The implementation is consistent, complete, and follows the
methodology patterns. All files referenced in the CHANGELOG exist.
The VERSION matches the CHANGELOG. Cross-references are consistent
and bidirectional where expected. Dispatch and output contracts are
aligned across all workflow files, agent prompts, and specialist
contracts. Consumer update instructions are complete. Integration
templates are updated in parallel. No smell test violations.

The three notes are cosmetic: stale "As of vX.Y.Z" version headers
in three wiki topic articles, a stale release count in
framework-philosophy.md, and a minor wording style difference in
data-analyst.md. None affect correctness or create operational risk
for an orchestrator following these files.
