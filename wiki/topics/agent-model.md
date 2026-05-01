# Agent Model

## Summary

Fabrika's agent model defines how AI agents are organized, dispatched, and constrained across different project types. Rather than a single general-purpose agent, Fabrika decomposes work into specialized roles -- planners, reviewers, validators, implementers, architects, coordinators, and designers -- each with explicit input/output contracts and behavioral rules. The orchestrating session never writes production code; it routes work to the right specialist and synthesizes results for the project owner.

The model evolved substantially between v0.1.0 and v0.18.0. It started with 4 agents for sprint-based projects, grew to 13 agents with the project type taxonomy expansion (v0.6.0), then to 16 with cost awareness and security depth (v0.8.0), and finally to 23 agents organized under 7 archetypes with the implementer (v0.12.0) and architect (v0.13.0) additions. Each expansion was driven by a specific gap: the orchestrator was doing too much, a domain lacked specialized review, or structural design quality was unmonitored.

The design philosophy is that agents carry *methodology expertise*, not tool expertise. A data-engineer agent knows how to plan and build pipelines regardless of whether the project uses dbt, Airflow, or Prefect. This means the agent prompt is reusable across consumer projects without modification, while project-specific configuration (stack, conventions, constraints) lives in the consumer's integration template (CLAUDE.md or copilot-instructions.md).

## Key Decisions

- **Role-based decomposition over task-based (v0.1.0).** The initial agent set (product-manager, code-reviewer, test-writer, scrum-master) was organized by role in the development lifecycle, not by task type. This pattern held through all subsequent expansions: each new agent fills a role gap, not a task gap. The alternative -- agents organized by feature area or module -- was rejected because it would create project-specific agents that could not be reused across consumers. Source: CHANGELOG 0.1.0.

- **Archetypes as the behavioral contract layer (v0.9.0).** Five archetype templates (planner, reviewer, validator, coordinator, designer) were introduced in v0.9.0 to define base tool profiles, dispatch contracts, and output contracts for each role category. This was extended to seven archetypes in v0.10.0 with implementer and architect stubs. Archetypes serve as starting points; specialist agents may diverge where their domain demands it. The archetype layer was created to solve a practical problem: without standardized dispatch contracts, the orchestrator had to guess what each agent needed and how to interpret its output. Source: CHANGELOG 0.9.0, core/agents/archetypes/.

- **Dispatch tiers: strict vs. contextual (v0.9.0).** Reviewers, validators, and designers receive *strict dispatch* -- only the approved plan, file paths, and rubric pointer, with no orchestrator opinions or pre-digested summaries. Planners and coordinators receive *contextual dispatch* -- broader project state including conversation history and owner preferences. The rationale is independence: a reviewer that receives the orchestrator's opinion about code quality is biased before it starts. Strict dispatch forces the agent to form its own judgment. This distinction became the foundation for all subsequent dispatch contract design. Source: CHANGELOG 0.9.0, core/workflows/dispatch-protocol.md.

- **The pure orchestrator principle (v0.12.0).** The orchestrator NEVER writes production code, even for trivial tasks. This was the most consequential architectural decision in Fabrika's evolution. Before v0.12.0, the orchestrating agent planned, implemented, and then spun up sub-agents for review -- filling its context window with implementation details and degrading its routing judgment. PRD-03 identified the core problem: "Implementation quality depends entirely on whatever the orchestrator happens to know, rather than on specialized agent prompts with domain-specific expertise." The solution was five specialist implementer agents and a lightweight dispatch path for trivial changes. The orchestrator's new role: understand what needs to happen, route work to the right specialist, receive results, mediate the feedback loop between evaluators and implementers, and synthesize for the owner. Source: PRD-03, CHANGELOG 0.12.0.

- **Five specialist implementers mapped to project types (v0.12.0).** Rather than a single generic implementer, five specialists were created: software-engineer (web-app, automation, library), data-engineer (data-engineering, analytics-engineering), data-analyst (analytics-workspace, data-app), ml-engineer (ml-engineering), and ai-engineer (ai-engineering). Each carries domain expertise in its prompt. Cross-domain stories receive multiple dispatches to different specialists rather than one agent trying to do both. The granularity of five was chosen deliberately -- coarser (3) would lose meaningful domain distinctions, finer (8+) would create overlapping agents with unclear routing. Source: PRD-03, CHANGELOG 0.12.0.

