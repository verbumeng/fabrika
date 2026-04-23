---
type: reference
title: Hook Discovery Workflow
created: 2026-04-23
updated: 2026-04-23
tags: [hooks, workflow, maintenance]
---

# Hook Discovery Workflow

This document guides when and how to create new hooks for a Fabrika project. Hooks enforce rules mechanically so the agent cannot rationalize around them. Not every rule needs a hook — most conventions are well-served by prompt instructions. This workflow helps you decide which rules have graduated from "guidance" to "enforcement."

## When to Run This Workflow

Run this workflow when any of these conditions appear during maintenance, retros, or normal development:

1. **Repeated violation pattern** — The same rule violation has appeared 3+ times in session logs, evaluator feedback, or bug reports. Three strikes means the prompt isn't holding.
2. **High-cost single violation** — A rule where even one violation causes real damage: data loss, security exposure, broken shared state, compliance breach.
3. **User correction** — The user has corrected the same agent behavior more than once. They shouldn't have to say it a third time.
4. **Lint rule graduation** — A custom lint rule in `docs/02-Engineering/Custom-Lint-Rules/` has been stable for 2+ sprints and could be enforced mechanically rather than by agent judgment.

## Decision Framework

For each candidate, answer these questions:

### 1. What is the cost of a single violation?

| Cost Level | Examples | Action |
|-----------|---------|--------|
| **Critical** — data loss, security breach, broken shared state | Committing secrets, force-pushing, writing to production configs | Must be a mechanical hook (command type, exit 2) |
| **High** — significant rework, workflow corruption | Committing to main, skipping STATUS.md update, wrong commit format | Should be a mechanical hook |
| **Medium** — inconsistency, drift, minor rework | Missing formatting, lock files not cleaned up | Good candidate for a hook (mechanical or advisory) |
| **Low** — cosmetic, preference, style | Verbose variable names, comment style, narrative quality | Keep as prompt instruction |

### 2. Can this be checked mechanically?

A hook needs a deterministic check — something a script can verify with pattern matching, file existence, exit codes, or string comparison.

**Good hook candidates:**
- "Is the branch name `main`?" (string comparison)
- "Does the staged diff contain `password=`?" (pattern match)
- "Is STATUS.md in the staged files?" (file existence)
- "Does the commit message match `type(scope): description`?" (regex)

**Bad hook candidates:**
- "Is this ADR well-written?" (subjective judgment)
- "Should this be a new agent or an extension of an existing one?" (requires reasoning)
- "Is this story properly scoped?" (context-dependent)

If the check requires reasoning rather than pattern matching, it stays as a prompt instruction, an agent-type hook (expensive, use sparingly), or a rubric criterion.

### 3. Where should the hook fire?

| If the check should happen... | Hook type |
|------------------------------|-----------|
| Before a git operation (commit, push) | Git hook (`pre-commit`, `commit-msg`, `pre-push`) |
| Before the agent uses a tool (Bash, Write, Edit) | Claude Code PreToolUse hook |
| After the agent uses a tool | Claude Code PostToolUse hook |
| During maintenance only | Maintenance checklist item, not a hook |

Git hooks are preferred when possible — they work with any AI coding tool, not just Claude Code. Use Claude Code hooks for catches that need to happen earlier (before the command runs) or for tool-specific behavior (auto-formatting after writes).

### 4. Should it block or advise?

| Blocking (exit 2) | Advisory (exit 0 + stdout message) |
|---|---|
| Violations that can't be undone easily | Violations that are easy to fix after the fact |
| Security-critical rules | Reminders about best practices |
| Workflow rules where the wrong state propagates | Cleanup tasks that can happen later |

## Creating the Hook

Once you've decided a hook is warranted:

### For git hooks

1. Determine which git event: `pre-commit`, `commit-msg`, or `pre-push`
2. Add the check to the appropriate existing script in `.claude/hooks/` (Fabrika ships combined hooks per event — don't create a separate file per check)
3. Use `exit 2` to block, `exit 0` to allow. **Do not use `exit 1` — in Claude Code hooks, exit 1 is non-blocking.** This is the most common mistake.
4. Include a clear error message with: what was blocked, why, and how to fix it
5. Test the hook manually: `echo "bad commit msg" | bash .claude/hooks/commit-msg.sh`

### For Claude Code hooks

1. Create a shell script in `.claude/hooks/claude-code/`
2. The script receives tool input as JSON on stdin. Parse with `jq`:
   ```bash
   INPUT=$(cat /dev/stdin)
   COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
   FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
   ```
3. Register the hook in `.claude/settings.json` under `hooks.PreToolUse` or `hooks.PostToolUse`
4. **Matcher is tool-name only** — you cannot filter by arguments in the matcher. The matcher says "fire on all Bash commands"; the script logic checks whether this specific command should be blocked.
5. Same exit code rules: `exit 0` = allow, `exit 2` = block, `exit 1` = non-blocking (logs but doesn't stop)

### For other tools

See `.fabrika/hook-adaptation-guide.md` for how to adapt hooks to Copilot, Cursor, and other AI coding tools. Git hooks work universally; Claude Code hooks need per-tool adaptation.

## Documenting the Hook

After creating a hook:
1. Update the Hooks section of the project's CLAUDE.md (or equivalent config) to describe the new hook
2. If the hook enforces a rule that was previously in Custom-Lint-Rules/, note that it's now mechanically enforced
3. Log the new hook in the maintenance findings file

## Anti-Patterns

- **Don't hook subjective judgments.** If you can't write a regex or file check for it, it's not a hook — it's a rubric criterion or prompt instruction.
- **Don't hook everything.** Hooks add friction. Each hook is a script that runs on every matching tool use. Reserve hooks for rules where the cost of violation justifies the overhead.
- **Don't duplicate rubric checks.** If the code-reviewer already grades something and the rubric is working, a hook just adds redundant enforcement. Hooks are for things that bypass or precede the evaluation cycle.
- **Don't use exit 1 thinking it blocks.** It doesn't. Exit 2 blocks. This is the most common hook bug.
- **Don't put argument logic in matchers.** Matchers filter by tool name only. `"matcher": "Bash(git push)"` does not work. Use `"matcher": "Bash"` and check the command inside the script.
