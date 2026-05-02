# Analytics Workspace Onboarding

Platform and source configuration protocol for analytics-workspace
projects. Run during bootstrap (BOOTSTRAP.md Phase 2W.1a) or
retroactively via ADOPT.md for existing workspaces.

All questions are skippable — the user can fill in details later.

---

## Prerequisites

The workspace must already have:
- The `sources/connections/` directory structure
- Templates copied: `Platform-Connection-Template.md` and
  `Source-Connection-Template.md` (in `docs/Templates/` or read
  directly from `[FABRIKA_PATH]/core/templates/`)

---

## Question Group 1: Platforms and Technology

Ask: **"What database platforms do you work with? (BigQuery,
Snowflake, Databricks, SQL Server, PostgreSQL, MySQL, DuckDB, other)"**

For each platform identified, create
`sources/connections/[platform]/README.md` using the
Platform-Connection-Template.

Also ask:
- "What file formats do you commonly work with? (CSV, Excel,
  Parquet, JSON, YXDB, other)"
- "What BI/ETL tools do you use? (Tableau, Power BI, Alteryx, dbt,
  Airflow, other)"

Record file formats in `STATUS.md`. BI/ETL tools will be documented
in detail during the source inventory conversation (BOOTSTRAP.md
Phase 2W.2) or as part of an existing workspace's source registry.

---

## Question Group 2: Cost Model (Cloud Platforms)

For each cloud platform identified (BigQuery, Snowflake, Databricks):

Ask: **"Do you know your pricing model for [platform]?"**

- BigQuery: on-demand (per TB scanned) or flat-rate (slot
  reservations)?
- Snowflake: what tier (standard, enterprise, business critical)?
  What default warehouse size?
- Databricks: what tier? What default cluster type?

If the user knows their pricing, fill in the Cost Model section of
the platform's README. If unknown: fill in the cost model source as
"default" and note in the platform README: "Cost model: using
default estimates. Update the Cost Model section for more accurate
cost projections." Also add a note in the project instruction file.

On-prem platforms (SQL Server, PostgreSQL, MySQL) and local platforms
(DuckDB) do not have per-query billing — skip cost model questions
for these. Their platform READMEs note "N/A" for cost.

---

## Question Group 3: Source Registry Scaffolding

Ask: **"Do you have specific databases, projects, or servers you'll
be querying regularly?"**

For each source identified, create a Level 1 stub beneath the
platform directory using the Source-Connection-Template:
`sources/connections/[platform]/[project-or-instance]/README.md`

After scaffolding, inform the user: "You can discover schemas for
these sources via INFORMATION_SCHEMA queries whenever you want — just
ask during an analysis task. We don't need to do that now."

---

## Question Group 4: Data Governance

Ask: **"Do you use a data catalog or data governance tool? (Alation,
Collibra, DataHub, Atlan, etc.)"**

If yes: "You can integrate a catalog tool with the agent workflow
if you want, but Fabrika doesn't have built-in integration — that
would require custom API configuration on your side. For now,
Markdown data dictionaries in the source registry are the default.
Would you like to set up the Markdown data dictionaries now?"

If no: proceed with Markdown-based data dictionaries as the default.

If the user wants to set up data dictionaries now, create stubs at
the appropriate level in the source registry hierarchy. Otherwise,
data dictionaries will be populated incrementally as the user works
with specific tables during analysis tasks.
