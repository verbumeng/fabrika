# [Platform Name]

Platform-level overview for `sources/connections/[platform]/`. Each
project or instance beneath this platform gets its own subdirectory
with a `README.md` using the Source-Connection-Template.

## Platform Type

- **Type:** [BigQuery | Snowflake | Databricks | SQL Server | PostgreSQL | MySQL | DuckDB | other]
- **Environment:** [cloud | on-prem | local]
- **Connection method:** [ODBC | native driver | API | CLI | other]

## Cost Model

> If you don't know your exact pricing tier, the defaults below are
> used for cost estimates in execution manifests and performance
> reviews. Update this section when you have your actual pricing info
> for more accurate cost projections.

- **Pricing model:** [on-demand | flat-rate/reserved | per-DBU | N/A (on-prem) | N/A (local)]
- **Cost basis:** [per TB scanned | per credit-hour | per DBU | N/A]
- **Rate:** [e.g., $6.25/TB, $2-4/credit-hour, $0.07-0.22/DBU, or "N/A — no per-query cost"]
- **Cost model source:** [actual (from account/admin) | default (published pricing)]

### Default Pricing Reference

If cost model source is "default," the following published defaults
are used (from the analytics-workspace workflow):

| Platform | Default Rate | Basis |
|----------|-------------|-------|
| BigQuery | $6.25/TB scanned | On-demand |
| Snowflake | $2-4/credit-hour | Standard tier, XS warehouse |
| Databricks | $0.07-0.22/DBU | Standard tier |
| SQL Server | N/A | No per-query cost — assess CPU/IO/lock impact |
| PostgreSQL | N/A | No per-query cost — assess server resource impact |
| MySQL | N/A | No per-query cost — assess server resource impact |

## EXPLAIN Mechanism

- **Command:** [e.g., `EXPLAIN`, `--dry_run`, `SET SHOWPLAN_XML ON`]
- **Output:** [e.g., estimated bytes scanned, logical plan with row counts, execution plan XML]

## General Notes

[Any platform-wide notes: authentication requirements, network
access constraints, maintenance windows, shared infrastructure
considerations.]

## Projects / Instances

List the Level 1 connections documented beneath this platform:

| Directory | Description |
|-----------|-------------|
| [e.g., `my-gcp-project/`] | [One-line description] |
