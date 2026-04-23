#!/bin/bash
# Pre-commit hook — Fabrika workflow enforcement
#
# Runs these checks in order, blocking the commit if any fail:
#   1. Branch protection — blocks commits directly to main/master
#   2. Secret scanning — blocks commits containing credential patterns
#   3. STATUS.md session gate — if a task lock file exists, requires STATUS.md in the commit
#   4. Mesh topology isolation scope — for mesh sprints, verifies files are within declared scope
#
# All blocking checks use exit 2 (hard block). Exit 1 is non-blocking in Claude Code hooks.

# ─────────────────────────────────────────────
# CHECK 1: Branch protection
# ─────────────────────────────────────────────
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo ""
  echo "Pre-commit BLOCKED: Direct commit to $BRANCH"
  echo "  Create a feature branch first:"
  echo "    git checkout -b feature/[PROJECT_KEY]-S-XXX-description"
  echo ""
  exit 2
fi

# ─────────────────────────────────────────────
# CHECK 2: Secret scanning
# ─────────────────────────────────────────────
# Scan staged diff for common credential patterns. Only checks added/modified lines (+).
SECRET_PATTERNS='(password|passwd|pwd)\s*=\s*["\x27][^"\x27]+|api[_-]?key\s*=\s*["\x27][^"\x27]+|-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY|sk-[a-zA-Z0-9]{20,}|token\s*=\s*["\x27][^"\x27]+|secret\s*=\s*["\x27][^"\x27]+|AWS_SECRET_ACCESS_KEY|GITHUB_TOKEN\s*='

STAGED_DIFF=$(git diff --cached --diff-filter=ACM -U0 2>/dev/null)
SECRET_HITS=$(echo "$STAGED_DIFF" | grep -nE "^\+" | grep -iE "$SECRET_PATTERNS" 2>/dev/null)

if [ -n "$SECRET_HITS" ]; then
  echo ""
  echo "Pre-commit BLOCKED: Possible secrets detected in staged changes"
  echo ""
  echo "$SECRET_HITS" | head -10
  echo ""
  echo "  If these are false positives, review and use git commit --no-verify to bypass."
  echo "  If real credentials, remove them and use environment variables or a secrets manager."
  echo ""
  exit 2
fi

# ─────────────────────────────────────────────
# CHECK 3: STATUS.md session gate
# ─────────────────────────────────────────────
# If a task lock file exists, the agent is in a formal Fabrika session.
# STATUS.md must be part of the commit to maintain session state.
LOCK_DIR=".claude/current_tasks"
if [ -d "$LOCK_DIR" ] && [ -n "$(ls -A "$LOCK_DIR"/*.lock 2>/dev/null)" ]; then
  if ! git diff --cached --name-only | grep -q "^STATUS.md$"; then
    echo ""
    echo "Pre-commit BLOCKED: Active session detected but STATUS.md not staged"
    echo "  Lock file found in $LOCK_DIR — you are in a Fabrika session."
    echo "  STATUS.md must be updated and staged with every session commit."
    echo ""
    echo "  To fix: update STATUS.md, then git add STATUS.md"
    echo "  If this is a mid-session WIP commit, update STATUS.md with current progress."
    echo ""
    exit 2
  fi
fi

# ─────────────────────────────────────────────
# CHECK 4: Mesh topology isolation scope enforcement
# ─────────────────────────────────────────────
# For mesh topology sprints: verifies modified files fall within the declared isolation scope
# for the active ticket. Blocks commit if out-of-scope files are modified.
# Inactive for pipeline and hierarchical topologies.

if [ ! -f "STATUS.md" ]; then
  # No STATUS.md yet — project may be in bootstrap. Allow commit.
  exit 0
fi

TOPOLOGY=$(grep -i "topology:" STATUS.md | head -1 | awk '{print $NF}' | tr -d '[:space:]')

if [ "$TOPOLOGY" != "mesh" ]; then
  # Not a mesh sprint — isolation scope enforcement doesn't apply
  exit 0
fi

# Find the active task lock file
if [ ! -d "$LOCK_DIR" ] || [ -z "$(ls -A $LOCK_DIR 2>/dev/null)" ]; then
  echo "  Mesh topology active but no task lock found in $LOCK_DIR."
  echo "  Cannot enforce isolation scope. Create a task lock before committing."
  exit 0
fi

LOCK_FILE=$(ls "$LOCK_DIR"/*.lock 2>/dev/null | head -1)
TICKET=$(basename "$LOCK_FILE" .lock)

# Find the sprint contract
CONTRACT=$(find docs/04-Backlog/Sprints/ -name "Sprint-*-contract.md" -newer STATUS.md 2>/dev/null | head -1)
if [ -z "$CONTRACT" ]; then
  CONTRACT=$(ls docs/04-Backlog/Sprints/Sprint-*-contract.md 2>/dev/null | tail -1)
fi

if [ -z "$CONTRACT" ]; then
  echo "  Mesh topology active but no sprint contract found."
  echo "  Cannot enforce isolation scope. Allowing commit."
  exit 0
fi

# Extract isolation scope for the active ticket
SCOPE_LINES=$(awk "/## .*${TICKET}/,/^## /" "$CONTRACT" | grep -E "^- \`" | sed 's/.*`\(.*\)`.*/\1/' | sed 's|/$||')

if [ -z "$SCOPE_LINES" ]; then
  echo "  Could not find isolation scope for $TICKET in $CONTRACT."
  echo "  Allowing commit, but verify scope manually."
  exit 0
fi

# Check staged files against scope
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
  echo "Pre-commit BLOCKED: Mesh topology isolation scope violation"
  echo "  Ticket: $TICKET"
  echo "  Contract: $CONTRACT"
  echo "  Out-of-scope files:$VIOLATIONS"
  echo ""
  echo "  Options:"
  echo "  1. Remove these files from the commit (git reset HEAD <file>)"
  echo "  2. If the scope needs to change, update the sprint contract first"
  echo "  3. If tasks are coupled, consider switching to hierarchical topology"
  echo ""
  exit 2
fi

exit 0
