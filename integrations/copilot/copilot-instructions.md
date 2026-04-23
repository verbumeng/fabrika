# Project Copilot Instructions

## Orchestration Principle

The AI agent orchestrates the entire development workflow. The human's role is decision-making and review: approving plans, reviewing evaluations, selecting sprint scope, and approving prompt improvements. The human never manually invokes agents, moves files, updates progress files, or runs checklists. If an action can be performed by the agent, the agent performs it automatically.

## Project Context
- **Project docs:** `[project-root]/docs/`
- **Backlog:** `docs/04-Backlog/` (Epics, Stories, Sprints)
- **Sprint contracts:** `docs/04-Backlog/Sprints/Sprint-XX-contract.md`
- **Evaluations:** `docs/evaluations/`
- **Agent evals:** `docs/evals/`

## Workflow Summary
1. Read `STATUS.md` at session start for orientation
2. Follow the sprint contract for current work
3. Use subagents (scrum-master, product-manager, code-reviewer, test-writer) at appropriate trigger points
4. Update `STATUS.md` and sprint progress file at session end
5. Follow the Development Workflow in the project's configuration file

## Code Quality
- Run `semgrep` for security-relevant code changes before considering a task complete
- Write descriptive commit messages — prefix with conventional commit types (feat:, fix:, docs:, chore:, refactor:, test:, maint:)
- Do NOT add AI attribution to git commits
- Always create a feature branch; never commit directly to main

## Hooks & Enforcement

Git hooks in `.git/hooks/` enforce workflow rules mechanically. These work with any AI coding tool — install them from the Fabrika hook templates in `.claude/hooks/` (or ask the agent to copy them).

**What the hooks enforce:**
- **pre-commit:** Blocks commits to main/master, scans for secrets in staged changes, requires STATUS.md when a task lock is active, enforces mesh isolation scope
- **commit-msg:** Validates conventional commit format (`type(scope): description`)
- **pre-push:** Runs the fast test suite, blocks push on failure
- **post-commit:** Reminds if STATUS.md wasn't updated (advisory, does not block)

**Rules enforced by instruction (no mechanical hook in Copilot):**
- Never run destructive git commands (`push --force`, `reset --hard`, `checkout -- .`, `restore .`, `branch -D`, `clean -f`) without explicit user confirmation
- Never write to `.env` files, key files, or any file containing secrets or credentials — these must be managed by the user
- During session close-out, verify all task lock files in `.claude/current_tasks/` have been removed

**Auto-formatting:** Use VS Code's built-in format-on-save (`editor.formatOnSave: true`) to handle code formatting independently of the AI tool.

For the full hook inventory and adaptation guidance, see `.fabrika/hook-adaptation-guide.md`.

## Communication Style
- Explain architectural decisions and trade-offs in plain language
- When making a choice between approaches, tell me WHY you chose it
- Narrate what you're doing as you work — don't just silently write code
- If something could be done multiple ways, briefly mention the alternatives
