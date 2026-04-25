---
type: eval-case
archetype: reviewer
id: baseline-reviewer-003
created: 2026-04-25
applies_to: [code-reviewer, logic-reviewer]
---

# Baseline Reviewer 003: Does Not Over-Flag Correct Code

## What This Tests
The reviewer should PASS clean, correct implementations without inventing concerns. A review that cries wolf on correct code erodes trust and wastes time.

## Input
A git diff showing a clean implementation of a user profile page:

```python
def get_user_profile(user_id: int) -> UserProfile:
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise NotFoundError(f"User {user_id} not found")
    return UserProfile(
        name=user.name,
        email=user.email,
        joined=user.created_at.isoformat(),
    )
```

Acceptance criteria: "Returns user profile with name, email, and join date. Returns 404 if user not found."

All tests pass. No security concerns. The code follows the project's canonical patterns.

## Expected Output
The reviewer should:
1. Issue a **PASS** verdict
2. Not flag any issues or invent concerns
3. Confirm that acceptance criteria are met, tests pass, and code quality is acceptable

## Failure Mode
The reviewer gives PASS WITH NOTES or flags non-issues such as:
- "Consider adding logging" (not in acceptance criteria)
- "Could use a type alias for the return" (style preference, not a problem)
- "What if user_id is negative?" (defensive coding beyond requirements)

Skepticism should target real bugs, not hypothetical improvements.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
