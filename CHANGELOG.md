# Changelog

All notable changes to Fabrika are documented here.

Format: each version lists changed files and the nature of the change. Consumer projects use the CHANGELOG to determine which files need updating (see UPDATE.md).

---

## 0.4.0

Harness engineering patterns inspired by Ryan Leapo's talk at Laten Space London. Adds canonical patterns, structural tests, lint-as-prompts, token observability, progressive context disclosure, and agent-locality guidance. These patterns formalize the "garbage collection loop" — the flywheel where observed agent failures become durable guardrails.

### Core (changed — consumer projects should update)
- `core/Document-Catalog.md` — **CHANGED.** Added three new doc types: Canonical Patterns (Tier 1, all types), Custom Lint Rules (Tier 3), and Structural Constraints (Tier 2). Updated Quick Reference sections for all project types.
- `core/rubrics/code-review-rubric.md` — **CHANGED.** Added criterion #7 "Pattern Conformance" (MEDIUM weight) — grades implementation against `docs/02-Engineering/Canonical-Patterns.md`. N/A if the doc does not exist yet. Renumbered Security to #8, Interface Contract to #9. Added N/A handling note to verdict scale.
- `core/rubrics/test-rubric.md` — **CHANGED.** Added criterion #7 "Structural Constraint Enforcement" (MEDIUM weight) — grades whether structural constraints have mechanical enforcement. N/A if no Structural Constraints doc exists. Renumbered Test Output Quality to #8.
- `core/maintenance-checklist.md` — **CHANGED.** Added two new checklist sections: "Pattern & Lint Rule Curation" (scan for canonical patterns to document, repeated code-reviewer feedback to convert into lint rules, structural constraint enforcement verification) and "Token Usage Review" (per-story token analysis, flagging disproportionately expensive stories, comparing predicted vs actual).
- `core/agents/scrum-master.md` — **CHANGED.** Added step 6: token budget estimation per story during sprint planning (observability only, not a hard cap). Added mesh topology assessment note about repo structure supporting isolation. Renumbered steps 7-10.
- `core/agents/product-manager.md` — **CHANGED.** Reinforced that owner approval of the spec is required before implementation begins — an unreviewed plan encodes potentially bad instructions.
- `core/agents/test-writer.md` — **CHANGED.** Added "Structural Tests" section: when `docs/02-Engineering/Structural-Constraints.md` exists, write tests that enforce codebase structure rules (file length, dependency edges, schema deduplication, banned imports, naming conventions). Tests produce prompt-style error messages with remediation instructions.
- `core/templates/Sprint-Progress-Template.md` — **CHANGED.** Added "Tokens (actual)" field to per-session entry template with measurement boundary guidance (begin story to ready for approval).
- `core/templates/Sprint-Retro-Template.md` — **CHANGED.** Added "Token Efficiency" section between Agent Quality Findings and Process Changes. Compares predicted vs actual token usage per story with calibration notes.
- `core/templates/Session-Log-Template.md` — **CHANGED.** Added "Token Usage" section with actual tokens and measurement notes fields.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added "Progressive context disclosure" and "Prefer improving existing agents over adding new ones" to Key Constraints. Updated session close-out step 15 to include token logging in sprint progress file.

### Operational Docs (changed — no consumer action needed)
- `BOOTSTRAP.md` — **CHANGED.** Updated step 2.5 to include Canonical-Patterns.md creation during bootstrap (start with 3-5 patterns). Added agent-locality guidance to Architecture Overview creation (prefer directory subtrees per domain).

