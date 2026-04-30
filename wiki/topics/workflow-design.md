# Workflow Design

## Summary

Fabrika defines three workflow families, each tailored to a different category of project. Sprint-based projects follow a sprint lifecycle with planning, implementation, evaluation, and retro phases. Analytics-workspace projects follow a task lifecycle (brief, plan, execute, validate, deliver) without sprint structure. Agentic-workflow projects follow a 7-step structural update lifecycle (Plan, Align, Execute, Verify, Incorporate, Present, Ship) for changes to methodology artifacts. Each family uses the same agent archetypes but dispatches them differently and at different cadences.

The workflow system evolved from a monolithic set of instructions baked into integration templates (v0.1.0) into a decomposed set of shared, tool-agnostic workflow files (v0.7.0) that both Claude Code and Copilot integrations reference. Major workflow additions include the dispatch protocol (v0.9.0), the agentic-workflow lifecycle (v0.10.0), the pure orchestrator rewrite (v0.12.0), design alignment (v0.14.0), graduated testing (v0.16.0), the briefing system (v0.5.1 through v0.17.0), and the wiki knowledge pipeline (v0.18.0). Each addition addressed a specific process gap -- requirements capture, testing discipline, structured communication, or knowledge consolidation.

The design philosophy is that workflows define the *sequence and contracts* for agent dispatch, while agent prompts define the *expertise and behavior* within each dispatch. Workflows are project-type-aware but tool-agnostic; integration templates provide the tool-specific glue (session management, hook configuration, subagent invocation patterns).

## Key Decisions

- **Context decomposition of workflows from integration templates (v0.7.0).** Before v0.7.0, all workflow details were inline in CLAUDE.md (~676 lines) and copilot-instructions.md (~490 lines). Six workflow files were extracted to core/workflows/: sprint-lifecycle.md, development-workflow.md, analytics-workspace.md, hooks-reference.md, progress-files.md, and doc-triggers.md. The integration templates now carry compact summaries with pointers. This reduced duplication between tools (the workflows are shared) and reduced always-loaded context. The cost is an additional file read when a workflow is needed, but progressive context disclosure makes this worthwhile. Source: CHANGELOG 0.7.0.

- **The 7-step structural update lifecycle (v0.10.0).** The agentic-workflow lifecycle defines: Step 1 (Plan) dispatches to the planner; Step 2 (Align) the orchestrator presents to the owner; Step 3 (Execute) dispatches to the implementer; Step 4 (Verify) dispatches independently to methodology-reviewer, structural-validator, and architect; Step 5 (Incorporate) the orchestrator synthesizes verification results; Step 6 (Present) the orchestrator briefs the owner; Step 7 (Ship) the orchestrator handles git operations. The protocol is not purely linear -- Step 5 can loop back to Step 2 if verifier findings change the scope. This lifecycle was designed for systems where the methodology itself is the product, and it replaced the legacy SYSTEM-UPDATE.md protocol when Fabrika adopted it in v0.11.0. Source: PRD-01, CHANGELOG 0.10.0, core/workflows/agentic-workflow-lifecycle.md.

- **The dispatch protocol as a standalone document (v0.9.0).** Rather than scattering dispatch rules across agent prompts and workflow files, all per-agent contracts were centralized in dispatch-protocol.md. This document specifies exactly what the orchestrator provides and withholds at each invocation point. The contracts grew from the initial 16 agents to include 5 specialist implementers (v0.12.0), 6 architect contracts (v0.13.0), conditional PRD and Domain Language fields (v0.14.0, v0.15.0), and spec-first/coverage test-writer contracts (v0.16.0). Source: CHANGELOG 0.9.0, core/workflows/dispatch-protocol.md.

- **Design alignment as a workflow phase (v0.14.0).** Brain dumps no longer go directly to story creation. They flow through Design Alignment -- a structured requirements-gathering protocol -- to produce a Project Charter (once per project) and PRDs (per phase/feature), which the scrum master then decomposes into sprint stories. The protocol was inspired by Pocock's "grill-me" skill and Brooks' "design concept" from The Design of Design, but made more collaborative: the orchestrator offers recommendations and reads the codebase to self-answer where possible. Convergence checks every ~10 questions prevent infinite grilling. The key behavioral change: the orchestrator MUST prompt for new chats at phase boundaries (Design Alignment complete, Charter/PRD approved, Sprint planned) to keep context windows clean. Source: PRD-05, CHANGELOG 0.14.0.

