# Fabrika

An agentic workflow methodology for software development and data work. Fabrika gives AI coding agents (Claude Code, GitHub Copilot) a structured framework for sprint planning, code review, testing, and continuous improvement — so the human focuses on decisions and the agent drives execution.

## What's in the box

- **28 specialized agents** across 7 archetypes (planner, reviewer, validator, coordinator, designer, implementer, architect) — the [Agent Catalog](core/agents/AGENT-CATALOG.md) maps each project type to the right set
- **A dispatch protocol** governing what context each agent receives at each invocation point — strict isolation for reviewers, contextual dispatch for planners
- **Three sprint topologies** (pipeline, mesh, hierarchical) for sprint-based projects, plus a tiered pre-execution review workflow for analytics workspaces
- **A Design Alignment protocol** that turns brain dumps into durable Project Charters and PRDs before sprint planning begins
- **A Domain Language system** — living vocabulary documents that flow into briefings, dispatch contracts, code review, and maintenance checks
- **A wiki knowledge layer** that consolidates scattered project artifacts into organized, continuously updated topic articles
- **A briefing system** with 9 formats for translating technical output into plain-language owner communication
- **Graduated testing** — TDD, test-informed, or test-after assigned per story based on complexity
- **A project documentation structure** with a catalog of 90+ document types organized by project type and priority tier
- **An evaluation harness** with baseline evals that ship day one, plus a framework for building project-specific evals from real observed failures
- **A sprint lifecycle** with deliberate chat boundaries, maintenance sessions, and structured retrospectives
- **A harvest loop** for flowing learnings from individual projects back into the canonical framework
- **A task promotion workflow** for graduating recurring analyses into reusable templates, scripts, dashboards, and automated jobs

## Quick start

**New project:** Point an agent at [BOOTSTRAP.md](BOOTSTRAP.md) and tell it your project name. It drives the rest.

**Existing project:** Point an agent at [ADOPT.md](ADOPT.md). It reads your repo structure and offers tiered integration — from "just the agents" to "full restructure."

**Updating:** When a new Fabrika version ships, point an agent at [UPDATE.md](UPDATE.md). It reads your project's `.fabrika/manifest.yml`, diffs against the changelog, and updates only what changed.

## Project types

Fabrika is project-type-aware. The Document Catalog, agents, and bootstrap process adapt based on what you're building:

### Sprint-based types (plan, build, evaluate, iterate)
| Type | Description |
|------|-------------|
| `web-app` | Full-stack web applications, SaaS, APIs |
| `data-app` | Dashboards, reporting tools, data entry apps — replacing Excel |
| `analytics-engineering` | Modeled data layers — dbt, DuckDB, warehouse transformations |
| `data-engineering` | Full pipeline infrastructure — ingestion, storage, orchestration, serving |
| `ml-engineering` | Model development, training, evaluation |
| `ai-engineering` | LLM-powered applications — RAG, agents, prompt engineering |
| `automation` | Scripts, CLIs, bots, scheduled jobs |
| `library` | Reusable packages, SDKs, shared modules |

### Task-based types (tiered pre-execution review)
| Type | Description |
|------|-------------|
| `analytics-workspace` | Ad hoc analysis, investigations, data requests |

### Methodology-based types (structural update lifecycle)
| Type | Description |
|------|-------------|
| `agentic-workflow` | Systems where the methodology itself is the product — agent prompts, workflows, instruction files |

Sprint-based projects can be multi-type. A data app with scrapers is `data-app` + `automation`. An AI chatbot with a web frontend is `ai-engineering` + `web-app`.

## Integrations

Fabrika currently supports two AI coding tool integrations:

- **Claude Code** — Full integration: project CLAUDE.md, `.claude/agents/`, hooks, settings
- **GitHub Copilot** — Project instructions, `.github/agents/`

The canonical agent definitions in `core/agents/` are tool-agnostic. The Agent Catalog (`core/agents/AGENT-CATALOG.md`) maps project types to the right set of agents. Each integration adapts them to the tool's conventions (file naming, placement).

## How it works

Read the [BOOTSTRAP.md](BOOTSTRAP.md) for the full workflow. The short version:

1. **Bootstrap** — Agent creates project structure, extracts a brain dump, builds backlog, scopes Sprint 1
2. **Design Alignment** — Structured requirements gathering produces a Project Charter (once) and PRDs (per feature/phase) before sprint planning begins
3. **Sprint** — Each story gets its own chat with a testing approach (TDD, test-informed, or test-after). Agents are dispatched via the dispatch protocol with strict isolation boundaries. Fresh chats at phase boundaries keep context clean.
4. **Between sprints** — Merge, maintenance (including knowledge synthesis and terminology drift checks), retro, planning. Four chats, not bundled.
5. **Over time** — The evaluation harness captures agent failures. Maintenance proposes prompt improvements. The harvest loop flows generalizable learnings back to canonical Fabrika. The wiki consolidates design knowledge into persistent topic articles.

## Versioning

Fabrika uses semantic versioning. Consumer projects carry a `.fabrika/manifest.yml` that tracks what was installed and when. See [MANIFEST_SPEC.md](MANIFEST_SPEC.md) for the spec, [UPDATE.md](UPDATE.md) for the update protocol.

## License

MIT License. See [LICENSE](LICENSE).

Built by [VerbumEng](https://github.com/verbumeng). For integration guides, workflows, and deep dives, subscribe to the [newsletter](https://verbumeng.substack.com/).
