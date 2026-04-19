# Fabrika

An agentic workflow methodology for software development. Fabrika gives AI coding agents (Claude Code, GitHub Copilot) a structured framework for sprint planning, code review, testing, and continuous improvement — so the human focuses on decisions and the agent drives execution.

## What's in the box

- **Four specialized agents** (scrum-master, product-manager, code-reviewer, test-writer) with defined roles, trigger points, and evaluation rubrics
- **Three sprint topologies** (pipeline, mesh, hierarchical) that adapt the workflow to how tasks are coupled
- **A complete project documentation structure** with a catalog of ~50 documents organized by project type and priority tier
- **An evaluation harness** that builds itself over time from real observed failures — not synthetic benchmarks
- **A sprint lifecycle** with deliberate chat boundaries, maintenance sessions, and structured retrospectives
- **A harvest loop** for flowing learnings from individual projects back into the canonical framework

## Quick start

**New project:** Point an agent at [BOOTSTRAP.md](BOOTSTRAP.md) and tell it your project name. It drives the rest.

**Existing project:** Point an agent at [ADOPT.md](ADOPT.md). It reads your repo structure and offers tiered integration — from "just the agents" to "full restructure."

**Updating:** When a new Fabrika version ships, point an agent at [UPDATE.md](UPDATE.md). It reads your project's `.fabrika/manifest.yml`, diffs against the changelog, and updates only what changed.

## Project types

Fabrika is project-type-aware. The Document Catalog and bootstrap process adapt based on what you're building:

| Type | Description |
|------|-------------|
| `data-app` | Dashboards, reporting tools, data entry apps — replacing Excel |
| `data-platform` | Pipelines, transformations (dbt), analytics engineering (DuckDB) |
| `ml-project` | Model development, training, evaluation |
| `web-app` | Full-stack web applications, SaaS, APIs |
| `automation` | Scripts, CLIs, bots, scheduled jobs |

Projects can be multi-type. A data app with scrapers is `data-app` + `automation`.

## Integrations

Fabrika currently supports two AI coding tool integrations:

- **Claude Code** — Full integration: project CLAUDE.md, `.claude/agents/`, hooks, settings
- **GitHub Copilot** — Project instructions, `.github/agents/`

The canonical agent definitions in `core/agents/` are tool-agnostic. Each integration adapts them to the tool's conventions (file naming, placement).

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

Built by [VerbumEng](https://github.com/verbumeng). For integration guides, workflows, and deep dives, subscribe to the [newsletter](https://verbum.ing).
