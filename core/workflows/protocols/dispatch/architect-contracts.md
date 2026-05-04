# Architect Dispatch Contracts

Per-agent dispatch contracts for all architect agents. For dispatch
tiers, tier-conditional dispatch, lightweight dispatch, retry protocol,
and output format constraints, see the dispatch protocol hub at
`core/workflows/protocols/dispatch-protocol.md`.

---

## Software Architect — Design Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Design question or PRD module section | Yes | What the architect should evaluate — either the owner's specific question or the spec's module/architecture section |
| Architecture pointer | Yes | Path to Architecture Overview |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists |
| Codebase structure | Yes | Top-level directory listing or module map — enough for the architect to understand current boundaries |
| Owner constraints | Optional | Preferences, concerns, or constraints from the conversation |

**Output expected:** Interface proposal or design assessment at `docs/evaluations/[identifier]-architecture-design.md`

---

## Software Architect — Review Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec that was approved before implementation |
| File paths to review | Yes | Specific paths of changed/added files |
| Architecture pointer | Yes | Path to Architecture Overview |

**Do not provide:** Opinions on implementation quality, code-reviewer
findings, suspected issues. The architect evaluates structural design
independently.

**Output expected:** Assessment report at `docs/evaluations/[TICKET]-architecture-review.md`

---

## Software Architect — Ad Hoc

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Target scope | Yes | Module, directory, or codebase area to assess |
| Architecture pointer | Yes | Path to Architecture Overview |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists |
| Owner concern | Optional | Specific concern motivating the assessment |

**Output expected:** Assessment report at `docs/evaluations/[identifier]-architecture-assessment.md`

---

## Data Architect — Design Mode

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Design question or PRD module section | Yes | What the architect should evaluate — either the owner's specific question or the spec's module/architecture section |
| Architecture pointer | Yes | Path to Architecture Overview |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists |
| Data Model pointer | Conditional | Required if the scope touches schema design |
| Pipeline Design pointer | Conditional | Required if the scope touches pipeline code |
| Source Contracts pointer | Conditional | Required if the scope touches ingestion |
| Serving Contracts pointer | Conditional | Required if the scope touches serving layer |
| Owner constraints | Optional | Preferences, concerns, or constraints from the conversation |

**Output expected:** Interface proposal or design assessment at `docs/evaluations/[identifier]-architecture-design.md`

---

## Data Architect — Review Mode

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved spec | Yes | The spec that was approved before implementation |
| File paths to review | Yes | Specific paths of changed/added files |
| Architecture pointer | Yes | Path to Architecture Overview |
| Data Model pointer | Conditional | Required if the implementation touches schema design |
| Pipeline Design pointer | Conditional | Required if the implementation touches pipeline code |

**Do not provide:** Opinions on implementation quality, code-reviewer
findings, suspected issues. The architect evaluates structural design
independently.

**Output expected:** Assessment report at `docs/evaluations/[TICKET]-architecture-review.md`

---

## Data Architect — Ad Hoc

**Tier:** Contextual

| Field | Required | Description |
|-------|----------|-------------|
| Target scope | Yes | Pipeline, schema, or data layer area to assess |
| Architecture pointer | Yes | Path to Architecture Overview |
| Domain Language pointer | Conditional | Path to Domain Language doc if it exists |
| Data Model pointer | Conditional | Required if assessing schema design |
| Pipeline Design pointer | Conditional | Required if assessing pipeline topology |
| Owner concern | Optional | Specific concern motivating the assessment |

**Output expected:** Assessment report at `docs/evaluations/[identifier]-architecture-assessment.md`

---

## Context Architect

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | Path to the plan file at `docs/plans/[identifier]-plan.md` |
| File paths | Yes | Every file created or changed |
| Structural reference pointers | Yes | Paths to catalogs, workflow files, integration templates — the system's structural reference docs |

**Do not provide:** Opinions about change quality, reviewer or
validator findings, suggested structural improvements.

**Output expected:** Architectural assessment at evaluation path.
Verdict: SOUND / CONCERNS / UNSOUND. Findings covering: instruction
decomposition, pointer patterns, context budget (always-loaded vs.
on-demand), pattern consistency, integration surface completeness.
