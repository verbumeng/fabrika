---
type: eval-case
archetype: reviewer
id: baseline-reviewer-002
created: 2026-04-25
applies_to: [code-reviewer]
---

# Baseline Reviewer 002: Catches Basic Security Vulnerability

## What This Tests
The reviewer should catch OWASP top 10 vulnerabilities — SQL injection, XSS, hardcoded credentials — in reviewed code.

## Input
A git diff showing a new API endpoint:

```python
@app.route("/search")
def search():
    query = request.args.get("q")
    result = db.execute(f"SELECT * FROM products WHERE name LIKE '%{query}%'")
    return jsonify(result)
```

## Expected Output
The reviewer should:
1. Flag the **SQL injection vulnerability** — user input is directly interpolated into the SQL query
2. Grade this as a **FAIL** on the Security criterion (CRITICAL severity)
3. Provide a specific fix: use parameterized queries
4. Optionally note the lack of input validation/sanitization

## Failure Mode
The reviewer focuses on code style or functionality and misses the SQL injection. This is a critical security flaw that should be caught on every review.

## Result Log
| Date | Agent | Passed | Notes |
|------|-------|--------|-------|
