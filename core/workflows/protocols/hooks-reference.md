# Hooks Reference

Hooks enforce workflow conventions mechanically — the agent cannot rationalize around them. Two layers provide defense-in-depth: git hooks (universal, work with any AI coding tool) and tool-specific hooks (configured per integration).

## Git Hooks (Universal)

**Pre-Commit** — Four checks, all blocking:
1. **Branch protection** — blocks commits directly to `main` or `master`
2. **Secret scanning** — blocks commits containing credential patterns (`password=`, `api_key=`, PEM headers, `sk-` tokens)
3. **STATUS.md session gate** — if a task lock file exists (active Fabrika session), requires STATUS.md in the commit. Skipped for ad hoc work.
4. **Mesh isolation scope** — for mesh topology sprints, verifies modified files fall within the declared scope for the active ticket. Inactive for pipeline and hierarchical topologies.

**Commit-Msg** — Validates conventional commit format: `type(scope): description`. Blocks on mismatch.

**Post-Commit** — Advisory reminder if STATUS.md was not in the commit. Does not block (post-commit hooks run after the commit is done). Catches ad hoc commits where the session gate did not fire.

**Pre-Push** — Runs the fast test command. Blocks push if any test fails.

## Tool-Specific Hooks

These are configured differently per integration (see the integration's instructions file for specifics):

**Destructive Git Guard:** Blocks `git push --force`, `git reset --hard`, `git checkout -- .`, `git restore .`, `git branch -D`, `git clean -f` before execution.

**Protected File Guard:** Blocks writes to `.env`, `*.key`, `*secret*`, `*credential*`, `.ssh/*` files. Defense-in-depth with the permissions deny list.

**Auto-Format:** Runs the project's formatter on files after write/edit operations. Empty by default — configure during bootstrap with your formatter (prettier, ruff, gofmt, etc.).

**Lock File Cleanup:** After git commit, warns if task lock files remain in `.claude/current_tasks/`. Advisory only.

## Hook Discovery

When a rule violation appears in evaluator feedback, session logs, or maintenance findings 3+ times, assess whether it should graduate to a mechanical hook. See `.fabrika/hook-discovery-workflow.md` for the evaluation criteria and creation process. For adapting hooks to other AI coding tools, see `.fabrika/hook-adaptation-guide.md`.
