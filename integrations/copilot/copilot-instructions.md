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

## Communication Style
- Explain architectural decisions and trade-offs in plain language
- When making a choice between approaches, tell me WHY you chose it
- Narrate what you're doing as you work — don't just silently write code
- If something could be done multiple ways, briefly mention the alternatives
