# Briefing Principles

These principles apply to all owner-facing briefings — spec briefings, sprint plan briefings, and any future briefing format.

## Core Principles

**Assume the owner hasn't touched this codebase in a week.** Re-establish context every time. Don't assume they remember variable names, data model fields, or decisions from previous sprints.

**Define terms even if they were defined before.** Repetition is cheap; confusion is expensive. A jargon glossary is mandatory in every briefing, not optional. When a Domain Language document exists for the project (`docs/00-Index/Domain-Language.md`), draw definitions from it rather than inventing them ad hoc — this ensures consistency across briefings, specs, and code. If a briefing introduces a term not yet in the Domain Language, define it in the jargon glossary and flag it for addition to the Domain Language document.

**Lead with product impact, not implementation.** "Users will be able to filter by date range" before "adds a DateRangeFilter component." The owner cares about what changes for the end user — implementation details are supporting evidence, not the headline.

**Make disagreement easy.** Frame design decisions as choices, not foregone conclusions. The briefing should make the owner feel invited to push back. Present alternatives that were considered, not just the winner.

## Why Briefings Exist

The agent produces structured artifacts (specs, sprint contracts) that serve as implementation contracts for downstream agents. Those artifacts are optimized for machine consumption — precise, structured, dense.

The owner's job is different: make decisions, catch design problems, guide taste and architecture. That requires understanding what is being proposed, why it matters, and where the judgment calls are. Briefings bridge the gap between agent artifacts and human decision-making.

## When to Brief

- After product-manager planning mode returns a spec → use Spec Briefing format
- After scrum-master sprint planning returns a plan → use Sprint Plan Briefing format
- After analysis-planner creates a task plan (analytics-workspace) → use Task Plan Briefing format
- After task delivery (analytics-workspace) → use Task Outcome Briefing format
- After workflow-planner produces a structural update plan (agentic-workflow) → use Structural Plan Briefing format
- After structural changes are complete, before shipping (agentic-workflow) → use Change Summary Briefing format
- Any time the owner needs to approve a direction or make a decision that will be hard to reverse once implementation starts

## Token Cost Reporting

When a briefing includes token efficiency data, use approximate cost ranges at model tiers rather than naming specific models or citing exact per-token prices. Model names and pricing change; approximate tiers stay useful longer.

**Canonical format:**

```
Token usage: [X] tokens
Approximate cost: ~$[high] at high-end / ~$[mid] at mid-tier / ~$[low] at economy tier
```

Always include a per-agent-role breakdown showing the cost contribution of each dispatched agent:

```
Breakdown: Planner ~$[X] | Implementer ~$[X] | Reviewer ~$[X] | Validator ~$[X]
```

Adjust the agent roles listed to match the agents actually dispatched (e.g., agentic-workflow updates include Architect; analytics-workspace tasks may not include Validator).

If token data is not available from the tool, note that and skip — do not fabricate numbers.
