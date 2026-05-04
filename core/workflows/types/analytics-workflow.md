# Analytics Workflow

For analytics workflow projects. No sprints. Work is organized as
individual analysis tasks.

## Design Alignment for Complex Analyses

Before the standard task lifecycle, the orchestrator checks whether
the work warrants structured alignment. Design Alignment fires at
project/phase level per standard triggers (new project, new phase,
owner request, detected ambiguity). Individual analytics tasks use the
task/plan flow regardless of complexity. If the orchestrator
determines the work is a new phase or feature rather than a task,
Design Alignment fires and produces a PRD.

Complexity indicators that suggest the work may be a new phase rather
than a task:

- 3+ data sources involved
- Multiple stakeholder groups with different needs
- Novel domain requiring terminology alignment
- Estimated effort exceeds 2 days
- Analysis informs a significant decision (budget, strategy, headcount)

Simple analyses proceed directly to the task lifecycle below.

## Pre-Workflow Assessment

After the task document is approved and the plan is written, before
the workflow begins:

1. Orchestrator reads the plan and classifies the task:
   - **Tier:** Local (Tier 1) vs. production (Tier 2), and which
     platforms. Highest tier wins for mixed sources.
   - **Stakes:** Low / medium / high (see Stakes Classification below).
2. Orchestrator communicates to the user: tier, stakes.
3. Workflow begins.

## Workflow Tiers

The workflow is determined by two independent dimensions: tier (data
environment) and stakes (review intensity). These are separate because
a low-stakes exploratory query on a cloud warehouse still needs cost
protection (tier), while a high-stakes analysis on local files needs
thorough validation (stakes) but not cost approval.

**Tier 1: Local data only.** Applies when ALL data sources are local
(DuckDB, Excel, CSV, Parquet, flat files). No execution manifest. No
performance review. Logic review always runs.

**Tier 2: Production data.** Applies when ANY data source in the plan
is a production database — cloud (BigQuery, Snowflake, Databricks) or
on-premise (SQL Server, PostgreSQL, MySQL). Execution manifest with
INFORMATION_SCHEMA and EXPLAIN plan output. Performance review. Cost
approval gate for cloud platforms.

**Mixed sources: highest tier wins.** If a task involves both local
files and a production database, the entire task uses Tier 2. A task
is a coherent unit of work — splitting review tiers per query within
a single task creates confusing ceremony for no benefit.

### Stakes Classification

Communicated to the user before the workflow begins, after plan
approval. The orchestrator assesses stakes from the task document's
audience and purpose.

| Stakes | Triggers | What scales |
|---|---|---|
| **Low** | Exploratory, internal consumption only, throwaway analysis | Logic review: standard checklist. Data validation: row counts + distributions. |
| **Medium** | Stakeholder ad hoc, team consumption, recurring report refresh, informs a team-level decision | Logic review: full checklist. Data validation: full checks, cross-references. |
| **High** | Executive audience, financial reporting, compliance, informs a major decision (budget, strategy, headcount) | Logic review: full checklist + extra scrutiny on edge cases. Data validation: all checks, multiple cross-references, thorough spot-checks. |

Cost/performance review intensity scales with tier, not stakes. Tier 2
always gets full performance review regardless of stakes.

---

## Tier 1 Workflow: Local Data Only

```
plan -> promotion check -> write -> logic review ->
[revise -> re-review]* -> execute -> validate + plan check -> deliver
```

### Phase Details

**Plan.** Analysis planner writes plan. Flags all data as local.
References Domain Language for term definitions. Points to relevant
data dictionaries in the source registry. Platform configuration
(connection type, local tools) comes from onboarding-scaffolded
files at `sources/connections/[platform]/README.md` when available.
After the plan is written, present the token cost estimate per
`core/workflows/protocols/token-estimation.md`.

**Promotion check.** Analysis planner checks `templates/` and
`recurring/` for prior similar tasks. If this is a repeat, flags it
and optionally initiates the promotion conversation (see
`[FABRIKA_PATH]/core/workflows/protocols/task-promotion.md`).

**Write.** Data analyst produces all code (SQL, Python, notebooks).
No execution manifest needed — local data is cheap to query. Code is
written to `tasks/[date-name]/work/`.

