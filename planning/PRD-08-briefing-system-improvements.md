# PRD-08: Briefing System Improvements

**Version target:** 0.17.0
**Dependencies:** PRD-06 (Domain Language — briefings reference it)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

The briefing system is well-designed but has specific gaps identified
during audit:

1. **Topology terminology** in sprint plan briefings has no concrete
   translation examples — the orchestrator is told to "explain in plain
   terms" but has no model for what that looks like
2. **Evaluation findings** in session summary briefings have no example
   translations from technical findings to plain language
3. **Token efficiency conflict** — session summary briefing says "no
   token counts in owner summary" but retro briefing includes a token
   efficiency table. The owner wants token costs visible.
4. **Token costs not in post-story briefings** — the owner wants to see
   token usage and equivalent API costs after each story, not just in
   retros
5. **Technical language in spec briefings** — no explicit guidance on
   avoiding jargon when framing design alternatives
6. **Analytics-workspace briefing coverage** — briefing formats only
   exist for sprint-based types. Analytics-workspace has no equivalent
   formal briefing structure.
7. **Domain Language not yet connected to briefings** — jargon
   glossaries are invented ad hoc rather than drawn from the living
   Domain Language document

## Solution

Targeted improvements to existing briefing files plus new coverage for
analytics-workspace. No new archetypes or major workflow changes — this
is a refinement release.

### Specific Fixes

**1. Topology translation examples (sprint-plan-briefing.md):**
Add concrete before/after examples showing how to translate topology
choices into plain language:
- NOT: "We chose mesh topology because stories don't share state"
- YES: "Each story can be worked independently because they modify
  different parts of the system — no one is waiting on anyone else"

**2. Evaluation findings translation (session-summary-briefing.md):**
Add example translations:
- NOT: "Test-writer flagged one edge case — empty datasets"
- YES: "The test writer found that if you feed the system with no data,
  it crashes instead of showing a friendly message — this has been fixed"

**3. Token efficiency in all story and retro briefings:**
Resolve the conflict by making token costs a standard briefing element
in BOTH post-story session summaries AND retro briefings. Format:

```
Token usage: [X] tokens ([cost estimate])
Equivalent API costs: ~$[high] (Opus) / ~$[mid] (Sonnet) / ~$[low] (Haiku)
```

Remove the "no token counts in owner summary" restriction from
session-summary-briefing.md. The owner explicitly wants this visibility.

**4. Technical language guidance (spec-briefing.md):**
Add explicit instruction: when framing design alternatives, explain
in terms of user impact, not implementation technology. If technical
terminology is necessary for the owner to understand a trade-off,
define it in the jargon glossary AND add it to the Domain Language
document.

**5. Analytics-workspace briefing formats:**
Create lightweight briefing equivalents for analytics-workspace:
- Task outcome briefing (after task delivery — what was found, why it
  matters, what to look at)
- Task plan briefing (after plan creation — what analysis approach was
  chosen, what data sources, cost estimate in plain terms)

**6. Domain Language integration (briefing-principles.md):**
Add instruction: when a Domain Language document exists, the jargon
glossary in briefings should draw from it. New terms introduced in a
briefing that aren't in the Domain Language should be flagged for
addition.

## Key Decisions (Already Aligned)

- Token costs in both post-story AND retro briefings with model tier
  breakdown (high/mid/low-end)
- Technical language in spec briefings must be explained if used, and
  new jargon should be added to Domain Language
- Analytics-workspace needs briefing formats (lighter than sprint-based)
- Domain Language is the source of truth for jargon definitions in
  briefings

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `core/briefings/task-outcome-briefing.md` | Analytics-workspace: plain-language briefing after task delivery |
| `core/briefings/task-plan-briefing.md` | Analytics-workspace: plain-language briefing after plan creation |

### Modified files

| File | Change |
|---|---|
| `core/briefings/sprint-plan-briefing.md` | Add concrete topology translation examples (before/after). |
| `core/briefings/session-summary-briefing.md` | Add evaluation findings translation examples. Add token efficiency section with model tier costs. Remove "no token counts" restriction. |
| `core/briefings/retro-briefing.md` | Clarify token efficiency format with model tier costs (high/mid/low). |
| `core/briefings/spec-briefing.md` | Add technical language guidance — explain in user impact terms. New jargon → Domain Language. |
| `core/briefings/briefing-principles.md` | Add Domain Language integration instruction. Add analytics-workspace briefing pointers. |
| `core/workflows/analytics-workspace.md` | Add briefing steps to task lifecycle (plan briefing after plan, outcome briefing after delivery). |
| `integrations/claude-code/CLAUDE.md` | Update owner briefings section to reference analytics-workspace briefings and token cost format. |
| `integrations/copilot/copilot-instructions.md` | Same updates for Copilot parity. |
| `VERSION` | 0.17.0 |
| `CHANGELOG.md` | Entry for 0.17.0 |
| `MIGRATIONS.md` | Consumer migration: copy new briefing files, update existing briefing files, update analytics-workspace workflow and integration templates. |

## Open Items (To Resolve During Execution)

- Exact token-to-cost conversion rates for current model pricing (or
  whether to use approximate ranges that stay valid across pricing
  changes)
- Whether analytics-workspace task briefings should be mandatory or
  only for tasks above a complexity threshold
- Whether the orchestrator tracks cumulative token costs across a
  sprint or just per-story
- How token cost reporting works when multiple agents are dispatched
  per story (sum of all dispatches? breakdown by agent?)

## Verification Criteria

- Sprint plan briefing has concrete topology translation examples
- Session summary briefing has evaluation findings translation examples
- Token costs appear in both session summary and retro briefings with
  model tier breakdown
- Spec briefing has technical language guidance
- Analytics-workspace has task plan and task outcome briefing formats
- Briefing principles reference Domain Language
- Integration templates reflect all changes
- No contradictions between briefing files (the old "no token counts"
  conflict is resolved)
- No smell test violations
