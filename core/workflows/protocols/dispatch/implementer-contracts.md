# Implementer Dispatch Contracts

Per-agent dispatch contracts for all implementer agents. For dispatch
tiers, tier-conditional dispatch, lightweight dispatch, retry protocol,
and output format constraints, see the dispatch protocol hub at
`core/workflows/protocols/dispatch-protocol.md`.

Five specialist implementers cover all domain workflow and analytics
workflow project types. Each inherits the base dispatch contract from
the Implementer archetype and adds domain-specific conditional fields.
The output contract is shared across all specialists.

For the agentic-workflow implementer (agentic-engineer), see the
Agentic Engineer contract below — it has its own dispatch contract
tailored to methodology work.

---

## Software Engineer

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec from the planner, approved by the owner |
| Architecture pointer | Yes | Path to Architecture Overview |
| File paths to modify | Yes | Existing files the spec says to change |
| Test conventions | Yes | Test runner, commands, coverage targets from project instructions |
| Owner constraints | Optional | Preferences or constraints from the conversation |
| API Design Guide pointer | Conditional | Required for library projects — path to API Design Guide |
| Structural Constraints pointer | Conditional | Path to Structural Constraints doc if it exists |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — implementer uses its terms for naming and populates code-level names for newly implemented concepts |
| Tests to pass | Conditional | Paths to failing tests the implementer must make pass — required for TDD stories, omitted for test-informed and test-after. The implementer writes the minimum code necessary to make these specific tests pass, not the full spec implementation. This enforces vertical slice discipline in TDD. |
| Review report paths | Conditional | Paths to evaluation reports from the current review cycle — required when dispatching for revision after a failed review. The implementer reads these directly alongside the original plan. |

**Output expected:** Changed files, implementation summary, spec
deviations flagged.

---

## Data Engineer

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec from the planner, approved by the owner |
| Architecture pointer | Yes | Path to Architecture Overview |
| File paths to modify | Yes | Existing files the spec says to change |
| Test conventions | Yes | Test runner, commands from project instructions |
| Owner constraints | Optional | Preferences or constraints from the conversation |
| Pipeline Design pointer | Conditional | Required if touching pipeline code — path to Data Pipeline Design |
| Source Contracts pointer | Conditional | Required if touching ingestion — path to Source System Contracts |
| Serving Contracts pointer | Conditional | Required if touching serving layer — path to Serving Contracts |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — implementer uses its terms for naming and populates code-level names for newly implemented concepts |
| Tests to pass | Conditional | Paths to failing tests the implementer must make pass ��� required for TDD stories. The implementer writes the minimum code necessary to make these specific tests pass. |
| Review report paths | Conditional | Paths to evaluation reports from the current review cycle — required when dispatching for revision after a failed review. The implementer reads these directly alongside the original plan. |

**Output expected:** Changed files, implementation summary, spec
deviations flagged.

---

## Data Analyst

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec or task plan from the planner |
| Source registry pointer | Yes | Path to sources/README.md |
| Work directory | Yes | Path to the task directory (for analytics workflow) or target directories |
| Source detail pointers | Conditional | Specific source docs if the work targets known sources |
| Owner constraints | Optional | Preferences or constraints from the conversation |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists �� implementer uses its terms for naming and populates code-level names for newly implemented concepts |
| Tests to pass | Conditional | Paths to failing tests the implementer must make pass — required for TDD stories in data-app projects. Not applicable to analytics workflow tasks (no sprint lifecycle). The implementer writes the minimum code necessary to make these specific tests pass. |
| Review report paths | Conditional | Paths to evaluation reports from the current review cycle — required when dispatching for revision after a failed review. The implementer reads these directly alongside the original plan. |

**Output expected:** Changed files, implementation summary, spec
deviations flagged.

---

### Data Analyst — Write-Only Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | The task plan approved by the owner |
| Source registry pointer | Yes | Path to `sources/README.md` |
| Work directory | Yes | Path to the task directory |
| Data environment classification | Yes | Local or production, with platform list if production |
| Source detail pointers | Conditional | Specific source docs if the work targets known sources |
| Data dictionary pointers | Conditional | Paths to data dictionary entries for tables being queried |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists |
| Owner constraints | Optional | Preferences or constraints from the conversation |

**Output expected:** Code files in `tasks/[date-name]/work/` plus
metadata queries (Tier 2). Do not execute.

---

