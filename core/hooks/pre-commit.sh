#!/bin/bash
# Pre-commit hook — Mesh topology isolation scope enforcement
# For mesh topology sprints: verifies modified files fall within the declared isolation scope
# for the active ticket. Blocks commit if out-of-scope files are modified.
#
# Inactive for pipeline and hierarchical topologies.
#
# HOW IT WORKS:
# 1. Reads STATUS.md to determine current topology
# 2. If topology is not "mesh", exits immediately (allow commit)
# 3. Reads the active task lock file to determine current ticket
# 4. Reads the sprint contract to find the isolation scope for that ticket
# 5. Compares staged files against the allowed scope
# 6. Blocks commit if any staged file is outside scope

# Step 1: Check topology from STATUS.md
if [ ! -f "STATUS.md" ]; then
  # No STATUS.md yet — project may be in bootstrap. Allow commit.
  exit 0
fi

TOPOLOGY=$(grep -i "topology:" STATUS.md | head -1 | awk '{print $NF}' | tr -d '[:space:]')

if [ "$TOPOLOGY" != "mesh" ]; then
  # Not a mesh sprint — isolation scope enforcement doesn't apply
  exit 0
fi

# Step 2: Find the active task lock file
LOCK_DIR=".claude/current_tasks"
if [ ! -d "$LOCK_DIR" ] || [ -z "$(ls -A $LOCK_DIR 2>/dev/null)" ]; then
  # No active task lock — can't determine scope. Warn but allow.
  echo "⚠️  Mesh topology active but no task lock found in $LOCK_DIR."
  echo "   Cannot enforce isolation scope. Create a task lock before committing."
  exit 0
fi

LOCK_FILE=$(ls "$LOCK_DIR"/*.lock 2>/dev/null | head -1)
TICKET=$(basename "$LOCK_FILE" .lock)

# Step 3: Find the sprint contract
CONTRACT=$(find docs/04-Backlog/Sprints/ -name "Sprint-*-contract.md" -newer STATUS.md 2>/dev/null | head -1)
if [ -z "$CONTRACT" ]; then
  CONTRACT=$(ls docs/04-Backlog/Sprints/Sprint-*-contract.md 2>/dev/null | tail -1)
fi

if [ -z "$CONTRACT" ]; then
  echo "⚠️  Mesh topology active but no sprint contract found."
  echo "   Cannot enforce isolation scope. Allowing commit."
  exit 0
fi

# Step 4: Extract isolation scope for the active ticket
# Look for the section after the ticket ID, find "Isolation Scope", extract directories
SCOPE_LINES=$(awk "/## .*${TICKET}/,/^## /" "$CONTRACT" | grep -E "^- \`" | sed 's/.*`\(.*\)`.*/\1/' | sed 's|/$||')

if [ -z "$SCOPE_LINES" ]; then
  echo "⚠️  Could not find isolation scope for $TICKET in $CONTRACT."
  echo "   Allowing commit, but verify scope manually."
  exit 0
fi

# Step 5: Check staged files against scope
STAGED_FILES=$(git diff --cached --name-only)
VIOLATIONS=""

for FILE in $STAGED_FILES; do
  # Skip non-source files that are always allowed
  case "$FILE" in
    STATUS.md|features.json|CLAUDE.md|.claude/*|docs/session-logs/*|docs/evaluations/*|docs/04-Backlog/Sprints/*)
      continue
      ;;
  esac

  IN_SCOPE=false
  for SCOPE in $SCOPE_LINES; do
    if echo "$FILE" | grep -q "^$SCOPE"; then
      IN_SCOPE=true
      break
    fi
  done

  if [ "$IN_SCOPE" = false ]; then
    VIOLATIONS="$VIOLATIONS\n  - $FILE"
  fi
done

if [ -n "$VIOLATIONS" ]; then
  echo ""
  echo "❌ Pre-commit BLOCKED: Mesh topology isolation scope violation"
  echo "   Ticket: $TICKET"
  echo "   Contract: $CONTRACT"
  echo "   Out-of-scope files:$VIOLATIONS"
  echo ""
  echo "   Options:"
  echo "   1. Remove these files from the commit (git reset HEAD <file>)"
  echo "   2. If the scope needs to change, update the sprint contract first"
  echo "   3. If tasks are coupled, consider switching to hierarchical topology"
  echo ""
  exit 1
fi

exit 0
