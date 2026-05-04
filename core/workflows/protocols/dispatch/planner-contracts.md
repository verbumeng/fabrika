# Planner Dispatch Contracts

Per-agent dispatch contracts for all planner agents. For dispatch
tiers, tier-conditional dispatch, lightweight dispatch, retry protocol,
and output format constraints, see the dispatch protocol hub at
`core/workflows/protocols/dispatch-protocol.md`.

---

## Product Manager — Planning Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Story content | Yes | The story file or ticket text — the request to be planned |
| Sprint contract | Yes | Current sprint contract with topology, acceptance criteria, token budgets |
| Architecture pointer | Yes | Path to `docs/02-Engineering/Architecture Overview.md` |
| Data model pointer | Conditional | Path to Data Model doc — required if story touches data |
| ADR pointers | Conditional | Paths to relevant ADRs — required if story relates to a prior decision |
| Research pointers | Conditional | Paths to research notes — required if story involves investigated tech |
| Owner context | Optional | Relevant preferences or constraints from the conversation |
| Phase definition | Yes | Path to `docs/01-Product/Phase Definitions.md` — so the planner respects phase boundaries |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — planner uses its terms in specs |

**Output expected:** Spec document at `docs/plans/[TICKET]-spec.md`

---

## Product Manager — Validation Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | Path to the spec that was approved before implementation |
| Sprint contract criteria | Yes | The acceptance criteria from the sprint contract for this story |
| Implementation paths | Yes | Specific file paths of the implementation to validate |

**Do not provide:** Opinions on implementation quality, known issues,
reviewer findings. The planner validates independently against the
spec.

**Output expected:** Verdict report at `docs/evaluations/[TICKET]-product-review.md`

---

## Experiment Planner — Planning Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Story content | Yes | The experiment request |
| Sprint contract | Yes | Current sprint contract |
| Model Design pointer | Yes | Path to `docs/02-Engineering/Model Design.md` |
| Evaluation Criteria pointer | Yes | Path to `docs/02-Engineering/Model Evaluation Criteria.md` |
| Training Data pointer | Conditional | Required if experiment changes training data |
| Prior experiment results | Conditional | Paths to prior experiment reports if this is an iteration |
| Owner context | Optional | Hypothesis preferences, resource constraints from conversation |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — planner uses its terms in specs |

**Output expected:** Experiment spec at `docs/plans/[TICKET]-spec.md`

---

## Experiment Planner — Validation Mode

**Tier:** Strict

Same structure as Product Manager validation mode. Validates
experiment results against the experiment spec's acceptance criteria,
hypothesis outcome, and methodological requirements.

---

## API Designer — Planning Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Story content | Yes | The API change request |
| Sprint contract | Yes | Current sprint contract |
| API Design Guide pointer | Yes | Path to `docs/02-Engineering/API Design Guide.md` |
| Current public API | Conditional | Current exports and type signatures if modifying existing API |
| Owner context | Optional | Compatibility constraints, consumer expectations from conversation |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — planner uses its terms in specs |

**Output expected:** API spec at `docs/plans/[TICKET]-spec.md`

---

## API Designer — Validation Mode

**Tier:** Strict

Same structure as Product Manager validation mode. Validates public
API surface matches spec exactly, backward compatibility maintained,
documentation complete.

---

## Analysis Planner

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Analysis request | Yes | The business question or request from the owner |
| Sources pointer | Yes | Path to `sources/README.md` for available data sources |
| Source detail pointers | Conditional | Specific source docs if the request targets known sources |
| Prior task pointers | Conditional | Paths to similar prior tasks if this might be a repeat |
| Templates pointer | Conditional | Path to `templates/` if checking for existing templates |
| Owner context | Optional | Deadline, audience, desired output format from conversation |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — planner uses its terms in specs |

**Output expected:** Brief at `tasks/[date-name]/brief.md`, then plan
at `tasks/[date-name]/plan.md` (two-step, owner approves brief before
plan)

