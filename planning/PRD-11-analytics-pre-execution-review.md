# PRD-11: Analytics Pre-Execution Review

**Version target:** TBD (not part of original 0.10–0.19 roadmap)
**Dependencies:** PRD-03 (implementer agents exist), PRD-04 (architect)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

The analytics-workspace workflow currently runs execution BEFORE
review. The sequence is: analysis planner writes the plan → owner
approves the plan → data analyst executes (SQL, notebooks, scripts)
→ reviewers assess the output. This means expensive or incorrect
queries hit the data warehouse before any reviewer sees the code.

If a query is malformed, overly broad, or inefficient, the cost and
damage are already done by the time the logic reviewer, data
validator, or performance reviewer evaluates the work. The only
pre-execution gate is the owner approving the plan — but the plan
describes the approach, not the literal SQL. The gap is between "plan
approved" and "code executed."

## Solution Direction (Open — Needs Design Alignment)

Add a pre-execution review gate to the analytics-workspace workflow.
After the data analyst writes their code (SQL, scripts, notebooks)
and before any queries run against the warehouse, a subset of
reviewers assess the work product.

### Key Questions to Resolve in Design Alignment

1. **Which reviewers assess pre-execution vs. post-execution?**
   - Logic reviewer: likely pre-execution (can assess join logic,
     filter correctness, aggregation approach from code alone)
   - Performance reviewer: likely pre-execution (can assess query
     cost, scan breadth, indexing from code alone)
   - Data validator: likely post-execution (needs actual output to
     check row counts, distributions, null rates, cross-references)
   - Or should all three run both pre and post?

2. **What does the data analyst produce before execution?**
   - Just the SQL/scripts, or also an execution plan / dry run?
   - Should the plan include estimated row counts or cost estimates
     from query explain plans?

3. **How does this interact with iterative analysis?**
   - Exploratory analysis often involves running small queries to
     understand the data, then building up to the full analysis. A
     heavy review gate before every query would kill this workflow.
   - Possible: review gate only for "final" execution against
     production data, not for exploratory queries against dev/sample
     data
   - Possible: cost threshold — queries below X estimated cost skip
     the gate

4. **Does this change the data analyst agent's dispatch contract?**
   - Currently the data analyst receives: approved spec, source
     registry, work directory, source detail pointers
   - May need a new output expectation: "produce query files but do
     not execute" as a first step, then "execute approved queries"
     as a second dispatch after review

5. **Does the analytics-workspace workflow file need restructuring?**
   - Currently has 6 phases: brief → plan → promotion check →
     execute → validate → deliver
   - Might become: brief → plan → promotion check → write →
     pre-execution review → execute → validate → deliver

## Scope (Preliminary — Subject to Alignment)

### Likely modified files

| File | Change |
|---|---|
| `core/workflows/analytics-workspace.md` | Add pre-execution review phase between write and execute |
| `core/workflows/dispatch-protocol.md` | Split data analyst dispatch into write-only and execute phases; add pre-execution dispatch contracts for relevant reviewers |
| `core/agents/data-analyst.md` | Add write-only mode (produce queries without executing) |
| `core/agents/logic-reviewer.md` | Possibly: add pre-execution review mode (assess code without output data) |
| `core/agents/performance-reviewer.md` | Possibly: add pre-execution review mode |
| `integrations/claude-code/CLAUDE.md` | Reflect workflow change |
| `integrations/copilot/copilot-instructions.md` | Same |
| `VERSION` | TBD |
| `CHANGELOG.md` | Entry for TBD version |

## Notes

This PRD was identified during the PRD-07 (TDD Integration) alignment
session on 2026-04-30. It is not part of the original 10-PRD roadmap
(0.10.0–0.19.0) and does not have a scheduled version target. It
should go through Design Alignment before execution.
