# Fabrika

An agentic workflow methodology for software development and data work. Fabrika gives AI coding agents (Claude Code, GitHub Copilot) a structured framework for sprint planning, code review, testing, and continuous improvement — so the human focuses on decisions and the agent drives execution.

## What's in the box

- **Thirteen specialized agents** organized by role archetype (planner, reviewer, validator, coordinator) — each project type gets the right set via the Agent Catalog
- **Three sprint topologies** (pipeline, mesh, hierarchical) for sprint-based project types, plus a task lifecycle (brief, plan, execute, validate, deliver) for analytics workspaces
- **A complete project documentation structure** with a catalog of 60+ documents organized by project type and priority tier
- **An evaluation harness** with baseline evals that ship day one, plus a framework for building project-specific evals from real observed failures
- **A sprint lifecycle** with deliberate chat boundaries, maintenance sessions, and structured retrospectives
- **A harvest loop** for flowing learnings from individual projects back into the canonical framework

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

### Task-based types (brief, plan, execute, validate, deliver)
| Type | Description |
|------|-------------|
| `analytics-workspace` | Ad hoc analysis, investigations, data requests |

Sprint-based projects can be multi-type. A data app with scrapers is `data-app` + `automation`. An AI chatbot with a web frontend is `ai-engineering` + `web-app`.

## Integrations

Fabrika currently supports two AI coding tool integrations:

- **Claude Code** — Full integration: project CLAUDE.md, `.claude/agents/`, hooks, settings
- **GitHub Copilot** — Project instructions, `.github/agents/`

The canonical agent definitions in `core/agents/` are tool-agnostic. The Agent Catalog (`core/agents/AGENT-CATALOG.md`) maps project types to the right set of agents. Each integration adapts them to the tool's conventions (file naming, placement).

## How it works

Read the [BOOTSTRAP.md](BOOTSTRAP.md) for the full workflow. The short version:

1. **Bootstrap** — Agent creates project structure, extracts a brain dump, builds backlog, scopes Sprint 1
2. **Sprint** — Each story gets its own chat. Agent plans, builds, and evaluates with subagents. Fresh chats at phase boundaries keep context clean.
3. **Between sprints** — Merge, maintenance, retro, planning. Four chats, not bundled.
4. **Over time** — The evaluation harness captures agent failures. Maintenance proposes prompt improvements. The harvest loop flows generalizable learnings back to canonical Fabrika.

## Versioning

Fabrika uses semantic versioning. Consumer projects carry a `.fabrika/manifest.yml` that tracks what was installed and when. See [MANIFEST_SPEC.md](MANIFEST_SPEC.md) for the spec, [UPDATE.md](UPDATE.md) for the update protocol.

## License

MIT License. See [LICENSE](LICENSE).

Built by [VerbumEng](https://github.com/verbumeng). For integration guides, workflows, and deep dives, subscribe to the [newsletter](https://verbumeng.substack.com/).
