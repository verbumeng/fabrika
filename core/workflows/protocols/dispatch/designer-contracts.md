# Designer Dispatch Contracts

Per-agent dispatch contracts for designer agents. For dispatch
tiers, tier-conditional dispatch, lightweight dispatch, retry protocol,
and output format constraints, see the dispatch protocol hub at
`core/workflows/protocols/dispatch-protocol.md`.

---

## Visualization Designer — Design Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Requirements | Yes | Story acceptance criteria or task brief |
| Audience | Yes | Who will consume this visualization |
| Data output | Yes | The data or query results to be visualized |
| Tool docs pointer | Conditional | Path to `sources/tools/` or `docs/03-Design/Dashboard Spec.md` |
| Existing designs | Conditional | Prior versions if this is an iteration |
| Integration targets | Conditional | Existing dashboards or UI components this integrates with |

**Do not provide:** Preferred chart types or layout direction.

**Output expected:** Design spec at `docs/03-Design/[feature]-viz-spec.md` or `tasks/[date-name]/work/viz-spec.md`

---

## Visualization Designer — Review Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Design to review | Yes | The visualization or dashboard to evaluate |
| Original requirements | Yes | The requirements it was built against |
| Design principles | Conditional | Rubric or design guide if one exists |

**Output expected:** Review report at `docs/evaluations/[TICKET]-viz-review.md` or `docs/evaluations/[task-name]-viz-review.md`
