---
type: change-verification
change-request: planning/CR-22-agents-as-composable-skills.md
plan: docs/plans/CR-22-plan.md
agent: methodology-reviewer
verdict: FAIL
created: 2026-05-04
---

# CR-22 Methodology Review

**Verdict: FAIL**

Five issues found. Three are blocking (incomplete rename propagation
that would cause a bootstrapping agent to use stale terminology or
reference non-existent catalog tables). Two are non-blocking notes.

---

## 1. Cross-Reference Consistency

### 1a. FAIL: BOOTSTRAP.md retains 12 occurrences of `analytics-workspace`

The plan's Risk #3 (analytics-workspace rename incomplete) and
Mitigation #3 (search ALL repo files) were not fully executed.
BOOTSTRAP.md is a canonical, instructional file — not historical
context. Twelve live occurrences remain:

- Line 71: type alignment table uses `analytics-workspace` as the
  project type value
- Line 79: explanation text for `analytics-workspace`
- Line 141: folder creation instruction for `analytics-workspace`
- Line 175: `.gitignore` guidance for `analytics-workspace`
- Line 190: wiki backfill conditional for `analytics-workspace`
- Line 246: branch point routing to Phase 2W uses `analytics-workspace`
- Line 491: Phase 2W heading says "analytics-workspace only"
- Lines 501, 505: CLAUDE.md/copilot template copy says
  `set project type to analytics-workspace`
- Line 584: readiness checklist says `Project type: analytics-workspace`
- Line 600: Design Alignment note says `analytics-workspace`
- Line 675: "Skip this phase for `analytics-workspace`"

**Fix:** Replace all 12 occurrences. The project type value in code
contexts (type alignment table, manifest, instruction file settings)
should be `analytics-workflow` (the renamed identifier). Descriptive
text should say "analytics workflow."

### 1b. FAIL: BOOTSTRAP.md references "Sprint-Based Types and Task-Based Types mapping tables" (line 295)

The AGENT-CATALOG no longer has these tables — they were replaced
with a unified "Agent Mapping by Workflow Type" section. BOOTSTRAP.md
line 295 tells the agent to "see the Sprint-Based Types and Task-Based
Types mapping tables in AGENT-CATALOG.md." The agent would search for
tables that do not exist.

**Fix:** Update line 295 to reference the "Agent Mapping by Workflow
Type" section or the "Agent Files" table in the AGENT-CATALOG.

### 1c. FAIL: README.md retains stale analytics-workspace references

Two occurrences in README.md:

- Line 9: "tiered pre-execution review workflow for analytics
  workspaces" (should say "analytics workflow")
- Line 49: The workflow types table uses `analytics-workspace` as the
  type tag (should be `analytics-workflow` to match the renamed
  concept)

The CHANGELOG entry says README.md was updated to remove three-category
headers and unify the workflow types table. The category dissolution was
done, but the analytics-workspace-to-analytics-workflow rename was
missed in this file.

**Fix:** Update both occurrences. Line 49 type tag should be
`analytics-workflow` or just match whatever the canonical project type
identifier is post-rename. Line 9 should say "analytics workflow."

### 1d. FAIL: MANIFEST_SPEC.md retains `analytics-workspace` in project_type enum (line 39)

The `project_type` field description lists `analytics-workspace` as a
valid value. This is a consumer-facing contract — consumers reading
the spec will use the old name.

**Fix:** Replace `analytics-workspace` with `analytics-workflow` in the
`project_type` field description.

### 1e. FAIL: Integration template CLAUDE.md retains `analytics-workspace` references

Three occurrences in `integrations/claude-code/CLAUDE.md`:

- Line 11: Project Type field lists `analytics-workspace` as a valid
  value
- Line 109: Verification method table uses `analytics-workspace`
- Line 387: Section heading says "analytics-workspace type only"

The CHANGELOG entry says the integration template was updated with
"renamed analytics-workspace." These three were missed.

**Fix:** Update all three to use the renamed identifier/term.

### 1f. NOTE: workflow-planner.md references `development-workflow` (line 175)

The workflow-planner agent prompt at line 175 contains a calibration
example that references "development-workflow (every mention of the
reviewer role)." Since development-workflow.md was deleted, this
reference is stale. However, this is inside an illustrative example
about tracing rename impacts, not a file path reference. The example
would still make conceptual sense even with the stale name, but it is
technically inaccurate.

**Fix (non-blocking):** Update the calibration example to reference
"story-execution (every mention of the reviewer role)" or the domain
workflow files, to match the current file structure.

### 1g. PASS: Document-Catalog freshness cross-reference updated

The Document-Catalog's Freshness Metadata section correctly references
`core/workflows/protocols/story-execution.md` (line 74) instead of
the deleted development-workflow.md. This is correct.

### 1h. PASS: dispatch-protocol.md hub correctly decomposed

The hub file retains cross-archetype content (dispatch tiers,
tier-conditional tables, lightweight dispatch, retry protocol, output
format constraints) and provides a clean routing table to 7 per-
archetype contract files. The hub is approximately 225 lines — within
the planned 200-300 range. Each per-agent contract file correctly
references the hub for shared mechanics. No content appears to be lost
in the decomposition (7 archetype files cover all agents listed in
AGENT-CATALOG).

### 1i. PASS: All CHANGELOG-referenced files exist

Every file listed in the 0.32.0 CHANGELOG entry was verified as
existing in the repo. The deleted file (development-workflow.md) is
confirmed deleted. The renamed files (analytics-workspace.md,
analytics-onboarding.md) are confirmed renamed — old paths do not
exist, new paths do.

---

## 2. Prompt Pattern Adherence

### 2a. PASS: Domain workflow files follow consistent structure

