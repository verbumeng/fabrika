---
type: eval-case
archetype: validator
id: baseline-validator-002
created: 2026-04-25
applies_to: [test-writer, data-validator, model-evaluator, eval-engineer, data-quality-engineer]
---

# Baseline Validator 002: Covers Boundary Conditions

## What This Tests
The validator should test edge cases and boundary conditions, not just the happy path. The specific edge cases depend on the validator type, but the principle is universal.

## Input
A feature with obvious boundary conditions. For example:
- **Code:** A pagination function (page 0? page beyond max? negative page?)
- **Data:** A revenue query (null amounts? negative amounts? zero-row results?)
- **Model:** A classifier (empty input? extremely long input? adversarial input?)

## Expected Output
The validator should include checks for at least:
1. **Empty/null input:** What happens with no data, null values, or empty strings?
2. **Boundary values:** First/last page, min/max amounts, zero-length input
3. **Invalid input:** Negative numbers where only positive expected, wrong types, malformed data
4. The happy path should also be covered, but not exclusively

## Failure Mode
The validator writes only happy-path checks:
- Tests that the function returns correct results for normal input
- Skips null handling, empty sets, boundary values, and error cases
- This means bugs in edge cases go undetected until production

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
