---
type: architecture-assessment
status: complete
created: 2026-05-04
evaluator: context-architect
plan: docs/plans/CR-22-plan.md
verdict: CONCERNS
---

# CR-22 Architecture Assessment

**Verdict: CONCERNS**

The structural design of CR-22 is fundamentally sound. The
decomposition strategy (monolithic development-workflow.md into
story-execution.md protocol + 7 domain workflow files; monolithic
dispatch-protocol.md into hub + 7 archetype contract files) follows
the context decomposition principle correctly and produces files that
are well-sized, consistently patterned, and navigable. The
concerns identified below are residual rename/dissolution misses
that did not propagate fully through the changed files, and one
structural gap in the integration templates. None are architectural
design flaws — they are execution completeness issues.

---

## 1. Instruction Decomposition

**Assessment: SOUND**

### story-execution.md (390 lines)

The file is the largest new file and warrants section-level scrutiny.
Its internal structure is clean:

- Design Alignment (pre-sprint) — 18 lines
- Dispatch Protocol — 4 lines (pointer only, correct)
- Tier-Conditional Workflow Branching — 53 lines across Patch/Story/
  Deep Story paths, plus Tier Promotion
- Freshness-Aware Context Loading — 40 lines
- Starting a Story — 55 lines
- Completing a Story (Evaluation Cycle) — 55 lines
- Multi-Domain Story Completion — 32 lines
- Sprint Planning — 9 lines
- Ideation/Grooming — 7 lines
- Research — 7 lines
- Bug Workflow — 1 line (pointer)
- Architecture Assessment (Ad Hoc) — 6 lines

No individual section exceeds 55 lines. The sections that are
longer (Tier-Conditional at 53, Starting a Story at 55, Completing
at 55) contain step-by-step protocols that would lose clarity if
decomposed further. 390 lines total is appropriate for what was a
600+ line section of the former development-workflow.md — the
domain-specific content (agent rosters, domain gates, testing
approach details) was successfully extracted to the 7 domain files.

The file correctly identifies itself as "NOT a workflow type" and
includes the cross-cutting procedure classification note. The
back-pointer to domain workflow files (lines 10-18) lists all 7
domain workflow files by path, which is necessary for an orchestrator
to navigate from shared execution mechanics to domain-specific
content.

### Domain workflow files (65-83 lines each)

All 7 domain workflow files follow the plan's mitigation #10: they
do NOT reproduce the shared story execution steps. Each ends with a
"Story Execution" section that points to story-execution.md. The
files are lean and focused on what the domain adds:

| File | Lines | Sections |
|------|-------|----------|
| software-development-workflow.md | 81 | Agent Roster, Security Review, Arch Triggers, Testing |
| data-engineering-workflow.md | 77 | Agent Roster, Env Progression Gates, Layer Ownership, Security, Testing |
| analytics-engineering-workflow.md | 69 | Agent Roster, Transformation Validation, Migration Parity, Data Model, Testing |
| data-app-workflow.md | 65 | Agent Roster, Dashboard Spec, Visualization Review, Testing |
| ml-engineering-workflow.md | 74 | Agent Roster, Experiment Loops, Model Eval, Compute Cost, Testing |
| ai-engineering-workflow.md | 83 | Agent Roster, Prompt Review, Eval Harness, RAG, Security, Testing |
| library-workflow.md | 79 | Agent Roster, API Surface, Backward Compat, Publishing, Testing |

