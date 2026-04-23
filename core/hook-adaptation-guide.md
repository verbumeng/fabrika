---
type: reference
title: Hook Adaptation Guide
created: 2026-04-23
updated: 2026-04-23
tags: [hooks, integration, cross-tool]
---

# Hook Adaptation Guide

Fabrika's enforcement layer uses two types of hooks: **git hooks** (universal) and **tool-specific hooks** (currently implemented for Claude Code). This guide documents what each hook enforces, how it's implemented per tool, and how to adapt the enforcement to any AI coding tool.

## Architecture Overview

```
Enforcement Layer          Claude Code    Copilot    Cursor/Other
--------------------------------------------------------------
Git hooks (universal)      Yes            Yes        Yes
Tool-specific hooks        settings.json  N/A        See adaptation
Enhanced instructions      CLAUDE.md      copilot-   adaptation
                                          instr.md   section below
```

**Git hooks are the primary enforcement layer.** They fire on git operations regardless of which tool drives them. Every AI coding tool that runs `git commit` or `git push` hits the same gates. This is the strongest, most portable enforcement.

**Tool-specific hooks are a bonus layer.** They catch problems earlier — before the command executes — and add capabilities git hooks can't provide (like auto-formatting after file writes). Claude Code has PreToolUse/PostToolUse hooks. Other tools have their own mechanisms or none at all.

## Hook Inventory

### Git Hooks (Universal — All Tools)

These are shell scripts installed to `.claude/hooks/` (for Claude Code) or `.git/hooks/` (for other tools). They work identically regardless of which AI tool triggers the git operation.

#### G1: Branch Protection
- **File:** `pre-commit.sh` (section 1)
- **What it enforces:** No direct commits to `main` or `master`
- **How it works:** Reads current branch name, blocks if it matches main/master
- **Blocks:** Yes (exit 2)
- **Why it matters:** Committing to main breaks the feature-branch workflow and is hard to undo cleanly

#### G2: Commit Message Format
- **File:** `commit-msg.sh`
- **What it enforces:** Conventional commit format — `type(scope): description`
- **How it works:** Regex validates the first line of the commit message against allowed types
- **Blocks:** Yes (exit 1 for git hooks — git uses exit 1 to block, unlike Claude Code which uses exit 2)
- **Why it matters:** Consistent commit history enables automated changelogs and makes git log useful

#### G3: Secret Scanning
- **File:** `pre-commit.sh` (section 2)
- **What it enforces:** No credentials, API keys, or private keys in committed code
- **How it works:** Greps the staged diff for patterns like `password=`, `api_key=`, `sk-`, PEM headers
- **Blocks:** Yes (exit 2)
- **Why it matters:** Secrets in git history are nearly impossible to fully remove and can lead to breaches

#### G4: STATUS.md Session Gate
- **File:** `pre-commit.sh` (section 3)
- **What it enforces:** During active Fabrika sessions (task lock file present), STATUS.md must be in the commit
- **How it works:** Checks for `.claude/current_tasks/*.lock`, if found verifies STATUS.md is staged
- **Blocks:** Yes (exit 2) when lock file present; skipped for ad hoc work (no lock file)
- **Why it matters:** Stale STATUS.md means the next session starts with wrong context

#### G5: Mesh Isolation Scope
- **File:** `pre-commit.sh` (section 4)
- **What it enforces:** During mesh topology sprints, modified files must be within the ticket's declared scope
- **How it works:** Reads topology from STATUS.md, scope from sprint contract, compares against staged files
- **Blocks:** Yes (exit 2) for out-of-scope files
- **Why it matters:** Mesh topology depends on isolation to prevent merge conflicts between parallel tasks

#### G6: STATUS.md Reminder
- **File:** `post-commit.sh`
- **What it enforces:** Soft reminder that STATUS.md wasn't in the commit
- **How it works:** Checks committed files for STATUS.md, prints warning if missing
- **Blocks:** No (advisory only — post-commit hooks cannot block)
- **Why it matters:** Catches ad hoc commits where G4 didn't fire (no lock file)

#### G7: Regression Gate
- **File:** `pre-push.sh`
- **What it enforces:** Test suite must pass before code reaches the remote
- **How it works:** Runs configurable `TEST_CMD`, blocks push on failure
- **Blocks:** Yes (exit 1)
- **Why it matters:** Prevents broken code from reaching the remote branch

### Claude Code Hooks (Tool-Specific)

These are configured in `.claude/settings.json` and reference shell scripts in `.claude/hooks/claude-code/`. They fire on Claude Code tool use, not git operations.

#### C1: Destructive Git Guard
- **File:** `claude-code/guard-destructive-git.sh`
- **Event:** PreToolUse
- **Matcher:** Bash
- **What it enforces:** Blocks `git push --force`, `git reset --hard`, `git checkout -- .`, `git restore .`, `git branch -D`, `git clean -f`
- **How it works:** Parses the Bash command from JSON stdin, regex-matches against destructive patterns
- **Blocks:** Yes (exit 2)
- **Why it matters:** Catches destructive commands before execution. Git hooks catch some of these too (pre-push blocks force push), but this hook catches a wider set and stops the command earlier.

