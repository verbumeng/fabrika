# Structural Validation Report: PRD-13 Review-Revise Loop Redesign

**Plan:** `docs/plans/PRD-13-plan.md`
**Version under review:** 0.22.0
**Date:** 2026-05-01

---

## Check 1: All files referenced in the CHANGELOG 0.22.0 entry exist

Every file path listed in the CHANGELOG 0.22.0 entry was checked
against the filesystem.

| File | Status |
|------|--------|
| `core/design-principles.md` | EXISTS |
| `core/workflows/dispatch-protocol.md` | EXISTS |
| `core/workflows/development-workflow.md` | EXISTS |
| `core/workflows/agentic-workflow-lifecycle.md` | EXISTS |
| `core/workflows/analytics-workspace.md` | EXISTS |
| `core/agents/archetypes/implementer.md` | EXISTS |
| `core/agents/context-engineer.md` | EXISTS |
| `core/topologies/Sprint-Contract-Pipeline.md` | EXISTS |
| `core/topologies/Sprint-Contract-Mesh.md` | EXISTS |
| `core/topologies/Sprint-Contract-Hierarchical.md` | EXISTS |
| `integrations/claude-code/CLAUDE.md` | EXISTS |
| `integrations/copilot/copilot-instructions.md` | EXISTS |
| `Domain-Language.md` | EXISTS |
| `wiki/topics/agent-model.md` | EXISTS |
| `wiki/topics/framework-philosophy.md` | EXISTS |
| `wiki/topics/workflow-design.md` | EXISTS |
| `VERSION` | EXISTS |
| `CHANGELOG.md` | EXISTS |
| `MIGRATIONS.md` | EXISTS |

**Result: PASS.** All 19 files exist.

---

## Check 2: AGENT-CATALOG agent file table matches actual files in core/agents/

Compared every filename in the AGENT-CATALOG Agent Files table against
the actual `.md` files in `core/agents/` (excluding AGENT-CATALOG.md
itself).

- Files in catalog but not on disk: none
- Files on disk but not in catalog: none
- 28 agent files match exactly
- 7 archetype files match exactly

The plan explicitly states no AGENT-CATALOG changes were expected
(no new agents, no removed agents). Confirmed.

**Result: PASS.**

---

## Check 3: Document-Catalog Quick Reference

