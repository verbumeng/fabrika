# Reviewer Dispatch Contracts

Per-agent dispatch contracts for all reviewer agents. For dispatch
tiers, tier-conditional dispatch, lightweight dispatch, retry protocol,
and output format constraints, see the dispatch protocol hub at
`core/workflows/protocols/dispatch-protocol.md`.

---

## Code Reviewer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | Path to the approved implementation spec |
| Sprint contract criteria | Yes | Acceptance criteria for this story |
| Rubric pointer | Yes | Path to `docs/02-Engineering/rubrics/code-review-rubric.md` |
| File paths to review | Yes | Specific paths of changed/added files |
| Features.json pointer | Yes | For feature pass/fail context |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — for Terminology Consistency criterion |

**Do not provide:** Implementation opinions, known concerns, other
reviewers' findings. The code reviewer runs the test suite, runs
semgrep, reads the diff, and forms its own judgment.

**Output expected:** Review report at `docs/evaluations/[TICKET]-code-review.md`

---

## Logic Reviewer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Task brief | Yes | Path to `tasks/[date-name]/brief.md` |
| Task plan | Yes | Path to `tasks/[date-name]/plan.md` |
| Source docs | Yes | Paths to relevant source documentation in `sources/` |
| Work product paths | Yes | Paths to SQL, scripts, notebooks in `tasks/[date-name]/work/` |
| Data dictionary pointers | Conditional | Paths to data dictionary entries for tables being queried — required when data dictionaries exist for the task's sources |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — for term usage checking |

**Do not provide:** Opinions on logic correctness, suspected issues,
data quality concerns. The logic reviewer reads the brief, reads the
plan, reads the code, and evaluates independently.

**Pre-execution context:** In the analytics workflow's tiered workflow,
the logic reviewer may be invoked before execution — no output data
is available. The review is on the code itself, not on results.

**Output expected:** Review report at `docs/evaluations/[task-name]-logic-review.md`

---

## Prompt Reviewer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec for the prompt changes |
| Prompt Library pointer | Yes | Path to `docs/02-Engineering/Prompt Library.md` |
| Model Config pointer | Yes | Path to `docs/02-Engineering/Model Configuration.md` |
| Guardrails pointer | Conditional | Path to `docs/02-Engineering/Guardrails Spec.md` if it exists |
| Changed prompt files | Yes | Specific paths of prompt files that changed |

**Output expected:** Review report at `docs/evaluations/[TICKET]-prompt-review.md`

---

## Security Reviewer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec for the feature being reviewed |
| Sprint contract criteria | Yes | Acceptance criteria |
| Architecture pointer | Yes | Path to `docs/02-Engineering/Architecture Overview.md` |
| Security doc pointer | Conditional | Path to `docs/02-Engineering/Security & Privacy.md` if it exists |
| Threat model pointer | Conditional | Path to existing threat model if one exists |
| File paths to review | Yes | Specific paths of changed/added files |

**Do not provide:** Suspected vulnerabilities, security concerns from
other reviewers. The security reviewer runs its own scans and forms
its own assessment.

**Output expected:** Review report at `docs/evaluations/[TICKET]-security-review.md`

---

## Performance Reviewer — Domain Workflow Context

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec for the feature being reviewed |
| Sprint contract criteria | Yes | Acceptance criteria |
| Architecture pointer | Yes | Path to Architecture Overview |
| Cost model pointer | Conditional | Path to Cost Model if it exists |
| File paths to review | Yes | Specific paths of changed/added files |

**Output expected:** Review report at `docs/evaluations/[TICKET]-performance-review.md`

---

## Performance Reviewer — Analytics Workflow

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Task brief | Yes | Path to `tasks/[date-name]/brief.md` |
| Task plan | Yes | Path to `tasks/[date-name]/plan.md` |
| Source docs | Yes | Paths to relevant source documentation |
| Work product paths | Yes | Paths to SQL, scripts in `tasks/[date-name]/work/` |
| Execution manifest | Yes | Path to `tasks/[date-name]/work/execution-manifest.md` — INFORMATION_SCHEMA results, EXPLAIN plan output, cost estimates |

**Pre-execution context:** In the analytics workflow Tier 2 workflow,
the performance reviewer is invoked before main query execution. The
review is on the execution manifest (metadata query results), not on
output data.

**Platform-specific assessment guidance:**
- **Cloud platforms:** Assess estimated bytes scanned, cost per query,
  recurring cost projections, scan optimization opportunities, DDL/DML
  risk re-confirmation.
- **On-prem platforms:** Assess query complexity, server resource
  consumption, lock risk, unbounded queries, index usage, DDL/DML risk
  re-confirmation. No dollar cost — assess impact on shared
  infrastructure.

**Output expected:** Review report at `docs/evaluations/[task-name]-performance-review.md`

---

## Reviewer (Base)

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | Path to the approved plan at `tasks/[date-name]/plan.md` |
| Brief | Yes | Path to the task brief at `tasks/[date-name]/brief.md` |
| Work product paths | Yes | Paths to deliverable files in `tasks/[date-name]/work/` |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — for terminology consistency check |

**Do not provide:** Opinions about the deliverables, suspected issues,
the implementer's notes on what went well or poorly. The reviewer must
read the deliverables, build its checklist from the plan, and form its
own judgment.

**Output expected:** Review report at
`docs/evaluations/[task-name]-review.md`

---

## Methodology Reviewer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | Path to the plan file at `docs/plans/[identifier]-plan.md` |
| File paths | Yes | Every file created or changed |
| CHANGELOG entry | Yes | The version entry describing the changes |
| Verification checklist | Yes | The project's verification checklist from its instruction file |

**Do not provide:** Opinions about the changes, suspected issues,
implementer notes on what went well or poorly.

**Output expected:** Review report at evaluation path. Verdict:
PASS / PASS WITH NOTES / FAIL. Per-criterion findings against:
cross-reference consistency, prompt pattern adherence, instruction
decomposition quality, smell test compliance, consumer update
completeness, dispatch/output contract consistency.
