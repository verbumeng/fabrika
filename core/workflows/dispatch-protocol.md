# Dispatch Protocol

How the orchestrator hands off work to sub-agents. This document
defines what to provide and what to withhold at each invocation point
in the development workflow.

The core principle: reviewers, validators, and designers receive
strict dispatch (plan + file paths + rubric, nothing else) to
preserve independence. Planners and coordinators receive contextual
dispatch (richer project state) because they are creating plans, not
judging implementations.

For archetype-level tool profiles and base contracts, see
`core/agents/archetypes/`.

---

## Dispatch Tiers

**Strict dispatch** — the orchestrator provides only the approved
plan, file paths, and rubric pointer. No opinions, no hints, no
pre-digested summaries. The sub-agent must form its own judgment.

**Contextual dispatch** — the orchestrator provides broader project
context: conversation history, owner preferences, prior decisions.
The sub-agent uses this context to make better plans, not to confirm
the orchestrator's conclusions.

Both tiers have required fields. The orchestrator must provide every
required field — omitting a required field means the sub-agent is
working blind on something it needs.

---

## Per-Agent Dispatch Contracts

### Product Manager — Planning Mode

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

**Output expected:** Spec document at `docs/plans/[TICKET]-spec.md`

---

### Product Manager — Validation Mode

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

### Experiment Planner — Planning Mode

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

**Output expected:** Experiment spec at `docs/plans/[TICKET]-spec.md`

---

### Experiment Planner — Validation Mode

**Tier:** Strict

Same structure as Product Manager validation mode. Validates
experiment results against the experiment spec's acceptance criteria,
hypothesis outcome, and methodological requirements.

---

### API Designer — Planning Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Story content | Yes | The API change request |
| Sprint contract | Yes | Current sprint contract |
| API Design Guide pointer | Yes | Path to `docs/02-Engineering/API Design Guide.md` |
| Current public API | Conditional | Current exports and type signatures if modifying existing API |
| Owner context | Optional | Compatibility constraints, consumer expectations from conversation |

**Output expected:** API spec at `docs/plans/[TICKET]-spec.md`

---

### API Designer — Validation Mode

**Tier:** Strict

Same structure as Product Manager validation mode. Validates public
API surface matches spec exactly, backward compatibility maintained,
documentation complete.

---

### Analysis Planner

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Analysis request | Yes | The business question or request from the owner |
| Sources pointer | Yes | Path to `sources/README.md` for available data sources |
| Source detail pointers | Conditional | Specific source docs if the request targets known sources |
| Prior task pointers | Conditional | Paths to similar prior tasks if this might be a repeat |
| Templates pointer | Conditional | Path to `templates/` if checking for existing templates |
| Owner context | Optional | Deadline, audience, desired output format from conversation |

**Output expected:** Brief at `tasks/[date-name]/brief.md`, then plan
at `tasks/[date-name]/plan.md` (two-step, owner approves brief before
plan)

---

### Code Reviewer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | Path to the approved implementation spec |
| Sprint contract criteria | Yes | Acceptance criteria for this story |
| Rubric pointer | Yes | Path to `docs/02-Engineering/rubrics/code-review-rubric.md` |
| File paths to review | Yes | Specific paths of changed/added files |
| Features.json pointer | Yes | For feature pass/fail context |

**Do not provide:** Implementation opinions, known concerns, other
reviewers' findings. The code reviewer runs the test suite, runs
semgrep, reads the diff, and forms its own judgment.

**Output expected:** Review report at `docs/evaluations/[TICKET]-code-review.md`

---

### Logic Reviewer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Task brief | Yes | Path to `tasks/[date-name]/brief.md` |
| Task plan | Yes | Path to `tasks/[date-name]/plan.md` |
| Source docs | Yes | Paths to relevant source documentation in `sources/` |
| Work product paths | Yes | Paths to SQL, scripts, notebooks in `tasks/[date-name]/work/` |

**Do not provide:** Opinions on logic correctness, suspected issues,
data quality concerns. The logic reviewer reads the brief, reads the
plan, reads the code, and evaluates independently.

**Output expected:** Review report at `docs/evaluations/[task-name]-logic-review.md`

---

### Prompt Reviewer

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

### Security Reviewer

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

### Performance Reviewer — Sprint-Based

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

### Performance Reviewer — Analytics Workspace

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Task brief | Yes | Path to `tasks/[date-name]/brief.md` |
| Task plan | Yes | Path to `tasks/[date-name]/plan.md` |
| Source docs | Yes | Paths to relevant source documentation |
| Work product paths | Yes | Paths to SQL, scripts in `tasks/[date-name]/work/` |

**Output expected:** Review report at `docs/evaluations/[task-name]-performance-review.md`

---

### Visualization Designer — Design Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Requirements | Yes | Story acceptance criteria or task brief |
| Audience | Yes | Who will consume this visualization |
| Data output | Yes | The data or query results to be visualized |
| Tool docs pointer | Conditional | Path to `sources/tools/` or `docs/03-Design/Dashboard Spec.md` |
| Existing designs | Conditional | Prior versions if this is an iteration |
| Integration targets | Conditional | Existing dashboards or UI components this integrates with |

**Do not provide:** Preferred chart types or layout direction.

**Output expected:** Design spec at `docs/03-Design/[feature]-viz-spec.md` or `tasks/[date-name]/work/viz-spec.md`

---

### Visualization Designer — Review Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Design to review | Yes | The visualization or dashboard to evaluate |
| Original requirements | Yes | The requirements it was built against |
| Design principles | Conditional | Rubric or design guide if one exists |

**Output expected:** Review report at `docs/evaluations/[TICKET]-viz-review.md` or `docs/evaluations/[task-name]-viz-review.md`

