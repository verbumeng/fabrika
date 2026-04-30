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
7. **Agentic-workflow briefing coverage** — agentic-workflow lifecycle
   references "follow briefing principles" at Steps 2 and 6 but has no
   dedicated briefing format files. Sprint-based and analytics-workspace
   types have structured formats; agentic-workflow does not.
8. **Domain Language not yet connected to briefings** — jargon
   glossaries are invented ad hoc rather than drawn from the living
   Domain Language document

## Solution

Targeted improvements to existing briefing files plus new coverage for
analytics-workspace and agentic-workflow. No new archetypes or major
workflow changes — this is a refinement release.

### Specific Fixes

**1. Topology translation examples (sprint-plan-briefing.md):**
Add concrete before/after examples showing how to translate topology
choices into plain language:
- NOT: "We chose mesh topology because stories don't share state"
- YES: "Each story can be worked independently because they modify
  different parts of the system — no one is waiting on anyone else"

Include examples for all three topologies (pipeline, mesh,
hierarchical).

**2. Evaluation findings translation (session-summary-briefing.md):**
Add example translations:
- NOT: "Test-writer flagged one edge case — empty datasets"
- YES: "The test writer found that if you feed the system with no data,
  it crashes instead of showing a friendly message — this has been fixed"

**3. Token efficiency in all story and retro briefings:**
Resolve the conflict by making token costs a standard briefing element
in BOTH post-story session summaries AND retro briefings. Use
approximate cost ranges at model tiers (high-end / mid-tier / economy)
rather than naming specific models — pricing and model names change.

Remove the "no token counts in owner summary" restriction from
session-summary-briefing.md. The owner explicitly wants this visibility.

Token cost format (canonical, defined in briefing-principles.md):

```
Token usage: [X] tokens
Approximate cost: ~$[high] at high-end / ~$[mid] at mid-tier / ~$[low] at economy tier
```

Always include a per-agent-role breakdown:

```
Breakdown: Planner ~$[X] | Implementer ~$[X] | Reviewer ~$[X] | Validator ~$[X]
```

For sprint retros: lead with sprint total prominently, then per-story
totals in the main table, then a drill-down detail section with
per-agent breakdown per story — structured so the detail is there but
visually subordinate to the headline numbers.

**4. Technical language guidance (spec-briefing.md):**
Add explicit instruction: when framing design alternatives, explain
in terms of user impact, not implementation technology. If technical
terminology is necessary for the owner to understand a trade-off,
define it in the jargon glossary AND add it to the Domain Language
document.

**5. Analytics-workspace briefing formats:**
Create briefing equivalents for analytics-workspace:
- Task plan briefing (after plan creation — what analysis approach was
  chosen, what data sources, cost estimate in plain terms)
- Task outcome briefing (after task delivery — what was found, why it
  matters, what to look at, per-agent token cost breakdown)

Briefings are always presented (not threshold-gated). For simple
tasks, the briefing is naturally short. The format ensures nothing is
missed, not that everything is verbose.

**6. Agentic-workflow briefing formats:**
Create briefing equivalents for agentic-workflow:
- Structural plan briefing (Step 2 Align — what the change does for
  the system, what's changing, open items with recommendations, what's
  NOT changing, execution order, jargon glossary)
- Change summary briefing (Step 6 Present — what changed, file-by-file
  summary, deviations from plan, verification results, implications for
  consumers, per-agent token cost breakdown, follow-up items)

**7. Domain Language integration (briefing-principles.md):**
Add instruction: when a Domain Language document exists, the jargon
glossary in briefings should draw from it. New terms introduced in a
briefing that aren't in the Domain Language should be flagged for
addition.

NOTE: This was largely implemented in 0.15.0. The briefing-principles
file already contains Domain Language integration text. Additional
work needed: add analytics-workspace and agentic-workflow briefing
pointers to the "When to Brief" section, and add a canonical token
cost format standard section.

## Key Decisions (Already Aligned)

- Token costs in both post-story AND retro briefings with model tier
  breakdown (high-end/mid-tier/economy) using approximate ranges, not
  specific model names
- Per-agent-role breakdown always shown in session summaries (not
  conditional on cost seeming high)
- Sprint retros: sprint total prominent, per-story totals in main
  table, per-agent breakdown as drill-down detail
- Technical language in spec briefings must be explained if used, and
  new jargon should be added to Domain Language