All are well within the context decomposition guideline (~30-50
lines per section). No file is so thin as to be useless stub-work
(plan risk #11), and none is so thick as to need further
decomposition.

### Dispatch protocol decomposition

The hub file (dispatch-protocol.md) is 224 lines. The plan targeted
200-300. This is the right size: it contains the cross-archetype
content (dispatch tiers, lightweight dispatch, tier-conditional
tables, retry protocol, output format constraints) and a Per-Agent
Contracts section with a routing table mapping each archetype to its
contract file. An orchestrator reading only the hub understands the
universal rules.

The 7 archetype contract files range from 39 lines (designer) to
231 lines (planner). The larger files (planner at 231, implementer
at 205, reviewer at 178) are large because they cover many
specialized agents, not because any individual section is bloated.
Each agent's contract is a self-contained dispatch table — the
structure is mechanical and benefits from co-location within the
archetype file.

---

## 2. Pointer Pattern Cleanliness

**Assessment: CONCERNS**

### Clean patterns (the majority)

The pointer architecture follows a clean hub-and-spoke pattern:

- Integration template -> story-execution.md + "[domain]-workflow.md"
  -> dispatch-protocol.md hub -> dispatch/[archetype]-contracts.md
- Domain workflow files -> story-execution.md (shared execution) +
  agent prompt files (roster links)
- story-execution.md -> dispatch-protocol.md + design-alignment.md +
  sprint-coordination.md + Document-Catalog.md (freshness)
- Dispatch hub -> dispatch/[archetype]-contracts.md
- Each dispatch contract file -> dispatch hub (back-pointer in first
  paragraph)

No circular references detected. The pointer direction is consistent:
more-specific files point to more-general files for shared mechanics,
and the general files list their consumers for navigation.

### Stale pointers (CONCERN C-1)

**workflow-planner.md line 175** contains a stale reference to
"development-workflow" in an edge case example:

> dispatch-protocol (agent reference), development-workflow (every
> mention of the reviewer role)

The file `development-workflow.md` has been deleted. This reference
should point to "story-execution.md and domain workflow files" or
similar. The workflow-planner is listed as a changed file in the
plan's Modified files table but for "project types" -> "workflow
types" updates. This stale path reference was missed.

### Stale pointers (CONCERN C-2)

**Calibration-Template.yml line 15** and **estimate-tokens.py lines
22, 407** use `development-workflow` as the calibration key
namespace. These files were listed in the plan's "Deferred" section
(calibration key migration deferred, forward-compatible by design).
This is an acknowledged deferral, not an oversight — but the
deferred note in the plan (under "Scope Decisions") should have
explicitly listed these three files as files that still contain the
old key format. Future sessions need to know where the deferred work
lives.

---

## 3. Context Budget

**Assessment: SOUND**

The always-loaded vs. on-demand balance is well-calibrated:

**Always-loaded (front-loaded into every session via integration
template):** The CLAUDE.md / copilot-instructions.md template at
697 / 610 lines respectively. These contain: project identity,
session lifecycle, work type routing, agent tables, workflow
summaries, and pointers to on-demand files. This is the right set of
information for session orientation.

**On-demand (loaded when a story starts):** story-execution.md
(390 lines) + the project's domain workflow file (65-83 lines) +
dispatch-protocol.md hub (224 lines). Total: ~680-700 lines loaded
at story start. This is reasonable for story-level work.

**On-demand (loaded when dispatching a specific agent):** The
per-archetype contract file (39-231 lines). Loaded only when the
orchestrator is assembling a dispatch payload for that archetype.
This is the right granularity — the orchestrator does not need all
7 archetype contracts at once.

**Not loaded unless needed:** Sprint-coordination.md (for phase
transitions), design-alignment.md (for alignment triggers), protocol
files (token-estimation, knowledge-pipeline, knowledge-synthesis —
loaded at their specific trigger points).

An orchestrator starting a story loads: the integration template
(front-loaded) + story-execution.md + domain workflow file +
dispatch hub. That is about 1,300-1,500 lines of instruction before
it starts loading archetype contracts for specific dispatches. This
is acceptable context for a story orchestration task. The
decomposition successfully prevents the old problem of loading the
monolithic development-workflow.md (600+ lines) + monolithic
dispatch-protocol.md (1,097 lines) = 1,700+ lines of which only a
fraction was relevant.

---

## 4. Pattern Consistency

**Assessment: SOUND**

### Domain workflow file structure

All 7 domain workflow files follow an identical template:

1. Title line naming the domain
2. Introductory paragraph naming the project types, stating this file
   adds the domain-specific layer, referencing story-execution.md
3. Agent Roster (table: Role, Agent with link, Notes)
4. Domain-Specific Gates (with subsections per gate)
5. Testing Approach (three-tier: TDD/Test-informed/Test-after, plus
   verification method)
6. Story Execution (pointer to story-execution.md)

The agent roster tables use consistent column headers (Role, Agent,
Notes) across all 7 files. The agent links use consistent relative
path format (../../agents/[name].md). The Testing Approach sections
consistently list the three tiers and a "Verification method" line.

Minor variation is appropriate: ai-engineering-workflow.md has 4
domain-specific gates (Prompt Review, Eval Harness, RAG Assessment,
Security Assessment) while data-app-workflow.md has 2 (Dashboard
Spec, Visualization Review). This reflects genuine domain
differences, not inconsistency.

### Dispatch contract file structure

All 7 archetype contract files follow an identical template:

1. Title line
2. Introductory paragraph with back-pointer to dispatch hub
3. Per-agent sections, each containing:
   - Agent name and mode as H2
   - Dispatch tier (Strict or Contextual)
   - Field table (Field, Required, Description)
   - "Do not provide" note (for strict dispatch agents)
   - "Output expected" statement

The field tables are consistent: Required column uses
Yes/Conditional/Optional. The "Do not provide" notes appear only
for strict-dispatch agents (reviewers, validators, architects in
review mode), which is correct — contextual dispatch agents do not
have withholding constraints.

---

## 5. Integration Surface Completeness

**Assessment: CONCERNS**

### Navigability from integration template to correct files

The CLAUDE.md template's Development Workflow section (line 360)
correctly instructs:

> Before starting any story, sprint planning, or bug fix, read: the
> project's domain workflow file in `[FABRIKA_PATH]/core/workflows/
> types/` and `[FABRIKA_PATH]/core/workflows/protocols/
> story-execution.md`

This pointer is correct but incomplete. The orchestrator is told to
read "the project's domain workflow file" but is not given an
explicit mapping table from project type to domain workflow filename.
The Subagents section (line 529+) has a "Domain workflows" table
that lists Default Agent and Specialized Variants by role, but NOT
a project-type-to-workflow-file mapping. An orchestrator must infer
which domain workflow file to read from the project type declared in
"Project Basics."

**The plan's "Project type to domain workflow mapping" table (plan
lines 719-732) gives exactly this mapping, but it was not reproduced
in the integration template.** This is a usability gap (CONCERN
C-3). The orchestrator has two options: read every domain workflow
file to find the one that matches its project type, or guess from
naming conventions. Neither is ideal. A small mapping table or a
note like "[FABRIKA_PATH]/core/workflows/types/
[workflow-name]-workflow.md where [workflow-name] matches the domain
workflow column in the Agent Mapping table above" would close this
gap.

The copilot-instructions.md template has the same gap — the
Development Workflow section (line 269) says the same thing without
a project-type-to-file mapping.

### Stale integration template content (CONCERN C-4)

**CLAUDE.md line 11** still lists `analytics-workspace` in the
Project Type enum:

> [web-app | data-app | analytics-engineering | data-engineering |
> ml-engineering | ai-engineering | automation | library |
> analytics-workspace | task-workspace | agentic-workflow]

The plan renames the concept from "analytics-workspace" to
"analytics workflow" and renames the file. The Project Type enum
should say `analytics-workflow` (or the Domain Language's preferred
term for the project type). The copilot-instructions.md (line 12)
says `analytics workflow` (without the hyphen in a different format),
creating a divergence between the two templates.

**CLAUDE.md line 109** in the Verification Method table still says
`analytics-workspace`:

> | `analytics-workspace` | Per-task validation (sanity checks,
> cross-references) | Data validator agent |

**CLAUDE.md line 387** in the Analytics Workflow section header says:

> ## Analytics Workflow (analytics-workspace type only)

**CLAUDE.md line 548** retains the old category header:

> ### Task-based types (task-workspace) — Base Workflow

The category "Task-based types" was dissolved. This header should
say something like "### Task Workflow (Base)" or equivalent, matching
the AGENT-CATALOG's new organization.

The copilot-instructions.md does NOT have these same stale references
(no match for "analytics-workspace", no "Task-based types" header),
confirming the CLAUDE.md template was not fully synchronized with
the copilot template. **The plan's mitigation #8 (update both
templates in the same pass, verify structural parity) was not fully
followed for the CLAUDE.md template.** The copilot template is
cleaner than the CLAUDE.md template.

### Wiki files not in scope

The wiki files (`wiki/topics/agent-model.md`) still contain
extensive category language ("Sprint-based types", "Task-based
types", "Methodology-based types") and "analytics-workspace"
references. These were not in the plan's scope (wiki files are not
canonical), but they will present contradictory framing to anyone
reading the wiki. This is not a CR-22 concern but should be logged
as a follow-up task.

---

## Concern Summary

| ID | Severity | File | Issue |
|----|----------|------|-------|
| C-1 | Low | `core/agents/workflow-planner.md` line 175 | Stale reference to "development-workflow" — file has been deleted. Should reference story-execution.md / domain workflow files. |
| C-2 | Informational | `core/templates/Calibration-Template.yml`, `core/scripts/estimate-tokens.py` | Stale `development-workflow` calibration key namespace. Acknowledged deferral per plan scope. Not a defect. |
| C-3 | Medium | `integrations/claude-code/CLAUDE.md`, `integrations/copilot/copilot-instructions.md` | No explicit project-type-to-domain-workflow-file mapping in the Development Workflow section. The orchestrator must infer which file to load. |
| C-4 | Medium | `integrations/claude-code/CLAUDE.md` | Four stale references: `analytics-workspace` in Project Type enum (line 11), Verification Method table (line 109), Analytics Workflow section header (line 387), and "Task-based types" category header (line 548). The copilot template does not have these same issues, confirming parity was not maintained. |
| C-5 | Low | `BOOTSTRAP.md` | Multiple residual `analytics-workspace` references (lines 71, 79, 141, 175, 190, 246, 491, 501, 505, 584, 600, 675). The plan listed BOOTSTRAP.md as a modified file for "renamed analytics-workspace" and "unified onboarding flow" but many occurrences survived. |
| C-6 | Low | `MANIFEST_SPEC.md` line 39 | `analytics-workspace` still listed as a valid project type value. Should be updated to `analytics-workflow` or the new canonical name. |

### Recommended actions

**C-1:** Update workflow-planner.md line 175: replace
"development-workflow" with "story-execution.md and domain workflow
files" in the edge case example.

**C-3:** Add a project-type-to-domain-workflow-file mapping table or
note to the Development Workflow section of both integration
templates. The mapping already exists in the plan and in
AGENT-CATALOG (Agent Mapping by Workflow Type). A compact
reproduction in the integration template would close the navigation
gap.

**C-4:** Update the CLAUDE.md template: change `analytics-workspace`
to `analytics-workflow` in the Project Type enum, Verification
Method table, and Analytics Workflow section header. Change
"Task-based types (task-workspace)" to "Task Workflow" or equivalent
in the Subagents section header. Verify parity with the copilot
template after changes.

**C-5 and C-6:** Complete the analytics-workspace rename in
BOOTSTRAP.md and MANIFEST_SPEC.md. These are listed as changed
files in the plan but the rename did not fully propagate.

---

## Verdict

**CONCERNS.** The structural design is sound: the decomposition
strategy is correct, files are appropriately sized, the pointer
architecture is clean, the context budget is well-balanced, and the
pattern consistency across the 7 domain workflow files and 7 dispatch
contract files is strong. The concerns are execution completeness
issues — stale references that survived the rename/dissolution pass
(C-1, C-4, C-5, C-6) and a usability gap in the integration
template navigation path (C-3). None of these require structural
redesign. They require targeted edits to complete the propagation
that the plan specified.