### Consumer update instructions
Projects on 0.3.x should:
1. Update `docs/02-Engineering/rubrics/code-review-rubric.md` — add Pattern Conformance criterion (#7), renumber remaining criteria, add N/A note to verdict scale (or re-copy from `core/rubrics/code-review-rubric.md` if not customized)
2. Update `docs/02-Engineering/rubrics/test-rubric.md` — add Structural Constraint Enforcement criterion (#7), renumber Test Output Quality to #8 (or re-copy if not customized)
3. Update `docs/02-Engineering/maintenance-checklist.md` — add "Pattern & Lint Rule Curation" and "Token Usage Review" sections (or re-copy if not customized)
4. Create `docs/02-Engineering/Canonical-Patterns.md` with 3-5 patterns for your tech stack (new file)
5. Optionally create `docs/02-Engineering/Structural-Constraints.md` with codebase structure rules (new file, Tier 2)
6. Create `docs/02-Engineering/Custom-Lint-Rules/` directory (new, populate during maintenance)
7. Update `.claude/agents/scrum-master.md` from `core/agents/scrum-master.md` (adds token estimation step + mesh assessment note)
8. Update `.claude/agents/product-manager.md` from `core/agents/product-manager.md` (adds approval reinforcement)
9. Update `.claude/agents/test-writer.md` from `core/agents/test-writer.md` (adds structural tests section)
10. Update `docs/Templates/Sprint-Progress-Template.md` (adds token tracking field)
11. Update `docs/Templates/Sprint-Retro-Template.md` (adds Token Efficiency section)
12. Update `docs/Templates/Session-Log-Template.md` (adds Token Usage section)
13. Update `CLAUDE.md` — add "Progressive context disclosure" and "Prefer improving existing agents" to Key Constraints; add token logging to session close-out step 15

---

## 0.3.1

### Operational Docs (changed — no consumer action needed)
- `UPDATE.md` — **CHANGED.** Step 1 now validates manifest format against MANIFEST_SPEC.md and regenerates non-conformant manifests in-place before proceeding. Replaces the vague "corrupted manifest → re-run ADOPT.md" guidance with specific regeneration instructions. Needed because early consumer projects have inconsistent manifest formats (wrong field names, missing hashes, map-vs-list).

---

## 0.3.0

Harvest from 4 consumer projects (Notnomo, Conduit, Social-engine, Vaultsync) on Fabrika 0.1.0. Bug tracking system, maintenance checklist improvements, scrum-master task system step, and settings permission update.

### Core (changed — consumer projects should update)
- `core/templates/Bug-Report-Template.md` — **NEW.** Structured bug report template with evaluator tracing (`missed-by`, `introduced-by`), root cause analysis sections (code trace + evaluator trace), and eval case linkage. Bugs use separate numbering from stories (BXX).
- `core/bug-workflow.md` — **NEW.** End-to-end bug fix workflow: file → root cause analysis through evaluator history → fix with regression test → create eval case for missed failure mode. Connects bugs to agent quality improvement.
- `core/maintenance-checklist.md` — **CHANGED.** Added "Evaluation Findings Sweep" section between Code Quality and Test Health. Triages non-blocking observations from evaluation reports into trivial (fix now), small (story), or speculative (someday-maybe).
- `core/agents/scrum-master.md` — **CHANGED.** Added step 7: "Create external task entries (if configured)" during sprint planning. Closes gap between CLAUDE.md template (which referenced this) and the agent prompt (which didn't have the step).

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added bug tracking system integration: `Bugs/` directory in project structure, bug numbering in Backlog System, Bug Reporting & Fix Workflow subsection in Development Workflow, bug review in Maintenance Sessions summary, bugs as ground truth in Evaluation System lifecycle, bug trigger in Document Creation Triggers table.
- `integrations/claude-code/settings-template.json` — **CHANGED.** Added `TodoWrite` to default permissions allow list.

### Consumer update instructions
Projects on 0.2.0 (or 0.1.0) should:
1. Copy `core/templates/Bug-Report-Template.md` → `docs/Templates/Bug-Report-Template.md` (new file)
2. Copy `core/bug-workflow.md` → `docs/02-Engineering/bug-workflow.md` (new file)
3. Create `docs/04-Backlog/Bugs/` directory
4. Update `docs/02-Engineering/maintenance-checklist.md` — add "Evaluation Findings Sweep" section between Code Quality and Test Health (or re-copy from `core/maintenance-checklist.md` if not customized)
5. Update `.claude/agents/scrum-master.md` from `core/agents/scrum-master.md` (if not customized; if customized, manually add step 7 and renumber)
6. Update `CLAUDE.md` — merge bug system integration points (Bugs/ in structure, bug numbering, Bug Reporting workflow, maintenance summary, evaluation system, document creation triggers)
7. Add `"TodoWrite"` to `.claude/settings.json` permissions.allow

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
