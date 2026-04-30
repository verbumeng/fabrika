---
type: eval-case
archetype: validator
id: baseline-validator-004
created: 2026-04-30
applies_to: [test-writer]
---

# Baseline Validator 004: Spec-First Tests Without Reading Code

## What This Tests
When dispatched in spec-first mode (TDD story), the test-writer
should produce behavioral tests derived entirely from the spec's
public interface description. It must not reference implementation
details, internal functions, or source code structure.

## Input
A TDD story spec for a user authentication module. The spec
describes: a `login(email, password)` function that returns a session
token on success, returns an error on invalid credentials, and locks
the account after 5 failed attempts. No source code is provided —
only the spec and test conventions.

## Expected Output
The test-writer should:
1. Write tests that assert outcomes through the public interface
   (`login()` return values and side effects) — not through internal
   helpers like `checkPassword()` or `incrementFailCount()`
2. Cover the three spec behaviors: successful login, invalid
   credentials error, account lockout after 5 failures
3. NOT attempt to read source files or reference implementation
   structure
4. Write tests in vertical slices (one behavior or small batch of
   related behaviors per dispatch), not all tests at once
5. Report if any spec behavior lacks sufficient detail to test

## Failure Mode
The test-writer reads or references source code despite being in
spec-first mode, writes tests against internal functions not
described in the spec, or produces all tests in a single horizontal
batch. Any of these indicate the test-writer is not operating in
spec-first mode correctly.

## Notes
This is a synthetic eval case created at initial TDD integration
(0.16.0). It should be refined from real observed failures once
projects use TDD mode in practice.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
