# Data Engineering Workflow

Domain workflow for **data-engineering** projects. This file defines
the domain-specific agents, review criteria, and testing approach that
compose with the shared story execution mechanics in
`core/workflows/protocols/story-execution.md`.

The shared story execution mechanics (story-start orientation,
dispatch protocol reference, tier-conditional branching, freshness-aware
context loading, testing approach branching, evaluation cycle,
multi-domain story completion) are defined in the story-execution
protocol — this file adds the data-engineering-specific layer.

---

## Agent Roster

| Role | Agent | Notes |
|------|-------|-------|
| Planner | [product-manager](../../agents/product-manager.md) | Expands stories into specs; validates acceptance criteria |
| Reviewer | [code-reviewer](../../agents/code-reviewer.md) | Reviews pipeline code against spec and rubric |
| Supplemental Reviewer | [security-reviewer](../../agents/security-reviewer.md) | Security review for credential handling, data access |
| Supplemental Reviewer | [performance-reviewer](../../agents/performance-reviewer.md) | Query performance, pipeline efficiency |
| Validator | [data-quality-engineer](../../agents/data-quality-engineer.md) | Tests at every pipeline lifecycle stage |
| Coordinator | [scrum-master](../../agents/scrum-master.md) | Sprint coordination (complexity-triggered) |
| Implementer | [data-engineer](../../agents/data-engineer.md) | Writes pipeline code against approved spec |
| Architect | [data-architect](../../agents/data-architect.md) | Evaluates pipeline topology, schema design, storage architecture |

---

## Domain-Specific Gates

### Environment Progression Gates

Data engineering work follows a lifecycle-stage model (ingestion ->
storage -> transformation -> serving). Each stage has its own quality
gates:

- **Ingestion:** Source contract compliance, idempotency verification,
  schema evolution handling, backfill procedure documentation
- **Storage:** Layer correctness (raw/staging/transformed/served),
  partition strategy validation, retention policy compliance
- **Transformation:** Business logic correctness (transformation logic
  doc alignment), data quality rule coverage, deduplication handling
- **Serving:** Consumer contract compliance, freshness SLA
  verification, downstream impact assessment

### Layer Ownership Model

Pipeline code is organized by lifecycle stage. Stories touching
multiple stages are multi-domain stories (see story-execution.md).
The data-architect reviews cross-stage interface contracts.

### Security Review

The security-reviewer assesses credential handling, data access
patterns, and DDL/DML safety for production databases.

---

## Testing Approach

- **TDD** — new pipeline stages, new ingestion patterns, new serving
  contracts
- **Test-informed** — modifications to existing pipelines, schema
  changes
- **Test-after** — configuration changes, retry logic adjustments

**Verification method:** Pipeline integration tests + per-stage data
quality checks + output diffing against known-good oracle data.

---

## Story Execution

For all story execution mechanics, follow
`core/workflows/protocols/story-execution.md`.
