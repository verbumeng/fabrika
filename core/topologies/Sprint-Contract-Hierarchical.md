---
type: sprint-contract
sprint: Sprint-XX
topology: hierarchical
created: YYYY-MM-DD
---

# Sprint XX Contract — Hierarchical

## Overview
- **Topology:** Hierarchical (tightly coupled tasks, sequenced with dependency graph)
- **Stories:** [X] stories, [Y] total points
- **Sprint dates:** YYYY-MM-DD to YYYY-MM-DD

## Dependency Graph

```
[TICKET-1] ([Title]) → [TICKET-2] ([Title]) → [TICKET-3] ([Title])
```

Execution order is left-to-right. Each ticket must be completed and its evaluators must pass before the next ticket begins.

## Shared Interfaces

Define all interfaces shared between tickets. All agents reference these definitions.

```
[InterfaceName] {
  [field]: [type] — [description]
  [field]: [type] — [description]
}
```

**Contract rule:** If an upstream ticket changes a shared interface, all downstream tickets must be reviewed before work continues.

---

## [TICKET-1]: [Title] (Upstream — no dependencies)

### Testing Approach
- **Testing approach:** [TDD | Test-informed | Test-after]

### Produces
- [What this ticket creates that downstream tickets depend on]
- [e.g., "Exports `calculateScore(homeId)` function returning `HealthScore` type from `src/lib/health-score.ts`"]

### Acceptance Criteria
- [ ] [Specific testable behavior 1]
- [ ] [Specific testable behavior 2]
- [ ] Shared interface implementation matches the contract definition above
- [ ] All existing tests continue to pass (regression baseline)

---

## [TICKET-2]: [Title] (Depends on: [TICKET-1])

### Testing Approach
- **Testing approach:** [TDD | Test-informed | Test-after]

### Dependency Context
[Explain what this ticket needs from the upstream ticket. Be specific about the interface, function, data shape, or component it consumes.]

### Prerequisite Check
Before starting this ticket, verify:
- [ ] [TICKET-1] status is `Done` or `In Review` with all evaluators passed
- [ ] The shared interface produced by [TICKET-1] matches the contract definition

### Acceptance Criteria
- [ ] [Specific testable behavior 1]
- [ ] [Specific testable behavior 2]
- [ ] All existing tests continue to pass (regression baseline)

---

## [TICKET-3]: [Title] (Depends on: [TICKET-2])
*(Copy the dependent section template above for each additional story)*

---

## End-to-End Acceptance Criteria
These criteria verify the integrated flow across all tickets:
- [ ] [Full flow behavior 1: e.g., "Add room → score updates → dashboard reflects → notification fires"]
- [ ] [Full flow behavior 2]

## Rollback Protocol
Because tickets are coupled, a failure in a downstream ticket may indicate an issue with the upstream interface. The evaluation cycle for hierarchical sprints:
1. Evaluate each ticket individually after completion
2. After all tickets are complete, run end-to-end acceptance criteria
3. If end-to-end fails, identify which ticket's output is incorrect
4. Standard retry protocol applies (max 3 cycles on the failing ticket: implementer reads review reports directly, revises, all evaluators re-review. After 3 failed cycles, orchestrator diagnoses failure pattern and presents diagnosis to owner)

## Notes
[Any context, constraints, or open questions for this sprint]
