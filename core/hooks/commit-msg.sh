#!/bin/bash
# Commit-msg hook — Conventional commit message format validation
# Validates that commit messages follow the format: type(SCOPE): description
#
# Allowed types: feat, fix, docs, chore, refactor, test, maint, style, perf, ci, build
# SCOPE is optional but recommended (e.g., the ticket ID: feat(MYAPP-S-042): add login)
#
# Blocks commit if the message doesn't match.

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -1 "$COMMIT_MSG_FILE")

# Allow merge commits and revert commits through
if echo "$COMMIT_MSG" | grep -qE "^(Merge |Revert )"; then
  exit 0
fi

# Validate conventional commit format: type[(scope)]: description
# type is required, scope is optional, colon+space+description is required
PATTERN="^(feat|fix|docs|chore|refactor|test|maint|style|perf|ci|build)(\([^)]+\))?: .+"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
  echo ""
  echo "Commit message validation FAILED"
  echo "  Message: $COMMIT_MSG"
  echo ""
  echo "  Expected format: type(scope): description"
  echo "  Example: feat(MYAPP-S-042): add user authentication flow"
  echo ""
  echo "  Allowed types: feat, fix, docs, chore, refactor, test, maint, style, perf, ci, build"
  echo "  Scope is optional but recommended (use the ticket ID when working a story)"
  echo ""
  exit 1
fi

exit 0
