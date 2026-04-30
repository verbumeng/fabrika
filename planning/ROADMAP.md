# Fabrika 0.10.0–0.19.0 Roadmap

This roadmap was produced during an alignment session on 2026-04-27.
It covers 10 PRDs that fundamentally evolve Fabrika's agent model,
workflow, and knowledge management.

## Sequencing

PRDs 01-02 are **bootstrap** PRDs — they use the current SYSTEM-UPDATE.md
protocol because the new process doesn't exist yet. Once PRD-02 lands,
Fabrika is an agentic-workflow project and all subsequent PRDs execute
through the new workflow.

| Order | PRD | Version | Depends On | Execution Method |
|---|---|---|---|---|
| 1 | [PRD-01: Agentic-Workflow Project Type](PRD-01-agentic-workflow-project-type.md) | 0.10.0 | — | SYSTEM-UPDATE.md |
| 2 | [PRD-02: Apply Agentic-Workflow to Fabrika](PRD-02-apply-agentic-workflow-to-fabrika.md) | 0.11.0 | PRD-01 | SYSTEM-UPDATE.md |
| 3 | [PRD-03: Implementer + Pure Orchestrator](PRD-03-implementer-archetype-pure-orchestrator.md) | 0.12.0 | PRD-01, PRD-02 | Agentic-workflow |
| 4 | [PRD-04: Architect Archetype](PRD-04-architect-archetype.md) | 0.13.0 | PRD-01, PRD-03 | Agentic-workflow |
| 5 | [PRD-05: Design Alignment + Charter + PRD](PRD-05-design-alignment-project-charter-prd.md) | 0.14.0 | PRD-03 | Agentic-workflow |
| 6 | [PRD-06: Domain Language](PRD-06-domain-language.md) | 0.15.0 | PRD-05 | Agentic-workflow |
| 7 | [PRD-07: TDD Integration](PRD-07-tdd-integration.md) | 0.16.0 | PRD-03, PRD-04 | Agentic-workflow |
| 8 | [PRD-08: Briefing Improvements](PRD-08-briefing-system-improvements.md) | 0.17.0 | PRD-06 | Agentic-workflow |
| 9 | [PRD-09: Wiki — Consumer Projects](PRD-09-wiki-knowledge-layer-consumer-projects.md) | 0.18.0 | PRD-06 | Agentic-workflow |
| 10 | [PRD-10: Wiki — Canonical Fabrika](PRD-10-wiki-knowledge-layer-canonical-fabrika.md) | 0.19.0 | PRD-02, PRD-06, PRD-09 | Agentic-workflow |

## Execution Protocol

Each PRD is executed in a **fresh chat** to keep context clean. The
user starts a new Claude Code session and provides the execution prompt
(see below). Each chat follows the system update protocol end-to-end:
plan → align → execute → verify → incorporate → present → ship.

## Follow-Up PRDs (Outside Original Roadmap)

| PRD | Version | Status | Notes |
|---|---|---|---|
| [PRD-11: Analytics Pre-Execution Review](PRD-11-analytics-pre-execution-review.md) | TBD | Needs Design Alignment | Add pre-execution review gate to analytics-workspace so reviewers assess SQL before it hits the warehouse. Identified during PRD-07 alignment (2026-04-30). |
| [PRD-12: Plan Persistence Alignment](PRD-12-plan-persistence-alignment.md) | TBD | Needs Design Alignment | Align plan artifact persistence across all project types so agentic-workflow plans are files (like sprint-based specs and analytics-workspace plans), re-invoked through the planner on owner feedback, and used as validation artifacts. Also addresses Fabrika "PRD" terminology confusion. Identified during PRD-10 alignment (2026-04-30). |

## Themes

- **Agent model evolution** (PRDs 01-04): Pure orchestrator, implementer
  agents, architect agents, agentic-workflow project type
- **Requirements and planning** (PRDs 05-06): Design alignment, project
  charter, PRD documents, domain language
- **Development quality** (PRDs 07-08): TDD integration, briefing
  improvements
- **Knowledge management** (PRDs 09-10): Wiki knowledge layer for
  consumer projects and canonical Fabrika