### Data Analyst — Execute-Metadata Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | The task plan approved by the owner |
| Work product paths | Yes | Paths to logic-reviewed metadata queries |
| Source registry pointer | Yes | Path to `sources/README.md` |
| Work directory | Yes | Path to the task directory |

**Output expected:** Execution manifest at
`tasks/[date-name]/work/execution-manifest.md`

---

## ML Engineer

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The experiment or feature spec |
| Architecture pointer | Yes | Path to Architecture Overview |
| File paths to modify | Yes | Existing files the spec says to change |
| Test conventions | Yes | Test runner, commands from project instructions |
| Owner constraints | Optional | Preferences or constraints from the conversation |
| Model Design pointer | Conditional | Required if touching model architecture — path to Model Design |
| Training Data pointer | Conditional | Required if touching training pipeline — path to Training Data Spec |
| Evaluation Criteria pointer | Conditional | Required if touching evaluation — path to Model Evaluation Criteria |
| Prior experiments | Conditional | Paths to prior experiment reports if this is an iteration |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — implementer uses its terms for naming and populates code-level names for newly implemented concepts |
| Tests to pass | Conditional | Paths to failing tests the implementer must make pass — required for TDD stories. The implementer writes the minimum code necessary to make these specific tests pass. |
| Review report paths | Conditional | Paths to evaluation reports from the current review cycle — required when dispatching for revision after a failed review. The implementer reads these directly alongside the original plan. |

**Output expected:** Changed files, implementation summary, spec
deviations flagged. Include compute resource estimates if applicable.

---

## AI Engineer

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec from the planner, approved by the owner |
| Architecture pointer | Yes | Path to Architecture Overview |
| File paths to modify | Yes | Existing files the spec says to change |
| Test conventions | Yes | Test runner, commands from project instructions |
| Owner constraints | Optional | Preferences or constraints from the conversation |
| Prompt Library pointer | Conditional | Required if touching prompts — path to Prompt Library |
| Model Configuration pointer | Conditional | Required if changing model routing — path to Model Configuration |
| Guardrails pointer | Conditional | Required if touching safety — path to Guardrails Spec |
| Evaluation Strategy pointer | Conditional | Required if touching eval — path to Evaluation Strategy |
| RAG Architecture pointer | Conditional | Required if touching retrieval — path to RAG Architecture |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — implementer uses its terms for naming and populates code-level names for newly implemented concepts |
| Tests to pass | Conditional | Paths to failing tests the implementer must make pass — required for TDD stories. The implementer writes the minimum code necessary to make these specific tests pass. |
| Review report paths | Conditional | Paths to evaluation reports from the current review cycle — required when dispatching for revision after a failed review. The implementer reads these directly alongside the original plan. |

**Output expected:** Changed files, implementation summary, spec
deviations flagged. Include token usage impact estimates if applicable.

---

## Implementer (Base)

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | Path to the approved plan at `tasks/[date-name]/plan.md` |
| Task document | Yes | Path to the task document at `tasks/[date-name]/task.md` |
| Work directory | Yes | Path to the task directory where deliverables are written |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists — implementer uses its terms in deliverables |
| Owner constraints | Optional | Preferences or constraints from the conversation |
| Review report paths | Conditional | Paths to evaluation reports from the current review cycle — required when dispatching for revision after a failed review. The implementer reads these directly alongside the original plan. |

**Output expected:** Deliverable files in `tasks/[date-name]/work/`,
implementation summary with acceptance criteria coverage and any
deviations.

---

## Agentic Engineer

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | Path to the approved plan file at `docs/plans/[identifier]-plan.md` |
| Architecture pointers | Yes | Paths to catalogs, workflow files, integration templates, and other structural reference docs |
| Version state | Yes | Current VERSION and CHANGELOG — needed for version bumps and changelog entries |
| File paths to modify | Yes | Existing files the plan says to change |
| Project constraints | Yes | Versioning discipline, smell tests, context decomposition rules from the project instruction file |
| Owner constraints | Optional | Preferences or constraints from the conversation |
| Review report paths | Conditional | Paths to verification reports from the current review cycle — required when dispatching for revision after a failed verification. The agentic engineer reads these directly alongside the original plan. |

**Output expected:** Changed files on the feature branch, VERSION
bump, CHANGELOG entry, MIGRATIONS entry if applicable, plus a summary
of what was done and any implementation decisions that deviated from
the plan.