- **Lightweight dispatch for trivial changes (v0.12.0).** Three conditions must ALL be true: the change touches exactly one file, the spec fully specifies the edit (no design decisions), and the change is not a new feature, refactor, or architectural change. Under lightweight dispatch, the plan field can be inline text and architecture pointers are optional, but the orchestrator still dispatches to an implementer agent. This prevents the pure orchestrator principle from creating excessive ceremony for config changes or copy updates. Source: CHANGELOG 0.12.0, core/workflows/dispatch-protocol.md.

- **Two architect specialists (v0.13.0).** The architect archetype evaluates and improves structural design -- it proposes, it does not implement. Two specialists: software-architect (web-app, automation, library, ai-engineering) for module depth, interface design, and dependency structure; data-architect (data-engineering, analytics-engineering, data-app, ml-engineering) for schema design, pipeline topology, and data flow boundaries. The design draws from John Ousterhout's "A Philosophy of Software Design" (deep modules vs. shallow modules) and includes spiral mitigation (owner-gated proposals, done thresholds, conditional maintenance trigger, assessment tracking, cap of 2 refactor stories per review) to prevent infinite optimization loops. Source: PRD-04, CHANGELOG 0.13.0.

- **Agent maturity progression (v0.10.0 through v0.12.0).** New agents start as stubs (minimal prompts with base archetype behavior) and are fleshed out with detailed evaluation procedures, calibration examples (PASS/FAIL/edge cases), and context window hygiene guidance. The five agentic-workflow agents (workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect) were stubs in v0.10.0-v0.11.0 and reached full maturity in v0.12.0. The implementer and architect archetype stubs from v0.10.0 were replaced with full definitions in v0.12.0 and v0.13.0 respectively. This pattern -- stub first, flesh out later -- allows new agent types to be referenced in catalogs and dispatch contracts before their full behavior is defined. Source: CHANGELOG 0.10.0, 0.11.0, 0.12.0, 0.13.0.

- **Agentic-workflow agents as a distinct category (v0.10.0, v0.11.0).** Methodology-based project types use a different agent roster than sprint-based or task-based types. The agentic-workflow roster (workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect) handles changes to systems where the methodology itself is the product. These agents write and review agent prompts, workflow definitions, and instruction files rather than application code. Context-engineer is the implementer; context-architect evaluates instruction decomposition, pointer patterns, and context budgets. Source: PRD-01, PRD-02, CHANGELOG 0.10.0, 0.11.0.

- **Supplemental reviewers and designers (v0.8.0).** The primary reviewer (code-reviewer or logic-reviewer) provides broad quality evaluation. Supplemental reviewers provide depth in specific areas: security-reviewer (web-app, data-engineering, ai-engineering), performance-reviewer (all types), and prompt-reviewer (ai-engineering). The visualization-designer (analytics-workspace, data-app, analytics-engineering) handles chart type selection, layout design, and accessibility. These roles are optional invocations, not required for every story. Source: CHANGELOG 0.8.0.

- **Domain Language integration into dispatch (v0.15.0, extended v0.20.0).** When a Domain Language document exists, it is included as a conditional field in dispatch contracts for 10 agent types: 4 planners, 5 implementers, and the code-reviewer. Planners use Domain Language terms in specs; implementers name things using Domain Language terms; the code-reviewer checks terminology consistency. This wiring ensures vocabulary consistency without requiring agents to search for the document themselves. In v0.20.0, Domain Language and data dictionary pointer fields were added to analytics-workspace agents: logic-reviewer (for term usage checking against business definitions), data-analyst (for correct column names and business meanings), analysis-planner (for term ambiguity flagging), and data-validator (for expected distributions and refresh cadence). Source: PRD-06, CHANGELOG 0.15.0, 0.20.0.

