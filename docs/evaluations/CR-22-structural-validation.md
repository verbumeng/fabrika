---
type: change-verification-report
change-request: planning/CR-22-agents-as-composable-skills.md
plan: docs/plans/CR-22-plan.md
version: 0.32.0
verdict: FAIL
date: 2026-05-04
agent: structural-validator
---

# CR-22 Structural Validation

**Verdict: FAIL** — 4 of 10 checks failed. The core structural work
(dispatch decomposition, domain workflow files, story-execution
extraction, development-workflow deletion, agent prompt updates) is
clean. The failures are all incomplete rename/dissolution passes in
BOOTSTRAP.md, integration templates (CLAUDE.md), Document-Catalog.md,
README.md, and MANIFEST_SPEC.md.

---

## Check 1: File Existence

**Result: PASS**

Every file referenced in the CHANGELOG 0.32.0 entry exists at the
stated path. Verified all 49 files (7 new dispatch contracts, 7 new
domain workflows, 1 new story-execution protocol, 14 updated agent
prompts, 10 updated protocol files, 6 framework-level files, 2
integration templates, VERSION, CHANGELOG, MIGRATIONS). The deleted
file `core/workflows/types/development-workflow.md` does not exist on
disk (confirmed deleted). The renamed files
`core/workflows/types/analytics-workspace.md` and
`core/workflows/protocols/analytics-onboarding.md` do not exist on
disk (confirmed renamed).

---

## Check 2: VERSION Match

**Result: PASS**

VERSION file contains `0.32.0`. CHANGELOG latest entry header is
`## 0.32.0 — Agents as composable skills; category dissolution`.
Match confirmed.

---

## Check 3: AGENT-CATALOG Match

**Result: PASS (minor note)**

The Agent Files table in `core/agents/AGENT-CATALOG.md` lists 32
agent files. There are 32 agent `.md` files on disk in
`core/agents/` (excluding `AGENT-CATALOG.md` and
`agent-frontmatter-spec.md`). Every file in the table has a
corresponding file on disk and vice versa.

**Note:** The base agents (planner.md, implementer.md, reviewer.md,
validator.md) list their "Used by" as `task-workspace (base agent)`.
The project type name `task-workspace` is the correct project type
identifier (not a category label), so this is acceptable. However,
this is worth flagging for consistency awareness since the analytics
workflow type was renamed from `analytics-workspace` to
`analytics workflow` (concept) while `analytics-workflow.md` (file).
The task-workspace project type name was NOT renamed in this CR, so
`task-workspace` in the Used-by column is correct.

---

## Check 4: Cross-Reference Resolution

**Result: PASS**

Verified cross-references in the changed files:

- All 7 domain workflow files reference
  `core/workflows/protocols/story-execution.md` — file exists
- story-execution.md lists all 7 domain workflow file paths — all
  exist
- dispatch-protocol.md hub references 7 dispatch sub-files via
  relative links — all exist
- Each dispatch sub-file back-references the hub — path is correct
- AGENT-CATALOG references `core/agents/archetypes/` and
  `core/agents/agent-frontmatter-spec.md` — both exist
- AGENT-CATALOG references
  `core/workflows/protocols/dispatch-protocol.md` — exists
- No live references to the deleted
  `core/workflows/types/development-workflow.md` found in any
  changed file (the grep hit in story-execution.md was a false
  positive: `software-development-workflow.md` contains the
  substring but is a different file)

---

## Check 5: Category Dissolution Grep

**Result: FAIL**

Searched all changed files for "sprint-based types", "task-based
types", "methodology-based types" (case-insensitive). Zero matches
required.

**Violations found (3):**

1. `BOOTSTRAP.md` line 295: references "Sprint-Based Types and
   Task-Based Types mapping tables" in the agent installation
   instructions
2. `BOOTSTRAP.md` line 675: `> **Sprint-based types only.** Skip
   this phase for \`analytics-workspace\`.`
3. `integrations/claude-code/CLAUDE.md` line 548: section header
   `### Task-based types (task-workspace) — Base Workflow`

The `core/` directory is clean — zero matches. CHANGELOG and
MIGRATIONS historical entries contain the terms (allowed).
Planning files and wiki files contain the terms (not changed
files, allowed). The violations are in BOOTSTRAP.md and the
CLAUDE.md integration template.

---

## Check 6: analytics-workspace Grep

