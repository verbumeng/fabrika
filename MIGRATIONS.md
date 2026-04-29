# Migrations

When a Fabrika update requires consumer projects to do more than a straight file overwrite, the migration steps are documented here.

---

## 0.14.0 — Design Alignment + Project Charter + PRD

**Affects:** All sprint-based consumer projects and agentic-workflow projects. Analytics-workspace projects are affected only if they use Design Alignment for complex analyses.

**What changed:** The orchestrator now runs a Design Alignment protocol before sprint planning to produce durable requirements documents. Brain dumps no longer go directly to story creation — they flow through Design Alignment to produce a Project Charter (once per project) and PRDs (per phase/feature). The scrum master receives the approved PRD as primary input for story decomposition. Sprint retros check for PRD drift. The maintenance checklist gains Story-to-PRD Traceability. Analytics-workspace projects can optionally trigger Design Alignment for complex analyses, producing an enhanced Analysis Brief instead of Charter/PRD.

**Migration steps:**

1. **Copy new files.** Copy `core/workflows/design-alignment.md`, `core/templates/Project-Charter-Template.md`, and `core/templates/PRD-Template.md` to your Fabrika path.

2. **Update changed core files.** Update the following from the Fabrika source: `core/Document-Catalog.md`, `core/workflows/doc-triggers.md`, `core/workflows/sprint-lifecycle.md`, `core/workflows/development-workflow.md`, `core/workflows/dispatch-protocol.md`, `core/agents/scrum-master.md`, `core/maintenance-checklist.md`.

3. **Update changed integration and root-level files.** Update your integration template (CLAUDE.md or copilot-instructions.md) and `BOOTSTRAP.md`.

4. **Update analytics-workspace workflow** (analytics-workspace projects only). Update `core/workflows/analytics-workspace.md`.

5. **Create PRDs directory.** Create `docs/01-Product/PRDs/` in your project.

6. **Produce retroactive Charter and PRDs for existing projects.** This is the key adoption step. Run a Design Alignment session against your existing codebase and documentation:

   - **Retroactive Project Charter:** The orchestrator reads existing docs (Vision & Positioning, Phase Definitions, Architecture Overview, story history) and synthesizes them into a Project Charter at `docs/01-Product/Project-Charter.md`. This does not require the full Design Alignment question protocol — the information already exists in your docs, it just needs to be consolidated into Charter form.

   - **Retroactive PRDs for past phases:** For each completed phase, produce a lightweight PRD that documents what was built. These are retrospective — they record decisions already made, not planning documents. Place them in `docs/01-Product/PRDs/` with a naming convention like `PRD-001-[phase-name].md`.

   - **Active PRD for the current phase:** For the current active phase, produce a full PRD that functions as a planning document. This is the one the scrum master will reference for future sprint planning. If you're mid-sprint, this PRD should reflect the current state — what's been built, what remains, what the acceptance criteria are.

   The retroactive synthesis is a single-session exercise. The orchestrator does the reading and consolidation; the owner reviews and approves the result.

7. **Behavioral change.** After migration, the orchestrator no longer creates stories directly from brain dumps or ad hoc requests. New work flows through Design Alignment (when triggered) to produce or update a PRD, which the scrum master then decomposes into stories. Existing stories that are already in progress are unaffected — this applies to new work going forward.

**Why this matters:** Design Alignment catches requirements misalignment before it becomes implementation waste. The Charter provides a stable reference point that prevents scope creep across phases. PRDs create a traceable chain from requirements to stories to implementation, making retros and maintenance reviews more effective. The fresh-chat boundary between alignment and planning prevents context window bloat from carrying the full requirements conversation into sprint planning.

---

## 0.13.0 — Architect Archetype

**Affects:** All sprint-based consumer projects. Task-based projects (analytics-workspace) are not affected — no architect is assigned to that type.

**What changed:** Two architect agents (software-architect, data-architect) evaluate structural design across all sprint-based project types. The architect archetype stub from 0.10.0 is replaced with a full definition scoped to the shared behavioral contract (standardized vocabulary, dispatch tiers, output format, base rules). Domain-specific expertise lives in each specialist agent file. Architecture review is added to the maintenance checklist with conditional triggers and spiral mitigation (not every cycle, max 2 refactor stories). The code-review rubric gains a Module Depth criterion for lightweight structural assessment.

**Migration steps:**

1. **Copy the architect agent for your project type.** software-architect for web-app/automation/library/ai-engineering, data-architect for data-engineering/analytics-engineering/data-app/ml-engineering. Place in your agent directory (`.claude/agents/` or `.github/agents/`). Multi-type projects spanning both categories: copy both.

2. **Update architect archetype.** Replace `core/agents/archetypes/architect.md` — the stub is now a full definition. Note: the archetype no longer contains agentic-workflow-specific evaluation criteria (instruction decomposition, pointer patterns) — those live in context-architect.md's own file. If you have an agentic-workflow project, verify context-architect.md is self-contained (it should be if you updated to 0.12.0).

3. **Update AGENT-CATALOG.md.** New Architect column in Sprint-Based and Task-Based mapping tables. 2 new rows in Agent Files table.

4. **Update development-workflow.md.** Three new architect invocation points: optional design review after spec approval, optional structural evaluation during the evaluation cycle, and an ad hoc architecture assessment section.

