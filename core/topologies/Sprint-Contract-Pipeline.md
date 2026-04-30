---
type: sprint-contract
sprint: Sprint-XX
topology: pipeline
feature: "[TICKET] — [Feature Name]"
created: YYYY-MM-DD
---

# Sprint XX Contract — Pipeline

## Overview
- **Topology:** Pipeline (plan → build → evaluate)
- **Feature:** [TICKET] — [Feature Name]
- **Story points:** [X]
- **Testing approach:** [TDD | Test-informed | Test-after]
- **Sprint dates:** YYYY-MM-DD to YYYY-MM-DD

## Stage 1: Plan
- **Entry condition:** One-line feature description or story with acceptance criteria
- **Agent:** product-manager (planning mode)
- **Exit condition:** Full spec approved by owner at `docs/plans/[TICKET]-spec.md`
- **Exit artifacts:**
  - [ ] Spec document with user stories, data model impact, design direction
  - [ ] Updated features.json with feature entries for this ticket

## Stage 2: Build
- **Entry condition:** Approved spec document
- **Agent:** Implementer + test-writer (flow depends on testing approach — see `core/workflows/development-workflow.md`)
- **Exit condition:** Feature implemented, all tests passing, committed to feature branch
- **Exit artifacts:**
  - [ ] Implementation complete per spec
  - [ ] Unit tests written and passing
  - [ ] E2E tests written and passing (if applicable per project verification method)
  - [ ] No regressions — all existing tests continue to pass

## Stage 3: Evaluate
- **Entry condition:** Running feature on dev server (or testable implementation for non-UI projects)
- **Agents:** code-reviewer, test-writer (verification), product-manager (validation mode)
- **Exit condition:** All evaluators pass, or documented failures with specific fix instructions
- **Exit artifacts:**
  - [ ] Code review report at `docs/evaluations/[TICKET]-code-review.md`
  - [ ] Test verification report at `docs/evaluations/[TICKET]-test-review.md`
  - [ ] Product validation report at `docs/evaluations/[TICKET]-product-review.md`
  - [ ] All features.json entries for this ticket have `passes: true`

## Rollback Protocol
- If evaluation fails and fix is straightforward → fix and re-evaluate (max 2 retries)
- If evaluation fails and approach is fundamentally wrong → `git revert` to last passing commit, re-read this contract, try different approach
- After 2 failed retry cycles → escalate to owner with all evaluation reports and summary of attempts

## Acceptance Criteria
- [ ] [Specific testable behavior 1]
- [ ] [Specific testable behavior 2]
- [ ] [Specific testable behavior 3]
- [ ] All existing tests continue to pass (regression baseline)

## Notes
[Any context, constraints, or open questions for this sprint]
