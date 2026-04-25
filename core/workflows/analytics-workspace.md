# Analytics Workspace Workflow

For `analytics-workspace` project types only. No sprints. Work is organized as individual analysis tasks.

## Task Lifecycle
1. **Brief** — Analysis planner takes the ask, writes `tasks/[date-name]/brief.md` (business question, stakeholder, deadline, desired output)
2. **Plan** — Analysis planner writes `tasks/[date-name]/plan.md` (data sources, approach, SQL/logic, assumptions, validation strategy). Owner approves.
3. **Execute** — Work happens in `tasks/[date-name]/work/`. SQL files, notebooks, scripts.
4. **Validate** — Logic reviewer checks join/filter/aggregation logic. Data validator runs sanity checks (row counts, distributions, cross-references).
5. **Deliver** — `tasks/[date-name]/outcome.md` — results, methodology, data quality notes, output location.

## Advisory Mode (GUI Tools)
For Tableau, Power BI, Alteryx, and similar tools the agent cannot directly access:
- **Agent can:** Write SQL, draft DAX/M expressions, draft calculated fields, write validation queries, review described logic
- **Human does:** Execute inside the tool, screenshot results, describe workflow steps for review

## Source Registry
`sources/README.md` is the index. Three categories:
- `sources/connections/` — queryable data sources (warehouses, databases, ODBC, APIs)
- `sources/tools/` — BI/ETL tools in advisory mode (Tableau Server, Power BI, Alteryx)
- `sources/files/` — recurring flat file sources (CSVs, Excel, YXDBs)
