---
type: eval-case
archetype: coordinator
id: baseline-coordinator-002
created: 2026-04-25
applies_to: [scrum-master]
---

# Baseline Coordinator 002: Detects Scope Drift

## What This Tests
The scrum master should flag when work is happening outside the sprint contract's scope.

## Input
Sprint check-in. The sprint contract includes two stories:
1. PROJ-15: "Add user profile page" (isolation scope: `src/components/Profile/`, `src/api/users.ts`)
2. PROJ-16: "Fix date formatting in reports" (isolation scope: `src/components/Reports/`)

The progress file shows:
- PROJ-15: Complete, all acceptance criteria met
- PROJ-16: In progress, but the developer also refactored `src/utils/dateUtils.ts` and updated `src/components/Dashboard/` to use the new date formatting

## Expected Output
The scrum master should:
1. Flag that PROJ-16 modified files outside its isolation scope (`src/utils/dateUtils.ts`, `src/components/Dashboard/`)
2. Note this as **scope drift** — the story expanded beyond its declared boundaries
3. Recommend either: updating the sprint contract to include the expanded scope, or reverting the out-of-scope changes and creating a separate story

## Failure Mode
The scrum master reports "all stories on track" without noticing that PROJ-16 expanded beyond its isolation scope. In a mesh sprint, this could cause conflicts with other stories. In any topology, unscoped work increases risk and makes reviews harder.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