- **Document hierarchy: brain dump to implementation (v0.14.0).** The full chain is: brain dump -> Design Alignment -> Project Charter (first time) -> PRD (per phase/feature) -> Sprint Planning (scrum master dispatched) -> Per-story specs (planner dispatched) -> Implementation (implementer dispatched). Each transition has a defined owner (orchestrator or agent), explicit output format, and fresh-chat boundary. This hierarchy replaced the previous flat model where the orchestrator jumped from brain dump to stories. Source: PRD-05, CHANGELOG 0.14.0.

- **Graduated testing: TDD, test-informed, test-after (v0.16.0).** Instead of a single "implement then test" flow, each sprint story is assigned a testing approach by the scrum master during sprint planning. TDD (high complexity): spec-first tests before code, implementation in vertical slices. Test-informed (medium complexity): implementer codes with awareness of test boundaries, then test-writer verifies. Test-after (low complexity): implement, then verify. The test-writer gained a spec-first mode for TDD stories where input is the approved spec only (no source code), and output is behavioral tests verifying the public interface. Vertical slice discipline is critical: one test -> one implementation -> next test, not all tests at once. Source: PRD-07, CHANGELOG 0.16.0.

- **The briefing system as structured communication (v0.5.1 through v0.17.0).** Owner briefings evolved from zero formal structure (v0.1.0-v0.4.0) to 9 briefing format files covering all three project type categories. The system started with spec and sprint plan briefings (v0.5.1), added session summary and retro briefings (v0.5.2), and expanded to analytics-workspace (task plan, task outcome) and agentic-workflow (structural plan, change summary) in v0.17.0. Cross-cutting principles are in briefing-principles.md; each format file defines sections, guidance, and translation examples. The design decision is that briefings always happen (not threshold-gated) -- depth scales naturally with complexity. Source: CHANGELOG 0.5.1, 0.5.2, 0.17.0, PRD-08.

- **Token cost visibility resolved in favor of transparency (v0.17.0).** An internal contradiction existed: session-summary-briefing.md said "no token counts in owner summary" while retro-briefing.md included a token efficiency table. PRD-08 resolved this: token costs appear in BOTH session summaries and retros, using approximate model-tier ranges (high-end/mid-tier/economy) rather than specific model names (which change). Per-agent-role breakdown is always included so the owner can see where tokens are being spent. Sprint retros use a drill-down structure: sprint total prominent, per-story costs in the main table, per-agent breakdown as glossable detail. Source: PRD-08, CHANGELOG 0.17.0.

- **The wiki knowledge pipeline (v0.18.0).** A 5-phase pipeline transforms scattered project artifacts (ADRs, retro findings, evaluation reports, research docs) into organized, continuously updated topic articles. Phase 1 (Extract) pulls content from artifacts. Phase 2 (Index) scores salience and produces batch JSON intermediates. Phase 3 (Synthesize) clusters by topic and writes/updates articles. Phase 4 (Link) cross-references related topics. Phase 5 (Glossary) feeds new terms back to Domain Language. Sprint-based projects run Extract+Index during maintenance, Synthesize+Link every 2-3 sprints, and full reintegration quarterly. Topic articles are created via notice-and-proceed -- the agent creates and notifies, proceeding unless the owner objects. Source: PRD-09, CHANGELOG 0.18.0.

- **Evaluation cycle with orchestrator-as-translator (v0.12.0).** After implementation, the evaluation cycle dispatches to reviewer and validator agents independently. If they find issues, the orchestrator translates their findings into implementer fix instructions rather than having the implementer read raw evaluation reports directly. This translation step adds a round trip but ensures the implementer receives instructions in its own domain vocabulary rather than evaluator jargon. Maximum 2 retry cycles before escalating to the owner. Source: CHANGELOG 0.12.0, core/workflows/development-workflow.md.

