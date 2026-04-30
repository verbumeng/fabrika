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

### 7. Pattern Conformance — Weight: MEDIUM
Does the implementation use canonical patterns where applicable?

- **Pass:** New code follows patterns defined in `docs/02-Engineering/Canonical-Patterns.md` where relevant. No ad-hoc reimplementation of concerns that have a canonical pattern (error handling, API calls, state management, logging, etc.).
- **Partial:** Code works but uses a different approach than the canonical pattern without justification. Not a hard fail, but the reviewer should flag it and recommend aligning.
- **Fail:** Code reimplements a canonical concern in a way that contradicts the documented pattern, creating inconsistency that will confuse future agent work.
- **N/A:** Skip if `docs/02-Engineering/Canonical-Patterns.md` does not yet exist (early project with no patterns established).

### 8. Security — Weight: MEDIUM
Are there any OWASP top 10 vulnerabilities or other security concerns?

- **Pass:** No vulnerabilities detected by semgrep or manual review. Input validation at system boundaries. No credentials in code.
- **Fail:** XSS, SQL injection, command injection, insecure authentication, or exposed secrets.

### 9. Cost & Performance Awareness — Weight: MEDIUM
Does the implementation avoid unnecessarily expensive operations?

- **Pass:** No unbounded queries, no expensive operations in loops without batching, no frontier-model LLM calls where a smaller model suffices, caching used where appropriate for repeated computations. Warehouse queries filter on partition keys where available.
- **Partial:** Minor cost inefficiencies that are acceptable for one-off work but would be problematic at scale or on a recurring schedule (e.g., full table scan on a small table, missing LIMIT on exploratory queries).
- **Fail:** Unbounded SELECT * on large tables in production paths, API/LLM calls in tight loops without batching, no cost consideration for recurring operations, missing partition filters on multi-TB tables.
- **Notes:** Scale severity to context. A one-off analysis scanning 5GB is not a fail. A daily scheduled job scanning 500GB without partition filters is. For `ai-engineering`, check model selection, prompt caching, and token waste. The performance-reviewer agent does the deep dive; this criterion catches the obvious issues.

### 10. Interface Contract Compliance (Hierarchical Topology Only) — Weight: HIGH
Does the implementation respect shared interface contracts defined in the sprint contract?

- **Pass:** All shared interfaces match the contract definitions exactly.
- **Fail:** Interface deviates from contract without documented agreement to change.
- **Only applies when the current sprint topology is `hierarchical`.** Skip for pipeline and mesh topologies.

**Note:** The performance-reviewer agent provides deeper cost and performance analysis. The architect agent (if configured for this project type) provides deeper structural/module design analysis. These criteria are the code-reviewer's lightweight first-pass checks — flag the obvious issues, and the specialist agents will handle the deep analysis.

### 11. Module Depth / Interface Simplicity — Weight: MEDIUM
Does the implementation favor deep modules with simple interfaces over shallow modules with complex interfaces?

- **Pass:** New modules hide complexity behind simple interfaces. No pass-through methods or wrapper classes that add interface complexity without adding functionality. Changes are localized — modifying the implementation doesn't require interface changes.
- **Partial:** Some shallow modules exist (e.g., a service class that delegates every method to another class), but the overall structure is navigable. Flag for architect review if the project has an architect agent configured.
- **Fail:** Implementation adds significant interface complexity relative to functionality. Multiple new modules that are just pass-throughs. Changes to one module cascade interface changes through 3+ other modules.
- **Notes:** This is the code-reviewer's lightweight structural check. The architect agent (if configured) performs the deep module depth analysis. When grading Partial, recommend invoking the architect as an evaluation supplement.

### 12. Terminology Consistency — Weight: MEDIUM
Do code names align with the project's Domain Language document?

- **Pass:** Code uses terms from Domain Language consistently. Class names, function names, database columns, and variables align with the domain vocabulary. No ad hoc synonyms for terms that have Domain Language definitions. If the implementer implemented a Domain Language concept, the code-level name field in the Domain Language document has been populated.
- **Partial:** Code uses some Domain Language terms but introduces alternative names for some concepts (e.g., Domain Language defines "Order" but code uses "Purchase" in some places). Or code-level names are populated for some implemented concepts but not all.
- **Fail:** Code systematically uses different terminology from Domain Language, creating a translation layer between the domain model and the code. Or multiple Domain Language concepts were implemented without populating their code-level names.
- **N/A:** Skip if no Domain Language document exists for this project.
- **Notes:** This is a naming alignment check, not a deep semantic analysis. If the code introduces a legitimate new concept not yet in the Domain Language, the reviewer should flag it for addition rather than marking it as a failure. The code-level name field in the Domain Language is mandatory — "not yet implemented" is acceptable only for concepts that have not been implemented in code yet.

## Verdict Scale
- **PASS:** All CRITICAL criteria pass, no HIGH criteria fail, no more than 1 MEDIUM partial or N/A.
- **PASS WITH NOTES:** All CRITICAL criteria pass, 1 HIGH partial or 2+ MEDIUM partials. Notes describe what should be improved.
- **FAIL:** Any CRITICAL fail, OR 2+ HIGH fails. Specific failures listed with fix instructions.

**Note:** Criteria marked N/A (topology-specific criteria that don't apply, Pattern Conformance when Canonical Patterns doesn't exist yet, or Terminology Consistency when no Domain Language exists) are excluded from the verdict calculation.

## Output Format
Write your review to `docs/evaluations/[TICKET]-code-review.md` with:
1. Verdict (PASS / PASS WITH NOTES / FAIL)
2. Per-criterion grades
3. Specific findings (file paths, line numbers, descriptions)
4. Fix instructions (if FAIL or PASS WITH NOTES)
