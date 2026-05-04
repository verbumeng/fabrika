# Validator Dispatch Contracts

Per-agent dispatch contracts for all validator agents. For dispatch
tiers, tier-conditional dispatch, lightweight dispatch, retry protocol,
and output format constraints, see the dispatch protocol hub at
`core/workflows/protocols/dispatch-protocol.md`.

---

## Test Writer — Spec-First Mode (TDD Stories)

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec defining expected behavior — this is the ONLY source of truth (no code exists yet) |
| Sprint contract criteria | Yes | Acceptance criteria for this story |
| Rubric pointer | Yes | Path to `docs/02-Engineering/rubrics/test-rubric.md` |
| Test conventions | Yes | Test runner, commands, coverage targets, fixture patterns (from project instructions) |
| Existing test files | Yes | Paths to existing tests so the validator avoids duplication |
| Structural constraints | Conditional | Path to `docs/02-Engineering/Structural-Constraints.md` if it exists |

**Do not provide:** Source paths (code does not exist yet), hints
about implementation approach, suggested test cases. The test writer
designs its own tests from the spec.

**Output expected:** Test file(s) in `tests/`, concise summary of
what behavior each test verifies.

---

## Test Writer — Coverage Mode (Test-Informed and Test-After Stories)

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec defining expected behavior |
| Sprint contract criteria | Yes | Acceptance criteria |
| Rubric pointer | Yes | Path to `docs/02-Engineering/rubrics/test-rubric.md` |
| Source paths | Yes | Paths to the source code to verify |
| Test conventions | Yes | Test runner, commands, coverage targets, fixture patterns (from project instructions) |
| Existing test files | Yes | Paths to existing tests so the validator can avoid duplication (the validator discovers these during its process but providing paths up front saves search time) |
| Structural constraints | Conditional | Path to `docs/02-Engineering/Structural-Constraints.md` if it exists |

**Do not provide:** Hints about what to test, suspected bugs, known
edge cases. The test writer designs its own verification strategy from
the spec and the source code.

**Output expected:** Test files in `tests/`, evaluation report at `docs/evaluations/[TICKET]-test-review.md`

---

## Model Evaluator

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The experiment or feature spec |
| Sprint contract criteria | Yes | Acceptance criteria |
| Rubric pointer | Yes | Path to test rubric |
| Evaluation Criteria pointer | Yes | Path to `docs/02-Engineering/Model Evaluation Criteria.md` |
| Training Data pointer | Yes | Path to `docs/02-Engineering/Training Data Spec.md` |
| Source paths | Yes | Paths to model code and evaluation scripts |

**Output expected:** Eval report at `docs/evaluations/[TICKET]-test-review.md`

---

## Eval Engineer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec for the AI feature |
| Sprint contract criteria | Yes | Acceptance criteria |
| Rubric pointer | Yes | Path to test rubric |
| Evaluation Strategy pointer | Yes | Path to `docs/02-Engineering/Evaluation Strategy.md` |
| Prompt Library pointer | Yes | Path to `docs/02-Engineering/Prompt Library.md` |
| Guardrails pointer | Conditional | Path to Guardrails Spec if it exists |
| Source paths | Yes | Paths to source code and prompts |

**Output expected:** Eval report at `docs/evaluations/[TICKET]-test-review.md`

---

## Data Quality Engineer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec for the pipeline feature |
| Sprint contract criteria | Yes | Acceptance criteria |
| Rubric pointer | Yes | Path to test rubric |
| Pipeline Design pointer | Yes | Path to `docs/02-Engineering/Data Pipeline Design.md` |
| Source Contracts pointer | Yes | Path to `docs/02-Engineering/Source System Contracts.md` |
| Serving Contracts pointer | Yes | Path to `docs/02-Engineering/Serving Contracts.md` |
| Source paths | Yes | Paths to pipeline code |

**Output expected:** Test report at `docs/evaluations/[TICKET]-test-review.md`

---

## Data Validator

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Task document | Yes | Path to `tasks/[date-name]/task.md` |
| Task plan | Yes | Path to `tasks/[date-name]/plan.md` (includes the validation approach — do not extract it separately) |
| Source docs | Yes | Paths to relevant source documentation |
| Work product paths | Yes | Paths to output files and scripts |
| Data dictionary pointers | Conditional | Paths to data dictionary entries for tables being validated — required when data dictionaries exist for the task's sources |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — for term consistency in the validation report |

**Output expected:**
1. Internal evaluation report at `docs/evaluations/[task-name]-data-validation.md` — verdict, findings, validation queries (for the review loop)
2. Human-facing validation report at `tasks/[date-name]/validation-report.md` — evidence chain tracing key claims back to code and data (for the stakeholder)

---

## Validator (Base)

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Task document | Yes | Path to `tasks/[date-name]/task.md` |
| Approved plan | Yes | Path to `tasks/[date-name]/plan.md` |
| Work product paths | Yes | Paths to deliverable files in `tasks/[date-name]/work/` |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — for term consistency check |

**Do not provide:** Reviewer findings, opinions about deliverable
quality, suspected issues. The validator evaluates independently
against the task document and plan.

**Output expected:**
1. Internal evaluation at `docs/evaluations/[task-name]-validation.md`
2. Human-facing validation report at
   `tasks/[date-name]/validation-report.md`

---

## Structural Validator

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | Path to the plan file at `docs/plans/[identifier]-plan.md` |
| File paths | Yes | Every file created or changed |
| CHANGELOG entry | Yes | The version entry |
| Verification checklist | Yes | The structural verification checklist |

**Do not provide:** Opinions, suspected issues, implementation
commentary.

**Output expected:** Verification report at evaluation path.
Verdict: PASS / FAIL. Per-check results with specific evidence for
each checklist item.