**Logic review.** Logic reviewer reviews all code. Checks: join
logic, filter logic, aggregation logic, business logic, DDL/DML
detection (protects local DuckDB from destructive operations), term
usage against Domain Language and data dictionary chain.

**Revise (if needed).** Data analyst reads the logic review report at
`docs/evaluations/[task-name]-logic-review.md` alongside the original
plan. Addresses each finding. Does not receive orchestrator-synthesized
fix instructions — reads the review directly.

**Re-review (if revised).** Logic reviewer re-checks revised code.
Verifies original findings are addressed AND that no new issues were
introduced. Writes versioned report (`-v2.md`). Loop continues until
green lights or 3 failed cycles, at which point the orchestrator
diagnoses the failure pattern and presents it to the user for
intervention (see Review-Revise Loop below).

**Execute.** Data analyst runs approved code.

**Validate.** Data validator runs validation scaled to the task's
stakes classification (see Stakes Classification table above): low
stakes get row counts and distributions, medium adds full checks and
cross-references, high adds multiple cross-references and thorough
spot-checks. Writes internal evaluation report to
`docs/evaluations/[task-name]-data-validation.md`. Writes human-facing
validation report to `tasks/[date-name]/validation-report.md`
(detailed evidence chain — always full detail regardless of stakes).

**Plan check.** Analysis planner in validation mode (see dispatch
contract in `[FABRIKA_PATH]/core/workflows/protocols/dispatch-protocol.md`).
Validates output answers the task document's question in the right
format for the stakeholder.

**Deliver.** Analysis planner writes `outcome.md`. Presents outcome
and validation report to owner using the Task Outcome Briefing format
(`[FABRIKA_PATH]/core/briefings/task-outcome-briefing.md`). Prompts:
"If you have follow-up analysis, start a new chat referencing this
task's outcome and task document for context."

---

## Tier 2 Workflow: Production Data

Applies when ANY data source in the plan is a production database
(cloud or on-prem). Highest tier wins for mixed sources.

```
plan -> promotion check -> write (code + metadata queries) ->
logic review -> [revise -> re-review]* ->
execute metadata (INFORMATION_SCHEMA + EXPLAIN) ->
performance review -> [revise -> logic re-review ->
re-run metadata -> performance re-review]* ->
[cost approval - cloud only] -> execute main queries ->
validate + plan check -> deliver
```

### Phase Details

**Plan.** Analysis planner writes plan. Flags production data sources
by type (BigQuery, Snowflake, Databricks, SQL Server, etc.).
References Domain Language and data dictionary chain for term
definitions. Platform configuration and cost model come from
onboarding-scaffolded files at
`sources/connections/[platform]/README.md` — these are populated
during workspace bootstrap (see BOOTSTRAP.md Phase 2W.1a) or
created manually. Includes preliminary cost estimate based on the
cost model documented there (or published defaults if cost model
unknown — see Platform-Specific EXPLAIN Mechanisms below).
After the plan is written, present the token cost estimate per
`core/workflows/protocols/token-estimation.md`.

**Promotion check.** Same as Tier 1.

**Write.** Data analyst produces ALL code: main queries/scripts AND
metadata queries. The metadata queries include:

- INFORMATION_SCHEMA lookups for each production table referenced:
  column names, data types, approximate row counts
- EXPLAIN / dry run statements for each production query: estimated
  execution plan, estimated bytes scanned or cost

All code is written to `tasks/[date-name]/work/`. Metadata queries
are clearly labeled as such (separate files or clearly marked
sections).

**Logic review.** Logic reviewer reviews ALL code — main queries AND
metadata queries. Checks: join logic, filter logic, aggregation
logic, business logic, DDL/DML detection (CRITICAL for production
databases — CREATE, DROP, ALTER, TRUNCATE, INSERT, UPDATE, DELETE
are flagged explicitly), metadata queries target the correct
databases/schemas/tables (consistent with what the main queries
reference), term usage against Domain Language and data dictionary
chain.

**Revise (if needed).** Data analyst reads the logic review report
alongside the original plan. Addresses findings.

**Re-review (if revised).** Logic reviewer re-checks. Versioned
report. Loop until green or 3 failed cycles -> orchestrator diagnosis
-> user intervention.

