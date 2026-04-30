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

- **Domain Language integration into dispatch (v0.15.0).** When a Domain Language document exists, it is included as a conditional field in dispatch contracts for 10 agent types: 4 planners, 5 implementers, and the code-reviewer. Planners use Domain Language terms in specs; implementers name things using Domain Language terms; the code-reviewer checks terminology consistency. This wiring ensures vocabulary consistency without requiring agents to search for the document themselves. Source: PRD-06, CHANGELOG 0.15.0.

## Current State

As of v0.19.0, the agent model consists of:

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
- Task-based types (analytics-workspace): analysis-planner, logic-reviewer, performance-reviewer, data-validator, visualization-designer, data-analyst implementer, no coordinator or architect
- Methodology-based types (agentic-workflow): workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect, scrum-master (for change backlog sequencing)

**Dispatch infrastructure:**
- Dispatch protocol (core/workflows/dispatch-protocol.md) defines per-agent contracts with required and conditional fields
- Lightweight dispatch path for trivial changes (single file, fully specified, not a new feature)
- Retry protocol with orchestrator-as-translator pattern (orchestrator translates evaluator findings into implementer fix instructions, maximum 2 retry cycles)

**Testing modes for the test-writer (v0.16.0):**
- Spec-first mode (TDD stories): input is spec only, output is behavioral tests
- Coverage mode (test-informed and test-after stories): input is code + spec, output is gap-filling tests

## Open Questions

- **Should analytics-workspace get an architect?** Currently analytics-workspace has no architect agent. As analytics projects grow in complexity (multi-source pipelines, data models with many relationships), structural review may become valuable. The current position is that analytics-workspace is task-based and ephemeral enough not to need architectural governance, but this may not hold for all consumer projects.

- **Agent session reuse across TDD cycles.** For tools that support persistent agent sessions (Claude Code), the orchestrator can reuse test-writer and implementer sessions across RED-GREEN-REFACTOR cycles. For tools that don't (Copilot subagents), each dispatch is self-contained. The design accommodates both, but the token cost difference is significant and may warrant a dedicated TDD session management pattern.

- **No dedicated wiki/knowledge agent.** The v0.18.0 knowledge pipeline is managed by the orchestrator during maintenance. PRD-09 noted that if synthesis quality suffers from context overload, a dedicated knowledge agent is a future iteration. Whether this will be needed depends on how large consumer project wikis become in practice.

- **Orchestrator-as-translator friction.** The evaluation feedback loop routes evaluator findings through the orchestrator, which translates them into implementer fix instructions. This adds a round trip and potential information loss. Whether direct evaluator-to-implementer dispatch would improve quality is an open question, balanced against the risk of losing orchestrator context about the broader story.

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

### PRDs
- PRD-01 -- agentic-workflow project type and initial archetype stubs
- PRD-02 -- applying agentic-workflow to Fabrika, agent dispatch for system updates
- PRD-03 -- implementer archetype, pure orchestrator, specialist implementers
- PRD-04 -- architect archetype, structural design evaluation, spiral mitigation
- PRD-06 -- Domain Language integration into agent dispatch
- PRD-07 -- TDD integration, spec-first mode for test-writer

### Core files
- core/agents/AGENT-CATALOG.md -- complete agent-to-project-type mapping
- core/workflows/dispatch-protocol.md -- per-agent dispatch contracts and tiers
- core/agents/archetypes/ -- 7 archetype definitions
