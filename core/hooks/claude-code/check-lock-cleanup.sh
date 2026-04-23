#!/bin/bash
# Claude Code PostToolUse hook — Lock file cleanup check
# Matcher: Bash
#
# After a git commit, checks whether task lock files remain in .claude/current_tasks/.
# If the commit message suggests session close-out, warns about leftover lock files.
#
# Advisory only — does not block.

INPUT=$(cat /dev/stdin)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Only trigger on git commit commands
if ! echo "$COMMAND" | grep -qE "^git commit\b"; then
  exit 0
fi

LOCK_DIR=".claude/current_tasks"

# Check for remaining lock files
if [ -d "$LOCK_DIR" ]; then
  LOCKS=$(ls "$LOCK_DIR"/*.lock 2>/dev/null)
  if [ -n "$LOCKS" ]; then
    LOCK_COUNT=$(echo "$LOCKS" | wc -l | tr -d ' ')
    LOCK_NAMES=$(echo "$LOCKS" | xargs -I{} basename {} .lock | tr '\n' ', ' | sed 's/,$//')
    echo ""
    echo "  Lock file check: $LOCK_COUNT task lock(s) still active: $LOCK_NAMES"
    echo "  If this session is ending, remove lock files during close-out."
    echo "  If work continues, this is expected — ignore this message."
    echo ""
  fi
fi

exit 0