#### C2: Protected File Guard
- **File:** `claude-code/guard-protected-files.sh`
- **Event:** PreToolUse
- **Matcher:** Write, Edit
- **What it enforces:** No agent writes to `.env`, `*.key`, `*secret*`, `*credential*`, `.ssh/*` files
- **How it works:** Parses the file path from JSON stdin, pattern-matches against protected names
- **Blocks:** Yes (exit 2)
- **Why it matters:** Defense-in-depth with the permissions deny list. The deny list blocks reading; this blocks writing with a clearer error message.

#### C3: Auto-Format on Write
- **File:** `claude-code/auto-format.sh`
- **Event:** PostToolUse
- **Matcher:** Write, Edit
- **What it enforces:** Consistent code formatting without spending tokens on style
- **How it works:** Runs configurable `FORMAT_CMD` on the file after it's written. Empty by default — consumer configures during bootstrap.
- **Blocks:** No (transforms file, always exits 0)
- **Why it matters:** Eliminates formatting drift. The agent focuses on logic; the formatter handles style.

#### C4: Lock File Cleanup Check
- **File:** `claude-code/check-lock-cleanup.sh`
- **Event:** PostToolUse
- **Matcher:** Bash
- **What it enforces:** Warns about remaining task lock files after git commit
- **How it works:** Detects git commit commands, checks for `.claude/current_tasks/*.lock` files, prints advisory
- **Blocks:** No (advisory only)
- **Why it matters:** Leftover lock files block the next session from starting cleanly

## Adapting to GitHub Copilot

Copilot does not have a PreToolUse/PostToolUse hook system. The enforcement strategy relies on two layers:

### Layer 1: Git hooks (full coverage)

All seven git hooks (G1-G7) work identically with Copilot. Install them to `.git/hooks/` instead of `.claude/hooks/`:

```bash
cp .claude/hooks/pre-commit.sh .git/hooks/pre-commit
cp .claude/hooks/commit-msg.sh .git/hooks/commit-msg
cp .claude/hooks/pre-push.sh .git/hooks/pre-push
cp .claude/hooks/post-commit.sh .git/hooks/post-commit
chmod +x .git/hooks/pre-commit .git/hooks/commit-msg .git/hooks/pre-push .git/hooks/post-commit
```

Or use a git hooks manager like `husky` or `lefthook` to share hooks via the repo.

### Layer 2: Instructions (substitute for tool-specific hooks)

Add these to `.github/copilot-instructions.md` to replicate the intent of C1-C4 via prompt guidance:

- **C1 equivalent:** "Never run destructive git commands (push --force, reset --hard, checkout --, restore ., branch -D, clean -f) without explicit user confirmation."
- **C2 equivalent:** "Never write to .env files, key files, or any file containing secrets or credentials. These must be managed by the user."
- **C3 equivalent:** Use VS Code's built-in format-on-save (`editor.formatOnSave: true`) which works independently of the AI tool.
- **C4 equivalent:** "During session close-out, verify all task lock files in `.claude/current_tasks/` have been removed."

### Coverage gap

Copilot relies on prompt compliance for C1, C2, and C4. This is weaker than mechanical enforcement — the git hooks remain the primary safety net. The critical rules (secrets, force push) are already covered by git hooks G3, G1, and G7.

## Adapting to Other Tools (Cursor, Windsurf, Aider, etc.)

### Step 1: Install git hooks (universal)

Every tool benefits from git hooks. Install G1-G7 to `.git/hooks/` or use a hooks manager. This gives you branch protection, commit format validation, secret scanning, STATUS.md enforcement, mesh isolation, and regression gating regardless of the AI tool.

### Step 2: Check for tool-specific hook support

| Tool | Hook System | Adaptation |
|------|------------|------------|
| **Cursor** | `.cursor/rules/` supports rule files; no PreToolUse/PostToolUse equivalent | Express C1-C4 as rules in Cursor's format. Formatting (C3) via editor settings. |
| **Windsurf** | `.windsurfrules` supports instructions; no mechanical hooks | Express C1-C4 as instructions. Formatting via editor. |
| **Aider** | `.aider.conf.yml` supports conventions; no hook system | Express C1-C4 as conventions. Formatting via pre-commit framework. |
| **Continue** | `.continuerc.json` supports rules; no hook system | Express C1-C4 as rules. Formatting via editor. |

### Step 3: Use the pre-commit framework for cross-tool mechanical enforcement

For tools without their own hook system, the [pre-commit](https://pre-commit.com/) framework provides a standardized way to run checks. It manages git hooks and can run formatters, linters, and custom scripts on every commit.

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: branch-protection
        name: Block commits to main
        entry: bash .claude/hooks/pre-commit.sh
        language: system
        stages: [commit]
```

This wraps the Fabrika git hooks in pre-commit's management, making them work consistently across any tool.

### Step 4: Adapt the agent instructions

Point the AI tool at this document:

> "Read `.fabrika/hook-adaptation-guide.md` and configure equivalent enforcement for [your tool]. Git hooks are already installed. Set up your tool's equivalent of the Claude Code-specific hooks (C1-C4) using whatever mechanism your tool supports."

The conceptual descriptions in the Hook Inventory section above give the agent enough context to recreate the enforcement in any tool's configuration format.
