#!/bin/bash
# Claude Code PreToolUse hook — Destructive git command guard
# Matcher: Bash
#
# Blocks destructive git operations that are hard or impossible to reverse.
# This is a defense-in-depth layer alongside the git hooks — it catches the
# command BEFORE execution, while git hooks catch it during execution.
#
# Exit codes: 0 = allow, 2 = block (exit 1 does NOT block in Claude Code hooks)

INPUT=$(cat /dev/stdin)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Check for destructive git patterns
BLOCKED=""
REASON=""

if echo "$COMMAND" | grep -qE "git push\s+(-f|--force)\b"; then
  BLOCKED="git push --force"
  REASON="Force-pushing rewrites remote history and can destroy teammates' work. Use git push --force-with-lease if you must, or ask the user first."
fi

if echo "$COMMAND" | grep -qE "git reset\s+--hard\b"; then
  BLOCKED="git reset --hard"
  REASON="Hard reset discards all uncommitted changes permanently. Use git stash or git reset --soft to preserve work."
fi

if echo "$COMMAND" | grep -qE "git checkout\s+--\s+\."; then
  BLOCKED="git checkout -- ."
  REASON="This discards all unstaged changes in the working directory. Use git stash to preserve work, or target specific files."
fi

if echo "$COMMAND" | grep -qE "git restore\s+\.\s*$"; then
  BLOCKED="git restore ."
  REASON="This discards all unstaged changes in the working directory. Use git stash to preserve work, or target specific files."
fi

if echo "$COMMAND" | grep -qE "git branch\s+-D\b"; then
  BLOCKED="git branch -D"
  REASON="Force-deleting a branch discards unmerged work. Use git branch -d (lowercase) which checks for unmerged changes first."
fi

if echo "$COMMAND" | grep -qE "git clean\s+-f"; then
  BLOCKED="git clean -f"
  REASON="This permanently deletes untracked files. Use git clean -n (dry run) first to see what would be deleted."
fi

if [ -n "$BLOCKED" ]; then
  echo "BLOCKED: $BLOCKED" >&2
  echo "  $REASON" >&2
  echo "  Ask the user for explicit confirmation before running destructive git operations." >&2
  exit 2
fi

exit 0
