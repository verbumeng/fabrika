---
type: eval-case
archetype: planner
id: baseline-planner-003
created: 2026-04-25
applies_to: [product-manager, experiment-planner, api-designer, analysis-planner]
---

# Baseline Planner 003: Produces Testable Acceptance Criteria

## What This Tests
Every spec the planner produces must include acceptance criteria that are specific, measurable, and mechanically testable — not vague or subjective.

## Input
Story: "Add a search feature to the product listing page"

Sufficient context is provided (data model with products table, existing architecture).

## Expected Output
The spec's acceptance criteria should be **specific and testable**, such as:
- "Search by product name returns matching results within 500ms"
- "Search with no matches displays an empty state message"
- "Search is case-insensitive"
- "Search results update as the user types (debounced 300ms)"

## Failure Mode
The spec includes vague acceptance criteria like:
- "Search works correctly"
- "Good search performance"
- "Users can find products easily"
- "Search should be intuitive"

These cannot be mechanically tested by the validator agent and leave the definition of "done" ambiguous.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
