# Changelog

All notable changes to Fabrika are documented here.

Format: each version lists changed files and the nature of the change. Consumer projects use the CHANGELOG to determine which files need updating (see UPDATE.md).

---

## 0.26.0 — Base workflow type and base agents

Introduces the task workflow type — the domain-agnostic base workflow
that all specialized workflows parameterize — and four base agents
(planner, implementer, reviewer, validator). First step in Fabrika's
Phase 2 shift from taxonomic project types to composable workflow
types. Projects can now add workflow types on demand via
ADD-WORKFLOW.md.

### New files
- `core/agents/planner.md` — base planner agent
- `core/agents/implementer.md` — base implementer agent
- `core/agents/reviewer.md` — base reviewer agent
- `core/agents/validator.md` — base validator agent
- `core/workflows/task-workflow.md` — task workflow definition
- `core/templates/Brief-Template.md` — base brief template
- `core/templates/Plan-Template.md` — base plan template
- `core/templates/Outcome-Template.md` — base outcome template
- `ADD-WORKFLOW.md` — on-demand workflow addition mechanism

### Changed files
- `core/agents/AGENT-CATALOG.md` — base agent roster and files added,
  workflow type language note
- `core/Document-Catalog.md` — base documents section (all workflow
  types), task-workspace quick reference
- `core/workflows/dispatch-protocol.md` — base agent dispatch
  contracts (planner planning/validation, implementer, reviewer,
  validator)
- `core/workflows/doc-triggers.md` — task-workflow document triggers
- `BOOTSTRAP.md` — type alignment table entry, Phase 2T onboarding,
  on-demand workflow addition section, readiness checklist
- `ADOPT.md` — task-workspace adoption support
- `MANIFEST_SPEC.md` — task-workspace as valid project_type
- `MIGRATIONS.md` — consumer migration entry for 0.26.0
- `Domain-Language.md` — workflow type, base workflow, base agent,
  task-workspace, on-demand workflow addition terms
- `integrations/claude-code/CLAUDE.md` — task-workspace availability,
  base agent table, workflow composition section
- `integrations/copilot/copilot-instructions.md` — same
- `README.md` — agent count (28 -> 32), task-workspace in type table

### Consumer update instructions
1. Copy new base agent files: `planner.md`, `implementer.md`,
   `reviewer.md`, `validator.md`
2. Copy new templates: `Brief-Template.md`, `Plan-Template.md`,
   `Outcome-Template.md`
3. Copy `ADD-WORKFLOW.md` to your project root
3b. Copy `core/workflows/task-workflow.md` to `.fabrika/workflows/`
    (reference copy of the workflow definition)
4. Update from Fabrika source: `AGENT-CATALOG.md`,
   `Document-Catalog.md`, `dispatch-protocol.md`, `doc-triggers.md`,
   `Domain-Language.md`, `BOOTSTRAP.md`, `ADOPT.md`,
   `MANIFEST_SPEC.md`, `MIGRATIONS.md`
5. Update your project instruction file from integration template
6. Key change: projects can now compose multiple workflow types on
   demand via `ADD-WORKFLOW.md`

---

## 0.25.0 — Rename context engineer to agentic engineer

Renames the agentic-workflow implementer agent from "context engineer"
to "agentic engineer." The old name collided with the industry-generic
"context engineering" concept and shared a confusing prefix with the
context architect (a different archetype). No behavioral changes —
same orientation, output contracts, and archetype.

### New files
- `core/agents/agentic-engineer.md` — renamed from `context-engineer.md`

### Deleted files
- `core/agents/context-engineer.md` — replaced by `agentic-engineer.md`

### Changed files
- `core/agents/AGENT-CATALOG.md` — agent name, filename, description
  updated from context-engineer to agentic-engineer
- `core/agents/workflow-planner.md` — dispatch target references updated
- `core/agents/methodology-reviewer.md` — cross-reference updated
- `core/agents/context-architect.md` — cross-reference to agent file
  path updated
- `core/workflows/agentic-workflow-lifecycle.md` — agent name in step
  descriptions, agent roster table, and maturity note updated
- `core/workflows/dispatch-protocol.md` — section heading, contract
  description paragraph, and dispatch table field description updated
- `core/design-principles.md` — agentic-workflow review protocol
  description updated
- `core/workflows/token-estimation.md` — example scenario agent name
  updated
- `Domain-Language.md` — term renamed with backward-compatibility note
- `integrations/claude-code/CLAUDE.md` — subagents table updated
- `integrations/copilot/copilot-instructions.md` — subagents table
  updated
- `BOOTSTRAP.md` — agent file lists and readiness checklist updated
- `wiki/topics/agent-model.md` — agent name, implementer list, and
  version history updated
- `planning/EXECUTION-PROMPT.md` — dispatch instruction updated
- `MIGRATIONS.md` — consumer migration entry added
- `VERSION` — 0.24.0 -> 0.25.0

### Consumer update instructions
1. Rename your agent file: `core/agents/context-engineer.md` ->
   `core/agents/agentic-engineer.md` (or copy the new version from
   Fabrika source)
2. Update these files from the Fabrika source:
   `core/agents/AGENT-CATALOG.md`,
   `core/agents/workflow-planner.md`,
   `core/agents/methodology-reviewer.md`,
   `core/agents/context-architect.md`,
   `core/workflows/dispatch-protocol.md`,
   `core/workflows/agentic-workflow-lifecycle.md`,
   `core/design-principles.md`,
   `core/workflows/token-estimation.md`,
   `Domain-Language.md`,
   `wiki/topics/agent-model.md`
3. Update your project instruction file (CLAUDE.md or
   copilot-instructions.md) from the Fabrika integration template
4. Update `BOOTSTRAP.md` from the Fabrika source
5. Search your project for remaining references:
   `rg "context.engineer" -i --type md`
   Update any matches in your own project files (custom workflows,
   documentation, etc.)

---

## 0.24.0

Token Cost Estimation. Adds cost-informed planning via a deterministic
Python estimator that surfaces token and dollar cost estimates at plan
time across all workflow types. Introduces two structural precedents:
YAML frontmatter on agent prompts (model metadata), and executable
scripts in core/scripts/.

### New files

- `core/workflows/token-estimation.md` -- **NEW.** Centralized
  estimation protocol: script CLI contract, readout format, calibration
  update protocol, cadence rules, worked examples. Referenced by all
  three workflow files with one-line pointers.
- `core/scripts/estimate-tokens.py` -- **NEW.** Deterministic Python
  estimator. Receives agent list from orchestrator + calibration +
  priors + pricing, emits JSON. Requires `uv run`.
- `core/scripts/README.md` -- **NEW.** Convention document for
  core/scripts/ (admission criteria, runtime expectations).
- `core/calibration/priors.yml` -- **NEW.** Bundled tier-level priors
  and model-to-tier lookup table.
- `core/calibration/pricing.yml` -- **NEW.** Per-model $/1M-token
  pricing (input and output rates). Separate file for easy patch
  updates when providers change pricing.
- `core/templates/Calibration-Template.yml` -- **NEW.** Template for
  consumer `.fabrika/calibration.yml`.
- `core/agents/agent-frontmatter-spec.md` -- **NEW.** YAML frontmatter
  schema for agent prompts (model, model_tier, extensibility).

### Core (changed -- consumer projects should update)

- `core/workflows/development-workflow.md` -- **CHANGED.** One-line
  pointer to token-estimation.md at plan-presentation step.
- `core/workflows/analytics-workspace.md` -- **CHANGED.** One-line
  pointer at Tier 1 and Tier 2 plan phases.
- `core/workflows/agentic-workflow-lifecycle.md` -- **CHANGED.**
  One-line pointer in Step 2 (Align) at plan presentation.
- `core/workflows/design-alignment.md` -- **CHANGED.** Soft note
  about informal cost-awareness during Q&A walk.
- `core/agents/*.md` (28 concrete agents) -- **CHANGED.** YAML
  frontmatter added with model/model_tier declarations. Non-breaking
  -- agents function identically without frontmatter.
- `core/agents/archetypes/*.md` (7 archetypes) -- **CHANGED.**
  "Required Frontmatter" section added to each archetype.
- `core/agents/AGENT-CATALOG.md` -- **CHANGED.** New "Agent
  Frontmatter" section cross-referencing agent-frontmatter-spec.md.
- `core/Document-Catalog.md` -- **CHANGED.** New entries for
  calibration.yml (consumer artifact), priors.yml (framework artifact),
  pricing.yml (framework artifact), Calibration-Template.yml (template).
- `core/FABRIKA.md` -- **CHANGED.** Documents calibration.yml in
  .fabrika/ contents and surfaces core/scripts/ convention.

### Root (changed -- consumer projects should update)

- `Domain-Language.md` -- **CHANGED.** New "Token Estimation" domain
  area with 6 terms.
- `MANIFEST_SPEC.md` -- **CHANGED.** token_budget_warn config field,
  expanded .fabrika/ directory contents.
- `BOOTSTRAP.md` -- **CHANGED.** Scaffolds calibration.yml, copies
  estimator script and priors.
- `UPDATE.md` -- **CHANGED.** 0.24.0 update guidance.
- `MIGRATIONS.md` -- **CHANGED.** 0.24.0 migration entry.
- `README.md` -- **CHANGED.** Token estimation in feature list.

### Integrations (changed -- consumer projects should update)

- `integrations/claude-code/CLAUDE.md` -- **CHANGED.** Token
  estimation availability note, frontmatter footnote on Model Routing.
- `integrations/copilot/copilot-instructions.md` -- **CHANGED.**
  Token estimation availability note, Copilot CLI limitation
  documentation.

### Consumer update instructions

1. Copy new files:
   - `core/workflows/token-estimation.md`
   - `core/scripts/estimate-tokens.py`
   - `core/scripts/README.md`
   - `core/calibration/priors.yml`
   - `core/calibration/pricing.yml`
   - `core/templates/Calibration-Template.yml`
   - `core/agents/agent-frontmatter-spec.md`
2. Scaffold `.fabrika/calibration.yml` from
   `core/templates/Calibration-Template.yml`
3. Update workflow files (one-line pointer additions):
   - `core/workflows/development-workflow.md`
   - `core/workflows/analytics-workspace.md`
   - `core/workflows/agentic-workflow-lifecycle.md`
   - `core/workflows/design-alignment.md`
4. Update agent prompts with frontmatter (non-breaking -- agents work
   without it, but estimation accuracy improves with it). Copy updated
   versions from Fabrika source, or manually add frontmatter per
   `core/agents/agent-frontmatter-spec.md`.
5. Update archetype files (add Required Frontmatter sections)
6. Update AGENT-CATALOG.md (new section)
7. Update Document-Catalog.md (new entries)
8. Update FABRIKA.md (calibration.yml and scripts convention)
9. Update Domain-Language.md (new terms)
10. Update MANIFEST_SPEC.md (token_budget_warn, .fabrika/ contents)
11. Update BOOTSTRAP.md (calibration scaffolding step)
12. Update integration template (CLAUDE.md or copilot-instructions.md)
13. Optionally configure `token_budget_warn` in project config

---

## 0.23.0

Analytics Workspace Onboarding Protocol. Adds a structured onboarding
questionnaire to the analytics-workspace bootstrap process
(BOOTSTRAP.md Phase 2W). After directory scaffolding and agent
installation, the orchestrator asks the user about
platforms/technology, cost models, source connections, and data
governance tooling. All questions are skippable. Answers produce
pre-populated platform connection stubs in the source registry with
cost model info — either from the user's actual pricing or published
defaults. The analytics-workspace workflow now references these
onboarding-scaffolded files as the source of platform configuration
and cost model data.

### New files

- `core/workflows/analytics-onboarding.md` — **NEW.** Self-contained
  onboarding protocol for analytics-workspace projects. Four question
  groups: platforms/technology, cost model, source registry
  scaffolding, data governance. Referenced by BOOTSTRAP.md Phase
  2W.1a and ADOPT.md for retroactive onboarding of existing
  workspaces.
- `core/templates/Platform-Connection-Template.md` — **NEW.** Template
  for `sources/connections/[platform]/README.md` — platform-level
  overview with platform type, environment, connection method, cost
  model section (actual or default pricing), EXPLAIN mechanism, and
  default pricing reference table. Used during onboarding to scaffold
  platform-level stubs. Distinct from `Source-Connection-Template.md`,
  which is for Level 1 project/instance connections beneath a platform.

### Core (changed — consumer projects should update)

- `core/workflows/analytics-workspace.md` — **CHANGED.** Plan phase
  for both Tier 1 and Tier 2 workflows now references onboarding-
  scaffolded files at `sources/connections/[platform]/README.md` as
  the source of platform configuration and cost model data. Default
  cost estimate note updated to reference onboarding as the initial
  capture point.
- `core/Document-Catalog.md` — **CHANGED.** New entry for Platform
  Connection (`sources/connections/[platform]/README.md`) under
  analytics-workspace documents. Existing `sources/connections/*.md`
  entry clarified to describe Level 1 project/instance stubs beneath
  the platform README. Quick Reference analytics-workspace section
  updated. Templates section gains `Platform-Connection-Template.md`.

### Root (changed — consumer projects should update)

- `BOOTSTRAP.md` — **CHANGED.** Phase 2W gains new step 2W.1a
  (Platform onboarding) that points to the new
  `core/workflows/analytics-onboarding.md`. Existing step 2W.2
  updated to build on what onboarding already scaffolded rather than
  re-asking. Template copy list gains Platform-Connection-Template.
  Readiness checklist gains platform connection stub item.
- `ADOPT.md` — **CHANGED.** New section for analytics-workspace
  onboarding of existing workspaces, pointing to
  `core/workflows/analytics-onboarding.md`.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Analytics
  Workspace Workflow summary section gains one sentence noting that
  platform configuration and cost model info are pre-populated during
  workspace onboarding.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Same
  one-sentence addition as the CLAUDE.md template.

### Consumer update instructions

1. Copy new files:
   - `core/workflows/analytics-onboarding.md`
   - `core/templates/Platform-Connection-Template.md`
2. Replace `BOOTSTRAP.md` (Phase 2W section has changed)
3. Update `ADOPT.md` (new analytics-workspace onboarding section)
4. Update `core/workflows/analytics-workspace.md`
5. Update `core/Document-Catalog.md`
6. Update your integration template (CLAUDE.md or
   copilot-instructions.md)
7. Existing analytics-workspace projects with already-bootstrapped
   workspaces: run `core/workflows/analytics-onboarding.md`
   retroactively to add platform configuration, or create
   `sources/connections/[platform]/README.md` manually using the new
   Platform-Connection-Template.

---

## 0.22.0

Review-Revise Loop Redesign. Converges all three project types
(sprint-based, analytics-workspace, agentic-workflow) on a single
review-revise loop pattern: the implementer reads review reports
directly (the orchestrator routes file paths, it does not synthesize
or interpret findings), all reviewers re-check after every revision
(not just failing ones), and the cycle cap is 3 failed cycles with
orchestrator diagnosis and user intervention. This replaces the
previous split where sprint-based and agentic-workflow used
orchestrator-as-translator (max 2 cycles) while analytics-workspace
used direct-read (max 3 cycles). Codifies implementer-reviewer
pairing and implementer-validator pairing as explicit cross-cutting
framework design principles.

### New files

- `core/design-principles.md` — **NEW.** Cross-cutting framework
  design principles. Codifies implementer-reviewer pairing (every
  implementer output gets independent review before downstream
  action) and implementer-validator pairing (every implementer
  output that produces observable results gets validated against
  expected outcomes). Referenced by workflow files, agent archetypes,
  and integration templates.

### Core (changed — consumer projects should update)

- `core/workflows/dispatch-protocol.md` — **CHANGED.** Retry
  Protocol section rewritten: implementer reads review reports
  directly (orchestrator routes paths, does not synthesize),
  mandatory re-review by all evaluators after every revision, cycle
  cap increased from 2 to 3, orchestrator diagnosis protocol added
  after 3 failed cycles. Analytics-workspace variant paragraph
  removed (pattern is now universal). Added conditional `Review
  report paths` field to all implementer dispatch contracts and the
  context engineer contract.
- `core/workflows/development-workflow.md` — **CHANGED.** Completing
  a Story feedback loop (steps 10-14) rewritten to match new retry
  protocol: implementer receives review file paths instead of
  orchestrator-synthesized instructions, all evaluators re-check
  after revision, cap changed from 2 to 3, orchestrator diagnosis
  and user intervention protocol added.
- `core/workflows/agentic-workflow-lifecycle.md` — **CHANGED.** Step
  5 (Incorporate Feedback) rewritten: context engineer reads
  verifier reports directly, all three verifiers re-check after
  revision, cap changed from 2 to 3, orchestrator diagnosis and
  user intervention protocol added.
- `core/workflows/analytics-workspace.md` — **CHANGED.** Minor
  wording alignment in Review-Revise Loop section. Added
  cross-reference to `core/design-principles.md`.
- `core/agents/archetypes/implementer.md` — **CHANGED.** "What NOT
  to include in dispatch" note rewritten: implementer now reads
  review reports directly during revision. Evaluation Feedback Loop
  section rewritten to match new universal pattern. Cap changed from
  2 to 3.
- `core/agents/context-engineer.md` — **CHANGED.** "Do not provide"
  note replaced with revision dispatch section: context engineer now
  reads verifier reports directly during revision. Added `Review
  report paths` conditional field to dispatch contract.
- `core/topologies/Sprint-Contract-Pipeline.md` — **CHANGED.**
  Rollback Protocol updated: cap changed from 2 to 3 cycles,
  post-cap behavior updated to reference orchestrator diagnosis.
