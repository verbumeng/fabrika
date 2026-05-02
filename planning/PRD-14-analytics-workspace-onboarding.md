# PRD-14: Analytics Workspace Onboarding Protocol

**Version target:** 0.23.0
**Dependencies:** PRD-11 (analytics pre-execution review — defines
the workflow that onboarding configures for), PRD-06 (domain
language — onboarding may initiate terminology capture)
**Status:** Aligned (2026-05-02)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

When a user creates an analytics workspace via BOOTSTRAP.md, the
current process scaffolds the directory structure and sets up the
project instruction file but does not gather platform-specific
configuration that the analytics workflow depends on. Specifically:

1. **Platform and technology identification.** The workflow tiers
   (local data vs. production data) and the pre-execution review
   process (PRD-11) depend on knowing what platforms the user works
   with: BigQuery, Snowflake, Databricks, SQL Server, DuckDB, Excel,
   etc. Currently this is discovered ad hoc during the first analysis
   task.

2. **Cost model documentation.** The performance reviewer and the
   pre-execution cost approval gate (PRD-11) need to know the
   platform's pricing model to estimate query costs. Without this,
   the system falls back to published default pricing, which may be
   inaccurate for the user's tier. Users often do not know their
   exact cost model, so the onboarding should handle both cases.

3. **Source registry scaffolding.** The source registry
   (`sources/README.md`, `sources/connections/`, etc.) is the
   backbone of how agents discover data sources and their schemas.
   Currently it is scaffolded as empty directories. Onboarding should
   ask what sources exist and create stubs so agents have something
   to reference from the first task.

4. **Data governance tooling.** Some organizations use data catalog or
   data governance tools (Alation, Collibra, DataHub, Atlan, etc.)
   that contain schema documentation, data dictionaries, lineage, and
   quality metadata. If available, these tools could abrogate the need
   for maintaining data dictionaries in Markdown. However, integrating
   these tools with agent workflows requires custom API configuration.
   Onboarding should surface this option.

## Solution Direction (Needs Design Alignment)

### Onboarding Questions

When bootstrapping an analytics workspace, after the standard
directory scaffolding, the orchestrator asks the user a series of
configuration questions. These are optional — the user can skip any
question and fill in the details later.

**Platform and technology:**
- What database platforms do you work with? (BigQuery, Snowflake,
  Databricks, SQL Server, PostgreSQL, MySQL, DuckDB, other)
- What file formats do you commonly work with? (CSV, Excel, Parquet,
  JSON, YXDB, other)
- What BI/ETL tools do you use? (Tableau, Power BI, Alteryx, dbt,
  Airflow, other)

**Cost model (for cloud platforms):**
- For each cloud platform identified: Do you know your pricing model?
  - BigQuery: on-demand (per TB scanned) or flat-rate (slot
    reservations)?
  - Snowflake: what tier (standard, enterprise, business critical)?
    What default warehouse size?
  - Databricks: what tier? What default cluster type?
- If unknown: "We'll use published default pricing for cost estimates.
  You can update the cost model later at
  `sources/connections/[platform]/README.md`."

**Source registry:**
- Do you have specific databases, projects, or servers you'll be
  querying regularly? (Scaffold connection stubs)
- For each source: general purpose/description, connection details
  the user wants to document

**Data governance:**
- Do you use a data catalog or data governance tool? (Alation,
  Collibra, DataHub, Atlan, etc.)
- If yes: "You can integrate a catalog tool with the agent workflow
  if you want, but Fabrika doesn't have built-in integration — that
  would require custom API configuration on your side. For now,
  Markdown data dictionaries in the source registry are the default.
  Would you like to set up the Markdown data dictionaries now?"
- If no: proceed with Markdown-based data dictionaries as the default

### Template Files

Onboarding creates platform-specific template files pre-populated
with defaults:

- `sources/connections/[platform]/README.md` — platform overview with
  cost model section (filled if known, stubbed with defaults if not)
- `sources/connections/[platform]/[project-or-instance]/README.md` —
  Level 1 stub for each identified source
- Cost model flag in the project instruction file if cost model is
  unknown: "Cost model: using default estimates. Update at
  [path] for more accurate cost projections."

### Source Registry Four-Level Structure

For each platform connection identified during onboarding, scaffold
the data dictionary hierarchy:

```
sources/connections/
  [platform]/
    README.md                    <- Platform overview + cost model
    [level-1: project/instance]/
      README.md                  <- Level 1 description
      [level-2: database]/
        README.md                <- Level 2 description
        [level-3: dataset/schema]/
          README.md              <- Level 3 description
          [level-4: table].md    <- Data dictionary (stubbed)
```

During onboarding, only the platform-level connection stubs are
created (Level 1 at most). After scaffolding, the orchestrator
informs the user that they can discover schemas via
INFORMATION_SCHEMA calls whenever they want, but this is not part of
onboarding — it would happen later, during a task or on their own
initiative. Levels 2-4 (database → dataset/schema → table data
dictionaries) are populated incrementally as the user works with
specific tables during analysis tasks.

## Scope (Preliminary)

### Likely modified files

| File | Change |
|---|---|
| `BOOTSTRAP.md` | Add analytics-workspace-specific onboarding questions after directory scaffolding |
| `core/templates/` | New template files for platform cost model docs, source connection stubs |
| `core/workflows/analytics-workspace.md` | Reference onboarding as the source of platform configuration |
| `integrations/claude-code/CLAUDE.md` | Reflect onboarding availability |
| `integrations/copilot/copilot-instructions.md` | Reflect onboarding availability |
| `VERSION` | TBD |
| `CHANGELOG.md` | Entry |

### What does NOT change

- The analytics workspace task lifecycle (PRD-11 handles that)
- Sprint-based or agentic-workflow bootstrapping (this is analytics-
  workspace-specific)
- Domain Language setup (handled by PRD-06 and Design Alignment)

## Resolved Questions (Aligned 2026-05-02)

- **Analysis patterns / validation intensity:** No. Stakes
  classification already handles validation intensity per-task.
  Onboarding does not ask about analysis patterns or pre-set
  defaults.
- **Data governance integration path:** Not a future PRD. Onboarding
  mentions catalog integration as an option the user can pursue on
  their own, but Fabrika has no built-in integration. Markdown data
  dictionaries are the default.
- **Source registry depth:** Onboarding scaffolds platform-level
  connection stubs (Level 1 at most). After scaffolding, the user is
  informed they can discover schemas via INFORMATION_SCHEMA whenever
  they want. Schema discovery is not part of onboarding.
