# Owner Preferences

## Summary

This article documents framework-level design decisions about how Fabrika communicates with project owners, how alignment sessions work, and what calibration assumptions the framework makes about its audience. These are not personal preferences of a specific individual -- they are codified communication patterns that agents follow, embedded in briefing formats, dispatch contracts, and workflow definitions. They exist because structured communication between agents and owners is a prerequisite for effective agentic workflows: an agent that cannot explain what it is doing in terms the owner understands will produce work the owner cannot evaluate.

The communication design evolved from informal patterns into explicit framework artifacts over Fabrika's history. The first briefing formats appeared in v0.5.1; by v0.17.0 the system had grown to 9 briefing format files with cross-cutting principles, canonical token cost reporting, and coverage across all three project type categories (sprint-based, analytics-workspace, agentic-workflow). The underlying philosophy is that communication is not overhead -- it is part of the methodology. An agent that implements correctly but explains poorly creates alignment problems that compound across sprints.

## Key Decisions

- **Plain-language briefing as a framework requirement (v0.5.1, refined through v0.17.0).** Briefings translate agent artifacts (specs, sprint contracts, evaluation reports) into plain-language summaries focused on product impact. The agent does not dump raw artifacts or give terse summaries; it follows a structured format that explains what is being built, why, how it fits into the product, and where the judgment calls are. This is codified in briefing-principles.md and nine format files. The design decision is that agents must bridge the gap between machine-optimized artifacts and human decision-making, not leave the translation to the owner. Source: CHANGELOG 0.5.1, core/briefings/briefing-principles.md.

- **Lead with product impact, not implementation (v0.5.1).** "Users will be able to filter by date range" comes before "adds a DateRangeFilter component." This principle applies to all briefing formats. The rationale: the owner's job is to make decisions, catch design problems, and guide taste -- that requires understanding what changes for the end user. Implementation details are supporting evidence, not the headline. Source: core/briefings/briefing-principles.md.

- **Define terms every time, even if defined before (v0.5.1, enriched v0.15.0).** Repetition is cheap; confusion is expensive. Every briefing includes a jargon glossary. When a Domain Language document exists (v0.15.0+), the glossary draws from it rather than inventing definitions ad hoc. New terms introduced in a briefing that are not in Domain Language are flagged for addition. This ensures vocabulary consistency across briefings, specs, and code. Source: core/briefings/briefing-principles.md, PRD-06.

- **Assume the owner hasn't touched the codebase in a week (v0.5.1).** Re-establish context every time. Do not assume the owner remembers variable names, data model fields, or decisions from previous sprints. This calibration assumption drives the verbosity level of briefings and is a design choice, not a personality accommodation -- any project owner working across multiple projects or taking breaks between sessions will benefit from re-contextualization. Source: core/briefings/briefing-principles.md.

- **Make disagreement easy (v0.5.1).** Frame design decisions as choices, not foregone conclusions. Present alternatives that were considered, not just the winner. The briefing should make the owner feel invited to push back. This is a framework-level design decision about power dynamics in agentic workflows: the agent proposes, the owner decides. If disagreement is effortful, the owner defaults to accepting proposals they may not fully understand. Source: core/briefings/briefing-principles.md.

- **Explain technical language in user-impact terms (v0.17.0).** When spec briefings frame design alternatives, they explain in terms of user impact, not implementation technology. If technical terminology is necessary, it gets defined in the jargon glossary AND flagged for Domain Language addition. Before/after translation examples were added to sprint plan briefings (topology choices), session summary briefings (evaluation findings), and spec briefings. This was driven by the observation that topology terminology like "mesh" or "pipeline" means nothing to the owner without translation. Source: PRD-08, CHANGELOG 0.17.0.

- **Token cost transparency (v0.17.0).** An internal contradiction between "no token counts in owner summary" and retro token efficiency tables was resolved in favor of transparency. Token costs appear in both session summaries and retros using approximate model-tier ranges (high-end/mid-tier/economy) rather than specific model names. Per-agent-role breakdown is always included so the owner can see where tokens are being spent. Sprint retros use drill-down structure: sprint total prominent at top, per-story costs in the main table, per-agent breakdown as glossable detail underneath. The rationale: the owner explicitly wants cost visibility, and model-tier ranges survive pricing changes. Source: PRD-08, CHANGELOG 0.17.0.

- **Briefings always presented, not threshold-gated (v0.17.0).** For analytics-workspace task plan and task outcome briefings, the design decision was to always present briefings rather than conditionally triggering them above a complexity threshold. Depth scales naturally -- simple tasks produce short briefings. The format ensures nothing is missed, not that everything is verbose. Consistency over optionality. Source: PRD-08, CHANGELOG 0.17.0.

- **Design alignment as collaborative conversation (v0.14.0).** When gathering requirements, the orchestrator walks the design tree by asking one question at a time, providing a recommended answer (owner can say yes/no), and reading the codebase to self-answer where possible. This is more collaborative than adversarial -- inspired by Pocock's "grill-me" skill but adapted to respect that the owner is working within a system with existing context. Convergence checks every ~10 questions prevent infinite grilling. Question categories (scope, users, behavior, constraints, integration, success criteria, terminology) are orchestrator thinking prompts, not a user-visible checklist. Source: PRD-05, CHANGELOG 0.14.0.

- **Narrate what you're doing and explain why (framework calibration).** Agents should explain architectural decisions and trade-offs in plain language. When choosing between approaches, explain why one was chosen. When something could be done multiple ways, briefly mention the alternatives. This applies to implementation commentary, briefings, and alignment conversations. The calibration is that the framework's documentation and communication should be accessible to someone learning software development, not assume senior-dev expertise. This is a framework design decision about audience -- Fabrika is meant to be usable by people at various experience levels, not just experts who can fill in gaps. Source: CLAUDE.md (global instructions, framework-level calibration).

