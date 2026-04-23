#!/bin/bash
# Post-commit hook — STATUS.md update reminder (advisory)
#
# This is the soft fallback for the pre-commit STATUS.md gate. The pre-commit hook
# blocks commits without STATUS.md when a task lock file is present (formal session).
# This hook catches the remaining case: ad hoc work outside a formal session where
# STATUS.md should still be updated but isn't strictly required.
#
# Advisory only — does not block. Post-commit hooks cannot block (the commit is done).

if ! git diff-tree --no-commit-id --name-only -r HEAD | grep -q "^STATUS.md$"; then
  echo ""
  echo "  Reminder: STATUS.md was not updated in this commit."
  echo "  If this was session work, update STATUS.md before ending the session."
  echo "  (The pre-commit hook enforces this when a task lock is active.)"
  echo ""
fi

exit 0
