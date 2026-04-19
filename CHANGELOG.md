# Changelog

All notable changes to Fabrika are documented here.

Format: each version lists changed files and the nature of the change. Consumer projects use the CHANGELOG to determine which files need updating (see UPDATE.md).

---

## 0.1.0

Initial public release. Agentic workflow methodology for Claude Code and GitHub Copilot.

### Core
- `core/agents/scrum-master.md` — Sprint planning, topology assessment, maintenance scheduling, retros
- `core/agents/product-manager.md` — Planning mode (spec expansion) and validation mode (acceptance criteria)
- `core/agents/code-reviewer.md` — Skeptical evaluation with grading rubrics, regression safety, topology scope enforcement
- `core/agents/test-writer.md` — Test writing, E2E verification, coverage reporting
- `core/topologies/Sprint-Contract-Pipeline.md` — Pipeline topology sprint contract template
- `core/topologies/Sprint-Contract-Mesh.md` — Mesh topology sprint contract template
- `core/topologies/Sprint-Contract-Hierarchical.md` — Hierarchical topology sprint contract template
- `core/templates/` — 11 templates: ADR, Epic, Story, Sprint, Sprint-Progress, Sprint-Retro, Session-Log, Feature-Spec, Dashboard-Spec, Data-Source-Research, Model-Design
- `core/rubrics/code-review-rubric.md` — Weighted grading criteria for code-reviewer agent
- `core/rubrics/test-rubric.md` — Weighted grading criteria for test-writer agent
- `core/hooks/` — 3 hooks: pre-push (regression gate), post-commit (STATUS.md reminder), pre-commit (mesh isolation scope)
- `core/evals/` — Evaluation harness scaffold: README, agent-changelog template, eval artifact template
- `core/Document-Catalog.md` — Full inventory of project documents by type and tier
- `core/maintenance-checklist.md` — Between-sprint maintenance session checklist
- `core/STATUS-template.md` — Project status snapshot template
- `core/features-template.json` — Agent-facing feature pass/fail tracker template

### Integrations
- `integrations/claude-code/CLAUDE.md` — Consumer project configuration template for Claude Code
- `integrations/claude-code/settings-template.json` — Claude Code settings template
- `integrations/copilot/copilot-instructions.md` — Consumer project configuration template for GitHub Copilot

### Operational Docs
- `BOOTSTRAP.md` — Agent-driven guide for bootstrapping new projects
- `ADOPT.md` — Tiered guide for integrating Fabrika into existing projects
- `UPDATE.md` — Protocol for updating consumer projects to newer Fabrika versions
- `MANIFEST_SPEC.md` — Specification for the `.fabrika/manifest.yml` consumer projects carry
- `HARVEST.md` — Workflow for harvesting generalizable learnings from project-local agent forks