---

## Analysis Planner — Validation Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Task brief | Yes | Path to `tasks/[date-name]/brief.md` — the business question, stakeholder, desired output format |
| Task plan | Yes | Path to `tasks/[date-name]/plan.md` — the approach that was approved |
| Task outcome | Yes | Path to `tasks/[date-name]/outcome.md` — the results produced |
| Work product paths | Yes | Paths to output files in `tasks/[date-name]/work/` — for format and completeness assessment |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — for terminology consistency check |

**Do not provide:** Data validation results, logic review findings,
performance review results, opinions on data quality. The analysis
planner validates independently against the brief's requirements.

**Output expected:** Validation report at
`docs/evaluations/[task-name]-brief-check.md`

Review checklist:
1. **Question answered** — does the outcome directly answer the
   business question stated in the brief?
2. **Completeness** — does the output cover all sub-questions or
   dimensions the brief specified?
3. **Format match** — is the output in the format the stakeholder
   requested?
4. **Audience appropriateness** — is the output at the right level
   of detail for the stated stakeholder?
5. **Terminology consistency** — do terms in the output match Domain
   Language definitions?
6. **Assumptions surfaced** — are the assumptions from the plan
   visible in the outcome?
7. **Caveats documented** — are data quality limitations, known gaps,
   or confidence levels stated?

Verdict: MEETS BRIEF / PARTIALLY MEETS BRIEF / DOES NOT MEET BRIEF.
If not MEETS BRIEF, the orchestrator routes findings to the data
analyst for revision. Standard review-revise loop applies.

---

## Planner (Base) — Planning Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Brief | Yes | Path to the task brief at `tasks/[date-name]/brief.md`, or brief content if not yet written to a file |
| Prior task pointers | Conditional | Paths to similar prior tasks if this might build on previous work |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — planner uses its terms in the plan |
| Owner context | Optional | Constraints, preferences, or prior decisions from the conversation |
| Existing plan path | Conditional | Path to existing plan file — required when re-invoked for revision after owner feedback |

**Output expected:** Plan at `tasks/[date-name]/plan.md` covering
deliverables, acceptance criteria, sequencing, constraints, and
validation approach.

---

## Planner (Base) — Validation Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Brief | Yes | Path to `tasks/[date-name]/brief.md` — the original ask |
| Approved plan | Yes | Path to `tasks/[date-name]/plan.md` — the approach that was approved |
| Outcome | Yes | Path to `tasks/[date-name]/outcome.md` — the results produced |
| Work product paths | Yes | Paths to deliverable files in `tasks/[date-name]/work/` |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — for terminology consistency check |

**Do not provide:** Reviewer findings, validator findings, opinions on
deliverable quality. The planner validates independently against the
brief's requirements.

**Output expected:** Validation report at
`docs/evaluations/[task-name]-brief-check.md`

---

## Workflow Planner — Planning Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Change request | Yes | The change request (CR, PRD, issue, or conversation context) describing what needs to change |
| Current file state | Yes | Paths to files that will be affected, so the planner can read their current state |
| Integration point map | Yes | The project's known cross-reference chains (from the project instruction file) |
| Version state | Yes | Current VERSION and latest CHANGELOG entry — needed for bump determination |
| Owner context | Optional | Constraints, preferences, or prior decisions from the conversation |
| Existing plan path | Conditional | Path to existing plan file — required when re-invoked for revision after owner feedback |

**Output expected:** Plan file at
`docs/plans/[identifier]-plan.md` covering: file change inventory,
integration point analysis, risk identification, mitigations, and
version bump determination.

---

## Planner Dispatch — Research Document Field

For Deep Story tier, the planner planning mode dispatch contract gains
one additional conditional field:

| Field | Required | Description |
|-------|----------|-------------|
| Research document | Conditional | Path to `docs/plans/[TICKET]-research.md` — required for Deep Story tier. Contains compressed findings from the research phase. |
