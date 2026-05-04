---
type: system-update-plan
change-request: planning/CR-22-agents-as-composable-skills.md
status: approved
created: 2026-05-04
---

# System Update Plan: CR-22 Agents as Composable Skills

CR-22 is the structural mechanism that makes workflow composition
work. It does eight things: dissolves the three project type
categories, formalizes the skills model, creates domain workflow files
for all current project types, decomposes development-workflow.md
(shared execution mechanics to a new story-execution protocol, domain
content to domain workflow files, then deletes the original),
decomposes the dispatch protocol, renames analytics-workspace to
analytics-workflow (file and concept), liberates cross-cutting
procedures from category binding, and updates the framework
vocabulary.

## Scope Decisions

Per the CR's alignment note #4, execution is phased:

**Executed now (0.32.0):**
- Category dissolution (prerequisites for CR-29 and CR-23)
- Skills model formalization (structural relationship between base
  agents and specialized agents)
- Dispatch protocol decomposition (1,097 lines; context decomposition
  principle demands it)
- Analytics-workspace rename to analytics-workflow (file rename from
  `analytics-workspace.md` to `analytics-workflow.md`, concept rename,
  MIGRATIONS entry)
- Analytics-onboarding rename to analytics-workflow-onboarding (file
  rename from `analytics-onboarding.md` to
  `analytics-workflow-onboarding.md` for consistency)
- Development-workflow decomposition: extract shared story execution
  mechanics to new `core/workflows/protocols/story-execution.md`,
  distribute domain-specific content to the 7 domain workflow files,
  then DELETE `development-workflow.md` from the codebase
- Domain workflow creation for ALL current project types (7 files
  covering all 8 sprint-based types plus the pattern for composition)
- Agent prompt file updates: grep and update all 30+ agent files that
  contain category language or stale "project type" references
- Procedure liberation assessment and reclassification
- Domain Language, integration templates, README, BOOTSTRAP updates
- All integration point syncs