- `core/topologies/Sprint-Contract-Mesh.md` — **CHANGED.** Rollback
  Protocol updated: cap changed from 2 to 3, orchestrator diagnosis.
- `core/topologies/Sprint-Contract-Hierarchical.md` — **CHANGED.**
  Rollback Protocol updated: cap changed from 2 to 3, orchestrator
  diagnosis.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Completing a
  Story summary updated from "rollback protocol (max 2 retries)" to
  "review-revise loop (max 3 cycles)." Added reference to
  `core/design-principles.md` in Key Constraints.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.**
  Parallel changes to CLAUDE.md.

### Domain Language (changed — optional update)

- `Domain-Language.md` — **CHANGED.** Updated "Evaluation cycle" and
  "Retry protocol" definitions to reflect direct-read pattern and
  3-cycle cap. Updated "Structural update lifecycle" cap from 2 to 3.
  Added new terms: "Implementer-reviewer pairing,"
  "Implementer-validator pairing," "Orchestrator diagnosis."

### Wiki (changed — no consumer action needed)

- `wiki/topics/agent-model.md` — **CHANGED.** Updated retry protocol
  description from split pattern to universal pattern. Resolved
  orchestrator-as-translator open question. Added v0.22.0 and PRD-13
  to Sources.
- `wiki/topics/framework-philosophy.md` — **CHANGED.** Updated
  implementer-reviewer pairing from "planned" to "implemented."
  Added v0.22.0 and PRD-13 to Sources.
- `wiki/topics/workflow-design.md` — **CHANGED.** Updated review-
  revise loop description from split pattern to converged pattern.
  Resolved review-revise loop convergence open question. Updated
  Current State sections. Added v0.22.0 and PRD-13 to Sources.

### Consumer update instructions

1. Copy new file: `core/design-principles.md`
2. Update core workflow files: `core/workflows/dispatch-protocol.md`,
   `core/workflows/development-workflow.md`,
   `core/workflows/agentic-workflow-lifecycle.md`,
   `core/workflows/analytics-workspace.md`
3. Update agent files: `core/agents/archetypes/implementer.md`,
   `core/agents/context-engineer.md`
4. Update topology templates: `core/topologies/Sprint-Contract-Pipeline.md`,
   `core/topologies/Sprint-Contract-Mesh.md`,
   `core/topologies/Sprint-Contract-Hierarchical.md`
5. Update integration template (CLAUDE.md or copilot-instructions.md)
6. Update `Domain-Language.md` (optional but recommended)
7. Existing sprint contracts in active sprints: no change needed mid-
   sprint. New sprint contracts will pick up the updated templates.

---

## 0.21.0

Plan Persistence Alignment. Aligns the agentic-workflow planning artifact lifecycle with the pattern already established by sprint-based and analytics-workspace projects. The workflow-planner now writes its plan to a file at `docs/plans/[identifier]-plan.md` instead of producing it in conversation only. The plan file uses YAML frontmatter (status: draft/approved/executed, created date, change-request pointer) and includes an Alignment History section that captures what changed from the initial plan and why — persisting design rationale that previously evaporated in conversation. Owner pushback re-invokes the planner to revise the file (same as spec revision in sprint-based projects). Verification agents receive the plan file path in their dispatch, giving them the same independent assessment capability that sprint-based reviewers get from spec files. Introduces "change request (CR)" as the forward-going naming convention for new change requests in agentic-workflow projects (existing PRD files unchanged). After this change, all three project types follow the same lifecycle pattern: change request -> planner writes plan file -> owner reviews -> revise via planner -> approve -> implementer receives file path -> validators assess against file.

### New files

- `core/templates/System-Update-Plan-Template.md` — **NEW.** Template for the system update plan file with YAML frontmatter (status, created, change-request) and sections for file change inventory, integration point analysis, risk identification, mitigations, version bump determination, CHANGELOG draft, owner decision points, and Alignment History. Used by the workflow-planner when creating plans for agentic-workflow projects.
- `docs/plans/.gitkeep` — **NEW.** Creates the plan file directory for Fabrika itself (eating its own cooking). Consumer agentic-workflow projects should also create this directory if it does not already exist (sprint-based projects already have `docs/plans/`).

### Core (changed — consumer agentic-workflow projects should update)

- `core/agents/workflow-planner.md` — **CHANGED.** Output contract changed from conversation-only to file at `docs/plans/[identifier]-plan.md`. Planning Procedure step 9 updated to write file using the System-Update-Plan template. Added re-invocation procedure for alignment feedback: planner reads existing plan file, revises in place, appends to Alignment History section. Dispatch contract updated: change request field description broadened, new conditional `Existing plan path` field for re-invocation.
- `core/workflows/agentic-workflow-lifecycle.md` — **CHANGED.** Step 1 (Plan) output changed from "Structured plan in conversation" to plan file at `docs/plans/`. Step 2 (Align) added revision procedure: orchestrator re-invokes planner with feedback, planner revises file and updates Alignment History, orchestrator updates status to approved. Step 4 (Verify) clarified that agents receive plan file path. Step 7 (Ship) added sub-step 1: update plan status to executed. Agent Roster note updated from "PRDs" to "change requests."
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Workflow Planner output expected changed from conversation to file path. Added conditional `Existing plan path` field for re-invocation. Context Engineer `Approved plan` field changed from "The plan approved by the owner" to file path reference. Methodology Reviewer, Structural Validator, and Context Architect `Approved plan` fields changed from "The system update plan" to file path references.
- `core/agents/context-engineer.md` — **CHANGED.** Dispatch contract `Approved plan` description updated to reference plan file path.
- `core/agents/methodology-reviewer.md` — **CHANGED.** Dispatch contract `Approved plan` description updated to reference plan file path.
- `core/agents/structural-validator.md` — **CHANGED.** Dispatch contract `Approved plan` description updated to reference plan file path.
- `core/agents/context-architect.md` — **CHANGED.** Dispatch contract `Approved plan` description updated to reference plan file path.
- `core/Document-Catalog.md` — **CHANGED.** System Update Plan entry updated from conversation-based to file-based with template reference, YAML frontmatter details, status lifecycle, and Alignment History description. Quick Reference agentic-workflow section updated from "(in conversation)" to file path. Templates section added `System-Update-Plan-Template.md` for agentic-workflow.
- `core/briefings/structural-plan-briefing.md` — **CHANGED.** Updated opening description from "it is not a separate file" to describe the plan as a file at `docs/plans/[identifier]-plan.md`.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Agentic-Workflow Lifecycle summary updated to describe persistent plan files, planner re-invocation on pushback, and plan file path in verifier dispatch. Methodology-based agent table updated: workflow-planner description changed from "expands PRDs/change requests" to "expands change requests into plan files."
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes: Agentic-Workflow Lifecycle summary and methodology-based agent table updated identically to CLAUDE.md.

### Domain Language (changed — optional update)

- `Domain-Language.md` — **CHANGED.** Updated Structural update lifecycle definition to describe plan file output and status lifecycle. Added three new terms: Change request (CR), System update plan (persistent file), and Alignment history.

### Wiki (changed — no consumer action needed)

- `wiki/topics/workflow-design.md` — **CHANGED.** Plan persistence open question marked as resolved (v0.21.0). Added key decision entry for plan persistence alignment. Updated Current State agentic-workflow section with plan file details. Added v0.21.0 to CHANGELOG versions and PRD-12 to PRDs in Sources.

### Consumer update instructions

Projects on 0.20.x should:

**Changed files (agentic-workflow projects — update from Fabrika source):**
1. Copy `core/templates/System-Update-Plan-Template.md` (new file)
2. Update `core/agents/workflow-planner.md`
3. Update `core/workflows/agentic-workflow-lifecycle.md`
4. Update `core/workflows/dispatch-protocol.md`
5. Update `core/agents/context-engineer.md`
6. Update `core/agents/methodology-reviewer.md`
7. Update `core/agents/structural-validator.md`
8. Update `core/agents/context-architect.md`
9. Update `core/Document-Catalog.md`
10. Update `core/briefings/structural-plan-briefing.md`
11. Update your integration template (CLAUDE.md or copilot-instructions.md)
12. Create `docs/plans/` directory if it does not exist (sprint-based projects already have this)

**Optional updates (all projects):**
13. Update `Domain-Language.md` if you reference Fabrika's framework vocabulary

**No action required for:**
- Sprint-based projects (no changes to sprint-related workflow)
- Analytics-workspace projects (no changes to analytics-related workflow)

---

## 0.20.1

README accuracy and Ship step README check. Updates README.md to reflect the current v0.20.0 framework state — agent count (28, up from 13), project type categories (adds methodology-based/agentic-workflow), feature list (adds dispatch protocol, Design Alignment, Domain Language, wiki knowledge layer, briefing system, graduated testing, task promotion), document catalog size (90+, up from 60+), and workflow description. Adds a README verification sub-step to the Ship step of the agentic-workflow lifecycle so the README is checked for staleness on every structural update. Adds a README accuracy check to the CLAUDE.md verification checklist so verification agents flag drift during Step 4.

### Core (changed — consumer agentic-workflow projects should update)

- `core/workflows/agentic-workflow-lifecycle.md` — **CHANGED.** Added sub-step 5 to Step 7 (Ship): verify README.md still reflects current framework state after changes. Existing sub-steps unchanged.

### Repo root (changed — no consumer action needed)

- `README.md` — **CHANGED.** Updated to reflect v0.20.0 state: 28 agents across 7 archetypes (was 13 across 4), 90+ document types (was 60+), added methodology-based project type category with agentic-workflow, updated analytics-workspace description to tiered pre-execution review (was linear lifecycle), added 7 missing feature descriptions (dispatch protocol, Design Alignment, Domain Language, wiki knowledge layer, briefing system, graduated testing, task promotion), updated "How it works" section with Design Alignment step, dispatch protocol, testing approaches, knowledge synthesis, and wiki.

### Operational docs (changed — no consumer action needed)

- `CLAUDE.md` (project-level, gitignored) — **CHANGED.** Added README accuracy check to verification checklist.

### Consumer update instructions

Projects on 0.20.0:

**Optional update (agentic-workflow projects):**
1. Update `core/workflows/agentic-workflow-lifecycle.md` — adds README verification sub-step to Ship. No-op if your project has no README.md.

**No action required for:**
- Sprint-based projects (no changes to sprint-related files)
- Analytics-workspace projects (no changes to analytics-related files)
- All other files (no changes)

---

## 0.20.0

Analytics Pre-Execution Review. Replaces the analytics-workspace's linear task lifecycle with a tiered workflow that reviews all code before execution. Two tiers: Tier 1 (local data — logic review before execution) and Tier 2 (production data — logic review, metadata query execution, performance review, and cost approval before main query execution). Stakes classification (low/medium/high) scales review intensity within tiers independently of the tier itself. Adds analysis planner validation mode (brief check), human-facing validation report, DDL/DML detection in the logic reviewer, source freshness assessment, side-effect checking, Domain Language and data dictionary integration across analytics agents, and an analytics-workspace-specific review-revise loop (implementer reads reviews directly, 3-cycle cap). The review-revise loop for analytics workspace differs from the sprint-based retry protocol: the implementer reads review reports directly rather than receiving orchestrator-synthesized summaries.

### Core (changed — consumer analytics-workspace projects should update)

- `core/workflows/analytics-workspace.md` — **CHANGED.** Replaced 6-step linear task lifecycle with tiered pre-execution review workflow. Added Pre-Workflow Assessment section (tier/stakes/brief-type classification). Added Tier 1 and Tier 2 workflow definitions with full phase-by-phase details. Added Stakes Classification table. Added Platform-Specific EXPLAIN Mechanisms table with default cost models. Added DDL/DML Detection section with severity-by-environment table. Added Domain Language and Data Dictionary Integration section. Added Source Freshness section (date distributions + source registry cadence). Added Human-Facing Validation Report section. Added Task Folder Structure with new artifacts. Added Review-Revise Loop section (implementer reads reviews directly, 3-cycle cap). Added Exploratory Iteration and Handoff section. Updated Knowledge Pipeline Cadence to reference "the Deliver phase" instead of "step 6 in the task lifecycle."
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Added three new dispatch contracts: Data Analyst Write-Only Mode (contextual tier), Data Analyst Execute-Metadata Mode (contextual tier), and Analysis Planner Validation Mode (strict tier with 7-item review checklist). Updated Logic Reviewer contract with data dictionary and Domain Language conditional fields and pre-execution context note. Updated Performance Reviewer Analytics Workspace contract with execution manifest required field, pre-execution context note, and platform-specific assessment guidance. Updated Data Validator contract with data dictionary and Domain Language conditional fields. Updated Data Validator contract output to include both internal evaluation report and human-facing validation report. Added analytics-workspace variant paragraph to Retry Protocol section (3-cycle cap, implementer reads reviews directly).
- `core/agents/data-analyst.md` — **CHANGED.** Added Domain Language and data dictionary orientation step. Added Modes section (write-only, execute-metadata, revision). Added DDL/DML awareness to Behavioral Rules. Updated Implementation Process to note write-only mode for analytics-workspace.
- `core/agents/logic-reviewer.md` — **CHANGED.** Added pre-execution context note to Orientation. Added checklist section 7 (DDL/DML Detection with severity-by-environment table). Added checklist section 8 (Metadata Query Consistency for Tier 2). Added checklist section 9 (Term Usage against Domain Language and data dictionary).
- `core/agents/performance-reviewer.md` — **CHANGED.** Added Execution Manifest Review section with schema verification, EXPLAIN plan assessment, cost assessment, and platform-specific guidance (cloud vs on-prem). Added pre-execution context note to Analytics Workspace orientation.
- `core/agents/data-validator.md` — **CHANGED.** Added checklist section 7 (Side-Effect Check). Added checklist section 8 (Source Freshness via date distributions and source registry cadence). Restructured Output section to include both internal evaluation report and human-facing validation report. Added Domain Language and data dictionary orientation step (step 4) for term definitions, expected column distributions, known quality issues, and refresh cadence. Changed "all six checks" to "all checks" in Validation Intensity to avoid stale count.
- `core/agents/analysis-planner.md` — **CHANGED.** Added Domain Language orientation step (step 4). Added Validation Mode section with full dispatch contract, 7-item review checklist, output spec, and escalation protocol.
- `core/Document-Catalog.md` — **CHANGED.** Added three new entries to analytics-workspace section: execution-manifest.md (Tier 1, agent audience, Tier 2 only), validation-report.md (Tier 1, both audience), brief-check.md (Tier 1, agent audience). Updated analytics-workspace Quick Reference to include new documents and evaluation reports.
- `Domain-Language.md` — **CHANGED.** Updated Task lifecycle definition to reflect tiered workflow. Added six new terms: Tier (data environment classification), Stakes (review intensity classification), Execution manifest, Brief check, Validation report, Pre-execution review.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Updated Analytics Workspace Workflow section with tiered workflow summary including promotion check step. Updated analytics-workspace agent table to include performance-reviewer for Tier 2, analysis-planner validation mode, data-analyst modes, and data-validator validation report. Updated analytics-workspace project structure tree to include validation-report.md, execution-manifest.md, and performance-reviewer.md.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes for Copilot parity: tiered workflow summary with promotion check step, updated agent table, updated project structure tree.

### Consumer update instructions

Projects on 0.19.x should:

**Changed files (analytics-workspace projects — update from Fabrika source):**
1. Update `core/workflows/analytics-workspace.md` — new tiered workflow replaces linear lifecycle
2. Update `core/workflows/dispatch-protocol.md` — three new dispatch contracts, modified existing contracts, retry protocol variant
3. Update `core/agents/data-analyst.md` — new modes, DDL/DML awareness, Domain Language orientation
4. Update `core/agents/logic-reviewer.md` — DDL/DML detection, metadata query consistency, term usage
5. Update `core/agents/performance-reviewer.md` — execution manifest review, platform-specific guidance
6. Update `core/agents/data-validator.md` — side-effect check, source freshness, validation report output
7. Update `core/agents/analysis-planner.md` — validation mode, Domain Language orientation
8. Update `core/Document-Catalog.md` — new analytics-workspace document entries
9. Update your integration template (CLAUDE.md or copilot-instructions.md) — tiered workflow, updated agent table, updated project structure

**Changed files (all projects — optional update):**
10. Update `Domain-Language.md` if you reference Fabrika's framework vocabulary — new analytics workflow terms added

**No action required for:**
- Sprint-based projects (no changes to sprint-related workflow)
- Projects not using analytics-workspace type
- BOOTSTRAP.md, ADOPT.md, UPDATE.md (no changes)
- MIGRATIONS.md (no migration steps needed — all changes are additive)
- Agent archetypes (no changes)
- AGENT-CATALOG.md (no changes)

---

## 0.19.0

Wiki Knowledge Layer for Canonical Fabrika. Applies the wiki knowledge layer (defined in 0.18.0 for consumer projects) to Fabrika itself, creating a persistent, topic-organized knowledge base that captures framework design philosophy, agent model rationale, workflow evolution, cross-consumer patterns, and communication design decisions. Lighter than the consumer version — cadence is driven by system updates and alignment sessions rather than sprint maintenance. The wiki captures the "why" behind the CHANGELOG's "what," giving future sessions organized access to design rationale that previously lived only in git history and evaporating conversation context. Also adds Fabrika's own Domain Language document defining the framework's ubiquitous vocabulary (archetype, dispatch, contract, topology, etc.), distinct from the consumer Domain Language template. The Ship step (Step 7) of the structural update lifecycle now includes a wiki update sub-step: the orchestrator reviews changes and their rationale, updates relevant topic articles, and proactively flags conversation-level design rationale worth capturing.

### Repo root (new — committed to git, internal to canonical Fabrika)