The plan (Risk #8, Mitigation #8) concluded that
`core/design-principles.md` is a framework-level reference document,
not a consumer-created document type, and therefore does not need a
Document-Catalog entry. This matches the treatment of similar
framework-level files (e.g., `Domain-Language.md` at the repo root
is in the Document-Catalog because consumers create their own copy,
but design-principles.md is consumed by reading the archetype, not
as a consumer document type).

No new document types were introduced by PRD-13. The Quick Reference
sections were not expected to change.

**Result: PASS.** No Document-Catalog update needed or expected.

---

## Check 4: doc-triggers table entries reference documents/workflows that exist

Read `core/workflows/doc-triggers.md`. All 32 trigger entries
reference documents, workflows, or templates that exist at the
referenced paths. No new doc-trigger entries were expected from
PRD-13 (no new document types created). Verified that existing
entries reference valid paths.

**Result: PASS.**

---

## Check 5: VERSION file matches the latest CHANGELOG entry version

- VERSION file content: `0.22.0`
- Latest CHANGELOG entry header: `## 0.22.0`

**Result: PASS.** Versions match.

---

## Check 6: Stale "max 2 retries" / "maximum 2" / "2 retry cycles" search

Searched all `.md` files for: `max 2 retries`, `maximum 2`,
`2 retry cycles`, `max 2 cycles`, `max 2`, `2 retry`, `2 retries`,
`2 failed`.

**Hits in core/ and integrations/:** None.

**Hits in Domain-Language.md:** None.

**Hits elsewhere (all acceptable):**

| File | Context | Acceptable? |
|------|---------|-------------|
| `CHANGELOG.md` line 19 | Describes what the old pattern was: "orchestrator-as-translator (max 2 cycles)" | Yes -- historical description of the before-state |
| `CHANGELOG.md` line 80 | Describes the change: "updated from 'rollback protocol (max 2 retries)' to..." | Yes -- quoting the old text being replaced |
| `CHANGELOG.md` line 898 | v0.9.0 entry: "maximum 2 retry cycles" | Yes -- historical CHANGELOG entry, not updated |
| `MIGRATIONS.md` line 11 | 0.22.0 migration: "max 2 cycles" describing the before-state | Yes -- explains what changed |
| `wiki/topics/workflow-design.md` lines 31, 91 | Historical context: "eliminating the split between...max 2 cycles" | Yes -- describing the old pattern that was replaced |
| `docs/plans/PRD-13-plan.md` | Multiple references | Yes -- plan file describing the change |
| `planning/PRD-13-review-revise-loop-redesign.md` | PRD source document | Yes -- the change request itself |

**Result: PASS.** No stale "max 2" language in any file that defines
current behavior. All remaining hits are historical references or
planning documents describing the before-state.

---

## Check 7: Stale "orchestrator synthesizes" / "synthesize findings" / "does NOT forward raw" search

Searched all `.md` files for: `orchestrator synthesizes`,
`synthesize findings`, `synthesizes findings`, `does NOT forward raw`,
`does not read raw evaluation reports`, `summarizes what to fix`,
`orchestrator summarizes`.

**Hits in canonical files (core/, integrations/, Domain-Language.md):**

| File | Line | Text | Assessment |
|------|------|------|------------|
| `integrations/claude-code/CLAUDE.md` line 603 | "it does not synthesize findings" | ACCEPTABLE -- this is the *new* language describing what the orchestrator does NOT do. It says the orchestrator "routes file paths, it does not synthesize findings." This is the correct post-PRD-13 statement. |
| `integrations/copilot/copilot-instructions.md` line 506 | Same as above | ACCEPTABLE -- same correct usage |
| `Domain-Language.md` line 269 | "it does not synthesize findings" | ACCEPTABLE -- same correct usage in updated definition |

**Hits in wiki/:**

| File | Text | Assessment |
|------|------|------------|
| `wiki/topics/workflow-design.md` line 15 | "does not synthesize or interpret findings" | ACCEPTABLE -- describes current behavior |
| `wiki/topics/framework-philosophy.md` line 31 | "does not interpret or synthesize findings" | ACCEPTABLE -- describes current behavior |
| `wiki/topics/framework-philosophy.md` line 45 | "does not synthesize findings" | ACCEPTABLE -- describes current behavior |

**Hits in planning/:**

| File | Assessment |
|------|------------|
| `planning/PRD-13-review-revise-loop-redesign.md` | PRD source -- describes the problem being fixed. Acceptable. |
| `docs/plans/PRD-13-plan.md` | Plan file -- describes the change. Acceptable. |

**Result: PASS.** All hits use the phrase in the correct post-PRD-13
sense ("the orchestrator does NOT synthesize") or are in
planning/historical documents. No file instructs the orchestrator to
synthesize findings.

---

## Check 8: Cross-references between files resolve

Verified that `core/design-principles.md` is cross-referenced from
all files specified in the plan:

| Referencing file | Line | Status |
|------------------|------|--------|
| `core/workflows/dispatch-protocol.md` | 912 | PRESENT |
| `core/workflows/development-workflow.md` | 133 | PRESENT |
| `core/workflows/agentic-workflow-lifecycle.md` | 141 | PRESENT |
| `core/workflows/analytics-workspace.md` | 453 | PRESENT |
| `core/agents/archetypes/implementer.md` | 98, 171 | PRESENT |
| `core/agents/context-engineer.md` | 197 | PRESENT |
| `integrations/claude-code/CLAUDE.md` | 603 | PRESENT |
| `integrations/copilot/copilot-instructions.md` | 506 | PRESENT |
| `Domain-Language.md` | 287, 296 | PRESENT |
| `wiki/topics/agent-model.md` | 87, 109 | PRESENT |
| `wiki/topics/framework-philosophy.md` | 45, 78 | PRESENT |
| `wiki/topics/workflow-design.md` | 31, 91, 140 | PRESENT |

Verified that `Review report paths` conditional field exists in
dispatch contracts for all 5 specialist implementers and the context
engineer:

| Contract | Line | Status |
|----------|------|--------|
| Software Engineer | 600 | PRESENT |
| Data Engineer | 623 | PRESENT |
| Data Analyst | 643 | PRESENT |
| ML Engineer | 667 | PRESENT |
| AI Engineer | 692 | PRESENT |
| Context Engineer | 731 | PRESENT |

**Result: PASS.** All cross-references resolve.

---

## Check 9: Integration templates reflect structural changes

Both integration templates were verified for the three required
updates:

| Change | `CLAUDE.md` | `copilot-instructions.md` |
|--------|-------------|--------------------------|
| "Completing a Story" line updated from "rollback protocol (max 2 retries)" to "review-revise loop (max 3 cycles)" | Line 312: correct | Line 223: correct |
| Reference to `core/design-principles.md` added | Line 603: in Key Constraints | Line 506: in Key Constraints |
| Implementer-reviewer pairing principle stated | Line 603: present | Line 506: present |

**Result: PASS.**

---

## Check 10: Consumer update instructions are complete

Every file a consumer needs to update is listed in the CHANGELOG
0.22.0 Consumer update instructions section:

1. New file: `core/design-principles.md` -- listed (step 1)
2. Core workflow files (4): all listed (step 2)
3. Agent files (2): all listed (step 3)
4. Topology templates (3): all listed (step 4)
5. Integration template: listed (step 5)
6. Domain-Language.md: listed as optional (step 6)
7. Sprint contract guidance: listed (step 7)

Wiki files are correctly marked "no consumer action needed" in the
CHANGELOG and are not listed in consumer update instructions.

MIGRATIONS.md has a complete 0.22.0 entry with behavioral changes
documented.

**Result: PASS.**

---

## Observations (non-blocking)

1. **data-analyst.md line 57** says "Do not wait for
   orchestrator-synthesized fix instructions" -- phrased as if
   orchestrator-synthesized instructions were still a possibility to
   wait for. After PRD-13, there are no orchestrator-synthesized
   instructions for any project type. The plan explicitly scoped this
   file as "no changes expected" and the text is directionally correct
   (it tells the agent to read the review report directly). Minor
   wording drift, not a behavioral issue.

---

## Verdict: PASS

All 10 checks pass. No structural inconsistencies found. The one
observation about data-analyst.md line 57 is cosmetic and non-blocking.