**Deferred:**
- Calibration key migration to skill-based keys (forward-compatible
  by design, per CR alignment note #5)

**Note on calibration data:** Calibration actuals should have been
recorded after CRs 17-21 and were not. The orchestrator must record
actuals at Step 7 of this CR and consider backfilling estimates for
the prior CRs based on session logs if available.

---

## File Change Inventory

### New files

| File | Purpose |
|------|---------|
| `core/workflows/protocols/story-execution.md` | Shared story execution mechanics extracted from the former development-workflow.md. Contains: story-start orientation, dispatch protocol reference, tier-conditional branching (Patch/Story/Deep Story paths), freshness-aware context loading, testing approach branching, evaluation cycle, multi-domain story completion, bug workflow reference, architecture assessment (ad hoc), ideation/grooming, research. This is the execution protocol for work at story complexity or above, regardless of domain. Referenced by all 7 domain workflow files. NOT about "sprint-based development" — the universal complexity spectrum (CR-18) applies to all work. |
| `core/workflows/types/software-development-workflow.md` | Domain workflow for software development projects (web-app, automation). Self-contained for its domain: names the domain, provides agent roster table (product-manager, code-reviewer, test-writer, software-engineer, software-architect + security-reviewer supplemental for web-app), references `story-execution.md` for shared execution mechanics, specifies domain-specific gates (security review for web-app), and testing approach guidance. |
| `core/workflows/types/data-engineering-workflow.md` | Domain workflow for data-engineering projects. Self-contained: agent roster (product-manager, code-reviewer, data-quality-engineer, data-engineer, data-architect), domain-specific gates (environment progression gates, layer ownership model), references `story-execution.md` for shared execution mechanics. |
| `core/workflows/types/analytics-engineering-workflow.md` | Domain workflow for analytics-engineering projects. Self-contained: agent roster (product-manager, code-reviewer, test-writer, data-engineer, data-architect), domain-specific gates (transformation validation, migration parity checks), references `story-execution.md` for shared execution mechanics. |
| `core/workflows/types/data-app-workflow.md` | Domain workflow for data-app projects. Self-contained: agent roster (product-manager, code-reviewer, test-writer, data-analyst, data-architect), domain-specific gates (dashboard spec validation, visualization review), references `story-execution.md` for shared execution mechanics. |
| `core/workflows/types/ml-engineering-workflow.md` | Domain workflow for ml-engineering projects. Self-contained: agent roster (experiment-planner, code-reviewer, model-evaluator, ml-engineer, data-architect), domain-specific gates (experiment loops, model evaluation criteria), references `story-execution.md` for shared execution mechanics. |
| `core/workflows/types/ai-engineering-workflow.md` | Domain workflow for ai-engineering projects. Self-contained: agent roster (product-manager, code-reviewer/prompt-reviewer, eval-engineer, ai-engineer, software-architect), domain-specific gates (prompt review, eval harness, RAG assessment), references `story-execution.md` for shared execution mechanics. |
| `core/workflows/types/library-workflow.md` | Domain workflow for library projects. Self-contained: agent roster (api-designer, code-reviewer, test-writer, software-engineer, software-architect), domain-specific gates (API surface review, backward compatibility checks), references `story-execution.md` for shared execution mechanics. |
| `core/workflows/protocols/dispatch/planner-contracts.md` | Per-archetype dispatch contracts for all planner agents (base planner, product-manager, experiment-planner, api-designer, analysis-planner, workflow-planner) — both planning and validation modes. Extracted from dispatch-protocol.md. |
| `core/workflows/protocols/dispatch/reviewer-contracts.md` | Per-archetype dispatch contracts for all reviewer agents (base reviewer, code-reviewer, logic-reviewer, prompt-reviewer, security-reviewer, performance-reviewer, methodology-reviewer). Extracted from dispatch-protocol.md. |
| `core/workflows/protocols/dispatch/validator-contracts.md` | Per-archetype dispatch contracts for all validator agents (base validator, test-writer, data-quality-engineer, model-evaluator, eval-engineer, data-validator, structural-validator). Extracted from dispatch-protocol.md. |
| `core/workflows/protocols/dispatch/implementer-contracts.md` | Per-archetype dispatch contracts for all implementer agents (base implementer, software-engineer, data-engineer, data-analyst, ml-engineer, ai-engineer, agentic-engineer). Extracted from dispatch-protocol.md. |
| `core/workflows/protocols/dispatch/architect-contracts.md` | Per-archetype dispatch contracts for all architect agents (software-architect, data-architect, context-architect) — design, review, and ad-hoc modes. Extracted from dispatch-protocol.md. |
| `core/workflows/protocols/dispatch/coordinator-contracts.md` | Dispatch contracts for coordinator agents (scrum-master — sprint planning and retro modes). Extracted from dispatch-protocol.md. |
| `core/workflows/protocols/dispatch/designer-contracts.md` | Dispatch contracts for designer agents (visualization-designer — design and review modes). Extracted from dispatch-protocol.md. |

### Modified files

| File | Change |
|------|--------|
| `core/agents/AGENT-CATALOG.md` | Remove three-category organization (Sprint-Based Types / Task-Based Types / Methodology-Based Types tables). Replace with a unified model: agents organized by archetype and skill level (base agents vs. domain specializations). Formalize the skill relationship: base agents carry skills, specialized agents carry parameterized skills. Rename "analytics-workspace" references to "analytics workflow". Update "Base Agents and Workflow Types" section to become the primary organizational framing rather than an addendum. |
| `core/Document-Catalog.md` | Remove three-category organization from "How to Use This Catalog" (Sprint-Based Types / Task-Based Types / Methodology-Based Types tables). Replace with a unified "Workflow Types" table where each type is listed without category grouping. Rename "analytics-workspace" to "analytics workflow" throughout. Update the Quick Reference section to remove category headers. Update the multi-type restriction note (task-based and methodology-based cannot combine with sprint-based) to reflect the composition model. |
| `core/workflows/types/development-workflow.md` | **DELETED.** Fully decomposed: shared story execution mechanics (story-start orientation, dispatch protocol reference, tier-conditional branching, freshness-aware context loading, testing approach branching, evaluation cycle, multi-domain story completion, bug workflow reference, architecture assessment, ideation/grooming, research) extracted to new `core/workflows/protocols/story-execution.md`. Domain-specific content (agent rosters, domain-specific gates, testing approach details) distributed to the 7 domain workflow files. Sprint ceremony already lives in sprint-coordination.md. After extraction, nothing remains — the file is deleted from the codebase. |
| `core/workflows/types/analytics-workflow.md` (renamed from `analytics-workspace.md`) | Rename file from `analytics-workspace.md` to `analytics-workflow.md`. Rename concept from "analytics-workspace" to "analytics workflow" in all headings, descriptions, and self-references. Update header to "Analytics Workflow" and adjust the first line to reflect the compositional framing. Add MIGRATIONS entry for the file path change. |
| `core/workflows/types/task-workflow.md` | Update the introductory paragraph to strengthen the skills model framing: the task workflow is not merely "the base" — it IS the unparameterized workflow. Specialized workflows (analytics, domain workflows, agentic) add domain knowledge to this foundation. Add a section or note establishing the three-tier abstraction (skill, workflow type, project). Remove lingering references to "task-based types" category language. |
| `core/workflows/protocols/dispatch-protocol.md` | Decompose from monolithic 1,097-line file into a hub document (~150-200 lines) that contains: dispatch tiers (strict/contextual/lightweight), tier-conditional dispatch tables, retry protocol, output format constraints, and pointers to per-archetype contract files in `core/workflows/protocols/dispatch/`. The per-agent contracts move to their respective archetype files. The hub remains the entry point that workflow files and integration templates reference. |
| `core/workflows/protocols/sprint-coordination.md` | Update references from "sprint-based project types" to complexity-triggered language. Remove category-bound language. Sprint coordination is a PROCEDURE, not a workflow — it activates when a project's work includes story-type or epic-type backlog items, regardless of which domain workflow is installed. Add trigger mechanism documentation: the orchestrator assesses need at bootstrap (from Design Alignment output), at adopt/add-workflow (from backlog complexity), and mid-project (when growing complexity is detected). Installation is proposed by the orchestrator, approved by the owner. |
| `core/workflows/protocols/design-alignment.md` | Update references from category-specific triggers to workflow-agnostic triggers. Remove "analytics-workspace" naming, use "analytics workflow". |
| `core/workflows/protocols/token-estimation.md` | Reclassify as cross-cutting procedure. Add a note clarifying this is workflow-agnostic — referenced by all workflow types, not owned by any one workflow. |
| `core/workflows/protocols/knowledge-pipeline.md` | Same cross-cutting reclassification note. |
| `core/workflows/protocols/knowledge-synthesis.md` | Same cross-cutting reclassification note. |
| `core/workflows/protocols/task-promotion.md` | Update "analytics-workspace" references to "analytics workflow". |
| `core/workflows/protocols/analytics-workflow-onboarding.md` (renamed from `analytics-onboarding.md`) | Rename file from `analytics-onboarding.md` to `analytics-workflow-onboarding.md` for consistency with analytics-workflow rename. Update "analytics-workspace" references to "analytics workflow" throughout. Triggers when a project ADDS the analytics workflow, not only at initial bootstrap. |
| `core/workflows/protocols/doc-triggers.md` | Update references from project type categories to workflow types. Rename "analytics-workspace" to "analytics workflow". |
| `core/workflows/protocols/hooks-reference.md` | Update any project-type-category references to workflow-type language. |
| `core/agents/agentic-engineer.md` | Update "project type" reference to "workflow type" language. |
| `core/agents/logic-reviewer.md` | Update "analytics-workspace" reference to "analytics workflow". |
| `core/agents/workflow-planner.md` | Update "project types" references in calibration/examples to "workflow types". |
| `core/agents/data-analyst.md` | Update all "analytics-workspace" references (6 occurrences) to "analytics workflow". |
| `core/agents/visualization-designer.md` | Update "analytics-workspace" and "sprint-based" references to workflow type language. |
| `core/agents/structural-validator.md` | Update "project types" references to "workflow types". |
| `core/agents/performance-reviewer.md` | Update "analytics-workspace" references to "analytics workflow". |
| `core/agents/archetypes/architect.md` | Update "project type categories" reference to workflow type language. |
| `core/agents/archetypes/implementer.md` | Update "project types" reference and "analytics-workspace" to workflow type language. |
| `core/agents/archetypes/designer.md` | Update "sprint-based" references to workflow type language. |
| `core/agents/archetypes/planner.md` | Update "sprint-based" and "analytics" references to workflow type language. |
| `core/agents/archetypes/reviewer.md` | Update "sprint-based" references to workflow type language. |
| `core/agents/archetypes/validator.md` | Update "sprint-based" references to workflow type language. |
| `core/agents/agent-frontmatter-spec.md` | If it references project type categories, update to workflow type language. |
| `BOOTSTRAP.md` | Replace the Phase 2 / Phase 2W / Phase 2A branching with a unified onboarding flow. The branch point in Phase 1 currently routes based on project type category; replace with workflow type assessment. Phase 2W becomes "Analytics Workflow Onboarding". Phase 2A remains structurally similar but uses composition framing. Remove all "sprint-based types," "task-based types," "methodology-based types" language. Rename "analytics-workspace" throughout. Update file path references from `analytics-workspace.md` to `analytics-workflow.md` and from `analytics-onboarding.md` to `analytics-workflow-onboarding.md`. Update the type alignment table in 1.2 to remove category groupings. Update the readiness checklists. |
| `ADOPT.md` | Update project type category references to workflow types. Rename "analytics-workspace" to "analytics workflow". Update file path references for renamed files. |
| `UPDATE.md` | Update any project type category references. |
| `HARVEST.md` | Update any project type category references. |
| `ADD-WORKFLOW.md` | Update to reflect the skills model. Rename "Analytics Workflow" section to use the new terminology. When adding a domain workflow: install the workflow's bundled procedures (e.g., analytics-workflow-onboarding always comes with analytics workflow), and assess whether sprint coordination is needed based on the project's work complexity. Sprint coordination can also be added independently of any workflow addition — it is complexity-triggered, not workflow-bundled. Update file path references. |
| `Domain-Language.md` | Add new terms: skill (the capability an agent exercises in one invocation — the agent carries the skill, the workflow invokes agents with their skills in sequence), workflow type (strengthen existing entry), process (named vocabulary, no current structural expression), procedure/SOP. Update existing terms: agent (add skill relationship — the agent HAS a skill, the agent is not "a skill"), roster (reframe as "the agents with their skills invoked by a workflow type"), specialist (reframe as "an agent carrying a parameterized skill"), base agent (reframe as "an agent carrying the unparameterized skill"), analytics-workspace project (rename to "analytics workflow"), sprint-based project (reframe around workflow composition), multi-type project (update to composition framing), Agent Catalog (update to skill-organized framing). Retire: "task-based project" as a category label (the task workflow exists; the category does not). Retire: "methodology-based project" as a category label. |
| `integrations/claude-code/CLAUDE.md` | Remove three-category Subagents organization (Sprint-based types / Task-based types / Methodology-based types). Replace with a unified agent table organized by archetype with domain specialization notes. Rename "analytics-workspace" throughout. Update the Project Type field comment to list all types without category grouping. Update the Workflow Composition section to reference the skills model. Update Analytics Workspace Workflow section heading and content to "Analytics Workflow". Update file path references. |
| `integrations/copilot/copilot-instructions.md` | Same changes as CLAUDE.md integration template. |
| `README.md` | Update the Project types section to remove three-category headers (Sprint-based types / Task-based types / Methodology-based types). Present all types in a single table as workflow types. Update the agent count if it changes. Update the feature list to mention the skills model. Rename "analytics-workspace" references. |
| `MANIFEST_SPEC.md` | Update any project type category references. |
| `VERSION` | Bump from `0.31.0` to `0.32.0`. |
| `CHANGELOG.md` | Add 0.32.0 entry. |
| `MIGRATIONS.md` | Add migration entries for consumers: dispatch protocol decomposition creates new files; category dissolution changes integration template organization; development-workflow.md deleted (replaced by story-execution.md protocol + domain workflow files); analytics-workspace.md renamed to analytics-workflow.md (file path change); analytics-onboarding.md renamed to analytics-workflow-onboarding.md (file path change); 7 new domain workflow files; story-execution.md new protocol file. |

### Files assessed but NOT changed

| File | Reason |
|------|--------|
| `core/agents/archetypes/*.md` (those not listed above) | Archetypes define base behavioral templates. Those without category language or "analytics-workspace" references need no restructuring. |
| `core/workflows/types/agentic-workflow.md` | Already uses its own vocabulary (structural mode, operational mode). No category language to remove. Cross-reference to dispatch protocol path unchanged (hub file stays at same path). |
| Rubric files (`core/rubrics/`) | Rubrics are agent-specific, not category-specific. No change needed. |
| Briefing files (`core/briefings/`) | Briefings reference workflow phases, not project type categories. No change needed. |
| `core/design-principles.md` | Already workflow-agnostic. No change needed. |
| `core/maintenance-checklist.md` | Template file. No category-specific language. |
| Agent prompt files not listed above (e.g., `code-reviewer.md`, `software-engineer.md`, `product-manager.md`, etc.) | Grep confirmed these files do not contain category language ("sprint-based types", "task-based types", "methodology-based types") or "analytics-workspace" references. Their used-by lists name project types (e.g., "web-app, automation, library") which remain accurate as workflow type names. No content change needed. |

---

## Integration Point Analysis

| Changed file | References from | Sync required |
|-------------|----------------|---------------|
| `core/agents/AGENT-CATALOG.md` | `BOOTSTRAP.md` (reads catalog for agent installation), `ADOPT.md`, `ADD-WORKFLOW.md`, integration templates (CLAUDE.md, copilot-instructions.md), `core/workflows/types/agentic-workflow.md` (agent roster reference), individual agent prompts (used-by lists), `README.md` (agent count) | All references say "see AGENT-CATALOG" — the path does not change. Content reorganization requires that all files describing the catalog's organization (integration templates' Subagents sections, README's agent description) match the new organization. |
| `core/Document-Catalog.md` | `BOOTSTRAP.md` (reads catalog for doc creation), integration templates (Document Catalog pointer), workflow files (reference specific docs by type), agent prompts (doc-triggers integration) | Path unchanged. The Quick Reference restructuring must match what BOOTSTRAP.md Phase 2.4 expects when reading "Tier 1 docs for this project type." |
| `core/workflows/protocols/dispatch-protocol.md` (hub) | All workflow type files (`story-execution.md`, `task-workflow.md`, `analytics-workflow.md`, `agentic-workflow.md`, domain workflow files), integration templates (Dispatch Protocol reference), `AGENT-CATALOG.md` (archetype dispatch reference), `Domain-Language.md` (dispatch contract term) | Hub file path unchanged. All existing references to `dispatch-protocol.md` continue to resolve. The dispatch reference formerly in development-workflow.md now lives in story-execution.md. The hub must clearly point to sub-files so readers find per-agent contracts. |
| `core/workflows/protocols/dispatch/*.md` (new) | `dispatch-protocol.md` (hub points to them), workflow type files (may reference specific archetype contracts), domain workflow files (reference their domain's agents' contracts) | Must be internally consistent with the hub. Each archetype contract must list the same fields currently in dispatch-protocol.md for that archetype's agents. |
| `core/workflows/types/development-workflow.md` (DELETED) | Integration templates (primary workflow reference for sprint projects), `BOOTSTRAP.md` (Phase 3 references development workflow), `sprint-coordination.md` (tier-conditional branching reference), `Document-Catalog.md` (freshness cross-reference), `task-workflow.md` (freshness cross-reference), domain workflow files (would have referenced it), all agent prompt files and archetypes that mention "development-workflow.md" as a path | **Deletion creates many broken references.** Every file that currently says "see development-workflow.md" must be updated to point to either `story-execution.md` (for execution mechanics) or the project's domain workflow file (for agent roster and domain gates). Integration templates must replace the single development-workflow.md reference with a two-file model: story-execution.md + [domain]-workflow.md. BOOTSTRAP.md Phase 3 must route to the domain workflow file, which in turn references story-execution.md. sprint-coordination.md's tier-conditional branching reference must point to story-execution.md. |
| `core/workflows/protocols/story-execution.md` (NEW) | Domain workflow files (all 7 reference it for shared execution mechanics), integration templates (CLAUDE.md, copilot-instructions.md), `BOOTSTRAP.md`, `sprint-coordination.md` (tier-conditional branching reference), `Document-Catalog.md` (freshness cross-reference), `task-workflow.md` (freshness cross-reference) | This file absorbs all the inbound references that formerly pointed to development-workflow.md for execution mechanics. Every domain workflow file must reference it. Integration templates must point to it alongside the domain workflow file. |
| Domain workflow files (7 new files in `core/workflows/types/`) | `story-execution.md` (references shared execution mechanics), integration templates (CLAUDE.md, copilot-instructions.md), `BOOTSTRAP.md` (agent installation per workflow type), `AGENT-CATALOG.md` (roster cross-reference) | Each domain workflow is self-contained for its domain: own agent roster, domain-specific gates, and a reference to story-execution.md for shared execution. Integration templates must list domain workflow files. BOOTSTRAP.md must route each project type to its domain workflow file. |
| `core/workflows/types/analytics-workflow.md` (renamed from `analytics-workspace.md`) | `BOOTSTRAP.md` Phase 2W, integration templates (Analytics Workflow sections), `Document-Catalog.md` (analytics entries), `AGENT-CATALOG.md`, `Domain-Language.md`, `dispatch-protocol.md` (analytics-specific contracts), `sprint-coordination.md`, `ADD-WORKFLOW.md`, `README.md`, all agent prompt files that reference the old name | Every file that says "analytics-workspace" (as concept or path) must be updated. File path references change from `analytics-workspace.md` to `analytics-workflow.md`. MIGRATIONS entry required. |
| `core/workflows/protocols/analytics-workflow-onboarding.md` (renamed from `analytics-onboarding.md`) | `BOOTSTRAP.md` Phase 2W (references onboarding protocol), `ADD-WORKFLOW.md` (references onboarding for analytics workflow addition) | File path references change from `analytics-onboarding.md` to `analytics-workflow-onboarding.md`. |
| Agent prompt files (14 files with updates) | Other agent files (cross-references), `AGENT-CATALOG.md` (used-by lists), workflow files (dispatch references) | Updates are terminology-only (replacing category language). No structural path changes. Agent file names do not change. |
| `BOOTSTRAP.md` | Integration templates (reference BOOTSTRAP.md for setup), `README.md` (Quick Start section), `ADOPT.md` (cross-reference) | Phase branching restructuring must not break the instructions that integration templates give agents for bootstrapping. File path references to analytics-workspace.md and analytics-onboarding.md must be updated. |
| `Domain-Language.md` | Integration templates (Domain Language pointer), workflow files (term usage), agent prompts (term definitions) | New terms must be used consistently in all files changed in this version. Retired category terms must not appear in any changed file. Skill definition must be precise: the capability an agent exercises in one invocation. |
| `integrations/claude-code/CLAUDE.md` | Consumer projects' CLAUDE.md files (copied during bootstrap) | Must accurately reflect the new agent organization, workflow types, skills model, and domain workflow files. Consumers copying this template get the composition-aware version. |
| `integrations/copilot/copilot-instructions.md` | Consumer projects' copilot-instructions.md files | Same as above. |
| `README.md` | External audience (GitHub landing page), `BOOTSTRAP.md` (references README for overview) | Must match the current framework state after all other changes. |
| `CLAUDE.md` (Fabrika's own, gitignored) | Every future Fabrika session | Must be updated: development-workflow.md is deleted. References to it must be replaced with story-execution.md and/or domain workflow files. Dispatch protocol hub path is unchanged. New dispatch sub-directory must be mentioned in the integration point map. New cross-reference chain: domain workflows <-> story-execution.md <-> AGENT-CATALOG <-> integration templates. |

---

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Dispatch protocol decomposition loses content | `dispatch-protocol.md`, `dispatch/*.md` | An agent contract that exists in the monolithic file is omitted from the decomposed files. The orchestrator cannot find the contract for a specific agent, leading to incorrect dispatch payloads. |
| 2 | Category dissolution incomplete | `AGENT-CATALOG.md`, `Document-Catalog.md`, `BOOTSTRAP.md`, integration templates, `README.md`, `Domain-Language.md`, agent prompt files | One file still uses "sprint-based types" category language while others have moved to workflow type language. New users encounter contradictory framing. |
| 3 | analytics-workspace rename incomplete | All files listing it (concept and path references) | Some files say "analytics-workspace" and others say "analytics workflow." File path references point to the old filename. Consumer projects get inconsistent terminology or broken references. |
| 4 | development-workflow.md deletion leaves dangling references | All files that currently reference `development-workflow.md` by path: integration templates, `BOOTSTRAP.md`, `sprint-coordination.md`, `Document-Catalog.md`, `task-workflow.md`, domain workflow files, agent prompts | A file still says "see development-workflow.md" after the file is deleted. The orchestrator follows a dead reference and cannot find the execution mechanics or domain-specific guidance. |
| 4a | Story execution protocol is incomplete or leaves gaps | `story-execution.md`, domain workflow files, integration templates | The extraction from development-workflow.md misses content that belonged in story-execution.md, or domain workflow files do not compose cleanly with the protocol, leaving gaps in the story execution path. An orchestrator reading story-execution.md + a domain workflow cannot complete a story end-to-end. |
| 5 | BOOTSTRAP.md branch logic breaks | `BOOTSTRAP.md` | The unified onboarding flow fails to route correctly to the analytics or agentic-workflow setup paths. A user bootstrapping an analytics project gets the sprint-based flow. |
| 6 | Domain Language new terms inconsistent with usage | `Domain-Language.md`, all changed files | A term is defined in Domain-Language.md but used differently (or not used) in the actual workflow and catalog files. Specifically: skill defined as agent capability but files say "agent is a skill" instead of "agent has a skill." |
| 7 | Dispatch hub file too thin or too thick | `dispatch-protocol.md` | Hub file either duplicates content that moved to sub-files (maintenance burden) or is too sparse to orient a reader (usability burden). |
| 8 | Integration templates diverge from each other | `integrations/claude-code/CLAUDE.md`, `integrations/copilot/copilot-instructions.md` | One template is updated but the other is missed. Consumers using Copilot get stale framing while Claude Code users get the current model. |
| 9 | Cross-cutting procedure notes are vague or incomplete | Protocol files (`token-estimation.md`, `knowledge-pipeline.md`, etc.) | Notes say "this is cross-cutting" but do not clarify how each workflow type references or invokes the procedure, leaving the liberation toothless. |
| 10 | Domain workflow files duplicate shared execution content | Domain workflow files, `story-execution.md` | Both domain files and story-execution.md describe the story execution steps. Changes to story execution must be made in multiple places. |
| 11 | Seven domain workflow files created without sufficient domain detail | All 7 domain workflow files | Files are created as thin stubs that do not add value beyond what AGENT-CATALOG already provides. They exist but do not meaningfully guide an orchestrator. |
| 12 | Agent prompt file updates miss an occurrence | 14+ agent files | A grep-and-replace pass misses a reference buried in a calibration example or edge case description. The agent prompt still says "analytics-workspace" or "sprint-based types" after the update. |
| 13 | File rename breaks consumer manifests | Consumer projects with `analytics-workspace.md` in their manifest | Consumer projects that track `analytics-workspace.md` in their `.fabrika/manifest.yml` will have a broken file reference after updating. MIGRATIONS entry must clearly explain the rename. |

---

## Mitigations

| Risk # | Mitigation |
|--------|-----------|
| 1 | After decomposition, count the number of H3 sections (per-agent headers) in the original dispatch-protocol.md and verify the same count exists across all decomposed files. Verify every agent listed in AGENT-CATALOG.md has a dispatch contract in exactly one decomposed file. |
| 2 | After all changes, search the full set of changed files for "sprint-based types", "task-based types", "methodology-based types" (exact phrases). Zero matches required. Also search for "Sprint-Based Types" and "Task-Based Types" as section headers. Zero matches required. Search agent prompt files specifically. |
| 3 | After all changes, search ALL repo files (not just changed files) for "analytics-workspace" (exact). The only allowed matches are in historical/migration notes that explain the rename, git history references, and CHANGELOG historical entries. All descriptive/instructional uses must say "analytics workflow." All file path references must point to `analytics-workflow.md` not `analytics-workspace.md`. |
| 4 | After all changes, grep ALL repo files for the path string "development-workflow.md" and the phrase "development workflow" (as a reference, not a historical note). Zero live references allowed — every occurrence must have been updated to point to `story-execution.md` (for execution mechanics) or to the project's domain workflow file (for agent roster/domain gates). Allowed exceptions: CHANGELOG historical entries, MIGRATIONS.md explaining the deletion, and any "formerly known as" notes. |
| 4a | Each domain workflow file must contain an explicit agent roster table (which planner, reviewer, validator, implementer, architect) and must reference `story-execution.md` for shared execution mechanics. Story-execution.md must contain an explicit note saying "for the domain-specific agent roster and domain gates, see the project's domain workflow file." Verify that an orchestrator reading story-execution.md + any one domain workflow file has a complete, non-redundant path from story start to story completion. |
| 5 | BOOTSTRAP.md must have a clear routing table in Phase 1.2 that maps each workflow type to its onboarding phase. The routing logic must be testable: given a project type, which phase does the agent go to? Verify by tracing each of the 11 project types through the routing table. |
| 6 | For each new term in Domain-Language.md, grep the changed files for at least one usage of that term. For each retired term, grep the changed files and verify zero instructional usage (historical/migration context is allowed). Specifically verify: "skill" is consistently described as a capability an agent HAS, not what an agent IS. |
| 7 | The hub file must contain: all content that is not per-agent-specific (dispatch tiers, tier-conditional dispatch tables, lightweight dispatch, retry protocol, output format constraints) plus a clear "Per-Agent Contracts" section with a table mapping each agent to its contract file path. The hub file should be 200-300 lines — short enough to not need decomposition itself, long enough to be self-orienting. |
| 8 | The implementer must update both integration templates in the same pass for every change. The verifiers must check both templates against each other for structural parity. |
| 9 | Each protocol file that receives a cross-cutting note must include a one-sentence statement: "Referenced by: [list of workflow types that invoke this procedure]." This makes the cross-cutting relationship concrete rather than abstract. |
| 10 | Domain workflow files must NOT reproduce the shared story execution steps. Each must say "the shared story execution mechanics (story-start orientation, dispatch, tier-conditional branching, evaluation cycle) are defined in `core/workflows/protocols/story-execution.md` — this file defines the [domain]-specific agents, review criteria, and testing approach that compose with those mechanics." The domain file adds, it does not repeat. |
| 11 | Each domain workflow file must contain at minimum: (a) a header naming the domain and which project types use it, (b) the agent roster table, (c) a reference to `story-execution.md`, (d) domain-specific gates or phases (even if brief), and (e) typical testing approach guidance for the domain. The content for (b), (d), and (e) already exists implicitly in AGENT-CATALOG and dispatch-protocol — the domain workflow makes it explicit. |
| 12 | After agent prompt updates, run a final grep across ALL files in `core/agents/` for "analytics-workspace", "sprint-based types", "task-based types", "methodology-based types", and "project type categories". Zero matches required (except in historical context or AGENT-CATALOG's used-by column where project type NAMES like "web-app" are correct). |
| 13 | MIGRATIONS.md entry must include: (a) the old path, (b) the new path, (c) instruction to update manifest.yml, (d) instruction to rename the local file, (e) instruction to update any project-level references to the old path. |

---

## Version Bump Determination

**Bump type:** minor
**New version:** 0.32.0
**Reasoning:** `core/**` changes (7 new domain workflow files, dispatch
protocol decomposition, agent catalog restructuring, document catalog
restructuring, agent prompt updates, file renames). Minor bump per
Fabrika bump rules.

---

## CHANGELOG Draft

```
## 0.32.0 — Agents as composable skills; category dissolution

Formalizes Fabrika's skills model: agents carry skills — the atomic
unit of agent capability exercised in one invocation. Base agents
(planner, implementer, reviewer, validator) carry unparameterized
skills. All specialized agents carry parameterized versions of these
skills, adding domain knowledge. Workflows invoke agents with their
skills in sequence. Projects compose workflow types. Dissolves the
three project type categories (sprint-based, task-based,
methodology-based) into a unified model where all types are workflow
types.

### Changed files

**Agent model restructuring**
- `core/agents/AGENT-CATALOG.md` — reorganized from three-category
  tables to unified archetype-based organization; formalized skill
  relationship (agents carry skills); renamed analytics-workspace to
  analytics workflow
- `core/Document-Catalog.md` — removed three-category organization;
  unified workflow type table; renamed analytics-workspace to analytics
  workflow; updated Quick Reference section

**Agent prompt updates**
- `core/agents/agentic-engineer.md` — updated "project type" to
  "workflow type"
- `core/agents/logic-reviewer.md` — updated "analytics-workspace" to
  "analytics workflow"
- `core/agents/workflow-planner.md` — updated "project types" to
  "workflow types"
- `core/agents/data-analyst.md` — updated all "analytics-workspace"
  references to "analytics workflow"
- `core/agents/visualization-designer.md` — updated category
  references to workflow type language
- `core/agents/structural-validator.md` — updated "project types" to
  "workflow types"
- `core/agents/performance-reviewer.md` — updated
  "analytics-workspace" to "analytics workflow"
- `core/agents/archetypes/architect.md` — updated "project type
  categories" to workflow type language
- `core/agents/archetypes/implementer.md` — updated "project types"
  and "analytics-workspace" to workflow type language
- `core/agents/archetypes/designer.md` — updated "sprint-based" to
  workflow type language
- `core/agents/archetypes/planner.md` — updated "sprint-based" to
  workflow type language
- `core/agents/archetypes/reviewer.md` — updated "sprint-based" to
  workflow type language
- `core/agents/archetypes/validator.md` — updated "sprint-based" to
  workflow type language

**Dispatch protocol decomposition**
- `core/workflows/protocols/dispatch-protocol.md` — decomposed from
  monolithic 1,097-line file into hub (~250 lines) with pointers to
  per-archetype contract files; retains dispatch tiers, tier-conditional
  dispatch, lightweight dispatch, retry protocol, output format
  constraints
- `core/workflows/protocols/dispatch/planner-contracts.md` — NEW:
  dispatch contracts for all planner agents (planning + validation
  modes)
- `core/workflows/protocols/dispatch/reviewer-contracts.md` — NEW:
  dispatch contracts for all reviewer agents
- `core/workflows/protocols/dispatch/validator-contracts.md` — NEW:
  dispatch contracts for all validator agents
- `core/workflows/protocols/dispatch/implementer-contracts.md` — NEW:
  dispatch contracts for all implementer agents
- `core/workflows/protocols/dispatch/architect-contracts.md` — NEW:
  dispatch contracts for all architect agents (design, review, ad-hoc
  modes)
- `core/workflows/protocols/dispatch/coordinator-contracts.md` — NEW:
  dispatch contracts for coordinator agents
- `core/workflows/protocols/dispatch/designer-contracts.md` — NEW:
  dispatch contracts for designer agents

**Workflow restructuring**
- `core/workflows/types/development-workflow.md` — DELETED; fully
  decomposed into story-execution.md (shared execution mechanics) and
  7 domain workflow files (domain-specific content)
- `core/workflows/protocols/story-execution.md` — NEW: shared story
  execution mechanics for work at story complexity or above; contains
  story-start orientation, dispatch protocol reference, tier-conditional
  branching, freshness-aware context loading, testing approach branching,
  evaluation cycle, multi-domain story completion, bug workflow reference,
  architecture assessment, ideation/grooming, research; referenced by all
  domain workflow files
- `core/workflows/types/software-development-workflow.md` — NEW:
  self-contained domain workflow for web-app and automation projects;
  own agent roster, domain-specific gates (security review for
  web-app), references story-execution.md for shared mechanics
- `core/workflows/types/data-engineering-workflow.md` — NEW:
  self-contained domain workflow for data-engineering projects;
  environment progression gates, layer ownership model
- `core/workflows/types/analytics-engineering-workflow.md` — NEW:
  self-contained domain workflow for analytics-engineering projects;
  transformation validation, migration parity checks
- `core/workflows/types/data-app-workflow.md` — NEW: self-contained
  domain workflow for data-app projects; dashboard spec validation,
  visualization review
- `core/workflows/types/ml-engineering-workflow.md` — NEW:
  self-contained domain workflow for ml-engineering projects; experiment
  loops, model evaluation criteria
- `core/workflows/types/ai-engineering-workflow.md` — NEW:
  self-contained domain workflow for ai-engineering projects; prompt
  review, eval harness, RAG assessment
- `core/workflows/types/library-workflow.md` — NEW: self-contained
  domain workflow for library projects; API surface review, backward
  compatibility
- `core/workflows/types/analytics-workflow.md` — RENAMED from
  analytics-workspace.md; concept renamed from analytics-workspace to
  analytics workflow
- `core/workflows/types/task-workflow.md` — strengthened skills model
  framing; added three-tier abstraction note

**Cross-cutting procedure classification**
- `core/workflows/protocols/token-estimation.md` — added cross-cutting
  procedure classification note
- `core/workflows/protocols/knowledge-pipeline.md` — same
- `core/workflows/protocols/knowledge-synthesis.md` — same
- `core/workflows/protocols/sprint-coordination.md` — updated from
  category language to complexity-triggered language; sprint
  coordination is a procedure that activates when work reaches
  story/epic complexity; added trigger mechanism documentation
  (assessed at bootstrap, adopt/add-workflow, and mid-project)
- `core/workflows/protocols/design-alignment.md` — updated from
  category language to workflow type language
- `core/workflows/protocols/task-promotion.md` — renamed
  analytics-workspace to analytics workflow
- `core/workflows/protocols/analytics-workflow-onboarding.md` —
  RENAMED from analytics-onboarding.md; renamed analytics-workspace to
  analytics workflow; triggers when project adds analytics workflow
- `core/workflows/protocols/doc-triggers.md` — updated to workflow type
  language
- `core/workflows/protocols/hooks-reference.md` — updated to workflow
  type language

**Framework-level files**
- `BOOTSTRAP.md` — unified onboarding flow replacing Phase 2 /
  Phase 2W / Phase 2A category branching; renamed analytics-workspace;
  updated file path references for renamed files; updated type alignment
  table and readiness checklists
- `ADOPT.md` — updated to workflow type language
- `UPDATE.md` — updated to workflow type language
- `HARVEST.md` — updated to workflow type language
- `ADD-WORKFLOW.md` — updated to skills model framing; renamed
  analytics workflow section; updated file path references; when adding
  a domain workflow, install bundled procedures and assess whether
  sprint coordination is needed based on work complexity; sprint
  coordination can also be added independently
- `MANIFEST_SPEC.md` — updated to workflow type language
- `Domain-Language.md` — added terms: skill (capability an agent
  exercises in one invocation), process, procedure/SOP; strengthened:
  workflow type, base agent, specialist, roster, Agent Catalog; refined
  agent term (agent HAS a skill, is not a skill); retired category
  labels: sprint-based project (as category), task-based project (as
  category), methodology-based project (as category); renamed
  analytics-workspace to analytics workflow
- `README.md` — removed three-category Project types section; unified
  workflow types table; updated feature description

**Integration templates**
- `integrations/claude-code/CLAUDE.md` — removed three-category
  Subagents organization; unified agent table by archetype; renamed
  analytics-workspace; updated workflow composition section; updated
  file path references
- `integrations/copilot/copilot-instructions.md` — same changes as
  CLAUDE.md

**Versioning**
- `VERSION` — 0.31.0 -> 0.32.0
- `CHANGELOG.md` — this entry
- `MIGRATIONS.md` — consumer migration for dispatch decomposition,
  category dissolution, development-workflow.md deleted (replaced by
  story-execution.md + domain workflow files),
  analytics-workspace.md renamed to analytics-workflow.md,
  analytics-onboarding.md renamed to
  analytics-workflow-onboarding.md, 7 new domain workflow files,
  story-execution.md new protocol file

### Consumer update instructions

1. **File renames (do first):**
   - Rename `core/workflows/types/analytics-workspace.md` to
     `core/workflows/types/analytics-workflow.md` in your project
   - Rename `core/workflows/protocols/analytics-onboarding.md` to
     `core/workflows/protocols/analytics-workflow-onboarding.md`
   - Update `.fabrika/manifest.yml` to reflect the new paths
2. **Domain workflow files:** Copy the domain workflow file(s) for your
   project's workflow type(s) from `core/workflows/types/`:
   - `software-development-workflow.md` (web-app, automation)
   - `data-engineering-workflow.md` (data-engineering)
   - `analytics-engineering-workflow.md` (analytics-engineering)
   - `data-app-workflow.md` (data-app)
   - `ml-engineering-workflow.md` (ml-engineering)
   - `ai-engineering-workflow.md` (ai-engineering)
   - `library-workflow.md` (library)
3. **Dispatch protocol decomposition:** Copy the new
   `core/workflows/protocols/dispatch/` directory (8 files) into your
   project's Fabrika reference path. Update your local copy of
   `dispatch-protocol.md` from Fabrika source (now a hub file).
4. **Updated catalogs:** Update `core/agents/AGENT-CATALOG.md` and
   `core/Document-Catalog.md` from Fabrika source.
5. **Agent prompt updates:** Update all agent prompt files listed in the
   Agent prompt updates section above from Fabrika source.
6. **Integration template:** Update your project's CLAUDE.md or
   copilot-instructions.md from the Fabrika integration template. The
   Subagents section has been reorganized. Merge your project-specific
   customizations.
7. **BOOTSTRAP.md:** Update from Fabrika source if you use it for new
   project bootstrapping.
8. **Domain Language:** No action needed for your project's Domain
   Language (that is project-specific). Fabrika's own Domain-Language.md
   has new terms — informational only.
9. **analytics-workspace rename:** If your project type is
   analytics-workspace, the name is now "analytics workflow." Update
   any human-facing documentation that references "analytics workspace"
   to say "analytics workflow."
10. **development-workflow.md DELETED:** Remove
    `core/workflows/types/development-workflow.md` from your project.
    Its content has been split: shared story execution mechanics are
    now in `core/workflows/protocols/story-execution.md` (copy this
    new file), and domain-specific content lives in the domain workflow
    files (step 2). Update any project-level references that pointed
    to development-workflow.md.
```

---

## Execution Sequencing

The changes have internal dependencies. The implementer should execute
in this order:

1. **Domain Language first.** Define the new terms (skill — the
   capability an agent exercises in one invocation, process,
   procedure/SOP) and update existing terms. Refine the agent term:
   an agent HAS a skill, the agent is not "a skill." This establishes
   the vocabulary that all subsequent file changes use.

2. **Dispatch protocol decomposition.** Create the `dispatch/`
   subdirectory and extract per-archetype contracts. Refactor the hub.
   This is a mechanical extraction with no conceptual changes to the
   contracts themselves — the content moves, the definitions do not
   change. Complete this before touching files that reference the
   dispatch protocol.

3. **AGENT-CATALOG restructuring.** Reorganize from three-category
   tables to unified archetype organization. Formalize the skill model
   in the "Base Agents and Workflow Types" section (promote it to the
   primary organizational frame). Rename analytics-workspace.

4. **Document-Catalog restructuring.** Remove three-category tables.
   Create unified workflow type table. Rename analytics-workspace.
   Update Quick Reference.

5. **Agent prompt file updates.** Grep all agent files in
   `core/agents/` for "analytics-workspace", "sprint-based",
   "task-based", "methodology-based", "project type". Update each
   match to use workflow type language. 14 files identified; final
   grep verification after all updates.

6. **File renames.** Rename `analytics-workspace.md` to
   `analytics-workflow.md`. Rename `analytics-onboarding.md` to
   `analytics-workflow-onboarding.md`. Update concept naming within
   both files.

7. **Workflow file changes.** In this order:
   a. Create `core/workflows/protocols/story-execution.md` — extract
      the shared story execution mechanics from
      development-workflow.md (story-start orientation, dispatch
      protocol reference, tier-conditional branching, freshness-aware
      context loading, testing approach branching, evaluation cycle,
      multi-domain story completion, bug workflow reference,
      architecture assessment, ideation/grooming, research). This is
      the execution protocol for work at story complexity or above,
      regardless of domain.
   b. Create all 7 domain workflow files (software-development,
      data-engineering, analytics-engineering, data-app, ml-engineering,
      ai-engineering, library). Each is self-contained for its domain:
      own agent roster, domain-specific gates, reference to
      story-execution.md for shared mechanics.
   c. DELETE `development-workflow.md` from the codebase. All its
      content has been distributed to story-execution.md and the
      domain workflow files.
   d. Update `task-workflow.md` (skills model framing)

8. **Protocol file updates.** Cross-cutting procedure notes, category
   language removal, analytics-workspace rename across all protocol
   files. Update sprint-coordination.md: clarify it is a
   complexity-triggered procedure (not a workflow type), add trigger
   mechanism documentation (assessed at bootstrap, adopt/add-workflow,
   and mid-project), replace the tier-conditional branching reference
   from development-workflow.md to story-execution.md. Update all
   other protocol files that referenced development-workflow.md to
   point to story-execution.md.

9. **BOOTSTRAP.md.** Unified onboarding flow. Depends on the catalog
   and workflow restructuring being complete. Update file path
   references for renamed files.

10. **Other framework files.** ADOPT.md, UPDATE.md, HARVEST.md,
    ADD-WORKFLOW.md, MANIFEST_SPEC.md. Update file path references.

11. **Integration templates.** CLAUDE.md and copilot-instructions.md.
    Last because they summarize everything above.

12. **README.md.** Last because it is the external-facing summary.

13. **VERSION, CHANGELOG, MIGRATIONS.** Final.

---

## Owner Decision Points

### 1. Dispatch protocol hub length

The decomposed dispatch-protocol.md hub will contain approximately
250-300 lines (dispatch tiers, tier-conditional dispatch tables,
lightweight dispatch, retry protocol, output format constraints, and
a routing table to per-archetype files). Is this the right balance,
or should some of this content also move to sub-files?

**Recommendation:** Keep the hub at 250-300 lines. The content that
remains (dispatch tiers, tier-conditional tables, retry protocol,
output constraints) is cross-archetype — it applies to all agents
equally and should not be repeated in each archetype file. An
orchestrator reading the hub gets the universal rules; reading an
archetype file gets the agent-specific fields.

### 2. Domain workflow file depth

The 7 domain workflow files are self-contained for their domain — each
has its own agent roster, domain-specific gates, and a reference to
`story-execution.md` for shared execution mechanics. They also draw
from AGENT-CATALOG and dispatch-protocol. How detailed should the
domain-specific gates and testing guidance be?

**Recommendation:** Start with the information already implicit in
AGENT-CATALOG and dispatch-protocol — make it explicit, not
inventive. Domain workflow files for domains with known specific
gates (data-engineering: environment progression; ml-engineering:
experiment loops; ai-engineering: eval harness) should document those
gates. Simpler domains (software-development, library) may have
shorter domain-specific sections. CR-23 will deepen the
data-engineering workflow with real-world requirements — the file
created here is the structural slot that CR-23 fills with substance.

---

## Procedure Liberation Assessment

Per CR alignment note #13, the plan must assess all procedures in
`core/workflows/protocols/` and classify them.

Procedures are triggered by one of three mechanisms:

1. **Cross-cutting** — workflow-agnostic; referenced by all or most
   workflow types regardless of domain.
2. **Workflow-bundled** — installed WITH a specific domain workflow
   via ADD-WORKFLOW.md; the workflow and its bundled procedures travel
   together.
3. **Complexity-triggered** — activates when a project's work reaches
   a certain complexity threshold (story/epic-level backlog items),
   regardless of which domain workflow is installed. The orchestrator
   assesses this at bootstrap, adopt/add-workflow, and mid-project.
   Installation is proposed by the orchestrator, approved by the
   owner.

There is NO "sprint workflow" — sprint coordination is a procedure,
not a workflow type. The workflow types are: task, analytics,
software-development, data-engineering, analytics-engineering,
data-app, ml-engineering, ai-engineering, library, agentic. Sprint
coordination is ceremony that activates based on work complexity, not
based on which workflow type was installed.

| Procedure | Classification | Rationale |
|-----------|---------------|-----------|
| `dispatch-protocol.md` | **Cross-cutting** | Dispatch mechanics apply to all workflows. Decomposed into hub + per-archetype files in this CR. |
| `story-execution.md` (NEW) | **Cross-cutting** | Shared story execution mechanics (story-start orientation, dispatch, tier-conditional branching, freshness check, evaluation cycle) for work at story complexity or above, regardless of domain. Referenced by all 7 domain workflow files. Not about "sprint-based development" — the universal complexity spectrum (CR-18) applies to all work. |
| `design-alignment.md` | **Cross-cutting** | Triggers on new project, new phase, ambiguity detection — across any workflow type. Not owned by any one workflow. |
| `sprint-coordination.md` | **Complexity-triggered** | The multi-chat sprint ceremony (planning, story chats, close-out, maintenance, retro). Activates when a project's work includes story-type or epic-type backlog items, regardless of domain workflow. The orchestrator assesses need at three points: (1) at bootstrap — from Design Alignment output, if charter + PRDs produce epics + stories, sprint coordination is obviously needed; (2) at adopt/add-workflow — the orchestrator assesses whether the project's backlog has story/epic-level work and proposes sprint coordination if needed; (3) mid-project — the orchestrator detects growing complexity (interwoven stories, epic-level goals) and proposes adding sprint coordination. Installation is proposed by the orchestrator, approved by the owner. A data-engineering project might need sprint coordination from day one; a different data-engineering project might just do tasks for months before needing it. |
| `token-estimation.md` | **Cross-cutting** | Referenced by all workflow types at plan/spec presentation time. Should be referenced once, invoked by any workflow at plan time. |
| `knowledge-pipeline.md` | **Cross-cutting** | The pipeline runs at cadences tied to delivery events, but the pipeline itself is workflow-agnostic. All workflow types invoke it at their delivery points. |
| `knowledge-synthesis.md` | **Cross-cutting** | Step-by-step companion to knowledge-pipeline.md. Same classification. |
| `task-promotion.md` | **Workflow-bundled** (analytics) | Promotion of recurring analyses into templates/scripts/dashboards. Bundled with the analytics workflow — installed when a project adds the analytics workflow via ADD-WORKFLOW.md. |
| `analytics-workflow-onboarding.md` (renamed) | **Workflow-bundled** (analytics) | Platform, source, and connection onboarding. Bundled with the analytics workflow — installed when a project adds the analytics workflow at bootstrap or later via ADD-WORKFLOW.md. |
| `doc-triggers.md` | **Cross-cutting** | Document creation triggers apply across workflow types. The trigger table maps events to documents regardless of which workflow produces the event. |
| `hooks-reference.md` | **Cross-cutting** | Hook enforcement applies to all workflows. Pre-push test gate, commit message format, secret scanning are universal. |
| `progress-files.md` | **Complexity-triggered** | Sprint progress files, STATUS.md format, and dev log format. Activates alongside sprint coordination when work reaches story/epic complexity. Task and analytics workflows use simpler status tracking until sprint coordination is added. |

**Action in this CR:** Add a classification note to each procedure
file identifying whether it is cross-cutting (workflow-agnostic),
workflow-bundled (installed with a specific domain workflow via
ADD-WORKFLOW.md), or complexity-triggered (activates when work reaches
story/epic complexity). Each note lists which workflow types reference
the procedure. No directory reorganization — the `protocols/`
directory already serves as the home for all types. The classification
note makes the distinction explicit and replaces any "this is for
[category] projects only" language with the appropriate trigger
mechanism.

**Note for future CR:** The owner identified that UX/UI design
concerns (wireframes, UX spec, design tokens, brand guidelines,
visualization) may need their own composable workflow type with a
dedicated designer agent. This is NOT a CR-22 concern. Log during
CR-22's ship step as a future CR to be written.

---

## Skills Model Specification

The plan must formalize the three-tier abstraction so the implementer
has a concrete specification to implement.

### Tier 1: Skill

A skill is the capability an agent exercises in one invocation. The
agent carries the skill; the workflow invokes agents with their skills
in sequence. The agent is NOT "a skill" — the agent HAS a skill.
This distinction matters: agents are dispatched entities with
identity, state, and dispatch contracts. Skills are what they do.

A skill does not decompose further within the Fabrika model. It
defines WHAT an agent knows how to do, independent of WHERE it does
it.

**Base skills** (from CR-17): carried by `planner.md`,
`implementer.md`, `reviewer.md`, `validator.md`. These agents carry
zero domain assumptions. Their evaluation criteria come from the plan
and brief, not from a domain model.

**Parameterized skills** (domain-specific): Each specialized agent
carries a base skill + domain knowledge. The domain knowledge adds:
domain-specific evaluation criteria, domain-specific dispatch contract
fields (conditional fields in the dispatch protocol), and domain
principles. Examples:
- `product-manager.md` = agent carrying planner skill + product
  domain knowledge
- `code-reviewer.md` = agent carrying reviewer skill + software
  review criteria
- `data-analyst.md` = agent carrying implementer skill + analytics
  domain knowledge
- `data-validator.md` = agent carrying validator skill + data quality
  criteria

The parameterization relationship is documented in AGENT-CATALOG.md,
not in the agent prompts themselves. Each agent prompt already carries
its archetype reference; the catalog documents which base skill each
agent extends.

### Tier 2: Workflow Type

A workflow type is a reusable multi-agent pattern that invokes agents
with their skills in an end-to-end work lifecycle. Workflows define
the shape of work.

**Current workflow types:**
- Task workflow (`task-workflow.md`) — the base; the unparameterized
  workflow
- Analytics workflow (`analytics-workflow.md`) — task workflow +
  analytics domain agents + tiered review
- Domain workflows (7 files) — self-contained workflows for their
  domain, referencing `story-execution.md` for shared execution
  mechanics:
  - Software development (`software-development-workflow.md`) — web-app, automation
  - Data engineering (`data-engineering-workflow.md`) — data-engineering
  - Analytics engineering (`analytics-engineering-workflow.md`) — analytics-engineering
  - Data app (`data-app-workflow.md`) — data-app
  - ML engineering (`ml-engineering-workflow.md`) — ml-engineering
  - AI engineering (`ai-engineering-workflow.md`) — ai-engineering
  - Library (`library-workflow.md`) — library
- Agentic workflow (`agentic-workflow.md`) — 7-step structural update

**Shared execution protocol:** `story-execution.md` is NOT a workflow
type — it is a protocol containing the shared story execution
mechanics (story-start orientation, dispatch, tier-conditional
branching, freshness check, evaluation cycle) that all domain
workflows reference for work at story complexity or above.

**Sprint coordination** (`sprint-coordination.md`) is NOT a workflow
type — it is a complexity-triggered procedure. It activates when a
project's work includes story-type or epic-type backlog items,
regardless of which domain workflow is installed. The orchestrator
assesses this at bootstrap, adopt/add-workflow, and mid-project.

There is no "sprint workflow" or "development workflow" in the
workflow types list. The term "sprint workflow" implies sprint
coordination is a workflow type — it is not. The former
development-workflow.md has been fully decomposed.

### Tier 3: Project

A project composes one or more workflow types. It is not locked to a
single type. The `ADD-WORKFLOW.md` mechanism allows adding workflow
types after bootstrap. The orchestrator routes incoming work to the
appropriate workflow based on backlog type assessment (CR-19).

### Project type to domain workflow mapping

Every current project type maps to a usable domain workflow file:

| Project type | Domain workflow file |
|-------------|---------------------|
| `web-app` | `software-development-workflow.md` |
| `automation` | `software-development-workflow.md` |
| `data-engineering` | `data-engineering-workflow.md` |
| `analytics-engineering` | `analytics-engineering-workflow.md` |
| `data-app` | `data-app-workflow.md` |
| `ml-engineering` | `ml-engineering-workflow.md` |
| `ai-engineering` | `ai-engineering-workflow.md` |
| `library` | `library-workflow.md` |

---

## Alignment History

- **v1:** Initial plan. 2026-05-04.
- **v2:** Owner feedback 2026-05-04. Seven revisions applied:
  (1) Corrected development-workflow.md description — it is NOT
  becoming a "sprint ceremony layer" (that is sprint-coordination.md);
  it is becoming the universal story execution workflow that domain
  workflows compose.
  (2) Expanded scope from 1 domain workflow to 7, covering all 8
  current sprint-based project types — without all of them, existing
  project types become unusable as composable workflows.
  (3) Reframed Procedure Liberation Assessment — procedures are
  triggered by workflow composition (compose the sprint workflow, get
  sprint-coordination; compose analytics, get analytics-onboarding),
  not bound to project type categories. Introduced
  "composition-triggered" classification.
  (4) Owner overrides plan recommendation on analytics-workspace file
  rename — file IS being renamed from analytics-workspace.md to
  analytics-workflow.md, with MIGRATIONS entry. Also renaming
  analytics-onboarding.md to analytics-workflow-onboarding.md for
  consistency.
  (5) Agent prompt files added to Modified files — 14 files containing
  category language or "analytics-workspace" references will be
  updated. Previously listed as "assessed but NOT changed."
  (6) Skills terminology refined — a skill is the capability an agent
  exercises in one invocation; the agent carries the skill; the agent
  is NOT "a skill." Updated Skills Model Specification and Domain
  Language entries accordingly.
  (7) Added calibration data note — actuals should have been recorded
  after CRs 17-21 and were not; orchestrator must record at Step 7
  and consider backfilling.
  Resolved Owner Decision Points #1 (file rename — yes, rename) and
  #2 (how many domain workflows — all 8 types covered by 7 files).
  Added new Owner Decision Point on domain workflow file depth.
- **v3:** Owner feedback 2026-05-04. Six revisions applied:
  (1) development-workflow.md is DELETED, not refactored. Shared story
  execution mechanics (story-start orientation, dispatch, tier-conditional
  branching, freshness check, testing approach branching, evaluation
  cycle, multi-domain story completion, bug workflow, architecture
  assessment, ideation/grooming, research) extracted to new protocol
  file `core/workflows/protocols/story-execution.md`. Domain-specific
  content (agent rosters, domain-specific gates, testing approach)
  distributed to the 7 domain workflow files. Each domain workflow is
  self-contained for its domain. The file is then deleted — nothing
  remains.
  (2) There is NO "sprint workflow" — removed the term from all plan
  sections. Sprint coordination is a PROCEDURE, not a workflow type.
  The workflow types list is: task, analytics, 7 domain workflows,
  agentic. Sprint coordination is ceremony that activates based on
  work complexity, not based on which workflow type was installed.
  (3) Sprint coordination is complexity-triggered, not
  composition-triggered. Three assessment points: at bootstrap (from
  Design Alignment output), at adopt/add-workflow (from backlog
  complexity), and mid-project (when the orchestrator detects growing
  complexity). A data-engineering project might need it from day one;
  another might do tasks for months before needing it.
  (4) ADD-WORKFLOW.md updated: when adding a domain workflow, install
  bundled procedures (e.g., analytics-workflow-onboarding with analytics
  workflow) and assess whether sprint coordination is needed based on
  work complexity. Sprint coordination can be added independently.
  (5) UX/UI design workflow identified as future CR — wireframes, UX
  spec, design tokens, brand guidelines, visualization may need their
  own composable workflow with a dedicated designer agent. Not a CR-22
  concern; logged for CR-22's ship step.
  (6) Procedure Liberation Assessment revised: replaced
  "composition-triggered" (which implied "compose the sprint workflow")
  with a three-way classification: cross-cutting (workflow-agnostic),
  workflow-bundled (installed with a specific domain workflow via
  ADD-WORKFLOW.md), and complexity-triggered (activates when work
  reaches story/epic complexity). sprint-coordination.md reclassified
  from composition-triggered to complexity-triggered.
  story-execution.md added as cross-cutting. task-promotion.md and
  analytics-workflow-onboarding.md reclassified as workflow-bundled
  (analytics).
