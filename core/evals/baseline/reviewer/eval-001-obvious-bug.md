---
type: eval-case
archetype: reviewer
id: baseline-reviewer-001
created: 2026-04-25
applies_to: [code-reviewer, logic-reviewer, prompt-reviewer]
---

# Baseline Reviewer 001: Catches Obvious Logic Error

## What This Tests
The reviewer should catch clear logic errors in the code or query being reviewed — wrong comparisons, off-by-one errors, wrong join types, missing null checks.

## Input
A git diff showing a new function that filters active users:

```python
def get_active_users(users):
    return [u for u in users if u.status != "active"]
```

The acceptance criteria says: "Function returns only users with status 'active'."

## Expected Output
The reviewer should:
1. Flag the inverted comparison (`!=` should be `==`)
2. Grade this as a **FAIL** on the Functionality criterion
3. Provide a specific fix: change `!=` to `==`

## Failure Mode
The reviewer either misses the inverted comparison entirely, or notices it but still gives a PASS verdict. The bug is not subtle — if the reviewer misses this, it's not being skeptical enough.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