- **Implementer-reviewer pairing as a design philosophy (v0.20.0).** Identified during the PRD-11 alignment session. Every implementer output gets an independent review before it is considered complete or acted upon downstream. The implementer produces, the reviewer independently assesses, the implementer revises based on findings, and the reviewer re-checks. The orchestrator routes but does not interpret or synthesize. This applies to all code the data analyst writes (main queries, metadata queries, revisions) and was recognized as a framework-wide principle, not just an analytics-workspace rule. The corollary — implementer-validator pairing — states that every output producing observable results gets validated. The nature of validation differs: analytics-workspace validates execution output, sprint-based validates test passage, agentic-workflow validates structural correctness. Source: PRD-11, CHANGELOG 0.20.0.

- **Analysis planner gains validation mode (v0.20.0).** The analysis planner was the only planner agent without a validation mode. Sprint-based projects have the product-manager validation mode (verify implementation meets acceptance criteria). Analytics-workspace lacked the equivalent "does the output answer the question?" check. A validation mode was added with a 7-item checklist (question answered, completeness, format match, audience appropriateness, terminology consistency, assumptions surfaced, caveats documented) and strict dispatch. This closes a gap where data accuracy was checked (data-validator) but requirements fulfillment was not. Source: PRD-11, CHANGELOG 0.20.0.

- **Data analyst gains three explicit modes (v0.20.0).** The data analyst previously had a single implicit mode: receive plan, implement, return results. Three explicit modes were added: write-only (produce code without executing), execute-metadata (run metadata queries and produce execution manifest), and revision (read review reports directly, address findings). Mode decomposition was driven by the pre-execution review workflow, which requires the data analyst to produce code, have it reviewed, then execute in separate phases. Source: PRD-11, CHANGELOG 0.20.0.

## Current State

As of v0.20.0, the agent model consists of:

**7 archetypes** defining base behavioral contracts:
- Planner (contextual dispatch for planning, strict for validation)
- Reviewer (strict dispatch, independent evaluation)
- Validator (strict dispatch, verification by execution)
- Coordinator (contextual dispatch, workflow cadence management)
- Designer (strict dispatch, visual/structural proposals)
- Implementer (contextual dispatch, production changes against approved plans)
- Architect (contextual for design mode, strict for review mode)

**23 agent files** covering all 10 project types:
- 4 planners: product-manager, experiment-planner, api-designer, analysis-planner
- 3 primary reviewers: code-reviewer, logic-reviewer, methodology-reviewer
- 3 supplemental reviewers: security-reviewer, performance-reviewer, prompt-reviewer
- 5 validators: test-writer, data-quality-engineer, model-evaluator, eval-engineer, data-validator
- 1 structural validator: structural-validator
- 1 designer: visualization-designer
- 1 coordinator: scrum-master
- 5 implementers: software-engineer, data-engineer, data-analyst, ml-engineer, ai-engineer (plus context-engineer for agentic-workflow)
- 2 architects: software-architect, data-architect (plus context-architect for agentic-workflow)

**Role mapping across project categories:**
- Sprint-based types (8 types): full agent roster with planner, reviewer, supplemental reviewers, validator, optional designer, scrum-master coordinator, implementer, and architect
- Task-based types (analytics-workspace): analysis-planner (planning + validation modes), logic-reviewer (pre-execution, all tiers), performance-reviewer (pre-execution, Tier 2 only), data-validator (post-execution + validation report), visualization-designer, data-analyst (write-only, execute-metadata, revision modes), no coordinator or architect
- Methodology-based types (agentic-workflow): workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect, scrum-master (for change backlog sequencing)

**Dispatch infrastructure:**
- Dispatch protocol (core/workflows/dispatch-protocol.md) defines per-agent contracts with required and conditional fields
- Lightweight dispatch path for trivial changes (single file, fully specified, not a new feature)
- Retry protocol: sprint-based and agentic-workflow use orchestrator-as-translator (max 2 cycles); analytics-workspace uses direct implementer-reads-reviews (max 3 cycles, with orchestrator diagnosis after cap). PRD-13 proposes converging all project types on the direct-read pattern.

**Testing modes for the test-writer (v0.16.0):**
- Spec-first mode (TDD stories): input is spec only, output is behavioral tests
- Coverage mode (test-informed and test-after stories): input is code + spec, output is gap-filling tests

