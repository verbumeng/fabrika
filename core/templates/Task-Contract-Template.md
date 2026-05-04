---
type: task-contract
task: [YYYY-MM-DD-short-name]
status: active
---

# Task Contract: [Short descriptive title]

> This contract defines the scope, approach, and acceptance criteria for an analytics workflow task. It is the lightweight equivalent of a sprint contract — scoped to a single task rather than a sprint of stories.

## Task Summary
- **Task document:** `tasks/[date-name]/task.md`
- **Plan:** `tasks/[date-name]/plan.md`
- **Owner approved plan:** [Yes / Pending]

## Acceptance Criteria
[What does "done" look like? Pull from the task document and plan.]
- [ ] [e.g., "Variance between Finance report and warehouse total is explained with specific drivers"]
- [ ] [e.g., "Output CSV delivered to shared drive at [path]"]
- [ ] [e.g., "Logic reviewer has verified join and aggregation logic"]
- [ ] [e.g., "Data validator has confirmed row counts and cross-references"]
- [ ] [e.g., "Outcome report written with methodology and data quality notes"]

## Validation Requirements
[What level of validation does this task need?]
- **Logic review:** [Required / Optional — based on complexity]
- **Data validation intensity:** [High / Medium / Low — based on stakes from the task document]
- **Cross-reference benchmarks:** [What known-good numbers to check against]

## Scope Boundaries
[What this task does NOT include, to prevent scope creep.]
- [e.g., "This analysis covers Q1 only — Q2 is a separate task"]
- [e.g., "We explain the variance but don't fix the underlying process"]
- [e.g., "SQL only — Tableau workbook updates are out of scope for this task"]

## Deliverables
| Deliverable | Format | Destination |
|-------------|--------|-------------|
| [e.g., Variance analysis] | [CSV] | [shared drive path] |
| [e.g., Executive summary] | [Email body text] | [stakeholder@company.com] |
| [e.g., Reusable query] | [SQL file] | [`src/queries/revenue-variance.sql`] |