- **Fresh-chat boundaries and brain-dump-to-align-to-execute flow (v0.14.0).** The alignment pattern is: the owner brain dumps, the orchestrator runs Design Alignment, produces Charter/PRD, gets owner approval, then starts a new chat for sprint planning. The brain dump is captured but not directly acted on -- it flows through a structured protocol first. Each phase transition gets an explicit prompt telling the user to start a new chat. This is not merely a context window optimization; it enforces separation of concerns so that alignment thinking does not bleed into implementation thinking. Source: PRD-05, CHANGELOG 0.14.0.

- **Version discipline as a communication contract (pre-v0.10.0, codified in CLAUDE.md).** Every canonical change requires a version bump and CHANGELOG entry. This is not just about release management -- it is a communication contract with consumers. Each CHANGELOG entry tells consumers exactly which files changed, what the nature of the change is, and what actions they need to take. Consumer update instructions are part of every CHANGELOG entry. If a change requires consumers to do anything beyond a straight file overwrite, it gets a MIGRATIONS.md entry. This discipline makes the framework maintainable at scale -- a consumer on v0.14.0 can read the CHANGELOG entries for v0.15.0, v0.16.0, v0.17.0, and v0.18.0 to know exactly what to update. Source: CLAUDE.md (project-level), CHANGELOG (all versions).

## Current State

As of v0.19.0, the communication design is implemented through:

**9 briefing format files:**
- Spec briefing (sprint-based, after planner produces spec)
- Sprint plan briefing (sprint-based, after scrum master plans)
- Session summary briefing (sprint-based, at session close-out)
- Retro briefing (sprint-based, at sprint retrospective)
- Task plan briefing (analytics-workspace, after plan creation)
- Task outcome briefing (analytics-workspace, after task delivery)
- Structural plan briefing (agentic-workflow, at Step 2 Align)
- Change summary briefing (agentic-workflow, at Step 6 Present)
- Briefing principles (cross-cutting, applies to all formats)

**Communication-integrated workflows:**
- Design Alignment protocol with question categories, convergence checks, and fresh-chat boundaries
- Domain Language document (Tier 1) ensuring vocabulary consistency across all communication
- Token cost reporting with canonical format defined in briefing-principles.md
- Evaluation findings translation examples (before/after) in session summary briefings
- Topology translation examples (before/after) for all three topologies in sprint plan briefings

**Calibration assumptions embedded in the framework:**
- Re-establish context every time (assume owner has been away)
- Briefings always presented (not conditional on complexity)
- Per-agent-role cost breakdown always shown (not conditional on cost seeming high)
- Design decisions framed as choices with alternatives
- Technical terminology defined in jargon glossary and flagged for Domain Language

## Open Questions

- **Briefing format proliferation.** With 9 format files, the briefing system is comprehensive but large. Whether additional project types or workflow phases will need further formats, and how to prevent the system from becoming unwieldy, is a design consideration.

- **Owner calibration for different experience levels.** The current calibration assumes a non-expert audience — someone who understands their domain but is new to software development. Whether Fabrika should offer multiple calibration levels (beginner, intermediate, advanced) or keep a single conservative default is unresolved. The current position is that over-explaining is cheaper than under-explaining.

- **Alignment protocol for trivial changes.** Design Alignment triggers on new projects, new phases, ambiguity, or owner request. For small features or bugfixes, the full alignment protocol may be excessive. The current sprint workflow handles this (stories go through planner spec expansion, not full Design Alignment), but the boundary between "needs alignment" and "just plan it" is judgment-based.

- **Cross-sprint context continuity.** Briefings re-establish context because they assume the owner has been away. But for owners working daily on a single project, this re-contextualization may feel redundant. Whether the framework should adapt its verbosity based on session frequency is an open question -- currently the answer is "always re-contextualize, repetition is cheap."

## Related Topics

- [Framework Philosophy](framework-philosophy.md) -- principles that drive communication design decisions
- [Workflow Design](workflow-design.md) -- workflows that include briefing and alignment steps
- [Agent Model](agent-model.md) -- agents that follow these communication patterns

## Sources

### CHANGELOG versions
- v0.5.1 -- spec briefing, sprint plan briefing, briefing principles
- v0.5.2 -- session summary briefing, retro briefing
- v0.14.0 -- design alignment protocol, Project Charter, PRD, document hierarchy, fresh-chat boundaries
- v0.15.0 -- Domain Language integration into briefings
- v0.17.0 -- analytics-workspace and agentic-workflow briefing formats, token cost visibility, translation examples

### PRDs
- PRD-05 -- design alignment protocol, collaborative conversation model, convergence checks
- PRD-06 -- Domain Language as source for briefing jargon glossaries
- PRD-08 -- briefing system improvements, token cost visibility resolution, analytics-workspace and agentic-workflow coverage

### Core files
- core/briefings/briefing-principles.md -- cross-cutting briefing principles and token cost format
- core/briefings/spec-briefing.md -- spec briefing format with technical language guidance
- core/briefings/sprint-plan-briefing.md -- sprint plan briefing with topology translation examples
- core/briefings/session-summary-briefing.md -- session summary with evaluation findings translation
- core/briefings/retro-briefing.md -- retro briefing with drill-down token efficiency
- core/briefings/task-plan-briefing.md -- analytics-workspace plan briefing
- core/briefings/task-outcome-briefing.md -- analytics-workspace outcome briefing
- core/briefings/structural-plan-briefing.md -- agentic-workflow Step 2 briefing
- core/briefings/change-summary-briefing.md -- agentic-workflow Step 6 briefing
- core/workflows/protocols/design-alignment.md -- requirements gathering protocol
