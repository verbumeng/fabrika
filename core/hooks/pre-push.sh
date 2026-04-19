#!/bin/bash
# Pre-push hook — Regression gate
# Runs the fast test suite before allowing push. Blocks push if any test fails.
#
# CONFIGURE: Update TEST_CMD after tech stack is chosen during project bootstrap Phase 2.
# The test command should match the "Fast test command" in CLAUDE.md's Project Stack section.

TEST_CMD=""  # e.g., "pytest -x -q --fast", "npx vitest --run", "just test-fast"

if [ -z "$TEST_CMD" ]; then
  echo "⚠️  Pre-push hook: No test command configured yet. Skipping."
  echo "   Configure TEST_CMD in .claude/hooks/pre-push.sh after tech stack setup."
  exit 0
fi

echo "🔒 Pre-push regression gate: running fast test suite..."
echo "   Command: $TEST_CMD"

eval "$TEST_CMD"
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo ""
  echo "❌ Pre-push BLOCKED: Tests failed (exit code $EXIT_CODE)"
  echo "   Fix failing tests before pushing."
  echo ""
  # Log the blocked push for session tracking
  LOG_DIR="docs/session-logs"
  if [ -d "$LOG_DIR" ]; then
    LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d)-blocked-push.md"
    echo "## Blocked Push — $(date +%Y-%m-%d' '%H:%M)" >> "$LOG_FILE"
    echo "- **Reason:** Test suite failed (exit code $EXIT_CODE)" >> "$LOG_FILE"
    echo "- **Command:** \`$TEST_CMD\`" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
  fi
  exit 1
fi

echo "✅ Tests passed. Push allowed."
exit 0
