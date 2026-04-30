---
type: reference
title: Maintenance Session Checklist
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [maintenance, workflow]
---

# Maintenance Session Checklist

## When to Run
- Between sprints (after sprint QA passes, before next sprint planning)
- Weekly if no sprint boundary has occurred
- When STATUS.md is more than 5 commits behind HEAD
- The scrum-master checks the `maintenance-latest` git tag during sprint planning and recommends maintenance if overdue

## Orientation
1. Read `STATUS.md` and the current sprint's progress file
2. Read git log since last maintenance: `git log maintenance-latest..HEAD --oneline`
3. Read `features.json` for current pass/fail state
4. Read recent session logs in `docs/session-logs/`

## Checklist

### Documentation Sync
- [ ] `docs/02-Engineering/Architecture Overview.md` reflects current codebase structure
- [ ] `CLAUDE.md` is accurate and not bloated (flag any sections that haven't been relevant in the last 3 sprints)
- [ ] `README.md` reflects current setup instructions
- [ ] Any ADRs created during the last sprint are complete and linked from relevant docs

### Code Quality
- [ ] Scan for duplicate code: functions >15 lines appearing >1 time (log findings to `docs/maintenance/dedup-YYYY-MM-DD.md`)
- [ ] Scan for `TODO`, `FIXME`, `HACK` comments and log them with file locations
- [ ] Check for unused imports and dead code in files modified since last maintenance
- [ ] Run semgrep for security scan on changed files

### Evaluation Findings Sweep
- [ ] Scan all `docs/evaluations/` reports created since last maintenance
- [ ] Collect non-blocking findings (items marked as observations, notes, or recommendations — not failures)
- [ ] Triage each finding:
  - **Trivial** (< 5 min fix) → fix in this maintenance session
  - **Small** (story-sized) → create a story in `docs/04-Backlog/Stories/` or add to an existing story's technical notes
  - **Speculative** (nice-to-have, no clear pain yet) → add to `docs/09-Personal-Tasks/Someday-Maybe.md`
- [ ] Log triage decisions to `docs/maintenance/eval-sweep-YYYY-MM-DD.md`

### Test Health
- [ ] Run the **full test command** (not fast mode), log results to `docs/maintenance/full-test-YYYY-MM-DD.md`
- [ ] Verify `features.json` pass/fail states match actual test results — fix any drift
- [ ] Identify any features marked as passing that now fail (regressions introduced since last verification)
- [ ] Check test coverage metrics against the 80%+ target

### Progress File Reconciliation
- [ ] `STATUS.md` accurately reflects current sprint state and active tickets
- [ ] Current sprint's progress file has entries for all completed work since last maintenance
- [ ] No orphaned lock files in `.claude/current_tasks/`
- [ ] If backlog mode is `jira`: verify Jira ticket statuses match local story statuses

### Dependency Health
- [ ] Check for outdated dependencies (`npm outdated` / `pip list --outdated` / equivalent)
- [ ] Log any security advisories to `docs/maintenance/deps-YYYY-MM-DD.md`
- [ ] Do **NOT** auto-update — just report. Owner decides on updates.

### Hook Health
- [ ] Verify pre-push hook test command matches current test runner configuration
- [ ] If test framework changed since last maintenance, update hook
- [ ] Verify pre-commit checks are working: branch protection, secret scanning, STATUS.md session gate, mesh isolation (if applicable)
- [ ] Verify commit-msg hook is validating conventional commit format
- [ ] If using Claude Code: verify settings.json hooks section references all four scripts in `.claude/hooks/claude-code/`
- [ ] If sprint topology changed, verify pre-commit isolation scope enforcement is appropriate
- [ ] If auto-format hook is configured (`FORMAT_CMD`), verify it still matches the project's formatter

### Hook Discovery
- [ ] Scan session logs and evaluator feedback since last maintenance for recurring rule violations
- [ ] If any rule violation has appeared 3+ times: run the hook discovery workflow (see `.fabrika/hook-discovery-workflow.md`)
- [ ] Check if any custom lint rules in `docs/02-Engineering/Custom-Lint-Rules/` have been stable for 2+ sprints and could graduate to mechanical hooks
- [ ] Log hook discovery findings to `docs/maintenance/hooks-YYYY-MM-DD.md`

### Pattern & Lint Rule Curation
- [ ] Scan session logs for implementation patterns used 2+ times that are not yet in `docs/02-Engineering/Canonical-Patterns.md` — propose additions
- [ ] Scan `docs/evaluations/` and `docs/evals/agent-changelog.md` for code-reviewer feedback that has appeared 3+ times across sprints on the same class of issue
- [ ] For each repeated finding: propose a custom lint rule with a prompt-style error message (remediation instructions, not just "X is not allowed") and save to `docs/02-Engineering/Custom-Lint-Rules/`
- [ ] If `docs/02-Engineering/Structural-Constraints.md` exists, verify all declared constraints still have working enforcement (tests or lint rules that actually run)
- [ ] Log pattern and lint curation findings to `docs/maintenance/patterns-YYYY-MM-DD.md`

### Terminology Drift Check

This section only runs when a Domain Language document exists at
`docs/00-Index/Domain-Language.md`. If no Domain Language document
exists, skip this section entirely.

- [ ] Scan code for class names, function names, database columns, and variables that use different terms than the Domain Language definitions
- [ ] Scan for Domain Language concepts that have been implemented in code but still have "not yet implemented" in the code-level name field — these need to be populated
- [ ] Scan Domain Language for terms that no longer appear anywhere in the codebase or docs (candidates for removal or marking as deprecated)
- [ ] Scan recent PRDs and specs for new domain concepts that were introduced but not added to Domain Language
- [ ] If drift is found: either update the code to match Domain Language (trivial rename) or update Domain Language to reflect legitimate vocabulary evolution (with a note explaining the change)
- [ ] Log terminology drift findings to `docs/maintenance/terminology-drift-YYYY-MM-DD.md`

### Architecture Review (Conditional)

This section only runs when at least one of these conditions is true:
- A major feature (5+ story points) landed since the last architecture review
- The owner explicitly requests an architecture review
- The code-reviewer flagged structural concerns (Module Depth / Interface Simplicity criterion scored Partial or Fail) in the current sprint
- No architecture review has been run in the last 3 sprints

If none of the above conditions are true, skip this section entirely.

- [ ] Identify the appropriate architect agent for this project type (software-architect or data-architect — see AGENT-CATALOG)
- [ ] Dispatch the architect in ad hoc mode with: Architecture Overview pointer, target scope (modules changed in the current sprint), any code-reviewer structural findings from this sprint's evaluation reports
- [ ] Review the architect's assessment. For each finding:
  - **Trivial** (naming, minor reorganization) — fix in this maintenance session
  - **Refactor story** (module deepening, interface redesign) — create a story in backlog with the architect's recommendation as acceptance criteria and the done threshold from the assessment
  - **Deferred** (stable module, low impact) — log as assessed with date in the architecture assessment tracking log
- [ ] Update architecture assessment tracking log at `docs/maintenance/architecture-tracking.md`:
  - Module/component assessed
  - Date assessed
  - Verdict (SOUND / CONCERNS / UNSOUND)
  - Action taken (fixed / story created / deferred)
  - Done threshold (when to re-assess)
- [ ] If the tracking log shows a module has been assessed SOUND in the last 2 reviews, skip it in future assessments unless new functionality is added

**Spiral mitigation:** Do not create more than 2 refactor stories per architecture review. If the architect identifies more than 2 significant issues, document them all but only create stories for the highest-impact 2. The rest go to the backlog as future candidates.

### Token Usage Review
- [ ] Scan the current sprint's progress file for "Tokens (actual)" entries
- [ ] If token data exists, calculate: total tokens this sprint, per-story averages, stories that consumed >2x the sprint average
- [ ] Flag disproportionately expensive stories with a note on likely cause (evaluator retries, large context loads, complex implementations)
- [ ] Compare against predicted token estimates from the sprint contract if available
- [ ] Log token findings to `docs/maintenance/context-review-YYYY-MM-DD.md` (alongside context efficiency findings below)

### Context Efficiency Review
- [ ] Scan `docs/session-logs/` since last maintenance
- [ ] Identify top 3 context efficiency issues (most frequent wasteful patterns across sessions)
- [ ] Recommend specific agent prompt or tool configuration changes
- [ ] Log findings to `docs/maintenance/context-review-YYYY-MM-DD.md`

### Evaluation Health
- [ ] Review `docs/evals/agent-changelog.md` for new entries since last maintenance
- [ ] Review session logs AND the **"Agent quality observations"** bullets in `Sprint-XX-progress.md` for repeated failure patterns (same type of failure 3+ times across sessions)
- [ ] For each pattern found:
  - Draft an eval case (code sample or task with known correct answer)
  - Save the draft to `docs/maintenance/agent-improvements-YYYY-MM-DD.md` under a "Proposed eval cases" section (do NOT save to `docs/evals/{agent-name}/` yet — owner approval happens in the retro chat)
- [ ] Run all existing eval cases against current agent prompts
- [ ] Report accuracy per agent (X/Y cases passed) — write the report to `docs/maintenance/agent-improvements-YYYY-MM-DD.md`
- [ ] If accuracy dropped since last run, flag specific regressions in the same file
- [ ] If agent prompts have been modified 3+ times without evals, note "build eval cases" as a recommendation in the same file

### Agent Improvement Proposals (requires existing evals)
- [ ] Identify eval cases that consistently fail
- [ ] Identify session log patterns not yet covered by evals
- [ ] For each improvement opportunity, write to `docs/maintenance/agent-improvements-YYYY-MM-DD.md` under a "Proposed prompt changes" section:
  - The specific prompt modification (diff or before/after snippet)
  - Eval suite results against the modified prompt (run in a test branch — do NOT commit changes to agent prompts during maintenance)
  - The headline delta: "This change improves [agent] accuracy from X/Y to X/Y, no regressions"
- [ ] **Do NOT apply changes during maintenance.** The retro chat is the approval gate. The retro template surfaces this file's contents for owner review and records approve/reject/defer decisions. Approved changes are applied in the retro chat (small text edits to agent prompt files) or scoped as a story for the next sprint if non-trivial.

### Stale Scaffolding Audit
- [ ] Review agent prompts for instructions that compensate for limitations the current model handles natively
- [ ] Review CLAUDE.md for sections that are always loaded but rarely relevant (candidates for on-demand loading)
- [ ] Flag any redundant verification steps between agents

### Story-to-PRD Traceability
- [ ] If an active PRD exists in `docs/01-Product/`, verify all active stories (`status: To Do` or `status: In Progress`) trace to an active PRD
- [ ] Flag orphan stories — stories with no PRD parent (created ad hoc, from brain dumps, or from a PRD that has since been superseded)
- [ ] Flag stale PRD sections — user stories or module changes described in the PRD with no corresponding stories in the backlog
- [ ] This is a lightweight documentation health check, not a blocking gate. Orphan stories are not invalid — they may be legitimate ad hoc work. The purpose is visibility, not enforcement.

## Session End
1. Commit all changes: `maint: [summary of maintenance work]`
2. Tag git: `git tag maintenance-YYYY-MM-DD && git tag -f maintenance-latest`
3. Update `STATUS.md` with maintenance completion note
4. Append maintenance summary to current sprint's progress file with `[maintenance]` tag
5. Write session report to `docs/session-logs/`

## Maintenance Summary Format (for progress file)
```markdown
## YYYY-MM-DD [maintenance]
- Full test suite: X passed, Y failed ([list failures])
- Dedup: [findings or "clean"]
- Docs updated: [list]
- CLAUDE.md: [trimmed X sections / no changes]
- Dependencies: [X updates available, Y security advisories / clean]
- Context efficiency: [findings or "no notable issues"]
- Evals: [X cases run, accuracy: Y/Z per agent / no cases yet]
- Agent improvements: [proposed X changes / none needed]
- Architecture review: [X modules assessed, Y stories created, Z deferred / skipped — conditional trigger not met]
- Hooks: [verified / updated X]
- Terminology drift: [X drifts found, Y fixed, Z Domain Language updates / clean / skipped — no Domain Language document]
```