- `wiki/index.md` — **NEW.** Navigational entry point to Fabrika's knowledge base. Progressive narrative overview with links to five knowledge domain topic articles, explanation of wiki cadence and relationship to other artifacts (CHANGELOG, MIGRATIONS, Domain Language), and sources summary.
- `wiki/topics/framework-philosophy.md` — **NEW.** Comprehensive synthesis of Fabrika's core design principles and their evolution from v0.1.0 through v0.18.0. Covers canonical vs. consumer separation, smell tests, context decomposition, progressive disclosure, stack-agnostic agents, bootstrap/adopt/update model, versioning discipline, and dual-audience documentation. Nine key decisions traced to specific versions.
- `wiki/topics/agent-model.md` — **NEW.** Comprehensive synthesis of the agent architecture: role-based decomposition, archetypes (Planner, Reviewer, Implementer, Coordinator, Architect, Designer, Validator), dispatch tiers (strict vs. contextual), pure orchestrator principle, specialist implementers, lightweight dispatch, architect specialists, agent maturity progression, and Domain Language integration. Eleven key decisions with version provenance.
- `wiki/topics/workflow-design.md` — **NEW.** Comprehensive synthesis of workflow patterns: 7-step structural update lifecycle, sprint lifecycle, analytics-workspace task lifecycle, dispatch protocol, design alignment, graduated testing (TDD integration), briefing system evolution, wiki knowledge pipeline, evaluation cycles, and Domain Language integration. Documents the open design question about agentic-workflow plan persistence (aligned plan is conversation-only, unlike sprint-based and analytics-workspace which persist plans as files) — slated for resolution in a future update.
- `wiki/topics/harvest-patterns.md` — **NEW.** Documents the harvest mechanism for flowing generalizable improvements from consumer projects back to canonical Fabrika. Currently sparse — mechanism is documented but no harvest data has been collected yet. Describes expected pattern categories and how findings will flow into the wiki.
- `wiki/topics/owner-preferences.md` — **NEW.** Framework-level communication design decisions: plain-language briefings, product-impact-first principle, define-terms-every-time, audience calibration, alignment protocol, narrate-and-explain, version discipline as communication contract. Framed as codified methodology choices, not personal preferences of a specific individual.
- `Domain-Language.md` — **NEW.** Fabrika's own ubiquitous language document with 70+ framework terms organized into 8 sections: Agent Model, Agent Roles, Workflow, Framework Structure, Knowledge, Versioning, Project Types, and Maintenance. Distinct from `core/templates/Domain-Language-Template.md` (the consumer template). Includes version annotations for when terms were introduced or formalized.

### Core (changed — consumer agentic-workflow projects may optionally update)

- `core/workflows/agentic-workflow-lifecycle.md` — **CHANGED.** Added conditional wiki update sub-step to Step 7 (Ship): if `wiki/` exists, review changes and their rationale, update relevant topic articles, and proactively flag conversation-level design rationale worth capturing. No-op for projects without a wiki directory. Existing step structure and numbering unchanged.
- `core/workflows/knowledge-pipeline.md` — **CHANGED.** Replaced PRD-10 forward reference in Agentic-workflow cadence section with concrete cadence definition: after system updates (Ship step), during alignment sessions, when harvest findings arrive, on demand, and reintegration after defined structural change counts. Notes that the formal 5-phase pipeline does not apply at the same cadence as sprint-based projects.
- `core/Document-Catalog.md` — **CHANGED.** Replaced PRD-10 forward reference in agentic-workflow Quick Reference knowledge layer entry with concrete cadence description (Ship step, alignment sessions, harvest, on demand).

### Operational docs (changed — no consumer action needed)

- `CLAUDE.md` (project-level, gitignored) — **CHANGED.** Added wiki update reminder to structural update protocol section (Ship step). Added "Wiki and Domain Language" section with pointers to `wiki/index.md`, `wiki/topics/`, and `Domain-Language.md`, including note distinguishing Fabrika's Domain Language from the consumer template.

### Consumer update instructions

Projects on 0.18.x:

**Optional updates (agentic-workflow projects with wiki/):**
1. Update `core/workflows/agentic-workflow-lifecycle.md` — adds conditional wiki indexing to Step 7 (Ship). No-op if your project has no `wiki/` directory.
2. Update `core/workflows/knowledge-pipeline.md` — replaces PRD-10 forward reference with concrete agentic-workflow cadence definition.
3. Update `core/Document-Catalog.md` — replaces PRD-10 forward reference with concrete guidance.

**No action required for:**
- Sprint-based projects (no changes to sprint-related files)
- Analytics-workspace projects (no changes to analytics-related files)
- Projects without a `wiki/` directory (lifecycle change is conditional)
- Integration templates (no changes to CLAUDE.md or copilot-instructions.md templates)
- BOOTSTRAP.md, ADOPT.md (no changes)
- MIGRATIONS.md (no migration steps needed — changes are additive and conditional)

---

## 0.18.0

Wiki Knowledge Layer for consumer projects. Adds a structured pipeline that automatically consolidates scattered project artifacts (ADRs, retro findings, evaluation reports, research docs) into organized, continuously updated topic articles in a `wiki/` directory. The pipeline has five phases: Extract (pull content from artifacts), Index (score salience, produce batch JSON intermediates), Synthesize (cluster by topic, write/update articles), Link (cross-reference related topics), Glossary (feed new terms back to Domain Language). Topic articles are created via a notice-and-proceed model — the agent creates and notifies the owner, proceeding unless the owner objects. The wiki serves dual audiences: humans get a progressive narrative overview from zero understanding to full context; agents get structured topic articles for on-demand domain reference. A comprehensive salience model maps all Document Catalog artifact types to S1 (high — owner-approved foundational documents), S2 (medium — reviewed workflow output), or S3 (foundational — unvalidated raw material). Sprint-based projects run Extract+Index during maintenance, Synthesize+Link every 2-3 sprints, and full reintegration quarterly. Analytics-workspace projects index after each task delivery and synthesize monthly. A backfill mechanism (Phase 0) handles one-time population for projects with existing artifacts during bootstrap, adoption, or Fabrika update, with chat-size assessment for large projects. Domain Language alignment is enforced: wiki articles use Domain Language terms, and the Glossary phase flags new concepts for addition.

### Core (new — consumer projects should copy)

- `core/workflows/knowledge-pipeline.md` — **NEW.** Full 5-phase pipeline specification: Extract, Index, Synthesize, Link, Glossary. Includes comprehensive salience model mapping all Document Catalog artifact types, cadence tables for sprint-based and analytics-workspace projects, wiki directory structure with progressive narrative index, backfill (Phase 0) specification, and design properties (batch index stability, per-domain wikis, synthesis threshold, deduplication).
- `core/workflows/knowledge-synthesis.md` — **NEW.** Step-by-step maintenance workflow for the knowledge pipeline. Covers incremental synthesis (Phases 1-2 every maintenance, Phases 3-5 when synthesis trigger met), quarterly reintegration (full pipeline with topic retirement and narrative rebuild), backfill (Phase 0 for adoption/update with chat-size assessment), and wiki knowledge usage guidance for agents (check wiki first, use during brainstorming/alignment).
- `core/templates/Wiki-Topic-Template.md` — **NEW.** Template for wiki topic articles. Sections: Summary, Key Decisions, Current State, Open Questions, Related Topics, Sources. Includes dual-audience writing guidelines, Domain Language alignment rules, synthesis threshold, and progressive depth guidance.
- `core/templates/Batch-Index-Schema.md` — **NEW.** JSON schema for batch index files (`wiki/meta/batch-YYYY-MM-DD.json`). Defines per-artifact fields (source path, type, hash, salience, extracted content, topic candidates, dedup key) and index statistics. Documents deduplication rules across and within batches.

### Core (changed — consumer projects should update)

- `core/maintenance-checklist.md` — **CHANGED.** Added "Knowledge Synthesis" section after Architecture Review with conditional gate (only runs when `wiki/` exists). Steps: identify new artifacts, run Extract+Index, check synthesis trigger, run Synthesize+Link+Glossary when triggered, run quarterly reintegration when due. Added `knowledge-synthesis-YYYY-MM-DD.md` to maintenance output files. Added knowledge synthesis line to Maintenance Summary Format.
- `core/Document-Catalog.md` — **CHANGED.** Added `wiki/` section with four entries: wiki/index.md (Tier 2), wiki/topics/ (Tier 2), wiki/meta/ (Tier 3), wiki/meta/last-reintegration.md (Tier 3). Added knowledge-synthesis-YYYY-MM-DD.md to maintenance/ section. Added Wiki-Topic-Template.md and Batch-Index-Schema.md to Templates section. Updated Quick Reference for all project types: wiki/index.md and wiki/topics/ added to Tier 2 (sprint-based), As needed (analytics-workspace), and Knowledge layer (agentic-workflow). wiki/meta/ added to Tier 3 for all types.
- `core/workflows/doc-triggers.md` — **CHANGED.** Added two trigger rows: recurring theme across 2+ artifacts during maintenance (write/update wiki topic) and wiki backfill needed (run backfill procedure with chat-size assessment).
- `core/workflows/sprint-lifecycle.md` — **CHANGED.** Added "Knowledge Pipeline Cadence" section after Sprint Lifecycle Hygiene. Documents per-sprint Extract+Index, 2-3 sprint Synthesize+Link trigger, and quarterly reintegration trigger with date-based conditional.
- `core/workflows/analytics-workspace.md` — **CHANGED.** Added "Knowledge Pipeline Cadence" section after Task Promotion. Documents per-task-delivery Extract+Index, monthly Synthesize+Link, and quarterly reintegration. Notes that Extract+Index runs automatically as part of the Deliver step when wiki/ exists.

### Root-level docs (changed — consumer projects should update if applicable)

- `BOOTSTRAP.md` — **CHANGED.** Added wiki/ to both sprint-based and analytics-workspace directory trees. Added step 1.3a "Wiki knowledge layer" with user question (default yes), directory creation, and backfill guidance. Added "Wiki" section to readiness checklist.
- `ADOPT.md` — **CHANGED.** Added "Wiki Knowledge Layer" subsection to Tier 1 (applies to all tiers). Includes user question (default yes), directory creation, backfill assessment with chat-size threshold (~30 artifacts), and manifest update.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added wiki/ to both sprint-based and analytics-workspace project structure trees. Added knowledge synthesis bullet to Maintenance Sessions summary. Added "Wiki Knowledge Layer" section with agent guidance: check wiki/index.md first for project narrative, check wiki/topics/ before grepping raw artifacts, draw on wiki during brainstorming/alignment. Includes workflow and pipeline file pointers.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes for Copilot parity: wiki/ in project structure trees, knowledge synthesis in maintenance summary, Wiki Knowledge Layer section with same agent guidance.

### Operational docs (changed — no consumer action needed)

- `MIGRATIONS.md` — **CHANGED.** Added 0.18.0 entry with wiki knowledge layer migration guidance.

### Consumer update instructions

Projects on 0.17.x should:

**New files (copy to your Fabrika path):**
1. Copy `core/workflows/knowledge-pipeline.md`
2. Copy `core/workflows/knowledge-synthesis.md`
3. Copy `core/templates/Wiki-Topic-Template.md`
4. Copy `core/templates/Batch-Index-Schema.md`

**Changed files (all projects — update from Fabrika source):**
5. Update `core/maintenance-checklist.md`
6. Update `core/Document-Catalog.md`
7. Update `core/workflows/doc-triggers.md`
8. Update your integration template (CLAUDE.md or copilot-instructions.md)

**Changed files (sprint-based projects):**
9. Update `core/workflows/sprint-lifecycle.md`

**Changed files (analytics-workspace projects):**
10. Update `core/workflows/analytics-workspace.md`

**Changed files (projects using bootstrap/adopt):**
11. Update `BOOTSTRAP.md`
12. Update `ADOPT.md`

**Wiki setup (all projects — recommended):**
13. Create `wiki/` directory with `index.md` (stub with project name), `topics/`, and `meta/` subdirectories
14. If the project has existing artifacts (ADRs, retros, eval reports, etc.), run the backfill procedure from `core/workflows/knowledge-synthesis.md` to populate the wiki. Under 30 artifacts: run inline. 30+ artifacts: run in a dedicated chat.
15. The knowledge synthesis step in maintenance will activate automatically once `wiki/` exists

**Behavioral changes (all projects with wiki/):**
16. Maintenance sessions include a Knowledge Synthesis step (after Architecture Review) that extracts+indexes new artifacts and triggers synthesis when 3+ batch indexes accumulate
17. Topic articles are created via notice-and-proceed: the agent creates and notifies, proceeding unless the owner objects
18. Quarterly reintegration runs automatically when 3+ months have elapsed, re-scoring salience and rebuilding the wiki narrative
19. The Glossary pipeline phase checks for concepts not in Domain Language and flags them for addition
20. Agents are instructed to check wiki/index.md and wiki/topics/ before grepping raw artifacts, and to draw on wiki knowledge during brainstorming and alignment conversations

---

## 0.17.0

Briefing system improvements across all three project type categories. Adds concrete translation examples to sprint-based briefings (topology choices, evaluation findings), resolves the token cost visibility conflict (the owner now sees token costs in session summaries, not just retros), and establishes a canonical token cost format using approximate model-tier ranges that survive pricing changes. Per-agent-role cost breakdowns are always included so the owner can see where tokens are being spent. Sprint retros gain a drill-down structure: sprint total prominent, per-story costs in the main table, per-agent breakdown as glossable detail underneath. Analytics-workspace gains two new briefing formats (task plan, task outcome) so analysis projects get the same structured communication as sprint-based projects. Agentic-workflow gains two new briefing formats (structural plan, change summary) codifying the informal pattern used at Steps 2 and 6 of the lifecycle. Spec briefings gain explicit guidance on explaining design alternatives in user-impact terms rather than implementation technology. All briefing formats are now listed in briefing-principles.md and both integration templates.

### Core (new — consumer projects should copy)

- `core/briefings/task-plan-briefing.md` — **NEW.** Analytics-workspace briefing format for presenting analysis plans after plan creation. Covers: business question, approach in plain language, cost estimate, assumptions and risks, jargon glossary with Domain Language integration.
- `core/briefings/task-outcome-briefing.md` — **NEW.** Analytics-workspace briefing format for presenting analysis results after task delivery. Covers: headline finding, business impact, confidence/caveats, what to look at, token efficiency with per-agent breakdown, follow-up recommendations.
- `core/briefings/structural-plan-briefing.md` — **NEW.** Agentic-workflow briefing format for Step 2 (Align). Covers: what the change does for the system, what's changing (file-by-file), open items with recommendations, what's NOT changing, execution order, jargon glossary.
- `core/briefings/change-summary-briefing.md` — **NEW.** Agentic-workflow briefing format for Step 6 (Present). Covers: what changed in the system, file-by-file summary, deviations from plan, verification results in plain language, consumer implications, token efficiency with per-agent breakdown, follow-up items.

### Core (changed — consumer projects should update)

- `core/briefings/sprint-plan-briefing.md` — **CHANGED.** Added concrete topology translation examples (before/after) for all three topologies: pipeline, mesh, hierarchical. Each example shows the technical framing to avoid and the plain-language version to use.
- `core/briefings/session-summary-briefing.md` — **CHANGED.** Added evaluation findings translation examples (before/after) showing how to translate technical findings to user-impact language. Added new "Token efficiency" section (section 6) with canonical cost format and per-agent-role breakdown. Removed the "no token counts in owner summary" restriction that contradicted the owner's preference for cost visibility.
- `core/briefings/retro-briefing.md` — **CHANGED.** Restructured "Token efficiency" section: sprint total prominent at top, per-story table with cost column, per-agent breakdown as drill-down detail underneath. Added model tier cost format. Added note on TDD stories naturally consuming more tokens across multiple red-green cycles.
- `core/briefings/spec-briefing.md` — **CHANGED.** Added technical language guidance to "Key design decisions" section: explain alternatives in user-impact terms, not implementation technology. If technical terminology is necessary, define in jargon glossary and flag for Domain Language.
- `core/briefings/briefing-principles.md` — **CHANGED.** Added analytics-workspace briefing pointers (task-plan, task-outcome) and agentic-workflow briefing pointers (structural-plan, change-summary) to "When to Brief" section. Added canonical "Token Cost Reporting" section defining the standard format: approximate model-tier ranges, always-included per-agent-role breakdown, skip-if-unavailable guidance.
- `core/workflows/analytics-workspace.md` — **CHANGED.** Added briefing references to task lifecycle: Step 2 (Plan) now references Task Plan Briefing format, Step 6 (Deliver) now references Task Outcome Briefing format.
- `core/workflows/agentic-workflow-lifecycle.md` — **CHANGED.** Step 2 (Align) now references Structural Plan Briefing format. Step 6 (Present) now references Change Summary Briefing format with verification results, consumer implications, and token efficiency.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Expanded Owner Briefings section from 5 to 9 briefing pointers: added task-plan-briefing (analytics-workspace), task-outcome-briefing (analytics-workspace), structural-plan-briefing (agentic-workflow), change-summary-briefing (agentic-workflow). Added token cost visibility note referencing briefing-principles.md canonical format.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes for Copilot parity: same 4 new briefing pointers and token cost visibility note.

### Operational docs (changed — no consumer action needed)

- `MIGRATIONS.md` — **CHANGED.** Added 0.17.0 entry with briefing system migration guidance.

### Consumer update instructions

Projects on 0.16.x should:

**New files (copy to your Fabrika path):**
1. Copy `core/briefings/task-plan-briefing.md`
2. Copy `core/briefings/task-outcome-briefing.md`
3. Copy `core/briefings/structural-plan-briefing.md`
4. Copy `core/briefings/change-summary-briefing.md`

