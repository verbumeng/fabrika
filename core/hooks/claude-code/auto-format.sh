#!/bin/bash
# Claude Code PostToolUse hook — Auto-format on write
# Matcher: Write, Edit
#
# Runs the configured formatter on files after they are written or edited.
# If FORMAT_CMD is empty, this hook does nothing (safe default for unconfigured projects).
#
# CONFIGURE: Update FORMAT_CMD after tech stack is chosen during project bootstrap.
# The command receives the file path as the last argument.
#
# Examples:
#   FORMAT_CMD="prettier --write"        # JavaScript/TypeScript
#   FORMAT_CMD="ruff format"             # Python
#   FORMAT_CMD="gofmt -w"               # Go
#   FORMAT_CMD="rustfmt"                # Rust
#   FORMAT_CMD="mix format"             # Elixir

FORMAT_CMD=""  # Set during bootstrap — leave empty to disable

if [ -z "$FORMAT_CMD" ]; then
  exit 0
fi

INPUT=$(cat /dev/stdin)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Only format source files — skip configs, markdown, images, etc.
case "$FILE_PATH" in
  *.md|*.json|*.yml|*.yaml|*.toml|*.lock|*.png|*.jpg|*.svg|*.ico)
    exit 0
    ;;
esac

eval "$FORMAT_CMD \"$FILE_PATH\"" 2>/dev/null

# Always exit 0 — formatting failures should not block the agent.
# If the formatter fails, the file was still written successfully.
exit 0
