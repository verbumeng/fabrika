# Changelog

All notable changes to Fabrika are documented here.

Format: each version lists changed files and the nature of the change. Consumer projects use the CHANGELOG to determine which files need updating (see UPDATE.md).

---

## 0.5.2

Session summary and retro briefing formats. Extends the owner briefing system (0.5.1) to cover session close-out summaries and sprint retro presentations. The agent now translates evaluation results, retro findings, and session outcomes into plain-language summaries focused on product impact, rather than telling the owner to go read raw report files.

### Core (new — consumer projects should copy)
- `core/briefings/session-summary-briefing.md` — **NEW.** Five-part briefing format for session close-out and story completion summaries. Covers: what changed in the product, key decisions, evaluation results in plain language, what to look at (if anything), what's next. Explicitly says not to send the owner to evaluation report files.
- `core/briefings/retro-briefing.md` — **NEW.** Six-part briefing format for presenting sprint retros. Covers: what the sprint accomplished, story-by-story recap, what we learned, what's changing, health check, anything needing input. Translates the dense retro artifact (eval tables, token metrics) into human-facing takeaways.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Expanded "Owner Briefings" section to include session-summary and retro briefing pointers. Updated Session Close-Out step 23, story completion step 16, and Sprint Retro chat description to reference briefing formats.

### Consumer update instructions
Projects on 0.5.1 should:
1. Copy `core/briefings/session-summary-briefing.md` and `core/briefings/retro-briefing.md` to your Fabrika briefings path (2 new files)
2. Update `CLAUDE.md` "Owner Briefings" section — add the two new pointer lines from `integrations/claude-code/CLAUDE.md`
3. In `CLAUDE.md` Session Close-Out, update step 23 to reference the Session Summary Briefing format
4. In `CLAUDE.md` Completing a Story, update step 16 to reference the Session Summary Briefing format
5. In `CLAUDE.md` Sprint Lifecycle > Sprint Retro chat, add the Retro Briefing reference

---

## 0.5.1

Owner briefing format. Adds structured plain-language briefing templates for how the orchestrating session presents specs and sprint plans to the owner. Instead of dumping raw artifacts or giving terse summaries, the agent follows a briefing format that explains what is being built, why, how it fits into the product, defines all jargon, and frames design decisions as choices the owner can push back on.

### Core (new — consumer projects should copy)
- `core/briefings/briefing-principles.md` — **NEW.** Cross-cutting principles for all owner briefings: assume the owner hasn't touched the codebase in a week, define terms even if defined before, lead with product impact not implementation, make disagreement easy.
- `core/briefings/spec-briefing.md` — **NEW.** Six-part briefing format for presenting specs after product-manager planning mode. Covers: what and why, how it works, key design decisions, jargon glossary, out of scope, open questions.
- `core/briefings/sprint-plan-briefing.md` — **NEW.** Six-part briefing format for presenting sprint plans after scrum-master planning. Covers: sprint goal, why these stories in this order, topology choice explained, jargon glossary, deferred work, risks.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Added "Owner Briefings" section with pointers to the three briefing files. Updated "Starting a Story" step 5 and "Sprint Planning" step 9 to reference the briefing format.

### Consumer update instructions
Projects on 0.5.0 should:
1. Copy `core/briefings/` directory (3 files) to your Fabrika path
2. Update `CLAUDE.md` — add the "Owner Briefings" section from `integrations/claude-code/CLAUDE.md` (insert between Development Workflow and Progress Files sections)
3. In `CLAUDE.md` Development Workflow > Starting a Story, update step 5 to reference the Spec Briefing format
4. In `CLAUDE.md` Development Workflow > Sprint Planning, update step 9 to reference the Sprint Plan Briefing format

---

## 0.5.0

Deterministic enforcement layer. Expands hooks from 3 git hooks to 7 git hooks + 4 Claude Code hooks, adds hook discovery workflow for project-specific hook graduation, and cross-tool adaptation guide for Copilot/Cursor/other tools. Fixes exit code bug in mesh isolation hook (was exit 1, should be exit 2). Inspired by Daniel Williams' articles on hooks as enforcement vs. prompts as guidance.

