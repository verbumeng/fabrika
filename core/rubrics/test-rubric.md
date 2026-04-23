---
type: rubric
title: Test Writing & Verification Grading Criteria
agent: test-writer
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [rubric, testing, evaluation]
---

# Test Writing & Verification Grading Criteria

## Purpose
This rubric defines how the test-writer agent evaluates test coverage and verification completeness. Load this file when writing tests and when verifying test adequacy.

## Skepticism Calibration
Tests exist to catch bugs, not to confirm the happy path. **Assume the implementation has edge cases that aren't being tested. Your job is to find them.** A test suite where everything passes easily is suspicious — either the tests aren't thorough or they're testing the wrong things.

## Grading Criteria

### 1. Regression Detection — Weight: CRITICAL
Do all existing tests still pass after the new implementation?

- **Pass:** Full test suite passes, including all pre-existing tests.
- **Fail:** Any pre-existing test fails after the new implementation.
- **This is a hard fail.** Report immediately — do not continue with other criteria until regressions are resolved.

### 2. Coverage — Weight: HIGH
Is core logic and storage adequately covered?

- **Pass:** 80%+ coverage on new code. All acceptance criteria from the sprint contract have corresponding test cases. Critical paths (data persistence, calculations, state transitions) are explicitly tested.
- **Partial:** 60-80% coverage, or acceptance criteria are tested but edge cases are not.
- **Fail:** Below 60% coverage, or critical paths have no tests.

### 3. Edge Case Coverage — Weight: HIGH
Are boundary conditions, error cases, and unusual inputs tested?

- **Pass:** Tests include: empty inputs, null/undefined values, boundary values (0, max, negative), concurrent access (if applicable), malformed data, permission failures.
- **Partial:** Some edge cases covered but obvious gaps remain.
- **Fail:** Only happy path tested.

### 4. E2E Verification — Weight: MEDIUM (when applicable)
Has the feature been verified end-to-end using the project's verification method?

- **Pass:** E2E test covers the full user flow described in the sprint contract acceptance criteria. For web/data apps: browser automation navigates the feature, interacts with it, and verifies the result. For data projects: output matches expected benchmark within tolerance.
- **Partial:** E2E test exists but doesn't cover all acceptance criteria.
- **Fail:** No E2E verification when the project type warrants it.
- **N/A:** Project type doesn't warrant E2E testing (e.g., pure library, CLI tool). Skip this criterion.

### 5. Test Quality — Weight: MEDIUM
Are the tests themselves well-written and maintainable?

- **Pass:** Tests have descriptive names, use fixtures where appropriate, don't depend on execution order, don't test implementation details (test behavior, not internals), are deterministic.
- **Partial:** Tests work but are fragile, tightly coupled to implementation, or have unclear names.
- **Fail:** Tests are flaky, order-dependent, or test the wrong things (e.g., testing that a mock was called rather than testing actual behavior).

### 6. False Positive Risk — Weight: MEDIUM
Could these tests pass even when the implementation is broken?

- **Pass:** Tests would genuinely fail if the feature broke. Assertions are specific (exact values, not just "truthy"). Tests exercise real code paths, not mocks of the code under test.
- **Fail:** Tests use overly broad assertions (`expect(result).toBeTruthy()`), mock the code under test rather than its dependencies, or would pass even if the feature were removed.

### 7. Structural Constraint Enforcement — Weight: MEDIUM (when applicable)
Are codebase structural constraints enforced by tests?

- **Pass:** All constraints declared in `docs/02-Engineering/Structural-Constraints.md` have corresponding tests. Tests produce prompt-style error messages with remediation instructions.
- **Partial:** Some constraints are enforced but others rely only on agent judgment (code-reviewer) rather than mechanical enforcement.
- **Fail:** Structural Constraints document exists but no tests enforce it.
- **N/A:** No `docs/02-Engineering/Structural-Constraints.md` exists yet. Skip this criterion.

### 8. Test Output Quality — Weight: LOW
Is test output concise and agent-friendly?

- **Pass:** Summary lines on success, specific error messages on failure. Grep-friendly format: `ERROR: [component] [description]`. Details go to log files, not stdout.
- **Partial:** Output is functional but verbose.
- **Fail:** Test failures produce wall-of-text stack traces with no summary.

## Verdict Scale
- **PASS:** All CRITICAL criteria pass, no HIGH criteria fail.
- **PASS WITH NOTES:** All CRITICAL criteria pass, 1 HIGH partial. Notes describe gaps.
- **FAIL:** Any CRITICAL fail, OR 2+ HIGH fails. Specific gaps listed with instructions for what tests to add.

## Output Format
Write your verification report to `docs/evaluations/[TICKET]-test-review.md` with:
1. Verdict (PASS / PASS WITH NOTES / FAIL)
2. Per-criterion grades
3. Coverage summary (lines, branches, functions if available)
4. Missing test cases (specific scenarios that should be tested)
5. E2E verification results (if applicable)