**Execute metadata.** Data analyst runs the logic-reviewed metadata
queries (cheap operations across all platforms — see Platform-Specific
EXPLAIN Mechanisms below). Produces the execution manifest at
`tasks/[date-name]/work/execution-manifest.md` containing:

- Tables touched (four-level path: project/server -> database ->
  dataset/schema -> table)
- Schema info per table from INFORMATION_SCHEMA (columns, types,
  approximate row counts)
- EXPLAIN plan output per production query (estimated execution plan,
  estimated bytes/rows scanned, join strategies)
- Estimated cost per query and total (calculated against the cost
  model from `sources/connections/[platform]/README.md`, or published
  defaults if cost model unknown)
- Data source classification (local / on-prem production / cloud
  production)

**Performance review.** Performance reviewer reviews the execution
manifest. Scope depends on platform type:

- **Cloud platforms (BigQuery, Snowflake, Databricks):** Estimated
  bytes scanned, cost per query (against cost model), recurring cost
  projections if the task may recur, scan optimization opportunities
  (partition filters, pre-aggregation, materialized views), DDL/DML
  risk re-confirmation.
- **On-prem platforms (SQL Server, PostgreSQL, MySQL):** Query
  complexity, estimated server resource consumption, lock risk on
  shared databases, unbounded queries, index usage, DDL/DML risk
  re-confirmation. No dollar cost — assess impact on shared
  infrastructure.
- **Both:** Flags queries whose cost/impact exceeds what the plan
  estimated.

**Revise (if performance review flags issues).** Data analyst reads
performance review + original plan. Revises main queries for
cost/efficiency.

**Re-review (if revised after performance review).** Both the logic
reviewer AND performance reviewer re-check. The logic reviewer
verifies the revision did not break correctness (a cost optimization
can change aggregation logic). The data analyst may need to re-run
EXPLAIN for revised queries and update the execution manifest. Loop
until both reviewers green or 3 failed cycles -> orchestrator
diagnosis -> user intervention.

**Cost approval (cloud only).** Before executing main queries against
a cloud warehouse, the orchestrator pauses and presents to the user:

- Total estimated cost (from execution manifest)
- Execution scale summary: number of queries, which tables, full
  scans vs. filtered scans, estimated rows/bytes per query, number
  of columns
- User approves or adjusts before execution proceeds

This gate applies only to cloud production data (BigQuery, Snowflake,
Databricks) where there is a direct dollar cost. On-prem databases do
not have per-query billing — the performance review is the sufficient
gate there.

**Execute.** Data analyst runs approved main queries.

**Validate.** Data validator runs validation scaled to the task's
stakes classification (see Stakes Classification table above): low
stakes get row counts and distributions, medium adds full checks and
cross-references, high adds multiple cross-references and thorough
spot-checks. Writes internal evaluation to
`docs/evaluations/[task-name]-data-validation.md`. Writes human-facing
validation report to `tasks/[date-name]/validation-report.md`
(detailed evidence chain — always full detail regardless of stakes).

**Plan check.** Analysis planner in validation mode. Same as Tier 1.

**Deliver.** Same as Tier 1.

---

## Platform-Specific EXPLAIN Mechanisms