**Result: FAIL**

Searched all repo files for "analytics-workspace". Only allowed in
CHANGELOG historical entries and MIGRATIONS notes.

**Violations found in changed files:**

**BOOTSTRAP.md** (11 occurrences, lines 71, 79, 141, 175, 190, 246,
491, 501, 505, 584, 600):
- Line 71: type alignment table still lists `analytics-workspace`
- Line 79: explanation text says "For `analytics-workspace`"
- Line 141: "For analytics workflow (`analytics-workspace`)" — mixed
  naming
- Line 175: "For `analytics-workspace`"
- Line 190: "project type is `analytics-workspace`"
- Line 246: branch point routing says `analytics-workspace`
- Line 491: Phase 2W header says "(analytics-workspace only)"
- Lines 501, 505: copy instructions set project type to
  `analytics-workspace`
- Line 584: STATUS.md sets "Project type: analytics-workspace"
- Line 600: Design Alignment section says "for
  analytics-workspace"

**integrations/claude-code/CLAUDE.md** (3 occurrences):
- Line 11: Project Type enum lists `analytics-workspace`
- Line 109: verification method table lists `analytics-workspace`
- Line 387: section header "Analytics Workflow
  (analytics-workspace type only)"

**README.md** (1 occurrence):
- Line 49: workflow types table lists `analytics-workspace`

**MANIFEST_SPEC.md** (1 occurrence):
- Line 39: project_type field description lists
  `analytics-workspace`

**core/Document-Catalog.md** (3 occurrences):
- Lines 577, 583, 589: notes say "Analytics-workspace extends..."

**Allowed matches (not violations):**
- CHANGELOG.md: historical entries (pre-0.32.0)
- MIGRATIONS.md: migration notes explaining the rename
- planning/ files: not changed files
- wiki/ files: not changed files
- .claude/worktrees/: worktree copies (not main branch)
- Domain-Language.md lines 263, 842: appear to be historical notes
  about the rename — need verification

---

## Check 7: development-workflow.md Grep

**Result: PASS**

Searched all repo files (excluding CHANGELOG, MIGRATIONS, planning,
docs/plans, docs/evaluations, wiki, .claude/worktrees) for live
references to `development-workflow.md`. Zero live references found.

The only match in `core/` was `story-execution.md` line 12 which
references `software-development-workflow.md` — a different file
(the grep pattern matched the substring). All references to the
deleted file have been updated.

---

## Check 8: Dispatch Contract Completeness

**Result: PASS**

Every agent in the AGENT-CATALOG Agent Files table has a dispatch
contract in exactly one decomposed dispatch file. Verified by
cross-referencing:

| Agent | Dispatch file | Contract sections |
|-------|--------------|-------------------|
| product-manager | planner-contracts.md | Planning + Validation |
| experiment-planner | planner-contracts.md | Planning + Validation |
| api-designer | planner-contracts.md | Planning + Validation |
| analysis-planner | planner-contracts.md | Planning + Validation |
| planner (base) | planner-contracts.md | Planning + Validation |
| workflow-planner | planner-contracts.md | Planning |
| code-reviewer | reviewer-contracts.md | Yes |
| logic-reviewer | reviewer-contracts.md | Yes |
| prompt-reviewer | reviewer-contracts.md | Yes |
| security-reviewer | reviewer-contracts.md | Yes |
| performance-reviewer | reviewer-contracts.md | Domain + Analytics |
| reviewer (base) | reviewer-contracts.md | Yes |
| methodology-reviewer | reviewer-contracts.md | Yes |
| test-writer | validator-contracts.md | Spec-first + Coverage |
| data-quality-engineer | validator-contracts.md | Yes |
| model-evaluator | validator-contracts.md | Yes |
| eval-engineer | validator-contracts.md | Yes |
| data-validator | validator-contracts.md | Yes |
| validator (base) | validator-contracts.md | Yes |
| structural-validator | validator-contracts.md | Yes |
| software-engineer | implementer-contracts.md | Yes |
| data-engineer | implementer-contracts.md | Yes |
| data-analyst | implementer-contracts.md | Yes (+ modes) |
| ml-engineer | implementer-contracts.md | Yes |
| ai-engineer | implementer-contracts.md | Yes |
| implementer (base) | implementer-contracts.md | Yes |
| agentic-engineer | implementer-contracts.md | Yes |
| software-architect | architect-contracts.md | Design + Review + Ad hoc |
| data-architect | architect-contracts.md | Design + Review + Ad hoc |
| context-architect | architect-contracts.md | Yes |
| scrum-master | coordinator-contracts.md | Sprint Planning + Retro |
| visualization-designer | designer-contracts.md | Design + Review |

