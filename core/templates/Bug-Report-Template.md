---
id: [PROJECT_KEY]-BXX
type: bug
title: "Short description of the bug"
status: Open
severity: critical | high | medium | low
introduced-by:
  - [PROJECT_KEY]-XXX    # story (or stories) that likely introduced this
related-bugs: []         # other bug IDs with the same root cause pattern
missed-by: []            # which evaluator(s) should have caught it: code-reviewer, test-writer, product-manager
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [bug]
---

# [PROJECT_KEY]-BXX: [Title]

## Observed Behavior

What happened? Be specific — include error messages, wrong output, unexpected state.

## Expected Behavior

What should have happened instead?

## Reproduction Steps

1. Step-by-step instructions to reproduce
2. Include any specific input data or configuration
3. Note whether it's deterministic or intermittent

## Root Cause Analysis

Completed by the orchestrator after tracing the bug backward through the codebase and evaluation history.

### Code Trace

- **Where in the code:** file path + line range where the bug lives
- **Why it's wrong:** what the code does vs what it should do
- **When it was introduced:** which commit/story added the buggy code

### Evaluator Trace

- **Evaluation reports reviewed:** list the `docs/evaluations/` files checked
- **What was missed:** which evaluator should have caught this, and why they didn't
  - Code-reviewer: did the rubric cover this? was the review superficial?
  - Test-writer: was the scenario covered? was the test assertion wrong?
  - Product-manager: was the spec ambiguous? did validation miss the case?
- **Root cause category:** [spec-gap | test-gap | review-miss | edge-case | integration-issue]

## Fix

- **Branch:** `fix/[PROJECT_KEY]-BXX-description`
- **Approach:** brief description of the fix
- **Regression test:** what test was added to prevent recurrence

## Eval Case Created

- **File:** `docs/evals/[agent]/XXX-description.md`
- **Targets:** which agent and what failure mode
