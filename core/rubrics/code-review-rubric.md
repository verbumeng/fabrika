---
type: rubric
title: Code Review Grading Criteria
agent: code-reviewer
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [rubric, code-review, evaluation]
---

# Code Review Grading Criteria

## Purpose
This rubric defines how the code-reviewer agent evaluates implementations. Load this file at the start of every code review session. Grade each criterion and produce a verdict.

## Skepticism Calibration
You are the skeptic in this workflow. The generator (main session) has already convinced itself the code works. Your job is to find what it missed. **Assume the implementation has at least one subtle bug. Your job is to find it.** Do not give the benefit of the doubt. If something looks like it might be wrong, investigate further before passing it.

## Grading Criteria

### 1. Regression Safety — Weight: CRITICAL (hard fail)
Do all existing tests still pass? Has any existing functionality been broken?

- **Pass:** All pre-existing tests pass. No behavioral changes to code outside the story's scope.
- **Fail:** Any existing test fails, OR code outside the story's scope was modified in a way that changes behavior.
- **This is a hard fail.** If regression safety fails, the overall review fails regardless of other criteria.

### 2. Isolation Compliance (Mesh Topology Only) — Weight: CRITICAL (hard fail)
Are all code changes within the declared isolation scope from the sprint contract?

- **Pass:** All modified files are within the declared scope.
- **Fail:** Any file outside the declared scope was modified.
- **Only applies when the current sprint topology is `mesh`.** Skip for pipeline and hierarchical topologies.

### 3. Functionality — Weight: HIGH
Does the implementation actually work? Does it handle the happy path AND edge cases?

- **Pass:** All acceptance criteria from the sprint contract are met. Edge cases are handled or explicitly documented as out of scope.
- **Partial:** Happy path works but edge cases are missing or fragile.
- **Fail:** Core acceptance criteria are not met, or the implementation is a stub/placeholder.

### 4. Code Quality — Weight: HIGH
Is the code well-structured, typed, tested, and maintainable?

- **Pass:** Clear naming, appropriate abstractions, no unnecessary complexity, proper error handling at system boundaries, types where the language supports them.
- **Partial:** Functional but messy — long functions, unclear naming, inconsistent patterns.
- **Fail:** Unmaintainable — deeply nested logic, magic numbers, no error handling, copy-pasted blocks.

### 5. Duplicate Implementation — Weight: MEDIUM
Does the new code re-implement functionality that already exists in the codebase?

- **Pass:** No duplicate implementations detected. New code uses existing utilities and helpers where appropriate.
- **Fail:** New code re-implements existing functionality. Recommend refactoring to use existing code or extracting a shared utility.

### 6. Product Depth — Weight: MEDIUM
Is the feature fully interactive, or is it a display-only stub?

- **Pass:** Feature is fully functional — user can complete the intended flow end-to-end.
- **Partial:** Feature renders but interactions are incomplete (buttons that don't work, forms that don't submit, data that doesn't persist).
- **Fail:** Feature is a visual stub with no real functionality.

### 7. Security — Weight: MEDIUM
Are there any OWASP top 10 vulnerabilities or other security concerns?

- **Pass:** No vulnerabilities detected by semgrep or manual review. Input validation at system boundaries. No credentials in code.
- **Fail:** XSS, SQL injection, command injection, insecure authentication, or exposed secrets.

### 8. Interface Contract Compliance (Hierarchical Topology Only) — Weight: HIGH
Does the implementation respect shared interface contracts defined in the sprint contract?

- **Pass:** All shared interfaces match the contract definitions exactly.
- **Fail:** Interface deviates from contract without documented agreement to change.
- **Only applies when the current sprint topology is `hierarchical`.** Skip for pipeline and mesh topologies.

## Verdict Scale
- **PASS:** All CRITICAL criteria pass, no HIGH criteria fail, no more than 1 MEDIUM partial.
- **PASS WITH NOTES:** All CRITICAL criteria pass, 1 HIGH partial or 2+ MEDIUM partials. Notes describe what should be improved.
- **FAIL:** Any CRITICAL fail, OR 2+ HIGH fails. Specific failures listed with fix instructions.

## Output Format
Write your review to `docs/evaluations/[TICKET]-code-review.md` with:
1. Verdict (PASS / PASS WITH NOTES / FAIL)
2. Per-criterion grades
3. Specific findings (file paths, line numbers, descriptions)
4. Fix instructions (if FAIL or PASS WITH NOTES)