- Analytics-workspace needs briefing formats (lighter than sprint-based)
  — always presented, not threshold-gated
- Agentic-workflow needs briefing formats for Steps 2 (Align) and 6
  (Present) — codifying the informal pattern already used
- Domain Language is the source of truth for jargon definitions in
  briefings

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `core/briefings/task-plan-briefing.md` | Analytics-workspace: plain-language briefing after plan creation |
| `core/briefings/task-outcome-briefing.md` | Analytics-workspace: plain-language briefing after task delivery |
| `core/briefings/structural-plan-briefing.md` | Agentic-workflow: plain-language briefing at Step 2 (Align) |
| `core/briefings/change-summary-briefing.md` | Agentic-workflow: plain-language briefing at Step 6 (Present) |

### Modified files

| File | Change |
|---|---|
| `core/briefings/sprint-plan-briefing.md` | Add concrete topology translation examples (before/after) for all three topologies. |
| `core/briefings/session-summary-briefing.md` | Add evaluation findings translation examples. Add token efficiency section with model tier costs and per-agent breakdown. Remove "no token counts" restriction. |
| `core/briefings/retro-briefing.md` | Restructure token efficiency: sprint total prominent, per-story totals in main table, per-agent drill-down detail section. Add model tier cost format. |
| `core/briefings/spec-briefing.md` | Add technical language guidance — explain in user impact terms. New jargon → Domain Language. |
| `core/briefings/briefing-principles.md` | Add analytics-workspace and agentic-workflow briefing pointers to "When to Brief". Add canonical "Token Cost Reporting" standard section. |
| `core/workflows/analytics-workspace.md` | Add briefing steps to task lifecycle (plan briefing after plan, outcome briefing after delivery). |
| `core/workflows/agentic-workflow-lifecycle.md` | Add briefing references at Step 2 (structural plan briefing) and Step 6 (change summary briefing). |
| `integrations/claude-code/CLAUDE.md` | Update Owner Briefings section: add analytics-workspace and agentic-workflow briefing pointers, add token cost visibility note. |
| `integrations/copilot/copilot-instructions.md` | Same updates for Copilot parity. |
| `VERSION` | 0.17.0 |
| `CHANGELOG.md` | Entry for 0.17.0 |
| `MIGRATIONS.md` | Consumer migration: copy new briefing files, update existing briefing files, update workflow files and integration templates. |

## Open Items (Resolved During Alignment)

All open items were resolved during the alignment session:

1. **Token-to-cost conversion rates:** Use approximate ranges at model
   tiers (high-end / mid-tier / economy) without naming specific
   models. Pricing changes don't require a Fabrika patch.

2. **Analytics-workspace briefings mandatory or threshold-based:**
   Always present briefings. Depth scales naturally — simple tasks
   produce short briefings. Consistency over optionality.

3. **Cumulative token costs or per-story:** Per-story in session
   summaries, cumulative in retros. The retro's per-story table gets
   a cost column; the sum gives the sprint total.

4. **Multi-agent dispatch reporting:** Per-agent-role breakdown always
   shown in session summaries (not conditional). Sprint retros:
   sprint total and per-story totals prominent, per-agent breakdown
   as drill-down detail — structured so the detail is there but
   visually subordinate.

## Verification Criteria

- Sprint plan briefing has concrete topology translation examples for
  all three topologies
- Session summary briefing has evaluation findings translation examples
- Token costs appear in both session summary and retro briefings with
  model tier breakdown and per-agent-role breakdown
- Token cost format is defined canonically in briefing-principles.md
  and referenced (not restated) in individual briefing files
- Spec briefing has technical language guidance
- Analytics-workspace has task plan and task outcome briefing formats
- Agentic-workflow has structural plan and change summary briefing
  formats
- Analytics-workspace workflow references task briefings at Steps 2
  and 6
- Agentic-workflow lifecycle references briefings at Steps 2 and 6
- Briefing principles reference Domain Language and list all briefing
  formats (sprint-based, analytics-workspace, agentic-workflow)
- Integration templates reflect all changes (both CLAUDE.md and
  copilot-instructions.md list all 8 briefing formats)
- No contradictions between briefing files (the old "no token counts"
  conflict is resolved)
- No smell test violations
- VERSION matches CHANGELOG
- MIGRATIONS entry lists all new and changed files
