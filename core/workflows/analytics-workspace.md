# Analytics Workspace Workflow

For `analytics-workspace` project types only. No sprints. Work is organized as individual analysis tasks.

## Design Alignment for Complex Analyses

Before the standard task lifecycle, the orchestrator checks whether the
analysis warrants structured alignment. If any of the following
complexity triggers are met, the orchestrator runs the Design Alignment
protocol (`core/workflows/design-alignment.md`) before creating the
brief:

- 3+ data sources involved
- Multiple stakeholder groups with different needs
- Novel domain requiring terminology alignment
- Estimated effort exceeds 2 days
- Analysis informs a significant decision (budget, strategy, headcount)

When triggered, Design Alignment produces an enhanced Analysis Brief
with deeper coverage of scope, terminology, and success criteria. The
output uses the standard brief template — it is NOT a Charter or PRD
(analytics-workspace is task-based, not sprint-based).

Simple analyses skip alignment and proceed directly to the task
lifecycle below.

## Task Lifecycle
1. **Brief** — Analysis planner takes the ask, writes `tasks/[date-name]/brief.md` (business question, stakeholder, deadline, desired output)
2. **Plan** — Analysis planner writes `tasks/[date-name]/plan.md` (data sources, approach, SQL/logic, assumptions, validation strategy). Includes a cost estimate (compute, API/LLM, total). Present the plan to the owner using the **Task Plan Briefing** format (`[FABRIKA_PATH]/core/briefings/task-plan-briefing.md`). Owner approves.
3. **Promotion check** — Analysis planner checks for prior similar tasks in `templates/` and `recurring/`. If this is a repeat, flags it and optionally initiates the promotion conversation (see `[FABRIKA_PATH]/core/workflows/task-promotion.md`).
4. **Execute** — Work happens in `tasks/[date-name]/work/`. SQL files, notebooks, scripts.
5. **Validate** — Logic reviewer checks join/filter/aggregation logic. Data validator runs sanity checks (row counts, distributions, cross-references). Performance reviewer checks cost/efficiency for high-compute or recurring tasks.
6. **Deliver** — `tasks/[date-name]/outcome.md` — results, methodology, data quality notes, output location. Present the outcome to the owner using the **Task Outcome Briefing** format (`[FABRIKA_PATH]/core/briefings/task-outcome-briefing.md`).

## Advisory Mode (GUI Tools)
For Tableau, Power BI, Alteryx, and similar tools the agent cannot directly access:
- **Agent can:** Write SQL, draft DAX/M expressions, draft calculated fields, write validation queries, review described logic
- **Human does:** Execute inside the tool, screenshot results, describe workflow steps for review

## Source Registry
`sources/README.md` is the index. Three categories:
- `sources/connections/` — queryable data sources (warehouses, databases, ODBC, APIs)
- `sources/tools/` — BI/ETL tools in advisory mode (Tableau Server, Power BI, Alteryx)
- `sources/files/` — recurring flat file sources (CSVs, Excel, YXDBs)

## Task Promotion
When analyses recur, the analysis planner initiates a promotion conversation with the owner. Five levels from least to most overhead: templatize, scriptify, visualize, automate, spin out. Most promotions stay within the current workspace (Levels 1-4). See `[FABRIKA_PATH]/core/workflows/task-promotion.md` for the full workflow.

Promoted task assets:
- `templates/` — reusable analysis templates (Level 1)
- `src/scripts/` and `src/queries/` — parameterized scripts (Level 2)
- `recurring/` — automated, scheduled analyses (Level 4)
- `recurring/README.md` — index of all recurring analyses

## Knowledge Pipeline Cadence

When an analytics workspace has a `wiki/` directory, the knowledge
pipeline runs at cadences tied to task delivery rather than sprints.
For the full pipeline specification, see
`[FABRIKA_PATH]/core/workflows/knowledge-pipeline.md`. For the
step-by-step procedure, see
`[FABRIKA_PATH]/core/workflows/knowledge-synthesis.md`.

| Cadence | Pipeline Phases | What Happens |
|---------|----------------|--------------|
| After each task delivery | Phases 1-2 (Extract + Index) | Index the task's brief, plan, and outcome as a batch in `wiki/meta/` |
| Monthly or on demand | Phases 3-4 (Synthesize + Link) | Synthesize recurring themes across tasks, update topic articles and `wiki/index.md` narrative. Triggered when 3+ batch indexes exist without a synthesis pass, or on owner request. |
| Quarterly | All phases (full reintegration) | Re-score salience, rewrite stale articles, merge/retire topics, rebuild narrative, clean up batch entries. Triggered when 3+ months since last reintegration. |

Extract+Index runs as part of the Deliver step (step 6 in the task
lifecycle) when a `wiki/` directory exists. After the outcome report
is written, the agent indexes the task's brief, plan, and outcome
as a batch. This is automatic — no additional user action required.