- **Fresh-chat boundaries as hygiene gates (v0.7.0, formalized v0.14.0).** Context windows degrade over long conversations. Fabrika mandates fresh chats at defined boundaries: after Design Alignment is complete, after Charter/PRD approval, and between sprint phases. The sprint lifecycle uses a cycle phase indicator (alignment, planning, dev, review, maintenance, retro) to signal which phase a chat belongs to. This is not optional -- it is a structural constraint to prevent context pollution between phases. Source: CHANGELOG 0.7.0, PRD-05.

- **Domain Language as a workflow-integrated living document (v0.15.0).** The old Glossary (Tier 4, static, optional) was elevated to Domain Language (Tier 1, living). Terms are captured during Design Alignment, consumed by planners and implementers via dispatch contracts, checked during code review (Terminology Consistency criterion), and audited during maintenance (Terminology Drift Check). Briefings draw jargon glossary definitions from Domain Language rather than inventing them ad hoc. Source: PRD-06, CHANGELOG 0.15.0.

- **Maintenance checklist as an evolving workflow (v0.1.0 through v0.18.0).** The maintenance checklist has been the most frequently modified file in Fabrika's history, gaining sections for evaluation findings sweep (v0.3.0), pattern and lint rule curation (v0.4.0), token usage review (v0.4.0), architecture review with spiral mitigation (v0.13.0), terminology drift check (v0.15.0), and knowledge synthesis (v0.18.0). It runs between sprints and includes conditional gates (architecture review only triggers under specific conditions, knowledge synthesis only runs when wiki/ exists). Source: CHANGELOG 0.3.0, 0.4.0, 0.13.0, 0.15.0, 0.18.0.

## Current State

As of v0.19.0, the workflow system includes:

**Sprint-based workflow** (8 project types):
- Design Alignment protocol for requirements gathering (brain dump -> Charter/PRD)
- Sprint lifecycle with phase indicator (alignment, planning, dev, review, maintenance, retro)
- Development workflow with testing approach branching (TDD/test-informed/test-after)
- Dispatch protocol with per-agent contracts and lightweight dispatch path
- Evaluation cycle with orchestrator-as-translator feedback loop
- 9 briefing formats across sprint, session, retro, spec, task, and structural contexts
- Maintenance checklist with 7+ sections including knowledge synthesis
- Hook system with 7 git hooks and 4 tool-specific hooks

**Task-based workflow** (analytics-workspace):
- Task lifecycle: brief -> plan -> execute -> validate -> deliver
- Design Alignment for complex analyses (3+ sources, novel domain, >2 day effort)
- Cost estimation in the plan phase
- Task promotion workflow (5-level graduation ladder for recurring analyses)
- Task plan and task outcome briefing formats
- Knowledge pipeline: Extract+Index after each task delivery, Synthesize+Link monthly

**Agentic-workflow** (methodology-based):
- 7-step structural update lifecycle (Plan, Align, Execute, Verify, Incorporate, Present, Ship)
- Three independent verification agents at Step 4
- Structural plan briefing (Step 2) and change summary briefing (Step 6)
- Owner-gated plan approval at Step 2

**Cross-cutting workflows:**
- Knowledge pipeline with 5 phases (Extract, Index, Synthesize, Link, Glossary)
- Doc-triggers table mapping situations to document creation actions
- Bug workflow connecting bug reports to agent quality improvement

## Open Questions

- **Agentic-workflow plan persistence gap.** The agentic-workflow lifecycle currently keeps the aligned plan in conversation only (not persisted as a file), unlike sprint-based projects (which persist specs at `docs/plans/[TICKET]-spec.md`) and analytics-workspace projects (which persist briefs and plans as files). This means the implementation contract for agentic-workflow changes is ephemeral. This gap has been identified and is slated for resolution in a future update (PRD-12). The target design: persist agentic-workflow plans as files, re-invoke the planner after owner feedback to revise the file, and have validators assess against the plan file -- consistent with how sprint-based and analytics-workspace projects work.

