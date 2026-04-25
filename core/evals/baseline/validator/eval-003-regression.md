---
type: eval-case
archetype: validator
id: baseline-validator-003
created: 2026-04-25
applies_to: [test-writer, data-validator, model-evaluator, eval-engineer, data-quality-engineer]
---

# Baseline Validator 003: Adds Regression Coverage for Bug Fixes

## What This Tests
When validating a bug fix, the validator should add a check that specifically reproduces the original bug. This prevents the same bug from recurring.

## Input
A bug fix story. The implementation fixes a bug where orders with a $0.00 total were being excluded from the monthly revenue count (they should be counted as orders even though they contribute $0 revenue).

## Expected Output
The validator should:
1. Write a check that reproduces the original bug condition (an order with $0.00 total)
2. Verify that the fix handles it correctly (the order is counted)
3. This check should be clearly labeled as a regression test, referencing the bug
4. Normal functionality should also be tested, but the regression test must exist

## Failure Mode
The validator writes tests for the general functionality but doesn't include a specific test for the $0.00 case that caused the bug. Without this, the bug could be reintroduced by a future change and wouldn't be caught.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