## Open Questions

- **Should analytics-workspace get an architect?** Currently analytics-workspace has no architect agent. As analytics projects grow in complexity (multi-source pipelines, data models with many relationships), structural review may become valuable. The current position is that analytics-workspace is task-based and ephemeral enough not to need architectural governance, but this may not hold for all consumer projects.

- **Agent session reuse across TDD cycles.** For tools that support persistent agent sessions (Claude Code), the orchestrator can reuse test-writer and implementer sessions across RED-GREEN-REFACTOR cycles. For tools that don't (Copilot subagents), each dispatch is self-contained. The design accommodates both, but the token cost difference is significant and may warrant a dedicated TDD session management pattern.

- **No dedicated wiki/knowledge agent.** The v0.18.0 knowledge pipeline is managed by the orchestrator during maintenance. PRD-09 noted that if synthesis quality suffers from context overload, a dedicated knowledge agent is a future iteration. Whether this will be needed depends on how large consumer project wikis become in practice.

- **Orchestrator-as-translator friction (partially resolved in v0.20.0).** The evaluation feedback loop routes evaluator findings through the orchestrator, which translates them into implementer fix instructions. This adds a round trip and potential information loss. The analytics-workspace workflow (v0.20.0) resolved this by having the implementer read review reports directly. This pattern proved more natural: the implementer is the domain expert who wrote the code and is better positioned to interpret findings in context. PRD-13 proposes adopting this direct-read pattern across all project types. The remaining question is whether the orchestrator-as-translator pattern has value in sprint-based contexts where the evaluator and implementer operate in different domain vocabularies, or whether direct reading is universally better.

## Related Topics

- [Framework Philosophy](framework-philosophy.md) -- the principles that shape agent design
- [Workflow Design](workflow-design.md) -- how agents are dispatched within workflows
- [Owner Preferences](owner-preferences.md) -- briefing and communication patterns agents follow

## Sources

### CHANGELOG versions
- v0.1.0 -- initial 4-agent system (product-manager, code-reviewer, test-writer, scrum-master)
- v0.6.0 -- expansion to 13 agents, 9 project types, role archetype organization
- v0.8.0 -- 3 new agents (performance-reviewer, security-reviewer, visualization-designer), supplemental reviewer role
- v0.9.0 -- 5 archetype templates, dispatch protocol, strict vs. contextual dispatch tiers
- v0.10.0 -- agentic-workflow type, implementer and architect archetype stubs, methodology-reviewer and structural-validator stubs
- v0.11.0 -- workflow-planner, context-engineer, context-architect stubs for agentic-workflow
- v0.12.0 -- full implementer archetype, 5 specialist implementers, pure orchestrator, full maturity for all agentic-workflow agents
- v0.13.0 -- full architect archetype, software-architect and data-architect specialists, spiral mitigation
- v0.15.0 -- Domain Language integration into dispatch contracts
- v0.16.0 -- spec-first and coverage modes for test-writer
- v0.20.0 -- data analyst modes (write-only, execute-metadata, revision), analysis planner validation mode, Domain Language/data dictionary integration for analytics agents, implementer-reviewer pairing philosophy, direct implementer-reads-reviews retry protocol

### PRDs
- PRD-01 -- agentic-workflow project type and initial archetype stubs
- PRD-02 -- applying agentic-workflow to Fabrika, agent dispatch for system updates
- PRD-03 -- implementer archetype, pure orchestrator, specialist implementers
- PRD-04 -- architect archetype, structural design evaluation, spiral mitigation
- PRD-06 -- Domain Language integration into agent dispatch
- PRD-07 -- TDD integration, spec-first mode for test-writer
- PRD-11 -- analytics pre-execution review, implementer-reviewer pairing, data analyst modes
- PRD-13 -- review-revise loop redesign across all project types (planned)

### Core files
- core/agents/AGENT-CATALOG.md -- complete agent-to-project-type mapping
- core/workflows/dispatch-protocol.md -- per-agent dispatch contracts and tiers
- core/agents/archetypes/ -- 7 archetype definitions
