---
type: sprint-contract
sprint: Sprint-XX
topology: mesh
created: YYYY-MM-DD
---

# Sprint XX Contract — Mesh

## Overview
- **Topology:** Mesh (independent tasks, no shared state)
- **Stories:** [X] stories, [Y] total points
- **Sprint dates:** YYYY-MM-DD to YYYY-MM-DD

## Independence Verification
The scrum-master has verified that the following stories have no overlapping file scopes, shared state, or data model dependencies. Each can be worked in any order without conflict.

---

## [TICKET-1]: [Title]

### Isolation Scope
This story works exclusively within:
- `src/[directory]/`
- `tests/[directory]/`
- `docs/[relevant docs]`

**Does NOT modify:** shared state, global styles, database schema, or files outside the listed scope.

### Acceptance Criteria
- [ ] [Specific testable behavior 1]
- [ ] [Specific testable behavior 2]
- [ ] All existing tests continue to pass (regression baseline)

---

## [TICKET-2]: [Title]

### Isolation Scope
This story works exclusively within:
- `src/[directory]/`
- `tests/[directory]/`
- `docs/[relevant docs]`

**Does NOT modify:** shared state, global styles, database schema, or files outside the listed scope.

### Acceptance Criteria
- [ ] [Specific testable behavior 1]
- [ ] [Specific testable behavior 2]
- [ ] All existing tests continue to pass (regression baseline)

---

## [TICKET-3]: [Title]
*(Copy the section template above for each additional story)*

---

## Scope Conflict Resolution
If during implementation a story needs to modify files outside its declared isolation scope:
1. **Stop.** Do not modify out-of-scope files.
2. Flag the conflict to the owner.
3. Options: extract the shared dependency into a prerequisite ticket, switch the conflicting stories to hierarchical topology, or re-scope one of the stories.

## Rollback Protocol
Each story is evaluated independently. If one story's evaluation fails, it does not affect the others. Standard retry protocol applies per-story (max 2 retries, then escalate).

## Notes
[Any context, constraints, or open questions for this sprint]
