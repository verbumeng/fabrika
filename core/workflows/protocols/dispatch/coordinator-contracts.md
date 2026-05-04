# Coordinator Dispatch Contracts

Per-agent dispatch contracts for coordinator agents. For dispatch
tiers, tier-conditional dispatch, lightweight dispatch, retry protocol,
and output format constraints, see the dispatch protocol hub at
`core/workflows/protocols/dispatch-protocol.md`.

---

## Scrum Master — Sprint Planning

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| STATUS.md | Yes | Current project state and cycle phase |
| Previous retro | Yes | Path to the previous sprint's retro file |
| Backlog state | Yes | Paths to stories with `status: To Do` |
| Features.json | Yes | Current pass/fail state |
| Git log | Yes | Recent commit history (last 10-20 commits) |
| Maintenance tag | Yes | When the last maintenance session ran |
| PRD pointer | Conditional | Path to the approved PRD — required for the first sprint of a new project or phase. If no PRD exists (legacy projects, subsequent sprints where all PRD stories are already in the backlog), the scrum master plans from backlog as before |
| Owner priorities | Optional | Any priorities or constraints from the conversation |
| Unfinished stories | Conditional | Stories from previous sprint that were not completed |

**Output expected:** Sprint file, sprint contract, sprint progress
file, updated story assignments

---

## Scrum Master — Sprint Retro

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Sprint progress file | Yes | Path to `Sprint-XX-progress.md` |
| Sprint contract | Yes | Path to the sprint contract (what was planned) |
| Maintenance findings | Conditional | Summary of maintenance session if one ran this cycle |
| Previous retro | Yes | Path to previous sprint's retro for trend tracking |
| Agent quality notes | Yes | Agent observations from the progress file |

**Output expected:** Retro file at `docs/04-Backlog/Sprints/Sprint-XX-retro.md`, updated STATUS.md
