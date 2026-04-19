#!/bin/bash
# Post-commit hook — STATUS.md update reminder
# Verifies that STATUS.md was modified in the commit. Warns (does not block) if missing.
# This ensures the session lifecycle close-out step is followed.

# Check if STATUS.md was part of the committed files
if ! git diff-tree --no-commit-id --name-only -r HEAD | grep -q "^STATUS.md$"; then
  echo ""
  echo "⚠️  Post-commit reminder: STATUS.md was not updated in this commit."
  echo "   The session lifecycle requires updating STATUS.md during close-out."
  echo "   If this was a mid-session commit, update STATUS.md before ending the session."
  echo ""
fi

# This hook does not block — it's advisory only.
exit 0