All 32 agents covered. The dispatch-protocol.md hub Per-Agent
Contracts table correctly maps each archetype to its contract file
and lists the agents covered.

---

## Check 9: Domain Workflow Completeness

**Result: PASS**

Each of the 7 domain workflow files has all required structural
elements:

| Domain Workflow | Header | Agent Roster Table | story-execution.md Ref | Domain-Specific Gates |
|----------------|--------|-------------------|----------------------|---------------------|
| software-development | Yes (web-app, automation) | 8 roles | Line 6 + Section "Story Execution" | Security Review (web-app), Architecture triggers |
| data-engineering | Yes (data-engineering) | 8 roles | Line 6 + Section "Story Execution" | Environment Progression, Layer Ownership, Security |
| analytics-engineering | Yes (analytics-engineering) | 8 roles | Line 6 + Section "Story Execution" | Transformation Validation, Migration Parity, Data Model Alignment |
| data-app | Yes (data-app) | 8 roles | Line 7 + Section "Story Execution" | Dashboard Spec Validation, Visualization Review |
| ml-engineering | Yes (ml-engineering) | 7 roles | Line 7 + Section "Story Execution" | Experiment Loops, Model Evaluation, Compute Cost |
| ai-engineering | Yes (ai-engineering) | 9 roles | Line 8 + Section "Story Execution" | Prompt Review, Eval Harness, RAG Assessment, Security |
| library | Yes (library) | 7 roles | Line 7 + Section "Story Execution" | API Surface Review, Backward Compatibility, Publishing Readiness |

Each file also has a Testing Approach section with TDD / Test-informed
/ Test-after guidance specific to the domain. Each file references
story-execution.md for shared execution mechanics and explicitly does
NOT reproduce those mechanics.

---

## Check 10: Integration Template Parity

**Result: FAIL**

The two integration templates have structural divergence:

**Divergence 1 — Project Type enum:**
- CLAUDE.md line 11: lists `analytics-workspace` (stale)
- copilot-instructions.md line 12: lists `analytics workflow`
  (correct but uses space instead of hyphen — should be
  `analytics-workflow` to match the file naming convention)

**Divergence 2 — Category section headers:**
- CLAUDE.md line 548: retains `### Task-based types (task-workspace)
  — Base Workflow` (stale category language)
- copilot-instructions.md: uses updated language (no matching
  section header found with category language)

**Divergence 3 — analytics-workspace references:**
- CLAUDE.md line 109: `analytics-workspace` in verification method
  table
- CLAUDE.md line 387: section header `## Analytics Workflow
  (analytics-workspace type only)`
- copilot-instructions.md: uses `analytics workflow` consistently

The copilot template was updated more thoroughly than the CLAUDE.md
template. The CLAUDE.md template retains stale `analytics-workspace`
references and category language that the copilot template has
already corrected.

---

## Summary of Failures

| Check | Status | Severity | Fix scope |
|-------|--------|----------|-----------|
| 5. Category dissolution | FAIL | High | BOOTSTRAP.md (2 occurrences), CLAUDE.md integration (1 occurrence) |
| 6. analytics-workspace rename | FAIL | High | BOOTSTRAP.md (11 occurrences), CLAUDE.md integration (3), README.md (1), MANIFEST_SPEC.md (1), Document-Catalog.md (3) |
| 10. Integration template parity | FAIL | Medium | CLAUDE.md integration has stale references that copilot template already fixed |

**Note:** Checks 5 and 6 overlap — the BOOTSTRAP.md and CLAUDE.md
integration template violations appear in both checks. The total
unique files needing fixes: BOOTSTRAP.md, integrations/claude-code/
CLAUDE.md, README.md, MANIFEST_SPEC.md, core/Document-Catalog.md.

All structural work (dispatch decomposition, domain workflow files,
story-execution protocol, development-workflow deletion, agent prompt
updates, cross-references, AGENT-CATALOG reorganization) is
structurally sound. The failures are all in the rename/dissolution
pass for files that were in the plan's changed file list but where
the implementer did not fully complete the find-and-replace.