5. **Update dispatch-protocol.md.** 6 new dispatch contracts for software-architect and data-architect (design mode, review mode, ad hoc — each with appropriate tier and field tables).

6. **Update code-review-rubric.md.** New criterion #11 Module Depth / Interface Simplicity (MEDIUM weight).

7. **Update maintenance-checklist.md.** New Architecture Review (Conditional) section with conditional triggers, assessment tracking, and spiral mitigation.

8. **Update your integration template** (CLAUDE.md or copilot-instructions.md). Architect in subagent tables, architect invocation points in workflow summary, architecture review in maintenance summary.

9. **Create architecture tracking log.** Create `docs/maintenance/architecture-tracking.md` (empty initially — populated during first architecture review maintenance session).

**Why this matters:** Structural design evaluation catches architectural drift — the slow accumulation of shallow modules and unstable interfaces — before it compounds into a codebase that's hard to change. The conditional trigger and spiral mitigation prevent the architect from generating infinite refactor work.

---

## 0.12.0 — Implementer Archetype + Pure Orchestrator

**Affects:** All consumer projects (sprint-based, task-based, and agentic-workflow).

**What changed:** The orchestrator is now a pure dispatcher — it never writes production code directly, even for trivial tasks. Five specialist implementer agents handle all implementation work, each carrying domain expertise for their project types. The development workflow's "Starting a Story" section dispatches to implementers instead of implementing directly. The evaluation feedback loop routes evaluator findings through the orchestrator (as translator) to the implementer rather than having the orchestrator fix issues directly. Lightweight dispatch provides a reduced-ceremony path for trivial changes while maintaining the implementer-always-implements principle. Multi-domain story support adds task decomposition with per-domain sessions and integration verification. All agentic-workflow agents (previously stubs) are fleshed out to full implementations. The product-manager and scrum-master gain domain scope assessment guidance.

**Migration steps:**

1. **Copy implementer agent(s) for your project type.** See the CHANGELOG consumer update instructions table for which agent(s) to copy. Place them in your agent directory (`.claude/agents/` or `.github/agents/`).

2. **Update development-workflow.md.** This is a behavioral change — the "Starting a Story" section and "Completing a Story" section are significantly rewritten. The orchestrator no longer implements directly. Review the new workflow and update your copy.

3. **Update dispatch-protocol.md.** The generic Implementer contract is replaced by 5 per-specialist contracts with domain-specific conditional fields. A new Lightweight Dispatch section defines the reduced-ceremony path. The Retry Protocol is rewritten with the orchestrator-as-translator pattern.

4. **Update AGENT-CATALOG.md.** New Implementer column added to Sprint-Based and Task-Based mapping tables. 5 new rows in Agent Files table.

5. **Update your integration template** (CLAUDE.md or copilot-instructions.md). Add Implementer to subagent tables and add the pure-orchestrator constraint to Key Constraints.

6. **For agentic-workflow projects:** Update all 5 agent stubs (workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect) to the full implementations.

7. **For all sprint-based/task-based projects:** Update product-manager.md (domain scope assessment in planning mode) and scrum-master.md (domain scope assessment in sprint planning).

**Why this matters:** The pure orchestrator model prevents context window degradation during implementation — the orchestrator stays focused on routing and synthesis while implementers handle domain-specific work. This also enables future domain specialization without changing the orchestration layer.

---

## 0.11.0 — Agentic-Workflow Agent Roster Completion (No Migration Needed)

**Affects:** Consumer projects using the `agentic-workflow` project type.

**What changed:** Three new specialized agent stubs were added for the agentic-workflow type: workflow-planner (planner), context-engineer (implementer), context-architect (architect). These replace the generic product-manager and archetype placeholders in the agentic-workflow agent roster. The "Architect — Agentic-Workflow" dispatch contract was renamed to "Context Architect." Verification checklist references in methodology-reviewer and structural-validator dispatch contracts were updated to point to the project's instruction file generically.

**Migration steps:** None beyond the file updates listed in the CHANGELOG. The new agents are additive — they fill previously empty slots in the agentic-workflow roster. No existing configurations break. Copy the three new agent files and update the changed files per the CHANGELOG consumer update instructions.

---

## 0.10.0 — New Project Type (No Migration Needed)

**Affects:** No existing consumer projects.

**What changed:** A new project type `agentic-workflow` was added for systems where the methodology itself is the product. Two new agent archetypes (implementer, architect) and two agentic-workflow-specific agents (methodology-reviewer, structural-validator) were introduced.

**Migration steps:** None. This is a purely additive change. Existing projects of any type continue to work without modification. The new type is only relevant when bootstrapping new agentic-workflow projects.

---

## 0.6.0 — Type Taxonomy Rename

**Affects:** All consumer projects using `data-platform` or `ml-project` as their project type.

**What changed:** `data-platform` was renamed to `analytics-engineering`. `ml-project` was renamed to `ml-engineering`.

**Migration steps:**
1. Update `.fabrika/manifest.yml` — change the `project_type` field value
2. Search your project CLAUDE.md (or copilot-instructions.md) for the old type name and replace it
3. No document file renames are needed — the documents themselves (Data Pipeline Design, Transformation Logic, Model Design, etc.) keep the same names and paths

**Why:** The rename better describes the discipline each type covers. "Data platform" was vague and could mean many things. "Analytics engineering" precisely describes building modeled data layers with dbt/DuckDB. "ML engineering" aligns with the other engineering-discipline types.
