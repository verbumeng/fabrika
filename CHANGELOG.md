# Changelog

All notable changes to Fabrika are documented here.

Format: each version lists changed files and the nature of the change. Consumer projects use the CHANGELOG to determine which files need updating (see UPDATE.md).

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