| Platform | EXPLAIN mechanism | Default cost model (when user's model unknown) |
|---|---|---|
| BigQuery | `EXPLAIN` or `--dry_run` (API: `dryRun: true`) -> estimated bytes scanned | $6.25/TB scanned (on-demand) |
| Snowflake | `EXPLAIN` -> logical plan with estimated row counts | $2-4/credit-hour (standard tier, XS warehouse) |
| Databricks | `EXPLAIN EXTENDED` -> logical + physical plan | $0.07-0.22/DBU (standard tier) |
| SQL Server | `SET SHOWPLAN_XML ON` -> estimated execution plan | No per-query cost. Assess CPU/IO/lock impact. |

When using default cost estimates, the execution manifest and cost
approval gate include a note: "Cost estimated using default [platform]
pricing. Actual costs may differ based on your pricing tier. To
improve estimates, update the Cost Model section in
`sources/connections/[platform]/README.md`." The platform README is
initially populated during workspace onboarding (BOOTSTRAP.md Phase
2W.1a) — if the user did not know their cost model at that time, the
file uses published defaults and flags this.

---

## DDL/DML Detection

The logic reviewer checks all code for DDL (CREATE, DROP, ALTER,
TRUNCATE) and DML (INSERT, UPDATE, DELETE) statements. This applies
across ALL tiers — any data environment.

| Environment | Severity | Rationale |
|---|---|---|
| Cloud production (BQ, Snowflake, Databricks) | CRITICAL ERROR | Destructive operations on cloud warehouse; may affect shared resources, cost, or data integrity |
| On-prem production (SQL Server, etc.) | CRITICAL ERROR | Destructive operations on shared production database; no undo on DROP TABLE |
| Local DuckDB | Flagged warning | Lower stakes but can still destroy the local database mid-analysis |
| File-based (CSV, Excel, Parquet) | Flagged warning (Python file operations) | Python scripts that overwrite source files; less common but possible |

DDL/DML detection is an addition to the logic reviewer's existing
checklist, not a new agent or review phase.

---

## Domain Language and Data Dictionary Integration

### Domain Language

Domain Language (`docs/00-Index/Domain-Language.md`) stays high-level:
business terms, their definitions, and pointers to data dictionaries
when a term has multiple definitions across data sources.

### Data Dictionaries

Data dictionaries live in the source registry and follow the
four-level platform hierarchy:

```
Level 1: Project / Server / Account / Instance
  Level 2: Database
    Level 3: Dataset / Schema
      Level 4: Table / View
```

Structure under `sources/connections/`:

```
sources/connections/
  [platform]/
    README.md                        <- Platform overview, cost model
    [level-1: project/instance]/
      README.md                      <- Level 1 description
      [level-2: database]/
        README.md                    <- Level 2 description
        [level-3: dataset/schema]/
          README.md                  <- Level 3 description
          [level-4: table-name].md   <- Data dictionary: columns,
                                        types, descriptions, business
                                        meaning, grain, refresh
                                        cadence, known quality issues
```

Data dictionaries are populated incrementally as the user works with
specific tables.

### Agent Integration

The following agents reference Domain Language and data dictionaries
during their orientation:

- **Analysis planner:** Reads Domain Language during plan creation.
  Flags terms in the task document/plan that have multiple definitions. Points
  agents to the relevant data dictionary entries for the task's data
  sources.
- **Data analyst:** Reads data dictionary entries for tables being
  queried. Uses correct column names, business definitions, and known
  quality notes.
- **Logic reviewer:** Checks term usage in code against Domain
  Language definitions and data dictionary entries. Flags ambiguity.
- **Data validator:** References data dictionaries for expected column
  distributions, known quality issues, refresh cadence (source
  freshness assessment).

The analysis planner checks Domain Language during plan creation if
the document exists.

---

## Source Freshness

Source freshness is assessed by the data validator post-execution
through two mechanisms:

1. **Date distribution check.** If the analysis should cover a
   specific period but the most recent date in the output data is
   earlier than expected, the data validator flags it. This is a
   natural extension of the distribution checks already in the data
   validator's checklist.

2. **Source registry cadence check.** If the source's connection doc
   (e.g., `sources/connections/[platform]/[instance]/README.md`)
   documents an expected refresh cadence, the data validator compares
   the latest date in the output against the documented lag.

No separate freshness queries are run. These checks use data already
available to the data validator during its standard validation
process.

---

## Human-Facing Validation Report

A deliverable produced by the data validator. Lives at
`tasks/[date-name]/validation-report.md`.

Purpose: trace each key claim in the outcome report back to the code
and data that supports it. This is the evidence chain that lets a
stakeholder (or the owner's future self) understand WHY they can trust
each number without re-reading the SQL.

Always detailed. The validation report is a detailed evidence chain
regardless of stakes. For low-stakes tasks it will naturally be
shorter (fewer queries, simpler logic = fewer chains to document), but
the level of detail per chain is the same.

The data validator writes it as a second output alongside its internal
evaluation report. Distinct from the internal evaluation report: the
evaluation report at `docs/evaluations/[task-name]-data-validation.md`
is for the review loop (verdict, findings, validation queries). The
validation report at `tasks/[date-name]/validation-report.md` is for
the stakeholder (evidence chain, traceability, trust).

---

## Task Folder Structure

```
tasks/[date-name]/
  task.md                           <- What is the question
  plan.md                           <- How we will answer it
  work/                             <- The code itself
    *.sql, *.py, *.ipynb
    execution-manifest.md           <- Tier 2 only: metadata query
                                       results (schema, EXPLAIN,
                                       cost estimates)
  outcome.md                        <- Results and methodology
  validation-report.md              <- Human-facing evidence chain

docs/evaluations/
  [task-name]-logic-review.md       <- Logic reviewer findings
  [task-name]-logic-review-v2.md    <- Versioned if revision occurred
  [task-name]-performance-review.md <- Performance reviewer findings
  [task-name]-data-validation.md    <- Data validator internal report
  [task-name]-plan-check.md         <- Analysis planner validation
```

The execution manifest lives in `work/` because it is a work product
(output of running metadata queries). The validation report lives at
the task root alongside the outcome because it is a stakeholder-facing
deliverable. Review reports stay in `docs/evaluations/` per existing
convention across all project types.

---

## Review-Revise Loop

The analytics workflow review-revise loop follows the universal
pattern defined in `core/design-principles.md`
(implementer-reviewer pairing):

- **Implementer reads reviews directly.** The data analyst reads
  review reports from `docs/evaluations/` alongside the original
  plan. The orchestrator routes file paths, it does not synthesize
  or interpret findings.
- **Mandatory re-review after every revision.** Revised code goes
  back through the same reviewers. A fix can introduce new errors.
- **3-cycle cap.** After 3 failed review cycles, the orchestrator
  diagnoses the failure pattern across all cycles and presents it to
  the user in plain language using Domain Language terms. User decides
  the path forward. Review cycle still runs after intervention.
- **Re-review scope after performance-triggered revision.** When a
  performance review flags issues and the data analyst revises main
  queries, BOTH the logic reviewer and performance reviewer re-check.
  The data analyst re-runs EXPLAIN for revised queries and updates
  the execution manifest.

---

## Exploratory Iteration and Handoff

After delivery, the orchestrator prompts the user:

> "Results delivered. If you have follow-up analysis, start a new
> chat and reference `tasks/[date-name]/outcome.md` and the task
> document for context."

Each analysis task is a bounded unit of work with its own task
document, plan, validation, and outcome. Follow-up iteration starts a new chat
that picks up from the outcome, not from scratch. The analysis
planner in the new session reads the prior outcome as part of its
orientation.

---

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
When analyses recur, the analysis planner initiates a promotion conversation with the owner. Five levels from least to most overhead: templatize, scriptify, visualize, automate, spin out. Most promotions stay within the current workspace (Levels 1-4). See `[FABRIKA_PATH]/core/workflows/protocols/task-promotion.md` for the full workflow.

Promoted task assets:
- `templates/` — reusable analysis templates (Level 1)
- `src/scripts/` and `src/queries/` — parameterized scripts (Level 2)
- `recurring/` — automated, scheduled analyses (Level 4)
- `recurring/README.md` — index of all recurring analyses

## Knowledge Pipeline Cadence

When an analytics workspace has a `wiki/` directory, the knowledge
pipeline runs at cadences tied to task delivery rather than sprints.
For the full pipeline specification, see
`[FABRIKA_PATH]/core/workflows/protocols/knowledge-pipeline.md`. For the
step-by-step procedure, see
`[FABRIKA_PATH]/core/workflows/protocols/knowledge-synthesis.md`.

| Cadence | Pipeline Phases | What Happens |
|---------|----------------|--------------|
| After each task delivery | Phases 1-2 (Extract + Index) | Index the task's task document, plan, and outcome as a batch in `wiki/meta/` |
| Monthly or on demand | Phases 3-4 (Synthesize + Link) | Synthesize recurring themes across tasks, update topic articles and `wiki/index.md` narrative. Triggered when 3+ batch indexes exist without a synthesis pass, or on owner request. |
| Quarterly | All phases (full reintegration) | Re-score salience, rewrite stale articles, merge/retire topics, rebuild narrative, clean up batch entries. Triggered when 3+ months since last reintegration. |

Extract+Index runs as part of the Deliver phase when a `wiki/`
directory exists. After the outcome report is written, the agent
indexes the task's task document, plan, and outcome as a batch. This
is automatic — no additional user action required.
