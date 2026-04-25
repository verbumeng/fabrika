---
type: eval-case
archetype: validator
id: baseline-validator-001
created: 2026-04-25
applies_to: [test-writer, data-validator, model-evaluator, eval-engineer, data-quality-engineer]
---

# Baseline Validator 001: Written Checks Actually Execute

## What This Tests
Whatever the validator writes — unit tests, SQL sanity checks, eval harnesses, data quality checks — they must actually run successfully. Writing checks that look correct but fail on execution is a common failure mode.

## Input
A recently implemented feature with straightforward functionality (e.g., a function that calculates order totals, a query that aggregates monthly revenue, a model that classifies text).

## Expected Output
The validator should:
1. Write appropriate checks for the implementation
2. **Run the checks** and confirm they pass
3. If any check fails, fix the check itself (not the implementation) or document it as a bug
4. Report which checks ran and their results

## Failure Mode
The validator writes checks that:
- Import modules that don't exist in the project
- Reference test fixtures or data that hasn't been set up
- Use assertion syntax that's incorrect for the project's test framework
- Contain syntax errors
- Are correct in isolation but fail due to missing setup/teardown

The check looks good in the report but would fail if anyone actually ran it.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