- **TDD for analytics-workspace.** The graduated testing approach (v0.16.0) was designed primarily for sprint-based projects. Test boundaries for SQL and analysis work are less clear than for application code. Whether analytics-workspace tasks benefit from TDD-style spec-first testing, and what that looks like in practice, is unresolved.

- **Workflow complexity for new contributors.** The workflow system has grown significantly. A new maintainer or contributor needs to understand the sprint lifecycle, development workflow, dispatch protocol, briefing system, maintenance checklist, and knowledge pipeline. Whether the current documentation adequately supports this onboarding, or whether a "workflow quick start" document is needed, is an open question.

- **Cadence calibration for knowledge synthesis.** The 2-3 sprint trigger for Synthesize+Link and the quarterly trigger for full reintegration are guidelines from PRD-09, not empirically validated. Whether these cadences are too frequent (wasting tokens on small increments) or too infrequent (letting knowledge go stale) will depend on consumer project usage patterns.

## Related Topics

- [Agent Model](agent-model.md) -- agents that execute within these workflows
- [Framework Philosophy](framework-philosophy.md) -- principles that constrain workflow design
- [Owner Preferences](owner-preferences.md) -- briefing and communication patterns within workflows
- [Harvest Patterns](harvest-patterns.md) -- how workflow outputs feed back into canonical Fabrika

## Sources

### CHANGELOG versions
- v0.1.0 -- initial sprint workflow, 4 agents, git hooks
- v0.3.0 -- bug workflow, maintenance checklist improvements
- v0.4.0 -- canonical patterns, token observability, progressive context disclosure
- v0.5.0 -- deterministic enforcement layer (expanded hooks)
- v0.5.1 -- spec and sprint plan briefing formats
- v0.5.2 -- session summary and retro briefing formats
- v0.7.0 -- progressive context decomposition (6 workflow files extracted)
- v0.8.0 -- cost awareness, task promotion workflow, supplemental reviewers
- v0.9.0 -- dispatch protocol, archetype templates, retry protocol
- v0.10.0 -- agentic-workflow lifecycle (7-step structural update)
- v0.12.0 -- pure orchestrator rewrite, implementer dispatch, orchestrator-as-translator
- v0.13.0 -- architect invocation points, spiral mitigation in maintenance
- v0.14.0 -- design alignment, project charter, PRD, document hierarchy
- v0.15.0 -- Domain Language integration, terminology drift check in maintenance
- v0.16.0 -- graduated testing (TDD/test-informed/test-after), spec-first mode
- v0.17.0 -- briefing system expansion (analytics-workspace, agentic-workflow), token cost visibility
- v0.18.0 -- wiki knowledge pipeline (5 phases), cadence integration, backfill mechanism

### PRDs
- PRD-01 -- agentic-workflow lifecycle design
- PRD-03 -- pure orchestrator, implementer dispatch, orchestrator-as-translator
- PRD-04 -- architect invocation points, spiral mitigation
- PRD-05 -- design alignment protocol, document hierarchy, fresh-chat boundaries
- PRD-06 -- Domain Language integration into workflows
- PRD-07 -- graduated testing, vertical slice discipline, spec-first mode
- PRD-08 -- briefing system improvements, token cost visibility
- PRD-09 -- wiki knowledge pipeline, cadence integration, notice-and-proceed model

### Core files
- core/workflows/agentic-workflow-lifecycle.md -- 7-step structural update lifecycle
- core/workflows/development-workflow.md -- sprint-based development workflow
- core/workflows/sprint-lifecycle.md -- sprint phase management
- core/workflows/analytics-workspace.md -- task-based lifecycle
- core/workflows/dispatch-protocol.md -- per-agent dispatch contracts
- core/workflows/knowledge-pipeline.md -- wiki 5-phase pipeline
- core/workflows/knowledge-synthesis.md -- maintenance-integrated synthesis workflow
- core/workflows/design-alignment.md -- requirements gathering protocol
- core/briefings/briefing-principles.md -- cross-cutting briefing principles
- core/maintenance-checklist.md -- between-sprint maintenance workflow
