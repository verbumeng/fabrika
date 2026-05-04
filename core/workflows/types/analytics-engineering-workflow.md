# Analytics Engineering Workflow

Domain workflow for **analytics-engineering** projects. This file
defines the domain-specific agents, review criteria, and testing
approach that compose with the shared story execution mechanics in
`core/workflows/protocols/story-execution.md`.

The shared story execution mechanics are defined in the story-execution
protocol — this file adds the analytics-engineering-specific layer.

---

## Agent Roster

| Role | Agent | Notes |
|------|-------|-------|
| Planner | [product-manager](../../agents/product-manager.md) | Expands stories into specs; validates acceptance criteria |
| Reviewer | [code-reviewer](../../agents/code-reviewer.md) | Reviews transformation code against spec and rubric |
| Supplemental Reviewer | [performance-reviewer](../../agents/performance-reviewer.md) | Warehouse compute cost, query efficiency |
| Validator | [test-writer](../../agents/test-writer.md) | Transformation output validation, dbt test generation |
| Designer | [visualization-designer](../../agents/visualization-designer.md) | When stories produce visual outputs |
| Coordinator | [scrum-master](../../agents/scrum-master.md) | Sprint coordination (complexity-triggered) |
| Implementer | [data-engineer](../../agents/data-engineer.md) | Writes transformation code (dbt models, SQL, DuckDB) |
| Architect | [data-architect](../../agents/data-architect.md) | Evaluates data model design, transformation topology |

---

## Domain-Specific Gates

### Transformation Validation

Every transformation story must verify:
- Output schema matches the data model documentation
- Business logic matches the Transformation Logic document
- Row counts and distributions are within expected ranges
- Grain is preserved or documented when changed

### Migration Parity Checks

For Alteryx-to-SQL or Excel-to-dbt migrations:
- Output of the new transformation must match the output of the
  legacy process within documented tolerances
- Any intentional deviations from legacy output must be documented
  in the story's completion summary and the Migration Plan

### Data Model Alignment

The data-architect reviews schema changes to ensure consistency with
the documented data model and downstream consumer expectations.

---

## Testing Approach

- **TDD** — new dbt models, new transformation logic, star schema
  builds
- **Test-informed** — modifications to existing models, incremental
  refresh logic
- **Test-after** — configuration changes, source freshness adjustments

**Verification method:** Output diffing against known-good oracle
data + dbt tests for schema and data quality.

---

## Story Execution

For all story execution mechanics, follow
`core/workflows/protocols/story-execution.md`.