All 7 domain workflow files follow the same pattern: introduction
paragraph naming the domain and referencing story-execution.md, an
Agent Roster table, Domain-Specific Gates section, Testing Approach
section, and a Story Execution pointer section. Each file is
self-contained for its domain as specified in the plan.

### 2b. PASS: Agent prompt updates are terminology-only

The 14 agent prompt files listed in the CHANGELOG received
terminology-only updates (replacing category language with workflow
type language). No structural changes to agent prompts. Zero
`analytics-workspace` or category-label references remain in
`core/agents/`.

### 2c. PASS: AGENT-CATALOG Skills Model section is well-structured

The new Skills Model section at the top of AGENT-CATALOG.md clearly
defines the three-tier relationship (base agents, specialized agents,
workflow types). The Agent Files table includes a new Skill column
that documents each agent's skill parameterization. This is a
meaningful addition — previously the skill relationship was implicit.

---

## 3. Instruction Decomposition Quality

### 3a. PASS: dispatch-protocol.md decomposition follows the principle

The monolithic 1,097-line file was decomposed into a ~225-line hub
plus 7 per-archetype files. The hub contains only cross-archetype
content. Each archetype file is self-contained for its agents. No
section in any file exceeds the ~30-50 line threshold guidance.

### 3b. PASS: story-execution.md is appropriately scoped

The extracted protocol file contains the shared story execution
mechanics without domain-specific content. At approximately 390 lines,
it is a substantial protocol, but the content is all execution
mechanics (story start, evaluation cycle, tier branching, freshness
loading, multi-domain completion, sprint planning, ideation, research,
bug workflow, architecture assessment). Domain workflow files correctly
reference it without duplicating its content.

### 3c. PASS: Domain workflow files avoid duplication

Each domain workflow file explicitly says to follow story-execution.md
for shared mechanics and adds only domain-specific content (agent
roster, gates, testing approach). No domain workflow reproduces the
shared execution steps.

---

## 4. Smell Test Compliance

### 4a. PASS: No personal or product-specific assumptions

No downstream project names (Notnomo, Hearthen, MNEMOS, Opifex,
edw labs, VerbumEng) appear in any changed canonical file. No personal
workflow assumptions leak. The domain workflow files describe domain
patterns generically (e.g., "Alteryx-to-SQL migrations" is a domain
concept, not a personal assumption).

### 4b. PASS: Framework-agnostic

A stranger cloning the repo for a greenfield project would find
coherent, self-explanatory workflow files. The skills model is
explained at the point of use (AGENT-CATALOG, Domain-Language). The
composition model is clear.

---

## 5. Consumer Update Completeness

### 5a. PASS WITH NOTE: CHANGELOG consumer update instructions are
substantially complete

The consumer update instructions cover: file renames, domain workflow
file installation, story execution protocol, dispatch protocol
decomposition, catalog updates, agent prompt updates, integration
template updates, and development-workflow.md deletion. The 8 steps
cover the necessary actions.

**Note:** The CHANGELOG entry in the plan draft was more detailed
(10 steps including analytics-workspace rename guidance and Domain
Language informational note). The implemented CHANGELOG entry has
8 steps — it is slightly compressed but the essential actions are
covered. Step 1 covers the renames, step 8 covers the deletion.

### 5b. PASS: MIGRATIONS.md entries are complete

The MIGRATIONS.md 0.32.0 entry documents: file renames (both with old
path, new path, and action), development-workflow.md deletion with
replacement pointers, new files list, dispatch protocol decomposition,
and category dissolution. Consumer projects have sufficient guidance
to migrate.

---

## 6. Dispatch/Output Contract Consistency

### 6a. PASS: Dispatch contracts match workflow documentation

The per-archetype dispatch contract files correctly document the
contracts for all agents listed in the AGENT-CATALOG. The hub file's
routing table maps each archetype to its contract file. Domain workflow
files reference story-execution.md which in turn references the
dispatch protocol. The chain is complete:
domain workflow -> story-execution.md -> dispatch-protocol.md hub ->
per-archetype contract files.

### 6b. PASS: Tier-conditional dispatch tables consistent

The dispatch protocol hub's Patch/Story/Deep Story tier-conditional
tables correctly document which agents are invoked at each tier. This
matches the story-execution.md execution paths.

---

## Summary of Findings

| # | Severity | File | Issue |
|---|----------|------|-------|
| 1a | **Blocking** | `BOOTSTRAP.md` | 12 occurrences of `analytics-workspace` not renamed |
| 1b | **Blocking** | `BOOTSTRAP.md` | References "Sprint-Based Types and Task-Based Types mapping tables" that no longer exist in AGENT-CATALOG |
| 1c | **Blocking** | `README.md` | 2 stale `analytics-workspace` references |
| 1d | **Blocking** | `MANIFEST_SPEC.md` | `analytics-workspace` in project_type enum |
| 1e | **Blocking** | `integrations/claude-code/CLAUDE.md` | 3 stale `analytics-workspace` references |
| 1f | Non-blocking | `core/agents/workflow-planner.md` | Calibration example references deleted `development-workflow` |

**Verdict: FAIL.** Five files contain stale terminology that would
cause a bootstrapping agent to use incorrect project type values,
reference non-existent catalog tables, or present outdated
terminology to consumers. The underlying structural changes (category
dissolution, skills model, dispatch decomposition, domain workflow
creation, story-execution extraction) are well-executed. The failures
are all in the final rename propagation pass — the plan's Risk #3
mitigation (search ALL repo files for analytics-workspace) was not
fully applied to BOOTSTRAP.md, README.md, MANIFEST_SPEC.md, and the
integration CLAUDE.md template.
