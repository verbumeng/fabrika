# Changelog

All notable changes to Fabrika are documented here.

Format: each version lists changed files and the nature of the change. Consumer projects use the CHANGELOG to determine which files need updating (see UPDATE.md).

---

## 0.2.0

Framework relationship documentation and harvest workflow improvements. Consumer projects now understand how local agent changes flow back to canonical Fabrika.

### Core (changed — consumer projects should update)
- `core/FABRIKA.md` — **NEW.** Framework relationship guide placed in consumer projects at `.fabrika/FABRIKA.md`. Explains the eval artifact → harvest → canonical update → propagation flow. Read on demand by agents, not always-loaded.
- `core/templates/Sprint-Retro-Template.md` — **CHANGED.** Added "Fabrika Eval Artifact" section with checklist item so retros can't complete without writing the eval artifact.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Replaced verbose Fabrika Relationship section with a 2-line pointer to `.fabrika/FABRIKA.md`. Reduces always-loaded context.

### Operational Docs (changed — no consumer action needed)
- `ADOPT.md` — **CHANGED.** Added merge-not-overwrite protocols for agent files, hooks, .gitignore, and Justfile. Added FABRIKA.md copy step to all tiers. Expanded conflict handling with per-file-type table.
- `BOOTSTRAP.md` — **CHANGED.** Added FABRIKA.md copy step to Phase 1.4.
- `HARVEST.md` — **CHANGED.** Added concrete "How to Run the Harvest" section with three options: copy-paste agent prompt, review system integration, and ad hoc triggers. Added "Verifying Eval Artifacts Exist" troubleshooting section.
- `CHANGELOG.md` — Updated for 0.2.0.
- `VERSION` — Bumped to 0.2.0.

### Consumer update instructions
Projects on 0.1.0 should:
1. Copy `core/FABRIKA.md` → `.fabrika/FABRIKA.md` (new file)
2. Update `docs/Templates/Sprint-Retro-Template.md` from `core/templates/Sprint-Retro-Template.md` (if not customized)
3. Update `CLAUDE.md` — replace the Fabrika Relationship section with the slim 2-line version pointing to `.fabrika/FABRIKA.md` (if the project has one; this was only added post-0.1.0 so some projects may not have it)

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
- `core/FABRIKA.md` — Framework relationship guide placed in consumer projects at `.fabrika/FABRIKA.md` (read on demand, not always-loaded)

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
