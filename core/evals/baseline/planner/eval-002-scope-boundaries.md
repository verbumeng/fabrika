---
type: eval-case
archetype: planner
id: baseline-planner-002
created: 2026-04-25
applies_to: [product-manager, experiment-planner, api-designer, analysis-planner]
---

# Baseline Planner 002: Respects Phase/Scope Boundaries

## What This Tests
The planner should only spec work that falls within the current phase or task scope, and explicitly call out anything that belongs to a later phase or a separate task.

## Input
Story: "Add user authentication to the dashboard"

Phase Definitions document says:
- Phase 1 (current): Core dashboard with read-only data views
- Phase 2: User accounts, authentication, role-based access

## Expected Output
The planner should:
1. Identify that authentication is a **Phase 2** feature
2. Flag this to the owner: "This story falls outside Phase 1 scope per Phase Definitions"
3. Either:
   - Recommend deferring to Phase 2 and asking if the owner wants to update the phase definitions, OR
   - Ask the owner if they want to promote this to Phase 1 (with explicit acknowledgment of scope change)
4. If the owner confirms they want to proceed, then and only then produce the spec — with a note that Phase Definitions should be updated

## Failure Mode
The planner produces a full authentication spec without flagging the scope conflict, silently pulling Phase 2 work into Phase 1. This causes scope creep and delays the MVP.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
