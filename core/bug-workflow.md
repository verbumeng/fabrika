---
type: engineering
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [engineering, bugs, workflow]
---

# Bug Reporting & Fix Workflow

When the owner reports a bug (says "this is broken", "I found a bug", describes unexpected behavior), follow this workflow end-to-end.

## 1. File the bug

1. Create a bug file at `docs/04-Backlog/Bugs/[PROJECT_KEY]-BXX-description.md` using `docs/Templates/Bug-Report-Template.md`
2. Find the next bug ID: `rg "^id: [PROJECT_KEY]-B" docs/04-Backlog/Bugs/ | sort | tail -1`
3. Fill in: observed behavior, expected behavior, reproduction steps, severity
4. Set `introduced-by` — which story (or stories) likely introduced it
5. Create a fix branch: `fix/[PROJECT_KEY]-BXX-description`

## 2. Root cause analysis (trace backward)

6. Read the code to identify where and why the bug occurs
7. Read the evaluation reports for the `introduced-by` story (`docs/evaluations/[TICKET]-*`)
8. Determine which evaluator(s) should have caught this:
   - **Code-reviewer** — did the rubric cover this path? was the review superficial?
   - **Test-writer** — was the scenario covered? was the test assertion wrong or missing?
   - **Product-manager** — was the spec ambiguous? did validation miss the acceptance criteria?
9. Set `missed-by` in the bug file
10. Categorize: `spec-gap`, `test-gap`, `review-miss`, `edge-case`, or `integration-issue`
11. Check `docs/04-Backlog/Bugs/` for related bugs with the same root cause pattern — link them via `related-bugs`

## 3. Fix and verify

12. Implement the fix
13. Invoke the **test-writer** agent to write a regression test targeting the exact bug scenario
14. Invoke the **code-reviewer** agent to review the fix
15. If the fix changes observable behavior or `missed-by` includes `product-manager` → invoke the **product-manager** agent in **validation mode**
16. Each evaluator writes a report to `docs/evaluations/[PROJECT_KEY]-BXX-[agent]-review.md`

## 4. Improve agent quality

17. Create an eval case in `docs/evals/[missed-by-agent]/` targeting the specific failure mode
18. If the miss suggests a prompt deficiency, propose a prompt change and log it to `docs/evals/agent-changelog.md`
19. Update bug file: fill in Fix and Eval Case Created sections
20. Commit with `fix([PROJECT_KEY]-BXX): description`

## Bug Severities

- **critical** — data loss, crash, core functionality broken
- **high** — wrong output, missed requirements
- **medium** — incorrect behavior that doesn't affect core correctness
- **low** — cosmetic, minor UX issues, non-blocking workaround exists

## Related

- Bug template: `docs/Templates/Bug-Report-Template.md`
- Bug files: `docs/04-Backlog/Bugs/`
- Eval cases: `docs/evals/[agent-name]/`
- Maintenance bug review: `docs/02-Engineering/maintenance-checklist.md`