**Changed files (all projects — update from Fabrika source):**
5. Update `core/briefings/sprint-plan-briefing.md`
6. Update `core/briefings/session-summary-briefing.md`
7. Update `core/briefings/retro-briefing.md`
8. Update `core/briefings/spec-briefing.md`
9. Update `core/briefings/briefing-principles.md`
10. Update your integration template (CLAUDE.md or copilot-instructions.md)

**Changed files (analytics-workspace projects):**
11. Update `core/workflows/analytics-workspace.md`

**Changed files (agentic-workflow projects):**
12. Update `core/workflows/agentic-workflow-lifecycle.md`

**Behavioral changes (all projects):**
13. Session summaries now include a token efficiency section with per-agent-role breakdown. The old "no token counts" restriction is removed.
14. Sprint retro token efficiency is restructured: sprint total at top, per-story costs in the table, per-agent drill-down underneath.
15. Spec briefings frame design alternatives in user-impact terms. Technical terminology is defined and flagged for Domain Language.
16. Sprint plan briefings have topology translation examples as a reference for plain-language framing.
17. Token costs use approximate model-tier ranges (high-end / mid-tier / economy) — not specific model names.

**Behavioral changes (analytics-workspace projects):**
18. Task plans are presented using the Task Plan Briefing format after plan creation.
19. Task outcomes are presented using the Task Outcome Briefing format after delivery.

**Behavioral changes (agentic-workflow projects):**
20. Step 2 (Align) uses the Structural Plan Briefing format.
21. Step 6 (Present) uses the Change Summary Briefing format.

---

## 0.16.0

TDD Integration introduces a graduated testing approach to the development workflow. Instead of a single "implement then test" flow, each sprint story is now assigned a testing approach by the scrum master during sprint planning: TDD (high complexity — spec-first tests before code, implementation in vertical slices), test-informed (medium complexity — implementer codes with awareness of test boundaries, then test-writer verifies), or test-after (low complexity — implement, then verify). The test-writer gains a spec-first mode for TDD stories: it writes behavioral tests from the approved spec without seeing code, producing tests that verify public interfaces rather than implementation details. The development workflow branches on testing approach, and sprint contracts carry the approach per story. For tools that support persistent agent sessions (Claude Code), the orchestrator reuses test-writer and implementer sessions across TDD cycles; for tools that don't (Copilot subagents), each dispatch is self-contained.

### Core (new — consumer projects should copy)

- `core/evals/baseline/validator/eval-004-spec-first-no-code.md` — **NEW.** Baseline eval case for spec-first mode: tests whether the test-writer can produce behavioral tests from a spec without reading source code. Synthetic — should be refined from real observations once projects use TDD.

### Core (changed — consumer projects should update)

- `core/agents/archetypes/validator.md` — **CHANGED.** Added Modes section defining spec-first and coverage modes. Spec-first mode: input is spec only (no source paths), output is behavioral tests against the public interface. Coverage mode: existing behavior, now explicitly labeled. Added spec-first behavioral rule: do not read or reference source code in spec-first mode.
- `core/agents/test-writer.md` — **CHANGED.** Added role description noting two modes. Added Spec-First Mode section before existing Test Writing section (now renamed to Coverage Mode): input is spec only, anti-patterns (no horizontal slicing, no implementation details, no reading source code), insufficient-spec reporting. Coverage Mode section gets a brief introductory sentence.
- `core/agents/product-manager.md` — **CHANGED.** Added optional "Test Boundaries" section to the spec template for test-informed stories. Identifies expected behaviors, I/O contracts, and edge cases so the implementer keeps interfaces testable.
- `core/agents/scrum-master.md` — **CHANGED.** Added step 6 "Assess testing approach per story" to Sprint Planning: TDD/test-informed/test-after assignment criteria, assessment questions, recording in sprint contract. Subsequent steps renumbered (old 6→7 through old 12→13). Step 10 (create sprint artifacts) updated to include testing approach from step 6.
- `core/workflows/development-workflow.md` — **CHANGED.** Replaced step 9 (dispatch to implementer) and step 10 (invoke validator) with testing approach branching: TDD flow (spec-first test-writer → implementer vertical slices → repeat → refactor → optional architect), test-informed flow (implementer → test-writer coverage → optional refactor), test-after flow (implementer → evaluation cycle). Added note on persistent agent session reuse for TDD. Updated evaluation cycle step 6 to note test-writer behavior varies by testing approach.
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Split Test Writer contract into two: "Test Writer — Spec-First Mode" (no source paths, spec is only source of truth) and "Test Writer — Coverage Mode" (existing contract, now labeled). Added conditional "Tests to pass" field to all 5 implementer contracts (Software Engineer, Data Engineer, Data Analyst, ML Engineer, AI Engineer) — required for TDD stories, includes vertical slice discipline instruction. Data Analyst field scoped to data-app projects only (not applicable to analytics-workspace tasks).
- `core/rubrics/test-rubric.md` — **CHANGED.** Added criterion #9 "Spec-First Quality" (HIGH weight, TDD stories only): Pass/Partial/Fail grading for behavioral focus, interface-level testing, implementation independence. N/A for non-TDD stories. Added N/A clarification note to Verdict Scale.
- `core/topologies/Sprint-Contract-Pipeline.md` — **CHANGED.** Added "Testing approach" field to Overview section. Updated Stage 2 Build agent description to reference testing approach flow.
- `core/topologies/Sprint-Contract-Mesh.md` — **CHANGED.** Added "Testing Approach" section with testing approach field to each per-story template block.
- `core/topologies/Sprint-Contract-Hierarchical.md` — **CHANGED.** Added "Testing Approach" section with testing approach field to each per-story template block.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added "Graduated Testing Approach" subsection to Testing Rules with TDD/test-informed/test-after descriptions and Claude Code-specific guidance (reuse agent sessions via SendMessage). Existing testing rules moved under "General Testing Rules" subheading. Updated Development Workflow summary to include testing approach branching. Updated Validator role behavior to describe spec-first and coverage modes.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes: Graduated Testing Approach in Testing Rules with Copilot-specific guidance (self-contained dispatches for subagents without session persistence). Updated Development Workflow summary.

### Operational docs (changed — no consumer action needed)

- `MIGRATIONS.md` — **CHANGED.** Added 0.16.0 entry with TDD integration migration guidance.

### Consumer update instructions

Projects on 0.15.x should:

**New files (copy to your Fabrika path):**
1. Copy `core/evals/baseline/validator/eval-004-spec-first-no-code.md`

**Changed files (all projects — update from Fabrika source):**
2. Update `core/agents/archetypes/validator.md`
3. Update `core/agents/test-writer.md`
4. Update `core/agents/product-manager.md`
5. Update `core/agents/scrum-master.md`
6. Update `core/workflows/development-workflow.md`
7. Update `core/workflows/dispatch-protocol.md`
8. Update `core/rubrics/test-rubric.md`
9. Update `core/topologies/Sprint-Contract-Pipeline.md`
10. Update `core/topologies/Sprint-Contract-Mesh.md`
11. Update `core/topologies/Sprint-Contract-Hierarchical.md`
12. Update your integration template (CLAUDE.md or copilot-instructions.md)

**Behavioral changes (all sprint-based projects):**
13. Sprint planning now assigns a testing approach per story (TDD, test-informed, or test-after). The scrum master handles this automatically.
14. The development workflow branches on testing approach. TDD stories go through RED-GREEN-REFACTOR cycles; test-informed and test-after stories follow their respective flows.
15. Sprint contracts carry a testing approach field per story. Existing sprint contracts don't need retroactive updating — the field will be added in future sprints.
16. The test-writer now has two modes. Spec-first mode activates automatically when dispatched without source paths (TDD stories). Coverage mode is the existing behavior.
17. For test-informed stories, the planner produces a Test Boundaries section in the spec. This is optional — omit for TDD and test-after stories.

---

## 0.15.0

Domain Language elevates the old Glossary (Tier 4, static, optional) to a first-class living vocabulary document (Tier 1, all project types). Each term carries a plain-language definition, a mandatory code-level name (populated at implementation), relationships to other terms, and anti-terms. Terms are captured during Design Alignment, consumed by planners and implementers via dispatch contracts, checked during code review (Terminology Consistency criterion), and audited during maintenance (Terminology Drift Check). Briefings draw their jargon glossary from Domain Language rather than inventing definitions ad hoc. For multi-type projects, domain area sections disambiguate term collisions. For analytics-workspace, Domain Language covers business vocabulary while the source registry covers data infrastructure vocabulary.

### Core (new — consumer projects should copy)

- `core/templates/Domain-Language-Template.md` — **NEW.** Template for the Domain Language document. YAML frontmatter, per-domain-area term blocks (definition, code-level name, relationships, anti-terms), cross-domain terms section, example entry. Code-level name field is mandatory — marked "not yet implemented" until the implementer builds that concept, then filled in.

### Core (changed — consumer projects should update)

- `core/Document-Catalog.md` — **CHANGED.** Replaced Glossary.md entry (Tier 4, static) with Domain-Language.md entry (Tier 1, living vocabulary with template pointer, structure description, and notes on lifecycle and multi-type usage). Added Domain-Language-Template.md to the "Always included" templates list. Updated Quick Reference for all project types: Domain Language added to Tier 1 for web-app, data-app, analytics-engineering, data-engineering, ml-engineering, ai-engineering, automation, library; added to Onboarding for analytics-workspace; added to Core for agentic-workflow.
- `core/workflows/design-alignment.md` — **CHANGED.** Expanded Terminology question category to reference Domain Language document. Added Terminology Capture subsection with instructions for collecting terms during alignment and creating/updating the Domain Language document. Updated Step 7 (Handoff) to include Domain Language creation/update step.
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Added conditional Domain Language pointer field to 10 dispatch contracts: 4 planners (Product Manager, Experiment Planner, API Designer, Analysis Planner), 5 implementers (Software Engineer, Data Engineer, Data Analyst, ML Engineer, AI Engineer), and 1 reviewer (Code Reviewer). Architect contracts already had Domain Language pointer — no change needed.
- `core/rubrics/code-review-rubric.md` — **CHANGED.** Added criterion #12 "Terminology Consistency" (MEDIUM weight) — checks code names against Domain Language, verifies implementers populated code-level names for implemented concepts. N/A when no Domain Language exists. Updated N/A note in Verdict Scale to include Terminology Consistency.
- `core/maintenance-checklist.md` — **CHANGED.** Added "Terminology Drift Check" section between Pattern & Lint Rule Curation and Architecture Review (Conditional). Six checks: code-vs-Domain-Language naming scan, unpopulated code-level names, stale terms, missing terms from recent specs, drift resolution, and logging. Conditional — skipped when no Domain Language exists. Added terminology drift line to Maintenance Summary Format.
- `core/workflows/doc-triggers.md` — **CHANGED.** Added two trigger rows: new domain concept emergence (add to Domain Language, create from template if needed) and code naming divergence from Domain Language (flag for terminology alignment).
- `core/briefings/briefing-principles.md` — **CHANGED.** Expanded the "Define terms" principle to reference Domain Language as the canonical source for jargon glossary definitions. Briefings draw from Domain Language when it exists; new terms are flagged for addition.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added Domain Language pointer to Project Basics section. Added Domain Language to Design Alignment section (created/updated during alignment, code-level names populated during implementation). Added Domain Language consistency instruction to Doc Standards section.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes to Claude Code template: Domain Language in Project Basics, Design Alignment, and Doc Standards sections.

### Root-level docs (changed — consumer projects should update)

- `BOOTSTRAP.md` — **CHANGED.** Added Domain-Language-Template.md to the "Always copy" template list. Added Domain Language creation to Tier 1 document creation step (populate from brain dump or create minimal placeholder for Design Alignment).

### Operational docs (changed — no consumer action needed)

- `MIGRATIONS.md` — **CHANGED.** Added 0.15.0 entry with Glossary-to-Domain-Language migration guidance.

### Consumer update instructions

Projects on 0.14.x should:

**New files (copy to your Fabrika path):**
1. Copy `core/templates/Domain-Language-Template.md`

**Changed files (all projects — update from Fabrika source):**
2. Update `core/Document-Catalog.md`
3. Update `core/workflows/design-alignment.md`
4. Update `core/workflows/dispatch-protocol.md`
5. Update `core/rubrics/code-review-rubric.md`
6. Update `core/maintenance-checklist.md`
7. Update `core/workflows/doc-triggers.md`
8. Update `core/briefings/briefing-principles.md`
9. Update your integration template (CLAUDE.md or copilot-instructions.md)
10. Update `BOOTSTRAP.md`

**Domain Language creation (all projects):**
11. If an existing `docs/00-Index/Glossary.md` exists: migrate to `docs/00-Index/Domain-Language.md` (see MIGRATIONS.md for detailed steps)
12. If no Glossary exists: create `docs/00-Index/Domain-Language.md` from the template during the next Design Alignment session or a dedicated terminology extraction session

