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
- [ ] Verify post-commit STATUS.md check is working (not producing false warnings)
- [ ] If sprint topology changed, verify pre-commit isolation scope enforcement is appropriate

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
- Hooks: [verified / updated X]
```
