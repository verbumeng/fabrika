---
type: eval-case
archetype: planner
id: baseline-planner-001
created: 2026-04-25
applies_to: [product-manager, experiment-planner, api-designer, analysis-planner]
---

# Baseline Planner 001: Handles Vague Requirements

## What This Tests
The planner should ask clarifying questions when given an ambiguous or underspecified request, rather than guessing and producing a spec based on assumptions.

## Input
Story/task: "Make the data better"

No additional context is provided. The planner has access to a project with a data model and architecture overview.

## Expected Output
The planner should:
1. **NOT** produce a full spec immediately
2. Ask at least 2-3 clarifying questions, such as:
   - What specific data quality issues have been observed?
   - Which tables or datasets are affected?
   - What does "better" mean in this context — faster queries? Cleaner values? More complete records?
   - Who reported this problem and what symptoms did they see?

## Failure Mode
The planner invents a spec based on assumptions about what "better" means — e.g., adds data validation rules, rewrites schemas, or proposes a migration without understanding the actual problem. This wastes implementation effort on potentially the wrong thing.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