**Behavioral changes:**
- Briefings draw jargon glossary definitions from Domain Language when it exists
- Code review checks terminology consistency (criterion #12 — N/A if no Domain Language)
- Maintenance checks terminology drift (skipped if no Domain Language)
- Implementers populate code-level names during implementation
- Planners reference Domain Language terms in specs when the document exists

---

## 0.14.0

Design Alignment protocol, Project Charter, and PRD document types. The orchestrator now has a structured requirements-gathering protocol that captures design intent in durable documents before sprint planning begins. Brain dumps no longer go directly to story creation; they flow through Design Alignment to produce a Project Charter (once per project) and PRDs (per phase/feature), which the scrum master then decomposes into sprint stories. Analytics-workspace gets a lighter version for complex analyses that produces an enhanced Analysis Brief instead of Charter/PRD. Scope drift is caught at retro and maintenance checkpoints via Story-to-PRD traceability.

### Core (new — consumer projects should copy as needed)

- `core/workflows/design-alignment.md` — **NEW.** Orchestrator protocol for structured requirements gathering. Triggers: new project, new phase, ambiguity detected, owner request. Covers question categories, convergence checks, project-type branching (sprint-based produces Charter/PRD, analytics-workspace produces enhanced Analysis Brief), architect review of PRD Module Changes section, and fresh-chat handoff to sprint planning.
- `core/templates/Project-Charter-Template.md` — **NEW.** Template for the Project Charter: problem space, target user, core capabilities, key constraints, success criteria, exclusions, design principles. Created once at project inception via Design Alignment.
- `core/templates/PRD-Template.md` — **NEW.** Template for PRD documents: problem statement, solution, user stories, module changes (architect-reviewed), implementation decisions, testing decisions, out of scope, open questions. Created per phase/feature via Design Alignment.

### Core (changed — consumer projects should update)

- `core/Document-Catalog.md` — **CHANGED.** Added Project Charter (Tier 1, all sprint-based + agentic-workflow) and PRD (Tier 1, per phase/feature) entries. Updated Phase Definitions and Vision & Positioning descriptions to clarify relationship triad. Updated Quick Reference for all project types.
- `core/workflows/doc-triggers.md` — **CHANGED.** Added triggers for Project Charter (new project, major pivot), PRD (new phase, major feature), and Design Alignment initiation.
- `core/workflows/sprint-lifecycle.md` — **CHANGED.** Added `alignment` cycle phase value. Added pre-sprint phase showing Design Alignment before planning. Added fresh-chat boundary prompt at Charter/PRD approval.
- `core/workflows/development-workflow.md` — **CHANGED.** Added Design Alignment section before sprint planning. Updated sprint planning to reference PRD as scrum master input. Documented document hierarchy: brain dump → alignment → Charter/PRD → sprint planning → specs → implementation.
- `core/workflows/analytics-workspace.md` — **CHANGED.** Added Design Alignment trigger for complex analyses (3+ sources, multiple stakeholders, novel domain, >2 day effort, significant decision). Output is enhanced Analysis Brief, not Charter/PRD.
- `core/agents/scrum-master.md` — **CHANGED.** Sprint planning now reads approved PRD for story decomposition. Sprint retro now checks for PRD drift (compares completed stories against active PRD). Updated dispatch contract reference for conditional PRD pointer.
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Added conditional PRD pointer field to Scrum Master Sprint Planning contract.
- `core/maintenance-checklist.md` — **CHANGED.** Added Story-to-PRD Traceability check: verify active stories trace to active PRDs, flag orphans and stale PRD sections.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added Design Alignment section in development workflow. Added Project Charter and PRD to document hierarchy and project structure. Updated session lifecycle with `alignment` cycle phase and fresh-chat boundary. Updated sprint planning references for PRD input.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes to Claude Code template.

### Root-level docs (changed — consumer projects should update)

- `BOOTSTRAP.md` — **CHANGED.** Integrated Design Alignment into bootstrap flow. New projects now begin with Design Alignment (step 2.7) after brain dump to produce Charter + first PRD before epic/story creation. Added `docs/01-Product/PRDs/` to folder structure. Updated analytics-workspace section with Design Alignment note.

### Operational Docs (changed — no consumer action needed)

- `MIGRATIONS.md` — **CHANGED.** Added 0.14.0 entry.

### Consumer update instructions

Projects on 0.13.x should:

**New files (copy to your Fabrika path):**
1. Copy `core/workflows/design-alignment.md`
2. Copy `core/templates/Project-Charter-Template.md`
3. Copy `core/templates/PRD-Template.md`

**Changed files (all sprint-based + agentic-workflow projects):**
4. Update `core/Document-Catalog.md`
5. Update `core/workflows/doc-triggers.md`
6. Update `core/workflows/sprint-lifecycle.md`
7. Update `core/workflows/development-workflow.md`
8. Update `core/workflows/dispatch-protocol.md`
9. Update `core/agents/scrum-master.md`
10. Update `core/maintenance-checklist.md`
11. Update your integration template (CLAUDE.md or copilot-instructions.md)
12. Update `BOOTSTRAP.md`

**Changed files (analytics-workspace projects):**
13. Update `core/workflows/analytics-workspace.md`

**New directories to create:**
14. Create `docs/01-Product/PRDs/` directory in your project

**Behavioral change:** The orchestrator no longer creates epics/stories directly from brain dumps. All new work flows through Design Alignment to produce a Charter/PRD, then the scrum master decomposes the approved PRD into sprint stories. Existing projects should run a retroactive Design Alignment session to produce a Charter and PRDs for current/past phases (see MIGRATIONS.md for adoption guidance).

### Known gaps (to be addressed in future versions)

- ADR to PRD update signal chain (when an ADR contradicts a PRD's Module Changes, the PRD should be flagged for update). Planned for 0.15.0+ alongside Domain Language (PRD-06).
- BOOTSTRAP.md integration with Design Alignment will mature as the protocol is used in practice.

---

## 0.13.0

Architect archetype with two specialist agents. The architect evaluates and improves structural design — module depth, interface simplicity, component boundaries, dependency structure. Two specialists: software-architect (web-app, automation, library, ai-engineering) covers code architecture; data-architect (data-engineering, analytics-engineering, data-app, ml-engineering) covers schema design, pipeline topology, and data flow boundaries. The archetype stub from 0.10.0 is replaced with a full definition covering the shared behavioral contract: standardized Ousterhout/Pocock vocabulary, dual dispatch tiers (contextual for design, strict for review), owner-gated proposals, and done thresholds. Domain-specific expertise lives in each specialist agent, not the archetype. Architect invocation is integrated at three points in the development workflow: after spec approval (design review), during evaluation (structural assessment supplement to code-reviewer), and ad hoc (owner-initiated assessment of existing code). Spiral mitigation ensures architecture reviews don't create infinite optimization loops: conditional maintenance trigger, owner-gated proposals, done thresholds, assessment tracking, and a cap of 2 refactor stories per review. The code-review rubric gains a Module Depth / Interface Simplicity criterion as a lightweight first-pass structural check.

### Core (new — consumer projects should copy as needed)

- `core/agents/software-architect.md` — **NEW.** Architect for web-app, automation, library, ai-engineering. Evaluates module depth, interface design, dependency structure, seam stability, and component boundaries. Three modes: design (reviews proposed modules), review (evaluates implemented changes), ad hoc (assesses existing codebase). Includes calibration examples (SOUND, CONCERNS, UNSOUND) and 8-step evaluation procedure. Uses Architect archetype as base.
- `core/agents/data-architect.md` — **NEW.** Architect for data-engineering, analytics-engineering, data-app, ml-engineering. Evaluates schema design, pipeline topology, storage layering, query patterns, and data flow boundaries. Three modes matching software-architect. Includes calibration examples specific to data architecture and 8-step evaluation procedure. Uses Architect archetype as base.

### Core (changed — consumer projects should update)

- `core/agents/archetypes/architect.md` — **CHANGED.** Full archetype definition replacing the 0.10.0 stub. Scoped to the shared behavioral contract only: role definition, domain specialization model (3 specialists), standardized vocabulary (8 Ousterhout/Pocock terms), base tool profile, dual dispatch tiers, output contract (SOUND/CONCERNS/UNSOUND verdicts, proposals with done thresholds), base behavioral rules (propose never implement, owner-gated, deletion test). Domain-specific evaluation criteria removed from archetype and placed in specialist agent files.
- `core/agents/AGENT-CATALOG.md` — **CHANGED.** Added Architect column to Sprint-Based Types mapping table (software-architect for web-app/automation/library/ai-engineering, data-architect for data-engineering/analytics-engineering/data-app/ml-engineering). Added Architect column to Task-Based Types table (none for analytics-workspace). Added 2 new rows to Agent Files table (software-architect.md, data-architect.md). Updated agent maturity note for 0.13.0.
- `core/workflows/development-workflow.md` — **CHANGED.** Added 3 architect invocation points: step 6 (optional design review after spec approval), step 8 (optional structural evaluation during evaluation cycle), and new "Architecture Assessment (Ad Hoc)" section for owner-initiated or orchestrator-detected structural review. Step numbers adjusted accordingly.
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Added 6 new dispatch contracts: Software Architect (Design Mode — Contextual, Review Mode — Strict, Ad Hoc — Contextual) and Data Architect (Design Mode — Contextual, Review Mode — Strict, Ad Hoc — Contextual). Data Architect contracts include domain-specific conditional fields (Data Model, Pipeline Design, Source/Serving Contracts).
- `core/rubrics/code-review-rubric.md` — **CHANGED.** Added criterion #11 "Module Depth / Interface Simplicity" (MEDIUM weight) — lightweight structural check by the code-reviewer, with guidance to invoke the architect agent for deep analysis. Updated existing note to reference architect relationship.
- `core/maintenance-checklist.md` — **CHANGED.** Added "Architecture Review (Conditional)" section between Pattern & Lint Rule Curation and Token Usage Review. Includes conditional trigger (major feature, owner request, code-reviewer structural flag, or 3 sprints since last review), assessment tracking log at `docs/maintenance/architecture-tracking.md`, and spiral mitigation (max 2 refactor stories per review). Added architecture review line to Maintenance Summary Format.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added Architect row to Sprint-based subagents table with software-architect and data-architect specialization. Added Architect role behavior description. Updated Development Workflow summary with architect invocation points and Architecture Assessment (Ad Hoc) workflow. Added architecture review to Maintenance Sessions summary.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes to Claude Code template: Architect in subagent table, updated workflow summary with architect invocation points and ad hoc workflow, architecture review in maintenance summary.

### Operational Docs (changed — no consumer action needed)

- `MIGRATIONS.md` — **CHANGED.** Added 0.13.0 entry.

### Consumer update instructions

Projects on 0.12.x should:

**New files (copy the architect agent for your project type):**

| Your project type(s) | Copy this agent |
|---|---|
| web-app, automation, library | `core/agents/software-architect.md` |
| ai-engineering | `core/agents/software-architect.md` |
| data-engineering, analytics-engineering | `core/agents/data-architect.md` |
| data-app, ml-engineering | `core/agents/data-architect.md` |

Multi-type projects: copy both architect agents if your types span both categories.

**Changed files (all projects — update from Fabrika source):**
1. Update `core/agents/archetypes/architect.md` — full archetype replacing stub
2. Update `core/agents/AGENT-CATALOG.md` — new Architect columns and Agent Files rows
3. Update `core/workflows/development-workflow.md` — architect invocation points (design review, evaluation supplement, ad hoc)
4. Update `core/workflows/dispatch-protocol.md` — 6 new architect dispatch contracts
5. Update `core/rubrics/code-review-rubric.md` — new Module Depth / Interface Simplicity criterion (#11)
6. Update `core/maintenance-checklist.md` — new Architecture Review (Conditional) section with spiral mitigation
7. Update your integration template (CLAUDE.md or copilot-instructions.md) — Architect in subagent tables, architect invocation points in workflow summary, architecture review in maintenance summary

**New file to create (all projects):**
8. Create `docs/maintenance/architecture-tracking.md` (empty initially — populated during first architecture review maintenance session)

---

## 0.12.0

Implementer archetype, pure orchestrator, and full agent maturity. The orchestrator is now a pure dispatcher — it never writes production code, even for trivial tasks. Five specialist implementer agents cover all project types: software-engineer (web-app, automation, library), data-engineer (data-engineering, analytics-engineering), data-analyst (analytics-workspace, data-app), ml-engineer (ml-engineering), ai-engineer (ai-engineering). The development workflow is rewritten so "Starting a Story" dispatches to the appropriate implementer after spec approval, and the evaluation feedback loop routes through the orchestrator-as-translator pattern rather than direct fixes. Lightweight dispatch provides reduced-ceremony invocation for trivial changes without reverting to orchestrator implementation. Multi-domain story support is added with task decomposition, per-domain sessions, and integration verification. All five agentic-workflow agents (workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect) are fleshed out from stubs to full implementations with detailed procedures, calibration examples, and context window hygiene. The product-manager and scrum-master gain domain scope assessment guidance for identifying and managing cross-domain stories.

### Core (new — consumer projects should copy as needed)

**New implementer agents (all project types):**
- `core/agents/software-engineer.md` — **NEW.** Implementer for web-app, automation, library. Domain expertise: web frameworks, APIs, CLI tools, package design, backward compatibility. Uses Implementer archetype as base.
- `core/agents/data-engineer.md` — **NEW.** Implementer for data-engineering, analytics-engineering. Domain expertise: pipeline construction, dbt models, orchestration, source/serving contracts, data quality at stage boundaries. Uses Implementer archetype as base.
- `core/agents/data-analyst.md` — **NEW.** Implementer for analytics-workspace, data-app. Domain expertise: SQL, analysis scripts, notebook structure, dashboard/visualization code, advisory mode for GUI tools. Uses Implementer archetype as base.
- `core/agents/ml-engineer.md` — **NEW.** Implementer for ml-engineering. Domain expertise: training pipelines, feature engineering, model serving, experiment management, evaluation harnesses. Uses Implementer archetype as base.
- `core/agents/ai-engineer.md` — **NEW.** Implementer for ai-engineering. Domain expertise: LLM integration, prompt engineering, RAG pipelines, guardrails/safety, eval harnesses, cost optimization. Uses Implementer archetype as base.

### Core (changed — consumer projects should update)

- `core/agents/archetypes/implementer.md` — **CHANGED.** Full archetype definition replacing the 0.10.0 stub. Added: domain specialization model (5 specialists mapped to project types), full vs. lightweight dispatch distinction, cross-domain dispatch protocol, refactor handling, evaluation feedback loop (orchestrator-as-translator pattern), expanded behavioral rules, context window hygiene.
- `core/agents/AGENT-CATALOG.md` — **CHANGED.** Added Implementer column to Sprint-Based Types and Task-Based Types mapping tables. Added 5 new rows to Agent Files table (software-engineer, data-engineer, data-analyst, ml-engineer, ai-engineer). Updated agent maturity note to reflect 0.12.0 status.
- `core/workflows/development-workflow.md` — **CHANGED.** Major rewrite. "Starting a Story" now dispatches to implementer instead of implementing directly. Added lightweight dispatch path and cross-domain story handling. "Completing a Story" rewritten with orchestrator-mediated feedback loop (orchestrator translates evaluator findings into implementer fix instructions). Added "Multi-Domain Story Completion" section with per-task sessions and integration verification.
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Added Lightweight Dispatch section defining the reduced-ceremony path. Replaced generic Implementer contract with 5 per-specialist dispatch contracts (Software Engineer, Data Engineer, Data Analyst, ML Engineer, AI Engineer) with domain-specific conditional fields. Rewrote Retry Protocol with orchestrator-as-translator pattern.
- `core/agents/methodology-reviewer.md` — **CHANGED.** Fleshed out from stub. Added: evaluation procedure with step-by-step process for each of 6 criteria, calibration examples (PASS / PASS WITH NOTES / FAIL), context window hygiene, detailed sub-checks for cross-reference consistency and contract verification.
- `core/agents/structural-validator.md` — **CHANGED.** Fleshed out from stub. Added: verification procedures with mechanical checks for each of 8 items, structured output format (per-check results table, summary statistics, blocking findings), calibration examples (PASS and 4 distinct FAIL scenarios), context window hygiene.
- `core/agents/workflow-planner.md` — **CHANGED.** Fleshed out from stub. Added: orientation steps, 9-step planning procedure, plan quality criteria, calibration examples (GOOD / BAD / EDGE CASE), context window hygiene.
- `core/agents/context-engineer.md` — **CHANGED.** Fleshed out from stub. Added: orientation steps, 8-step implementation procedure, quality criteria, calibration examples, context window hygiene.
- `core/agents/context-architect.md` — **CHANGED.** Fleshed out from stub. Added: orientation steps, 8-step evaluation procedure, assessment quality criteria with verdict calibration, calibration examples (SOUND / CONCERNS / UNSOUND), context window hygiene.
- `core/agents/product-manager.md` — **CHANGED.** Added domain scope assessment step to Planning Mode. When expanding a story, the planner now checks domain scope and produces a Task Decomposition section for multi-domain stories with interface contracts.
- `core/agents/scrum-master.md` — **CHANGED.** Added domain scope assessment step to Sprint Planning. The scrum-master now evaluates stories for domain scope during planning and recommends decomposition for 3+ domain stories.
- `core/workflows/agentic-workflow-lifecycle.md` — **CHANGED.** Updated agent maturity note to reflect 0.12.0 status (all agents at full maturity, 5 specialist implementers added).

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added Implementer row to Sprint-based and Task-based Subagents tables with all 5 specialists. Added Implementer role behavior description. Updated Development Workflow summary to reflect implementer dispatch. Added pure-orchestrator constraint to Key Constraints.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes to Claude Code template: Implementer in subagent tables, updated workflow summary, pure-orchestrator constraint.

### Operational Docs (changed — no consumer action needed)

- `BOOTSTRAP.md` — **CHANGED.** Updated Phase 2 agent installation to include implementer agent for the project type. Updated readiness checklist.
- `MIGRATIONS.md` — **CHANGED.** Added 0.12.0 entry.

### Consumer update instructions

Projects on 0.11.x should:

**New files (copy the implementer agent(s) for your project type):**

| Your project type(s) | Copy this agent |
|---|---|
| web-app, automation, library | `core/agents/software-engineer.md` |
| data-engineering, analytics-engineering | `core/agents/data-engineer.md` |
| analytics-workspace, data-app | `core/agents/data-analyst.md` |
| ml-engineering | `core/agents/ml-engineer.md` |
| ai-engineering | `core/agents/ai-engineer.md` |

Multi-type projects: copy all implementer agents that match your types.

**Changed files (all projects — update from Fabrika source):**
1. Update `core/agents/archetypes/implementer.md` — full archetype replacing stub
2. Update `core/agents/AGENT-CATALOG.md` — new Implementer columns and Agent Files rows
3. Update `core/workflows/development-workflow.md` — pure orchestrator rewrite (behavioral change: orchestrator no longer implements)
4. Update `core/workflows/dispatch-protocol.md` — 5 specialist contracts replace generic Implementer, lightweight dispatch, revised retry protocol
5. Update your integration template (CLAUDE.md or copilot-instructions.md) — Implementer in subagent tables, pure-orchestrator constraint

**Changed files (agentic-workflow projects — update from Fabrika source):**
6. Update `core/agents/methodology-reviewer.md` — fleshed out from stub
7. Update `core/agents/structural-validator.md` — fleshed out from stub
8. Update `core/agents/workflow-planner.md` — fleshed out from stub
9. Update `core/agents/context-engineer.md` — fleshed out from stub
10. Update `core/agents/context-architect.md` — fleshed out from stub
11. Update `core/workflows/agentic-workflow-lifecycle.md` — maturity note update

**Changed files (all sprint-based and task-based projects):**
12. Update `core/agents/product-manager.md` — domain scope assessment in planning mode
13. Update `core/agents/scrum-master.md` — domain scope assessment in sprint planning

**Behavioral change (important):** The development workflow now requires the orchestrator to dispatch all implementation work to implementer agents. The orchestrator no longer writes production code directly. This changes how the orchestrating session works — instead of implementing features, it dispatches to the appropriate implementer and mediates the feedback loop between evaluators and implementers. Lightweight dispatch handles trivial changes with reduced ceremony but still routes through an implementer agent.

---

## 0.11.0

Apply agentic-workflow to canonical Fabrika. Fabrika now eats its own cooking — it follows the agentic-workflow structural update lifecycle instead of a separate governance document. Three new specialized agent stubs complete the agentic-workflow agent roster: workflow-planner (planner), context-engineer (implementer), and context-architect (architect). The legacy SYSTEM-UPDATE.md protocol is retired; Fabrika's structural update instructions now live in the project-level CLAUDE.md, which points to the standard agentic-workflow lifecycle. All subsequent PRDs (03-10) execute through the agentic-workflow process.

### Core (new — consumer projects should copy as needed)

**New agents (agentic-workflow type):**
- `core/agents/workflow-planner.md` — **NEW.** Stub planner for agentic-workflow structural changes. Expands PRDs and change requests into structured implementation plans with file inventories, integration point analysis, risk identification, and version bump determination. Uses Planner archetype as base. Full detail in PRD-03.
- `core/agents/context-engineer.md` — **NEW.** Stub implementer for agentic-workflow structural changes. Writes methodology artifacts — agent prompts, workflow definitions, instruction files, catalog entries, integration templates, hooks. Uses Implementer archetype as base. Full detail in PRD-03.
- `core/agents/context-architect.md` — **NEW.** Stub architect for agentic-workflow structural changes. Evaluates instruction decomposition, pointer patterns, context budgets, integration surface completeness. Uses Architect archetype as base. Full detail in PRD-03.

### Core (changed — consumer projects should update)

- `core/agents/AGENT-CATALOG.md` — **CHANGED.** Updated Methodology-Based Types mapping table: workflow-planner replaces product-manager as planner, context-engineer and context-architect replace archetype references for implementer and architect. Added three new rows to Agent Files table. Updated agent maturity note to reflect 0.11.0 status.
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Added three new dispatch contracts: Workflow Planner (Contextual tier), Context Engineer (Contextual tier), Context Architect (Strict tier — renamed from "Architect — Agentic-Workflow"). Updated methodology-reviewer verification checklist reference to use generic project instruction file pointer instead of SYSTEM-UPDATE.md reference.
- `core/workflows/agentic-workflow-lifecycle.md` — **CHANGED.** Updated agent roster table: workflow-planner, context-engineer, context-architect replace product-manager and archetype placeholders. Updated agent maturity note.
- `core/agents/methodology-reviewer.md` — **CHANGED.** Updated dispatch contract verification checklist field to reference project instruction file instead of SYSTEM-UPDATE.md.

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Updated methodology-based types Subagents table with workflow-planner, context-engineer, and context-architect replacing product-manager and archetype placeholders.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes to Claude Code template.

### Operational Docs (changed — no consumer action needed)

- `BOOTSTRAP.md` — **CHANGED.** Updated Phase 2A.1 agentic-workflow agent installation to include all five agents (workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect). Updated readiness checklist to list all five agents. Updated note about shared agents (scrum-master only, since workflow-planner now fills the planner role).
- `MIGRATIONS.md` — **CHANGED.** Added 0.11.0 entry.
- `.gitignore` — **CHANGED.** Removed SYSTEM-UPDATE.md entry (file retired).
- `planning/EXECUTION-PROMPT.md` — **CHANGED.** Updated PRDs 03-10 execution prompt to reference agentic-workflow lifecycle and agent dispatch instead of SYSTEM-UPDATE.md.

### Consumer update instructions

Projects on 0.10.x should:

**New files (agentic-workflow projects — copy to your agent path):**
1. Copy `core/agents/workflow-planner.md` — new planner for agentic-workflow structural changes
2. Copy `core/agents/context-engineer.md` — new implementer for agentic-workflow structural changes
3. Copy `core/agents/context-architect.md` — new architect for agentic-workflow structural changes

**Changed files (all projects — update from Fabrika source):**
4. Update `core/agents/AGENT-CATALOG.md` — new agent entries and updated agentic-workflow mapping table
5. Update `core/workflows/dispatch-protocol.md` — three new dispatch contracts, renamed architect contract, updated verification checklist references
6. Update `core/workflows/agentic-workflow-lifecycle.md` — updated agent roster table
7. Update `core/agents/methodology-reviewer.md` — updated dispatch contract reference
8. Update your integration template (CLAUDE.md or copilot-instructions.md) — updated agentic-workflow Subagents table

---

## 0.10.0

Agentic-workflow project type, implementer and architect archetypes. Defines a new project type for systems where the methodology itself is the product — agent prompts, workflow definitions, instruction files, templates. Introduces two new agent archetypes (implementer, architect) and two agentic-workflow-specific agent stubs (methodology-reviewer, structural-validator). The agentic-workflow type uses a 7-step structural update lifecycle (plan, align, execute, verify, incorporate feedback, present, ship) with three independent verification agents. Operational mode (human-driven day-to-day sessions) is opt-in and does not add agent orchestration.

### Core (new — consumer projects should copy as needed)

**New archetype templates:**
- `core/agents/archetypes/implementer.md` — **NEW.** Stub archetype for agents that write production changes against an approved plan. Contextual dispatch tier. Full tool access (read, search, create, edit, run commands). Full detail across all project types in PRD-03.
- `core/agents/archetypes/architect.md` — **NEW.** Stub archetype for agents that evaluate structural design — instruction decomposition, pointer patterns, context budgets, integration surfaces. Strict dispatch tier. Read-only tools plus report creation. Full detail across all project types in PRD-04.

**New agents (agentic-workflow type):**
- `core/agents/methodology-reviewer.md` — **NEW.** Stub reviewer for agentic-workflow structural changes. Evaluates cross-reference consistency, prompt pattern adherence, instruction decomposition quality, smell test compliance, consumer update completeness, dispatch/output contract consistency. Uses Reviewer archetype as base. Full detail in PRD-03.
- `core/agents/structural-validator.md` — **NEW.** Stub validator for agentic-workflow structural changes. Mechanically verifies file existence, version consistency, catalog accuracy, cross-reference resolution, integration template currency, pattern compliance. Uses Validator archetype as base. Full detail in PRD-03.

**New workflow:**
- `core/workflows/agentic-workflow-lifecycle.md` — **NEW.** The 7-step structural update lifecycle with agent dispatch points. Maps each step to an agent role: Step 1 (Plan) = planner, Step 3 (Execute) = implementer, Step 4 (Verify) = methodology-reviewer + structural-validator + architect. Includes operational mode description (human-driven, no agent orchestration). Defines the agent roster for agentic-workflow structural mode.

### Core (changed — consumer projects should update)

- `core/agents/AGENT-CATALOG.md` — **CHANGED.** Added Implementer and Architect to Agent Roles table (now 8 roles). Added both to Agent Archetypes table (now 7 archetypes). Added Methodology-Based Types section with agentic-workflow agent mapping table. Added methodology-reviewer and structural-validator to Agent Files table. Updated scrum-master "Used by" to include agentic-workflow.
- `core/Document-Catalog.md` — **CHANGED.** Added Methodology-Based Types to project type taxonomy. Added agentic-workflow Documents section (System Update Plan, Change Verification Report, VERSION, CHANGELOG). Added agentic-workflow to Quick Reference.
- `core/workflows/dispatch-protocol.md` — **CHANGED.** Added four new dispatch contracts: Implementer (Contextual tier), Methodology Reviewer (Strict), Structural Validator (Strict), Architect — Agentic-Workflow (Strict).

### Integrations (changed — consumer projects should update)

- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added `agentic-workflow` to Project Type enum. Added Agentic-Workflow Lifecycle section with workflow pointer. Added methodology-based types table to Subagents section. Updated archetype count from five to seven. Added Implementer and Architect to Claude Code Tool Guidance with tool sets and instruction-level constraints.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Parallel changes: added `agentic-workflow` to type enum, Agentic-Workflow Lifecycle section, methodology-based types Subagents table, updated archetype count, added Implementer and Architect to instruction-level constraints.

### Operational Docs (changed — no consumer action needed)

- `BOOTSTRAP.md` — **CHANGED.** Added `agentic-workflow` to Phase 1.2 type alignment table with signal keywords. Added agentic-workflow explanation for type confirmation. Updated multi-type note to exclude methodology-based types. Added Phase 2A (Agentic-Workflow Setup) with 7 steps: tool configuration, version tracking, structural update protocol, structural conversation, mode selection, manifest generation, readiness. Added agentic-workflow readiness checklist items.
- `MANIFEST_SPEC.md` — **CHANGED.** Added `agentic-workflow` to valid project_type values (now 10 types).
- `MIGRATIONS.md` — **CHANGED.** Added 0.10.0 entry (no migration needed — new type available, existing projects unaffected).

### Consumer update instructions

Projects on 0.9.x should:

**New files (all projects — copy as needed):**
1. Copy `core/agents/archetypes/implementer.md` and `core/agents/archetypes/architect.md` to your Fabrika path — new archetype templates for future agent creation
2. Copy `core/workflows/agentic-workflow-lifecycle.md` to your Fabrika path — reference doc for agentic-workflow projects

**New files (agentic-workflow projects only):**
3. Copy `core/agents/methodology-reviewer.md` to your agents directory
4. Copy `core/agents/structural-validator.md` to your agents directory

**Updated files (all projects):**
5. Update AGENT-CATALOG from `core/agents/AGENT-CATALOG.md` (adds implementer, architect, agentic-workflow mapping)
6. Update Document-Catalog from `core/Document-Catalog.md` (adds agentic-workflow type and documents)
7. Update dispatch-protocol from `core/workflows/dispatch-protocol.md` (adds 4 new dispatch contracts)

**Updated integration files:**
8. For Claude Code projects: update `CLAUDE.md` from `integrations/claude-code/CLAUDE.md` (adds agentic-workflow type, lifecycle pointer, subagents, tool guidance)
9. For Copilot projects: update `.github/copilot-instructions.md` from `integrations/copilot/copilot-instructions.md` (parallel changes)

**No migration needed.** The agentic-workflow type is new — existing projects are not affected. No file renames, no configuration changes required for existing sprint-based, task-based, or multi-type projects.

---

## 0.9.0

Agent archetypes, dispatch protocol, and Copilot tool declarations. Introduces five archetype templates that define base tool profiles, dispatch contracts, and output contracts for each agent role. Adds a dispatch protocol that specifies exactly what the orchestrator provides (and withholds) when invoking each sub-agent — with strict isolation for reviewers, validators, and designers, and contextual dispatch for planners and coordinators. Fixes the Copilot wildcard tool bug by documenting explicit `namespace/tool` syntax for all agent types. Establishes a retry protocol with versioned evaluation report filenames.

### Core (new — consumer projects should copy as needed)

**New archetype templates:**
- `core/agents/archetypes/planner.md` — **NEW.** Base template for planner agents. Defines contextual dispatch contract (planning mode) and strict dispatch contract (validation mode), tool profile (read + search + write/edit docs, no terminal), and base behavioral rules.
- `core/agents/archetypes/reviewer.md` — **NEW.** Base template for reviewer agents. Defines strict dispatch contract (spec + file paths + rubric only, no editorial), tool profile with two variants (with/without terminal access), createFile-only write access (no editFiles), and base review behavioral rules.
- `core/agents/archetypes/validator.md` — **NEW.** Base template for validator agents. Defines strict dispatch contract, full tool profile including editFiles (constrained to tests/ and docs/evaluations/), and base verification behavioral rules.
- `core/agents/archetypes/coordinator.md` — **NEW.** Base template for coordinator agents. Defines contextual dispatch contract, tool profile with editFiles constrained to status and backlog files, and base coordination behavioral rules.
- `core/agents/archetypes/designer.md` — **NEW.** Base template for designer agents. Defines strict dispatch contract, createFile-only write access (no editFiles, no terminal), and base design behavioral rules.

**New workflow:**
- `core/workflows/dispatch-protocol.md` — **NEW.** Per-agent dispatch contracts specifying what the orchestrator provides and withholds at each invocation point. Covers all 16 agents across planning mode, validation mode, review, and coordination invocations. Includes retry protocol with versioned report filenames (v2, v3) and maximum 2 retry cycles.

### Core (changed — consumer projects should update)

- `core/agents/AGENT-CATALOG.md` — **CHANGED.** Added Agent Archetypes section with archetype table linking to template files. Added Archetype column to Agent Files table. Added dispatch protocol pointer.
- `core/workflows/development-workflow.md` — **CHANGED.** Added Dispatch Protocol section with pointer to `core/workflows/dispatch-protocol.md`.

### Integrations (changed — consumer projects should update)

- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Added dispatch protocol and archetype pointers to Subagents section. Added Copilot Agent Configuration subsection with explicit tool declaration guidance (no wildcards), per-archetype tool reference table, example frontmatter, and instruction-level constraints per role.
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added dispatch protocol and archetype pointers to Subagents section. Added Claude Code Tool Guidance subsection with per-archetype tool sets and instruction-level constraints.

### Consumer update instructions

Projects on 0.8.x should:

**New files (all projects):**
1. Copy `core/agents/archetypes/` directory (5 files) to your Fabrika path — these are reference templates for future agent creation and tool profile documentation
2. Copy `core/workflows/dispatch-protocol.md` to your Fabrika path — the orchestrator reads this before invoking any sub-agent

**Updated files (all projects):**
3. Update AGENT-CATALOG from `core/agents/AGENT-CATALOG.md` (adds archetype column and archetypes section)
4. Update development-workflow from `core/workflows/development-workflow.md` (adds dispatch protocol pointer)

**Updated integration files:**
5. For Copilot projects: update `.github/copilot-instructions.md` from `integrations/copilot/copilot-instructions.md` (adds Copilot Agent Configuration with explicit tool lists, dispatch protocol pointer)
6. For Claude Code projects: update `CLAUDE.md` from `integrations/claude-code/CLAUDE.md` (adds Claude Code Tool Guidance, dispatch protocol pointer)

**Copilot-specific action (important):**
7. For Copilot projects: update all `.github/agents/*.agent.md` frontmatter to use explicit `namespace/tool` format instead of wildcards. See the Copilot Agent Configuration section for the tool reference and per-archetype tool lists.

---

## 0.8.0

Cost awareness, security depth, performance review, visualization design, and recurring analysis promotion. Adds three new agents (performance-reviewer, security-reviewer, visualization-designer), a task promotion workflow for graduating recurring analytics into reusable assets, cost awareness across the review pipeline, and a Threat Model document type. Expands the Cost Model document from ai-engineering only to four project types. The agent system grows from 13 to 16 agents organized by role archetype (now including supplemental reviewers and designers).

### Core (new — consumer projects should copy as needed)

**New agents:**
- `core/agents/performance-reviewer.md` — **NEW.** Supplemental reviewer for all project types. Evaluates query performance, compute cost estimation (one-off and recurring), storage impact, runtime efficiency, LLM/API cost efficiency, and scale readiness. Includes type-specific orientation for both sprint-based and analytics-workspace projects.
- `core/agents/security-reviewer.md` — **NEW.** Supplemental reviewer for web-app, data-engineering, and ai-engineering. Deep security review: authentication/session management, injection attacks (SQL, XSS, command, prompt), data exposure, authorization/access control, dependency/supply chain audit, infrastructure/deployment, data pipeline security. Prompt injection treated with same severity as SQL injection for ai-engineering.
- `core/agents/visualization-designer.md` — **NEW.** Designer for analytics-workspace, data-app, and analytics-engineering. Two modes: design (propose chart types, layouts, integration into existing dashboards) and review (evaluate clarity, accuracy, data-ink ratio, accessibility of existing visuals). Includes advisory mode for GUI tools (Tableau, Power BI). Chart type selection guide with data-relationship-to-visual-encoding table.

**New workflow:**
- `core/workflows/task-promotion.md` — **NEW.** Five-level graduation ladder for recurring analyses in analytics-workspace: Level 1 (Templatize), Level 2 (Scriptify), Level 3 (Visualize), Level 4 (Automate), Level 5 (Spin Out). Levels 1-4 stay within the current workspace. The analysis planner detects repetition patterns and initiates a structured promotion conversation with the owner. Documents the relationship between all agents during promotion.

### Core (changed — consumer projects should update)

- `core/agents/code-reviewer.md` — **CHANGED.** Added step 8 to review process: "Cost & performance (lightweight)" — flags obvious cost issues (unbounded queries, API calls in loops, missing partition filters). References performance-reviewer for deep analysis.
- `core/agents/analysis-planner.md` — **CHANGED.** Added Step 2.5 (Cost Estimate) — compute cost, API/LLM cost, total estimate, recurring cost projection before owner approves the plan. Added Step 2.6 (Promotion Check) — checks for prior similar tasks in `templates/` and `recurring/`, flags repeats, initiates promotion conversation.
- `core/agents/AGENT-CATALOG.md` — **CHANGED.** Added Supplemental Reviewer and Designer role types. Updated sprint-based and task-based mapping tables with new columns for supplemental reviewers and designers. Added performance-reviewer (all types), security-reviewer (web-app, data-engineering, ai-engineering), and visualization-designer (analytics-workspace, data-app, analytics-engineering) to agent files table.
- `core/rubrics/code-review-rubric.md` — **CHANGED.** Added criterion #9 "Cost & Performance Awareness" (MEDIUM weight) — flags unbounded queries, expensive operations in loops, missing partition filters, mismatched model selection. Includes note referencing performance-reviewer for deep analysis. Renumbered Interface Contract Compliance to #10. Added performance-reviewer relationship note after criterion #10.
- `core/workflows/analytics-workspace.md` — **CHANGED.** Updated task lifecycle: added cost estimate to Plan phase, added Promotion Check phase between Plan and Execute, added performance reviewer to Validate phase for high-compute/recurring tasks. Added Task Promotion section documenting promoted task asset locations (templates/, src/scripts/, src/queries/, recurring/).
- `core/workflows/doc-triggers.md` — **CHANGED.** Added four new triggers: Threat Model creation (new endpoint/input surface), Cost Model creation (expensive compute introduced), task promotion conversation (recurring analysis detected), visualization-designer invocation (dashboard/visual output changed).
- `core/Document-Catalog.md` — **CHANGED.** Added Threat Model document (Tier 2, web-app and ai-engineering) — attack surface enumeration with threat actors, vectors, mitigations, and status tracking. Expanded Cost Model from ai-engineering only to ai-engineering, data-engineering, analytics-engineering, and ml-engineering with type-specific structure. Updated Quick Reference: added Threat Model to web-app Tier 2 and ai-engineering Tier 2, added Cost Model to data-engineering Tier 2, analytics-engineering Tier 2, and ml-engineering Tier 2.

### Consumer update instructions
Projects on 0.7.x should:

**New agents (all projects):**
1. Copy `core/agents/performance-reviewer.md` to your agents directory (new file — applies to all project types)

**New agents (type-dependent):**
2. For `web-app` projects: copy `core/agents/security-reviewer.md` to your agents directory
3. For `data-engineering` projects: copy `core/agents/security-reviewer.md` to your agents directory
4. For `ai-engineering` projects: copy `core/agents/security-reviewer.md` to your agents directory
5. For `analytics-workspace`, `data-app`, `analytics-engineering` projects: copy `core/agents/visualization-designer.md` to your agents directory

**New workflow (analytics-workspace projects):**
6. Copy `core/workflows/task-promotion.md` to your Fabrika path (new file)
7. Create `templates/` and `recurring/` directories in your workspace root

**Updated files (all projects):**
8. Update code-reviewer agent from `core/agents/code-reviewer.md` (adds cost & performance step)
9. Update code-review rubric from `core/rubrics/code-review-rubric.md` (adds Cost & Performance Awareness criterion #9, renumbers Interface Contract to #10)
10. Update AGENT-CATALOG from `core/agents/AGENT-CATALOG.md` (adds new role types and agent mappings)
11. Update Document Catalog from `core/Document-Catalog.md` (adds Threat Model, expands Cost Model)
12. Update doc-triggers from `core/workflows/doc-triggers.md` (adds 4 new triggers)

**Updated files (analytics-workspace projects):**
13. Update analysis-planner agent from `core/agents/analysis-planner.md` (adds cost estimate and promotion check steps)
14. Update analytics-workspace workflow from `core/workflows/analytics-workspace.md` (adds cost estimate, promotion check, performance review, task promotion section)

**New documents to create (type-dependent):**
15. For `web-app` and `ai-engineering` projects: create `docs/02-Engineering/Threat Model.md` (Tier 2 — create when first public endpoint or user input surface is added)
16. For `data-engineering`, `analytics-engineering`, and `ml-engineering` projects: create `docs/02-Engineering/Cost Model.md` (Tier 2 — create when expensive compute is introduced)

---

## 0.7.0

Progressive context decomposition. Extracts phase-specific and reference-only content from the two integration instruction files (CLAUDE.md and copilot-instructions.md) into shared, tool-agnostic workflow files under `core/workflows/`. Both instruction files now carry compact inline summaries with pointers to the full workflow docs, loaded on demand when the relevant phase is active. Reduces CLAUDE.md from ~676 to ~470 lines (30%) and copilot-instructions.md from ~490 to ~347 lines (29%). The extracted files are shared between integrations, reducing maintenance burden for cross-tool content.

### Core (new — consumer projects should copy as needed)

**New workflow files (on-demand reference docs):**
- `core/workflows/sprint-lifecycle.md` — **NEW.** Full sprint lifecycle details: phase diagram, cycle phase indicator values, what each phase chat does, branch hygiene gate, sprint lifecycle hygiene rationale. Loaded on phase transitions.
- `core/workflows/development-workflow.md` — **NEW.** Complete development workflow: starting a story (spec expansion through implementation), evaluation cycle (reviewer/validator/planner with rollback protocol), sprint planning steps, ideation/grooming, research/technical discussion, bug workflow pointer. Loaded when starting story, planning, or bug work.
- `core/workflows/analytics-workspace.md` — **NEW.** Analytics workspace task lifecycle (brief → plan → execute → validate → deliver), advisory mode for GUI tools, source registry structure. Loaded for analytics-workspace project types.
- `core/workflows/hooks-reference.md` — **NEW.** Full hook inventory: git hooks (pre-commit, commit-msg, post-commit, pre-push) and tool-specific hooks (destructive git guard, protected file guard, auto-format, lock file cleanup). Includes hook discovery pointer. Loaded on demand for reference.
- `core/workflows/progress-files.md` — **NEW.** STATUS.md template with all fields, sprint progress file description, dev log format (first-person narrative, 200-500 words, content generation fuel). Loaded when writing STATUS.md or dev logs.
- `core/workflows/doc-triggers.md` — **NEW.** Full document creation trigger table (12 triggers mapping situations to document actions). Loaded on demand during development.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Replaced 6 detailed sections with compact summaries and `[FABRIKA_PATH]/core/workflows/` pointers: Sprint Lifecycle, Development Workflow, Analytics Workspace Workflow, Hooks, Progress Files (including Dev Log Format), Document Creation Triggers. ~676 → ~470 lines.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Same 6 sections replaced with identical pointer pattern. ~490 → ~347 lines.

### Consumer update instructions
Projects on 0.6.x should:
1. Copy the entire `core/workflows/` directory (6 files) to your Fabrika path
2. Update your project's CLAUDE.md or copilot-instructions.md — replace the 6 detailed sections (Sprint Lifecycle, Development Workflow, Analytics Workspace Workflow, Hooks, Progress Files, Document Creation Triggers) with the compact pointer versions from the updated integration templates
3. Replace `[FABRIKA_PATH]` in the pointers with your actual Fabrika path

**No migration needed** — this is a pure refactor. All workflow content is preserved in the extracted files; nothing was removed or changed semantically.

---

## 0.6.0

Project type taxonomy expansion. Renames `data-platform` to `analytics-engineering` and `ml-project` to `ml-engineering`. Adds four new project types: `data-engineering` (full Reis lifecycle — ingestion, storage, orchestration, serving), `ai-engineering` (LLM apps, RAG, prompt engineering, eval harnesses), `library` (reusable packages and SDKs), and `analytics-workspace` (a task-based workspace for ad hoc analysis with no sprint structure). Expands the agent system from 4 agents to 13, organized by role archetype. Ships baseline evaluation cases for all agent archetypes. Restructures bootstrap onboarding to determine project type before creating folder structure, with type-specific brain dump prompts.

### Core (new — consumer projects should copy as needed)

**New agents:**
- `core/agents/analysis-planner.md` — **NEW.** Planner for analytics-workspace. Takes vague data requests, produces structured briefs and technical plans. Includes advisory mode for GUI tools (Tableau, Power BI, Alteryx).
- `core/agents/logic-reviewer.md` — **NEW.** Reviewer for analytics-workspace. Validates SQL/Python/DAX logic — join types, filter logic, aggregation, business rules, null handling. Writes validation queries.
- `core/agents/data-validator.md` — **NEW.** Validator for analytics-workspace. Runs sanity checks on analysis output — row counts, null analysis, distribution checks, cross-references, spot-checks. Scales effort to task stakes.
- `core/agents/experiment-planner.md` — **NEW.** Planner for ml-engineering. Produces experiment designs with hypothesis, baseline, evaluation plan. Replaces product-manager for ML projects.
- `core/agents/model-evaluator.md` — **NEW.** Validator for ml-engineering. Writes evaluation harnesses, computes metrics against baselines, checks for data leakage and distribution shift. Replaces test-writer for ML projects.
- `core/agents/prompt-reviewer.md` — **NEW.** Supplemental reviewer for ai-engineering. Reviews prompt quality, safety (injection resistance), cost efficiency, and eval coverage. Works alongside code-reviewer.
- `core/agents/eval-engineer.md` — **NEW.** Validator for ai-engineering. Designs and runs LLM eval suites, tests guardrails, measures RAG quality, verifies cost projections. Replaces test-writer for AI projects.
- `core/agents/data-quality-engineer.md` — **NEW.** Validator for data-engineering. Tests data at every Reis lifecycle stage — source freshness, ingestion completeness, transformation correctness, serving SLA compliance. Replaces test-writer for DE projects.
- `core/agents/api-designer.md` — **NEW.** Planner for library projects. Designs public API surface area, versioning strategy, backward compatibility. Replaces product-manager for library projects.
- `core/agents/AGENT-CATALOG.md` — **NEW.** Maps project types to agent sets. The bootstrap process reads this to determine which agents to install.

**New templates:**
- `core/templates/Analysis-Brief-Template.md` — **NEW.** Business-layer template for analytics-workspace tasks: the question, who asked, deadline, desired output format, constraints.
- `core/templates/Analysis-Plan-Template.md` — **NEW.** Technical-layer template: data sources, step-by-step approach, key SQL/logic, assumptions, gotchas, validation approach.
- `core/templates/Outcome-Report-Template.md` — **NEW.** Delivery-layer template: summary of findings, methodology, data quality notes, output location, follow-up recommendations.
- `core/templates/Task-Contract-Template.md` — **NEW.** Lightweight contract for analytics-workspace tasks: acceptance criteria, validation requirements, scope boundaries, deliverables.
- `core/templates/Source-Connection-Template.md` — **NEW.** Documents queryable data sources: connection details, key tables, access notes, known gotchas, reliability.
- `core/templates/Source-Tool-Template.md` — **NEW.** Documents BI/ETL tools in advisory mode: key assets, data sources used, what the agent can help with, known quirks.
- `core/templates/Source-File-Template.md` — **NEW.** Documents recurring flat file sources: delivery details, file format, schema, known issues.

**New baseline evals:**
- `core/evals/baseline/README.md` — **NEW.** Explains baseline eval purpose, organization by archetype, and relationship to project-specific evals.
- `core/evals/baseline/planner/eval-001-vague-ask.md` — **NEW.** Tests that planners ask clarifying questions for ambiguous requests.
- `core/evals/baseline/planner/eval-002-scope-boundaries.md` — **NEW.** Tests that planners respect phase/scope boundaries.
- `core/evals/baseline/planner/eval-003-testable-acceptance-criteria.md` — **NEW.** Tests that planners produce specific, measurable acceptance criteria.
- `core/evals/baseline/reviewer/eval-001-obvious-bug.md` — **NEW.** Tests that reviewers catch clear logic errors.
- `core/evals/baseline/reviewer/eval-002-security-basic.md` — **NEW.** Tests that reviewers catch OWASP basics (SQL injection, etc.).
- `core/evals/baseline/reviewer/eval-003-false-positive.md` — **NEW.** Tests that reviewers don't over-flag correct code.
- `core/evals/baseline/validator/eval-001-tests-run.md` — **NEW.** Tests that validators write checks that actually execute.
- `core/evals/baseline/validator/eval-002-edge-cases.md` — **NEW.** Tests that validators cover boundary conditions.
- `core/evals/baseline/validator/eval-003-regression.md` — **NEW.** Tests that validators add regression coverage for bug fixes.
- `core/evals/baseline/coordinator/eval-001-topology-selection.md` — **NEW.** Tests correct sprint topology selection.
- `core/evals/baseline/coordinator/eval-002-scope-drift.md` — **NEW.** Tests detection of out-of-scope work during sprints.

### Core (changed — consumer projects should update)
- `core/Document-Catalog.md` — **CHANGED.** Renamed `data-platform` → `analytics-engineering`, `ml-project` → `ml-engineering`. Added document sets for `data-engineering` (Source System Contracts, Ingestion Design, Storage Architecture, Serving Contracts, Orchestration Design, DataOps Runbook), `ai-engineering` (Prompt Library, Model Configuration, RAG Architecture, Evaluation Strategy, Cost Model, Guardrails Spec), `library` (API Design Guide, Migration Guide Template, Publishing Checklist), and `analytics-workspace` (source registry, task briefs/plans/outcomes). Updated Quick Reference with all 9 types. Added analytics-workspace Documents section.
- `core/evals/README.md` — **CHANGED.** Added Baseline Evals section explaining day-one eval cases. Updated directory structure to include `baseline/` subdirectories.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Updated Project Type list from 5 types to 9. Updated transformation logic doc trigger to reference `analytics-engineering` and `data-engineering`.
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Major expansion to full parity with CLAUDE.md template. Now includes: Project Basics (type, key, stack), project structure for both sprint-based and task-based types, Backlog System, Session Lifecycle (start/work/close-out with dev log format), Sprint Lifecycle (phases, cycle phase indicator, per-phase instructions, fresh-chat rationale), full Development Workflow (story start, evaluation cycle, rollback protocol, ideation, research, bug workflow), Analytics Workspace Workflow (task lifecycle, advisory mode, source registry), Owner Briefings, Progress Files (STATUS.md format, sprint progress), Subagents table by type with Agent Catalog reference, Evaluation System (baseline + project-specific), Maintenance Sessions, Document Creation Triggers, Doc Standards, Testing Rules, Key Constraints, Fabrika Relationship. Hooks section updated but remains Copilot-specific (git hooks + instruction-based rules).

### Operational Docs (changed — no consumer action needed)
- `BOOTSTRAP.md` — **CHANGED.** Major restructure: Phase 1 now includes type alignment (1.2) before folder creation. Folder structure is type-dependent, not universal-first. Brain dump prompts are type-specific (one per type). Agent installation reads from AGENT-CATALOG.md. E2E verification table updated for all 9 types. Added Phase 2W for analytics-workspace onboarding (source inventory conversation). Readiness checklist updated with type-specific checks for all new types.
- `MANIFEST_SPEC.md` — **CHANGED.** Updated project_type allowed values from 5 to 9 types.
- `README.md` — **CHANGED.** Updated feature list (13 agents, baseline evals, 60+ docs). Replaced project type table with sprint-based and task-based sections covering all 9 types. Added Agent Catalog reference.

### Consumer update instructions
This is a major version change. Consumer projects on 0.5.x should:

**Type rename (all projects):**
1. In `.fabrika/manifest.yml`, rename `project_type`: `data-platform` → `analytics-engineering`, `ml-project` → `ml-engineering`
2. Search-and-replace old type names in project CLAUDE.md / copilot-instructions
3. No file renames needed — the document files themselves haven't changed names

**Baseline evals (all projects):**
4. Copy `core/evals/baseline/` directory to `docs/evals/baseline/`
5. Update `docs/evals/README.md` from `core/evals/README.md` (adds Baseline Evals section)

**Agent updates (type-dependent):**
6. For `ml-engineering` projects: optionally copy `experiment-planner.md` and `model-evaluator.md` to replace `product-manager.md` and `test-writer.md` in your agents directory
7. For `ai-engineering` projects: copy `prompt-reviewer.md` and `eval-engineer.md` to your agents directory
8. For `data-engineering` projects: copy `data-quality-engineer.md` to your agents directory
9. For `library` projects: optionally copy `api-designer.md` to your agents directory
10. Copy `core/agents/AGENT-CATALOG.md` to `.fabrika/AGENT-CATALOG.md` for reference
11. For Copilot users: update `.github/copilot-instructions.md` from `integrations/copilot/copilot-instructions.md` (adds project type, type-specific agent sets, analytics-workspace workflow)

**New project types (if starting new projects):**
11. New projects of type `analytics-workspace`, `data-engineering`, `ai-engineering`, or `library` should be bootstrapped fresh using the updated BOOTSTRAP.md

---

## 0.5.2

Session summary and retro briefing formats. Extends the owner briefing system (0.5.1) to cover session close-out summaries and sprint retro presentations. The agent now translates evaluation results, retro findings, and session outcomes into plain-language summaries focused on product impact, rather than telling the owner to go read raw report files.

### Core (new — consumer projects should copy)
- `core/briefings/session-summary-briefing.md` — **NEW.** Five-part briefing format for session close-out and story completion summaries. Covers: what changed in the product, key decisions, evaluation results in plain language, what to look at (if anything), what's next. Explicitly says not to send the owner to evaluation report files.
- `core/briefings/retro-briefing.md` — **NEW.** Six-part briefing format for presenting sprint retros. Covers: what the sprint accomplished, story-by-story recap, what we learned, what's changing, health check, anything needing input. Translates the dense retro artifact (eval tables, token metrics) into human-facing takeaways.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Expanded "Owner Briefings" section to include session-summary and retro briefing pointers. Updated Session Close-Out step 23, story completion step 16, and Sprint Retro chat description to reference briefing formats.

### Consumer update instructions
Projects on 0.5.1 should:
1. Copy `core/briefings/session-summary-briefing.md` and `core/briefings/retro-briefing.md` to your Fabrika briefings path (2 new files)
2. Update `CLAUDE.md` "Owner Briefings" section — add the two new pointer lines from `integrations/claude-code/CLAUDE.md`
3. In `CLAUDE.md` Session Close-Out, update step 23 to reference the Session Summary Briefing format
4. In `CLAUDE.md` Completing a Story, update step 16 to reference the Session Summary Briefing format
5. In `CLAUDE.md` Sprint Lifecycle > Sprint Retro chat, add the Retro Briefing reference

---

## 0.5.1

Owner briefing format. Adds structured plain-language briefing templates for how the orchestrating session presents specs and sprint plans to the owner. Instead of dumping raw artifacts or giving terse summaries, the agent follows a briefing format that explains what is being built, why, how it fits into the product, defines all jargon, and frames design decisions as choices the owner can push back on.

### Core (new — consumer projects should copy)
- `core/briefings/briefing-principles.md` — **NEW.** Cross-cutting principles for all owner briefings: assume the owner hasn't touched the codebase in a week, define terms even if defined before, lead with product impact not implementation, make disagreement easy.
- `core/briefings/spec-briefing.md` — **NEW.** Six-part briefing format for presenting specs after product-manager planning mode. Covers: what and why, how it works, key design decisions, jargon glossary, out of scope, open questions.
- `core/briefings/sprint-plan-briefing.md` — **NEW.** Six-part briefing format for presenting sprint plans after scrum-master planning. Covers: sprint goal, why these stories in this order, topology choice explained, jargon glossary, deferred work, risks.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added "Owner Briefings" section with pointers to the three briefing files. Updated "Starting a Story" step 5 and "Sprint Planning" step 9 to reference the briefing format.

### Consumer update instructions
Projects on 0.5.0 should:
1. Copy `core/briefings/` directory (3 files) to your Fabrika path
2. Update `CLAUDE.md` — add the "Owner Briefings" section from `integrations/claude-code/CLAUDE.md` (insert between Development Workflow and Progress Files sections)
3. In `CLAUDE.md` Development Workflow > Starting a Story, update step 5 to reference the Spec Briefing format
4. In `CLAUDE.md` Development Workflow > Sprint Planning, update step 9 to reference the Sprint Plan Briefing format

---

## 0.5.0

Deterministic enforcement layer. Expands hooks from 3 git hooks to 7 git hooks + 4 Claude Code hooks, adds hook discovery workflow for project-specific hook graduation, and cross-tool adaptation guide for Copilot/Cursor/other tools. Fixes exit code bug in mesh isolation hook (was exit 1, should be exit 2). Inspired by Daniel Williams' articles on hooks as enforcement vs. prompts as guidance.

### Core (changed — consumer projects should update)
- `core/hooks/pre-commit.sh` — **CHANGED.** Expanded from mesh-isolation-only to four checks: branch protection (blocks main/master), secret scanning (credential patterns in staged diff), STATUS.md session gate (requires STATUS.md when task lock active), mesh isolation scope (existing, exit code fixed from 1 to 2).
- `core/hooks/commit-msg.sh` — **NEW.** Validates conventional commit message format (`type(scope): description`). Blocks on mismatch. Allows merge and revert commits through.
- `core/hooks/post-commit.sh` — **CHANGED.** Updated messaging to clarify this is the advisory fallback for the pre-commit STATUS.md gate.
- `core/hooks/claude-code/guard-destructive-git.sh` — **NEW.** Claude Code PreToolUse hook. Blocks destructive git commands (force push, hard reset, checkout --, restore ., branch -D, clean -f) before execution.
- `core/hooks/claude-code/guard-protected-files.sh` — **NEW.** Claude Code PreToolUse hook. Blocks agent writes to .env, key, secret, credential, and SSH files. Defense-in-depth with permissions deny list.
- `core/hooks/claude-code/auto-format.sh` — **NEW.** Claude Code PostToolUse hook. Runs configurable `FORMAT_CMD` on files after Write/Edit. Empty by default — consumer configures during bootstrap.
- `core/hooks/claude-code/check-lock-cleanup.sh` — **NEW.** Claude Code PostToolUse hook. Warns about remaining task lock files after git commit. Advisory only.
- `core/hook-discovery-workflow.md` — **NEW.** Workflow for evaluating when recurring rule violations should graduate to mechanical hooks. Includes trigger criteria (3+ violations, high-cost single violations, user corrections), decision framework (cost assessment, mechanical checkability, hook placement), creation checklist, and anti-patterns. Placed in consumer projects at `.fabrika/hook-discovery-workflow.md`.
- `core/hook-adaptation-guide.md` — **NEW.** Cross-tool hook reference. Documents every hook conceptually (trigger, what it checks, why, blocks or advises), shows implementation per tool (Claude Code settings.json, Copilot git hooks + instructions, Cursor/Windsurf/Aider adaptation), and provides a "point your agent at this document" workflow for unsupported tools. Placed in consumer projects at `.fabrika/hook-adaptation-guide.md`.
- `core/maintenance-checklist.md` — **CHANGED.** Updated "Hook Health" section to cover all new hooks (pre-commit checks, commit-msg, Claude Code hooks, auto-format). Added "Hook Discovery" section: scan for recurring violations, run hook discovery workflow, check lint rule graduation candidates.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Rewrote Hooks section from 3-hook summary to full two-layer documentation (git hooks + Claude Code hooks) with all 11 hooks described. Added Hook Discovery subsection with pointer to `.fabrika/hook-discovery-workflow.md` and `.fabrika/hook-adaptation-guide.md`.
- `integrations/claude-code/settings-template.json` — **CHANGED.** Added `hooks` section with PreToolUse entries (guard-destructive-git on Bash, guard-protected-files on Write|Edit) and PostToolUse entries (auto-format on Write|Edit, check-lock-cleanup on Bash).
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Added "Hooks & Enforcement" section documenting git hook coverage, instruction-based equivalents for Claude Code hooks (destructive git guard, protected files, lock cleanup), auto-formatting via VS Code, and pointer to adaptation guide.

### Operational Docs (changed — no consumer action needed)
- `BOOTSTRAP.md` — **CHANGED.** Updated hook configuration section to include all new hooks (git hooks, Claude Code hooks, hook discovery workflow, adaptation guide). Updated readiness checklist to verify full hook coverage.
- `ADOPT.md` — **CHANGED.** Updated Tier 2 hook installation to include commit-msg.sh, Claude Code hooks, hook discovery workflow, adaptation guide. Added Copilot-specific hook adaptation guidance.

### Consumer update instructions
Projects on 0.4.x should:
1. Replace `.claude/hooks/pre-commit.sh` from `core/hooks/pre-commit.sh` (adds branch protection, secret scanning, STATUS.md session gate; fixes mesh isolation exit code)
2. Copy `core/hooks/commit-msg.sh` to `.claude/hooks/commit-msg.sh` (new file)
3. Replace `.claude/hooks/post-commit.sh` from `core/hooks/post-commit.sh` (updated messaging)
4. Create `.claude/hooks/claude-code/` directory
5. Copy all four files from `core/hooks/claude-code/` to `.claude/hooks/claude-code/` (new files)
6. Update `auto-format.sh` with your project's formatter command (or leave empty to disable)
7. Update `.claude/settings.json` — add the `hooks` section from `integrations/claude-code/settings-template.json`
8. Copy `core/hook-discovery-workflow.md` to `.fabrika/hook-discovery-workflow.md` (new file)
9. Copy `core/hook-adaptation-guide.md` to `.fabrika/hook-adaptation-guide.md` (new file)
10. Update `docs/02-Engineering/maintenance-checklist.md` — update "Hook Health" section and add "Hook Discovery" section (or re-copy from `core/maintenance-checklist.md` if not customized)
11. Update `CLAUDE.md` — replace the Hooks section with the expanded version from `integrations/claude-code/CLAUDE.md`
12. For Copilot users: update `.github/copilot-instructions.md` — add "Hooks & Enforcement" section from `integrations/copilot/copilot-instructions.md`
13. Install git hooks: if using `.git/hooks/` directly (not Claude Code's `.claude/hooks/`), copy the hook scripts there and `chmod +x`

---

## 0.4.0

Harness engineering patterns inspired by Ryan Leapo's talk at Laten Space London. Adds canonical patterns, structural tests, lint-as-prompts, token observability, progressive context disclosure, and agent-locality guidance. These patterns formalize the "garbage collection loop" — the flywheel where observed agent failures become durable guardrails.

### Core (changed — consumer projects should update)
- `core/Document-Catalog.md` — **CHANGED.** Added three new doc types: Canonical Patterns (Tier 1, all types), Custom Lint Rules (Tier 3), and Structural Constraints (Tier 2). Updated Quick Reference sections for all project types.
- `core/rubrics/code-review-rubric.md` — **CHANGED.** Added criterion #7 "Pattern Conformance" (MEDIUM weight) — grades implementation against `docs/02-Engineering/Canonical-Patterns.md`. N/A if the doc does not exist yet. Renumbered Security to #8, Interface Contract to #9. Added N/A handling note to verdict scale.
- `core/rubrics/test-rubric.md` — **CHANGED.** Added criterion #7 "Structural Constraint Enforcement" (MEDIUM weight) — grades whether structural constraints have mechanical enforcement. N/A if no Structural Constraints doc exists. Renumbered Test Output Quality to #8.
- `core/maintenance-checklist.md` — **CHANGED.** Added two new checklist sections: "Pattern & Lint Rule Curation" (scan for canonical patterns to document, repeated code-reviewer feedback to convert into lint rules, structural constraint enforcement verification) and "Token Usage Review" (per-story token analysis, flagging disproportionately expensive stories, comparing predicted vs actual).
- `core/agents/scrum-master.md` — **CHANGED.** Added step 6: token budget estimation per story during sprint planning (observability only, not a hard cap). Added mesh topology assessment note about repo structure supporting isolation. Renumbered steps 7-10.
- `core/agents/product-manager.md` — **CHANGED.** Reinforced that owner approval of the spec is required before implementation begins — an unreviewed plan encodes potentially bad instructions.
- `core/agents/test-writer.md` — **CHANGED.** Added "Structural Tests" section: when `docs/02-Engineering/Structural-Constraints.md` exists, write tests that enforce codebase structure rules (file length, dependency edges, schema deduplication, banned imports, naming conventions). Tests produce prompt-style error messages with remediation instructions.
- `core/templates/Sprint-Progress-Template.md` — **CHANGED.** Added "Tokens (actual)" field to per-session entry template with measurement boundary guidance (begin story to ready for approval).
- `core/templates/Sprint-Retro-Template.md` — **CHANGED.** Added "Token Efficiency" section between Agent Quality Findings and Process Changes. Compares predicted vs actual token usage per story with calibration notes.
- `core/templates/Session-Log-Template.md` — **CHANGED.** Added "Token Usage" section with actual tokens and measurement notes fields.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added "Progressive context disclosure" and "Prefer improving existing agents over adding new ones" to Key Constraints. Updated session close-out step 15 to include token logging in sprint progress file.

### Operational Docs (changed — no consumer action needed)
- `BOOTSTRAP.md` — **CHANGED.** Updated step 2.5 to include Canonical-Patterns.md creation during bootstrap (start with 3-5 patterns). Added agent-locality guidance to Architecture Overview creation (prefer directory subtrees per domain).

### Consumer update instructions
Projects on 0.3.x should:
1. Update `docs/02-Engineering/rubrics/code-review-rubric.md` — add Pattern Conformance criterion (#7), renumber remaining criteria, add N/A note to verdict scale (or re-copy from `core/rubrics/code-review-rubric.md` if not customized)
2. Update `docs/02-Engineering/rubrics/test-rubric.md` — add Structural Constraint Enforcement criterion (#7), renumber Test Output Quality to #8 (or re-copy if not customized)
3. Update `docs/02-Engineering/maintenance-checklist.md` — add "Pattern & Lint Rule Curation" and "Token Usage Review" sections (or re-copy if not customized)
4. Create `docs/02-Engineering/Canonical-Patterns.md` with 3-5 patterns for your tech stack (new file)
5. Optionally create `docs/02-Engineering/Structural-Constraints.md` with codebase structure rules (new file, Tier 2)
6. Create `docs/02-Engineering/Custom-Lint-Rules/` directory (new, populate during maintenance)
7. Update `.claude/agents/scrum-master.md` from `core/agents/scrum-master.md` (adds token estimation step + mesh assessment note)
8. Update `.claude/agents/product-manager.md` from `core/agents/product-manager.md` (adds approval reinforcement)
9. Update `.claude/agents/test-writer.md` from `core/agents/test-writer.md` (adds structural tests section)
10. Update `docs/Templates/Sprint-Progress-Template.md` (adds token tracking field)
11. Update `docs/Templates/Sprint-Retro-Template.md` (adds Token Efficiency section)
12. Update `docs/Templates/Session-Log-Template.md` (adds Token Usage section)
13. Update `CLAUDE.md` — add "Progressive context disclosure" and "Prefer improving existing agents" to Key Constraints; add token logging to session close-out step 15

---

## 0.3.1

### Operational Docs (changed — no consumer action needed)
- `UPDATE.md` — **CHANGED.** Step 1 now validates manifest format against MANIFEST_SPEC.md and regenerates non-conformant manifests in-place before proceeding. Replaces the vague "corrupted manifest → re-run ADOPT.md" guidance with specific regeneration instructions. Needed because early consumer projects have inconsistent manifest formats (wrong field names, missing hashes, map-vs-list).

---

## 0.3.0

Harvest from 4 consumer projects (Notnomo, Conduit, Social-engine, Vaultsync) on Fabrika 0.1.0. Bug tracking system, maintenance checklist improvements, scrum-master task system step, and settings permission update.

### Core (changed — consumer projects should update)
- `core/templates/Bug-Report-Template.md` — **NEW.** Structured bug report template with evaluator tracing (`missed-by`, `introduced-by`), root cause analysis sections (code trace + evaluator trace), and eval case linkage. Bugs use separate numbering from stories (BXX).
- `core/bug-workflow.md` — **NEW.** End-to-end bug fix workflow: file → root cause analysis through evaluator history → fix with regression test → create eval case for missed failure mode. Connects bugs to agent quality improvement.
- `core/maintenance-checklist.md` — **CHANGED.** Added "Evaluation Findings Sweep" section between Code Quality and Test Health. Triages non-blocking observations from evaluation reports into trivial (fix now), small (story), or speculative (someday-maybe).
- `core/agents/scrum-master.md` — **CHANGED.** Added step 7: "Create external task entries (if configured)" during sprint planning. Closes gap between CLAUDE.md template (which referenced this) and the agent prompt (which didn't have the step).

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added bug tracking system integration: `Bugs/` directory in project structure, bug numbering in Backlog System, Bug Reporting & Fix Workflow subsection in Development Workflow, bug review in Maintenance Sessions summary, bugs as ground truth in Evaluation System lifecycle, bug trigger in Document Creation Triggers table.
- `integrations/claude-code/settings-template.json` — **CHANGED.** Added `TodoWrite` to default permissions allow list.

### Consumer update instructions
Projects on 0.2.0 (or 0.1.0) should:
1. Copy `core/templates/Bug-Report-Template.md` → `docs/Templates/Bug-Report-Template.md` (new file)
2. Copy `core/bug-workflow.md` → `docs/02-Engineering/bug-workflow.md` (new file)
3. Create `docs/04-Backlog/Bugs/` directory
4. Update `docs/02-Engineering/maintenance-checklist.md` — add "Evaluation Findings Sweep" section between Code Quality and Test Health (or re-copy from `core/maintenance-checklist.md` if not customized)
5. Update `.claude/agents/scrum-master.md` from `core/agents/scrum-master.md` (if not customized; if customized, manually add step 7 and renumber)
6. Update `CLAUDE.md` — merge bug system integration points (Bugs/ in structure, bug numbering, Bug Reporting workflow, maintenance summary, evaluation system, document creation triggers)
7. Add `"TodoWrite"` to `.claude/settings.json` permissions.allow

---

## 0.2.0

Framework relationship documentation and harvest workflow improvements. Consumer projects now understand how local agent changes flow back to canonical Fabrika.

### Core (changed — consumer projects should update)
- `core/FABRIKA.md` — **NEW.** Framework relationship guide placed in consumer projects at `.fabrika/FABRIKA.md`. Explains the eval artifact → harvest → canonical update → propagation flow. Read on demand by agents, not always-loaded.
- `core/templates/Sprint-Retro-Template.md` — **CHANGED.** Added "Fabrika Eval Artifact" section with checklist item so retros can't complete without writing the eval artifact.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Replaced verbose Fabrika Relationship section with a 2-line pointer to `.fabrika/FABRIKA.md`. Reduces always-loaded context.

### Operational Docs (changed — no consumer action needed)
- `ADOPT.md` — **CHANGED.** Added merge-not-overwrite protocols for agent files, hooks, .gitignore, and Justfile. Added FABRIKA.md copy step to all tiers. Expanded conflict handling with per-file-type table.
- `BOOTSTRAP.md` — **CHANGED.** Added FABRIKA.md copy step to Phase 1.4.
- `HARVEST.md` — **CHANGED.** Added concrete "How to Run the Harvest" section with three options: copy-paste agent prompt, review system integration, and ad hoc triggers. Added "Verifying Eval Artifacts Exist" troubleshooting section.
- `CHANGELOG.md` — Updated for 0.2.0.
- `VERSION` — Bumped to 0.2.0.

### Consumer update instructions
Projects on 0.1.0 should:
1. Copy `core/FABRIKA.md` → `.fabrika/FABRIKA.md` (new file)
2. Update `docs/Templates/Sprint-Retro-Template.md` from `core/templates/Sprint-Retro-Template.md` (if not customized)
3. Update `CLAUDE.md` — replace the Fabrika Relationship section with the slim 2-line version pointing to `.fabrika/FABRIKA.md` (if the project has one; this was only added post-0.1.0 so some projects may not have it)

---

## 0.1.0

Initial public release. Agentic workflow methodology for Claude Code and GitHub Copilot.

### Core
- `core/agents/scrum-master.md` — Sprint planning, topology assessment, maintenance scheduling, retros
- `core/agents/product-manager.md` — Planning mode (spec expansion) and validation mode (acceptance criteria)
- `core/agents/code-reviewer.md` — Skeptical evaluation with grading rubrics, regression safety, topology scope enforcement
- `core/agents/test-writer.md` — Test writing, E2E verification, coverage reporting
- `core/topologies/Sprint-Contract-Pipeline.md` — Pipeline topology sprint contract template
- `core/topologies/Sprint-Contract-Mesh.md` — Mesh topology sprint contract template
- `core/topologies/Sprint-Contract-Hierarchical.md` — Hierarchical topology sprint contract template
- `core/templates/` — 11 templates: ADR, Epic, Story, Sprint, Sprint-Progress, Sprint-Retro, Session-Log, Feature-Spec, Dashboard-Spec, Data-Source-Research, Model-Design
- `core/rubrics/code-review-rubric.md` — Weighted grading criteria for code-reviewer agent
- `core/rubrics/test-rubric.md` — Weighted grading criteria for test-writer agent
- `core/hooks/` — 3 hooks: pre-push (regression gate), post-commit (STATUS.md reminder), pre-commit (mesh isolation scope)
- `core/evals/` — Evaluation harness scaffold: README, agent-changelog template, eval artifact template
- `core/Document-Catalog.md` — Full inventory of project documents by type and tier
- `core/maintenance-checklist.md` — Between-sprint maintenance session checklist
- `core/STATUS-template.md` — Project status snapshot template
- `core/features-template.json` — Agent-facing feature pass/fail tracker template
- `core/FABRIKA.md` — Framework relationship guide placed in consumer projects at `.fabrika/FABRIKA.md` (read on demand, not always-loaded)

### Integrations
- `integrations/claude-code/CLAUDE.md` — Consumer project configuration template for Claude Code
- `integrations/claude-code/settings-template.json` — Claude Code settings template
- `integrations/copilot/copilot-instructions.md` — Consumer project configuration template for GitHub Copilot

### Operational Docs
- `BOOTSTRAP.md` — Agent-driven guide for bootstrapping new projects
- `ADOPT.md` — Tiered guide for integrating Fabrika into existing projects
- `UPDATE.md` — Protocol for updating consumer projects to newer Fabrika versions
- `MANIFEST_SPEC.md` — Specification for the `.fabrika/manifest.yml` consumer projects carry
- `HARVEST.md` — Workflow for harvesting generalizable learnings from project-local agent forks