---

### Test Writer

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

### Model Evaluator

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

### Eval Engineer

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

### Data Quality Engineer

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

### Data Validator

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Task brief | Yes | Path to `tasks/[date-name]/brief.md` |
| Task plan | Yes | Path to `tasks/[date-name]/plan.md` (includes the validation approach — do not extract it separately) |
| Source docs | Yes | Paths to relevant source documentation |
| Work product paths | Yes | Paths to output files and scripts |

**Output expected:** Validation report at `docs/evaluations/[task-name]-data-validation.md`

---

### Scrum Master — Sprint Planning

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| STATUS.md | Yes | Current project state and cycle phase |
| Previous retro | Yes | Path to the previous sprint's retro file |
| Backlog state | Yes | Paths to stories with `status: To Do` |
| Features.json | Yes | Current pass/fail state |
| Git log | Yes | Recent commit history (last 10-20 commits) |
| Maintenance tag | Yes | When the last maintenance session ran |
| Owner priorities | Optional | Any priorities or constraints from the conversation |
| Unfinished stories | Conditional | Stories from previous sprint that were not completed |

**Output expected:** Sprint file, sprint contract, sprint progress
file, updated story assignments

---

### Scrum Master — Sprint Retro

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Sprint progress file | Yes | Path to `Sprint-XX-progress.md` |
| Sprint contract | Yes | Path to the sprint contract (what was planned) |
| Maintenance findings | Conditional | Summary of maintenance session if one ran this cycle |
| Previous retro | Yes | Path to previous sprint's retro for trend tracking |
| Agent quality notes | Yes | Agent observations from the progress file |

**Output expected:** Retro file at `docs/04-Backlog/Sprints/Sprint-XX-retro.md`, updated STATUS.md

---

### Implementer

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | The plan approved by the owner in Step 2 |
| Architecture pointers | Yes | Paths to system architecture docs, catalogs, workflow files — whatever the plan references |
| Version state | Yes | Current VERSION and CHANGELOG — needed for version bumps |
| File paths to modify | Yes | Existing files the plan says to change |
| Owner constraints | Optional | Preferences or constraints from the conversation |

**Do not provide:** Raw evaluation reports from prior verification
rounds. If retrying after a failed review, the orchestrator
summarizes what needs to be fixed — the implementer does not read
verifier reports directly.

**Output expected:** Changed files on the feature branch, plus a
summary of what was done and any implementation decisions that
interpreted or deviated from the plan.

---

### Workflow Planner — Planning Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Change request | Yes | The PRD, issue, or conversation context describing what needs to change |
| Current file state | Yes | Paths to files that will be affected, so the planner can read their current state |
| Integration point map | Yes | The project's known cross-reference chains (from the project instruction file) |
| Version state | Yes | Current VERSION and latest CHANGELOG entry — needed for bump determination |
| Owner context | Optional | Constraints, preferences, or prior decisions from the conversation |

**Output expected:** Structured implementation plan in the
conversation covering: file change inventory, integration point
analysis, risk identification, mitigations, and version bump
determination.

---

### Context Engineer

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | The plan approved by the owner — the implementation contract |
| Architecture pointers | Yes | Paths to catalogs, workflow files, integration templates, and other structural reference docs |
| Version state | Yes | Current VERSION and CHANGELOG — needed for version bumps and changelog entries |
| File paths to modify | Yes | Existing files the plan says to change |
| Project constraints | Yes | Versioning discipline, smell tests, context decomposition rules from the project instruction file |
| Owner constraints | Optional | Preferences or constraints from the conversation |

**Do not provide:** Raw evaluation reports from prior verification
rounds. If retrying after a failed review, the orchestrator summarizes
what needs to be fixed — the context engineer does not read verifier
reports directly.

**Output expected:** Changed files on the feature branch, VERSION
bump, CHANGELOG entry, MIGRATIONS entry if applicable, plus a summary
of what was done and any implementation decisions that deviated from
the plan.

---

### Methodology Reviewer

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | The system update plan (what was intended) |
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

---

### Structural Validator

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | The system update plan |
| File paths | Yes | Every file created or changed |
| CHANGELOG entry | Yes | The version entry |
| Verification checklist | Yes | The structural verification checklist |

**Do not provide:** Opinions, suspected issues, implementation
commentary.

**Output expected:** Verification report at evaluation path.
Verdict: PASS / FAIL. Per-check results with specific evidence for
each checklist item.

---

### Context Architect

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | The system update plan |
| File paths | Yes | Every file created or changed |
| Structural reference pointers | Yes | Paths to catalogs, workflow files, integration templates — the system's structural reference docs |

**Do not provide:** Opinions about change quality, reviewer or
validator findings, suggested structural improvements.

**Output expected:** Architectural assessment at evaluation path.
Verdict: SOUND / CONCERNS / UNSOUND. Findings covering: instruction
decomposition, pointer patterns, context budget (always-loaded vs.
on-demand), pattern consistency, integration surface completeness.

---

## Retry Protocol

When a reviewer or validator FAILs an implementation and the
orchestrator fixes the issues, the sub-agent is re-invoked. On retry:

1. The orchestrator provides the same dispatch payload as the original
   invocation — same spec, same rubric, same file paths (updated to
   reflect fixes)
2. The orchestrator does NOT include the prior evaluation report in
   the dispatch — the sub-agent reviews fresh
3. The sub-agent writes its new report with a versioned filename:
   `[TICKET]-code-review-v2.md` (not overwriting the original)
4. Maximum 2 retry cycles. After 2 failures, the orchestrator stops
   and presents all reports to the owner.
