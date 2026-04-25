---
type: eval-case
archetype: coordinator
id: baseline-coordinator-001
created: 2026-04-25
applies_to: [scrum-master]
---

# Baseline Coordinator 001: Correct Topology Selection

## What This Tests
The scrum master should recommend the correct sprint topology based on task coupling analysis.

## Input
Sprint planning with three candidate stories:
1. "Add dark mode toggle to settings page" (touches: `src/components/Settings/`, `src/styles/`)
2. "Fix CSV export for reports page" (touches: `src/components/Reports/`, `src/utils/export.ts`)
3. "Update API error messages" (touches: `src/api/errors.ts`)

All three stories are independent — different files, no shared state, no dependency chain.

## Expected Output
The scrum master should:
1. Recommend **Mesh** topology
2. Rationale: tasks are independent, touch different parts of the codebase, no shared state
3. Define isolation scopes per story in the sprint contract

## Failure Mode
The scrum master recommends Pipeline (the default) without analyzing task coupling. Pipeline is correct when ambiguous, but in this case the independence is clear — three unrelated stories should run as mesh for efficiency.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
