#!/bin/bash
# Claude Code PreToolUse hook — Protected file guard
# Matcher: Write, Edit
#
# Blocks writes to files that should never be modified by the agent:
# environment files, key files, credential files, SSH keys.
#
# Defense-in-depth alongside the permissions deny list in settings.json.
# The deny list blocks Read access; this blocks Write/Edit access with
# a more informative error message.
#
# Exit codes: 0 = allow, 2 = block

INPUT=$(cat /dev/stdin)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Normalize to basename and check patterns
BASENAME=$(basename "$FILE_PATH")
BLOCKED=""

# .env files (exact match and prefix match)
if echo "$BASENAME" | grep -qE "^\.env($|\.)"; then
  BLOCKED=".env file"
fi

# Key files
if echo "$BASENAME" | grep -qE "\.key$"; then
  BLOCKED="key file"
fi

# Files with "secret" or "credential" in the name
if echo "$BASENAME" | grep -qiE "(secret|credential)"; then
  BLOCKED="credentials file"
fi

# SSH directory
if echo "$FILE_PATH" | grep -qE "\.ssh/"; then
  BLOCKED="SSH directory file"
fi

if [ -n "$BLOCKED" ]; then
  echo "BLOCKED: Cannot write to $BLOCKED ($BASENAME)" >&2
  echo "  Credentials and secrets must be managed outside of agent-written code." >&2
  echo "  Use environment variables, a secrets manager, or ask the user to edit this file manually." >&2
  exit 2
fi

exit 0