### Core (changed — consumer projects should update)
- `core/hooks/pre-commit.sh` — **CHANGED.** Expanded from mesh-isolation-only to four checks: branch protection (blocks main/master), secret scanning (credential patterns in staged diff), STATUS.md session gate (requires STATUS.md when task lock active), mesh isolation scope (existing, exit code fixed from 1 to 2).
- `core/hooks/commit-msg.sh` — **NEW.** Validates conventional commit message format (`type(scope): description`). Blocks on mismatch. Allows merge and revert commits through.
- `core/hooks/post-commit.sh` — **CHANGED.** Updated messaging to clarify this is the advisory fallback for the pre-commit STATUS.md gate.
- `core/hooks/claude-code/guard-destructive-git.sh` — **NEW.** Claude Code PreToolUse hook. Blocks destructive git commands (force push, hard reset, checkout --, restore ., branch -D, clean -f) before execution.
- `core/hooks/claude-code/guard-protected-files.sh` — **NEW.** Claude Code PreToolUse hook. Blocks agent writes to .env, key, secret, credential, and SSH files. Defense-in-depth with permissions deny list.
- `core/hooks/claude-code/auto-format.sh` — **NEW.** Claude Code PostToolUse hook. Runs configurable `FORMAT_CMD` on files after Write/Edit. Empty by default — consumer configures during bootstrap.
- `core/hooks/claude-code/check-lock-cleanup.sh` — **NEW.** Claude Code PostToolUse hook. Warns about remaining task lock files after git commit. Advisory only.
- `core/hook-discovery-workflow.md` — **NEW.** Workflow for evaluating when recurring rule violations should graduate to mechanical hooks. Includes trigger criteria (3+ violations, high-cost single violations, user corrections), decision framework (cost assessment, mechanical checkability, hook placement), creation checklist, and anti-patterns. Placed in consumer projects at `.fabrika/hook-discovery-workflow.md`.
- `core/hook-adaptation-guide.md` — **NEW.** Cross-tool hook reference. Documents every hook conceptually (trigger, what it checks, why, blocks or advises), shows implementation per tool (Claude Code settings.json, Copilot git hooks + instructions, Cursor/Windsurf/Aider adaptation), and provides a "point your agent at this document" workflow for unsupported tools. Placed in consumer projects at `.fabrika/hook-adaptation-guide.md`.
- `core/maintenance-checklist.md` — **CHANGED.** Updated "Hook Health" section to cover all new hooks (pre-commit checks, commit-msg, Claude Code hooks, auto-format). Added "Hook Discovery" section: scan for recurring violations, run hook discovery workflow, check lint rule graduation candidates.

### Integrations (changed — consumer projects should update)
- `integrations/claude-code/CLAUDE.md` — **CHANGED.** Rewrote Hooks section from 3-hook summary to full two-layer documentation (git hooks + Claude Code hooks) with all 11 hooks described. Added Hook Discovery subsection with pointer to `.fabrika/hook-discovery-workflow.md` and `.fabrika/hook-adaptation-guide.md`.
- `integrations/claude-code/settings-template.json` — **CHANGED.** Added `hooks` section with PreToolUse entries (guard-destructive-git on Bash, guard-protected-files on Write|Edit) and PostToolUse entries (auto-format on Write|Edit, check-lock-cleanup on Bash).
- `integrations/copilot/copilot-instructions.md` — **CHANGED.** Added "Hooks & Enforcement" section documenting git hook coverage, instruction-based equivalents for Claude Code hooks (destructive git guard, protected files, lock cleanup), auto-formatting via VS Code, and pointer to adaptation guide.

### Operational Docs (changed — no consumer action needed)
- `BOOTSTRAP.md` — **CHANGED.** Updated hook configuration section to include all new hooks (git hooks, Claude Code hooks, hook discovery workflow, adaptation guide). Updated readiness checklist to verify full hook coverage.
- `ADOPT.md` — **CHANGED.** Updated Tier 2 hook installation to include commit-msg.sh, Claude Code hooks, hook discovery workflow, adaptation guide. Added Copilot-specific hook adaptation guidance.

### Consumer update instructions
Projects on 0.4.x should:
1. Replace `.claude/hooks/pre-commit.sh` from `core/hooks/pre-commit.sh` (adds branch protection, secret scanning, STATUS.md session gate; fixes mesh isolation exit code)
2. Copy `core/hooks/commit-msg.sh` to `.claude/hooks/commit-msg.sh` (new file)
3. Replace `.claude/hooks/post-commit.sh` from `core/hooks/post-commit.sh` (updated messaging)
4. Create `.claude/hooks/claude-code/` directory
5. Copy all four files from `core/hooks/claude-code/` to `.claude/hooks/claude-code/` (new files)
6. Update `auto-format.sh` with your project's formatter command (or leave empty to disable)
7. Update `.claude/settings.json` — add the `hooks` section from `integrations/claude-code/settings-template.json`
8. Copy `core/hook-discovery-workflow.md` to `.fabrika/hook-discovery-workflow.md` (new file)
9. Copy `core/hook-adaptation-guide.md` to `.fabrika/hook-adaptation-guide.md` (new file)
10. Update `docs/02-Engineering/maintenance-checklist.md` — update "Hook Health" section and add "Hook Discovery" section (or re-copy from `core/maintenance-checklist.md` if not customized)
11. Update `CLAUDE.md` — replace the Hooks section with the expanded version from `integrations/claude-code/CLAUDE.md`
12. For Copilot users: update `.github/copilot-instructions.md` — add "Hooks & Enforcement" section from `integrations/copilot/copilot-instructions.md`
13. Install git hooks: if using `.git/hooks/` directly (not Claude Code's `.claude/hooks/`), copy the hook scripts there and `chmod +x`

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
