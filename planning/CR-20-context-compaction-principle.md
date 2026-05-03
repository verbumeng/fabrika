# CR-20: Context Compaction as Design Principle

**Version target:** TBD (patch or minor — extends design-principles.md
which CR-13 is creating, plus dispatch contract updates)
**Dependencies:** CR-13 (creates core/design-principles.md where this
will live), CR-18 (Deep Story tier's research phase is a compaction
boundary)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

Fabrika implicitly practices compaction at every phase boundary:
research produces a compressed document, specs compress intent into
structured form, evaluation reports compress reviewer findings into
actionable verdicts. But this is incidental rather than intentional.
Nothing in the framework names compaction as a principle, specifies
what "compressed" means at each boundary, or provides guardrails
against the two failure modes:

1. **Over-expansion.** An agent dumps raw file contents, full tool
   call outputs, or unfiltered search results into the context window.
   The next agent starts in the "dumb zone" — too much noise, too
   little signal.

2. **Under-compression.** A research document or spec is so terse
   that the next agent lacks the context to act correctly, requiring
   it to re-read files and re-discover what the previous phase already
   found.

The talk's framing (Dex Horthy, "No Vibes Allowed"): compaction is
THE meta-skill of effective AI workflows. Each phase transition
compresses the prior context so the next agent starts fresh in the
"smart zone" — past the 0% mark but well below the 40% mark where
quality degrades.

The key equation: better tokens in → better tokens out. Every context
window position is precious. The framework should enforce that agents
produce compressed outputs, not raw dumps.

## Solution Direction

Codify **compaction** as a named design principle in
`core/design-principles.md` (which CR-13 is already creating). Then
apply it concretely to dispatch contracts and agent output
specifications.

### The Principle

**Compaction:** Each phase transition in a workflow produces a
compressed artifact that is self-contained for the next phase. The
receiving agent should not need to re-read the sending agent's
inputs — only its outputs. Compaction preserves signal (what matters)
and discards noise (how it was found).

### Phase Boundaries Where Compaction Applies

| Transition | Input (raw) | Output (compressed) | What gets discarded |
|-----------|-------------|--------------------|--------------------|
| Research → Plan | Full file reads, search results, code exploration | Research document: findings, relevant file paths, line numbers, code snippets | Tool call outputs, dead-end explorations, irrelevant files read |
| Plan → Implement | Research doc, PRD/brief, architecture context | Spec/plan: exact steps, file paths, code snippets, acceptance criteria, test approach | Research document (spec is self-contained), PRD details not relevant to this story |
| Implement → Review | Full implementation context, trial-and-error | Diff + plan + brief | Implementation context (reviewer sees the result, not the journey) |
| Review → Revise | Full review analysis | Evaluation report: findings, severity, specific locations, suggested approach | Reviewer's internal reasoning about what to check |
| Revise → Re-review | Revision context, original review | Updated diff + original plan + prior review findings | Revision implementation context |

### Concrete Specifications

**Research output format constraints:**
- Must include: file paths with line numbers, code snippets (not full
  files), system behavior summary, relevant constraints/gotchas
- Must NOT include: full file contents, raw tool call outputs,
  exploration dead-ends, "I looked at X but it wasn't relevant"
- Target: fits comfortably in the next agent's context alongside its
  instructions and the task brief

**Spec/plan output format constraints:**
- Must be self-contained: a reader (human or agent) should understand
  what to do WITHOUT reading the research document
- Must include actual code snippets showing what will change (not
  just descriptions of changes)
- Must include acceptance criteria that are mechanically verifiable
- Must include the test approach for each change

**Evaluation report format constraints:**
- Must lead with the verdict (pass/fail/pass-with-notes)
- Must include specific file paths and line numbers for findings
- Must suggest approach for fixes (not just "this is wrong" but "fix
  by doing X")
- Must NOT include: general praise, restating what the code does,
  observations unrelated to quality

**Implementer revision context:**
- Receives: the review report + the original plan
- Does NOT receive: a summary of the review from the orchestrator
  (per CR-13 — the implementer reads reviews directly)
- The review report IS the compacted context for revision

### Integration with Sub-Agents

Sub-agents (research sub-agents, file-lookup sub-agents) are
themselves compaction tools. Their job is to explore a large space and
return a compressed result. The dispatch contract for any sub-agent
should specify:
- What the parent agent needs to know (the signal)
- What the sub-agent should discard (the noise)
- A target output size (rough guideline, not hard limit)

### Anti-Patterns to Document

1. **"Here's everything I found"** — Sub-agent returns full file
   contents instead of relevant excerpts.
2. **"Let me re-read the research"** — Implementer re-reads files
   that the research phase already summarized, because the research
   output wasn't self-contained.
3. **"The orchestrator will explain"** — Orchestrator creates its own
   summary of a reviewer's findings instead of passing the review
   report directly (CR-13 already fixes this).
4. **"I'll include this just in case"** — Agent includes context that
   "might be relevant" but isn't directly needed, burning context
   budget.

## Scope

### Modified files

| File | Change |
|------|--------|
| `core/design-principles.md` | Add Compaction principle (CR-13 creates this file; CR-20 adds to it) |
| `core/workflows/dispatch-protocol.md` | Add compaction guidance to dispatch contracts — specify output format constraints for each agent role |
| `core/workflows/development-workflow.md` | Note compaction boundaries at each phase transition |
| `core/workflows/analytics-workspace.md` | Same — note compaction at research → plan → implement boundaries |
| `core/workflows/task-workspace.md` | Same (if CR-17 lands first) |
| `core/workflows/adhoc-workflow.md` | Note that ad-hoc's lightweight nature IS compaction — minimal context by design (if CR-19 lands first) |
| `integrations/claude-code/CLAUDE.md` | Mention compaction as a design principle agents follow |
| `integrations/copilot/copilot-instructions.md` | Same |
| `Domain-Language.md` | Define compaction |
| `VERSION` | Bump |
| `CHANGELOG.md` | Entry |

### New files

None — this extends existing files, primarily design-principles.md.

### What does NOT change

- Agent prompts (agents don't need to know about the principle by
  name — the dispatch contracts and output format specs enforce it)
- Sprint lifecycle (compaction happens within stories, not between
  sprints)
- Topologies (orthogonal concern)
- Templates (the spec template already embodies compaction — this CR
  just names the principle)

## Design Decisions to Align

1. **Should there be hard token limits per output type?** E.g.,
   "research documents should be <2000 tokens." Leaning toward: no
   hard limits — quality of compression matters more than quantity.
   A guideline ("fits comfortably alongside agent instructions") is
   more useful than a number that varies by model and context window
   size.

2. **Should compaction be verifiable by a structural-validator?** I.e.,
   can we automatically check that a research document doesn't contain
   raw file dumps? Leaning toward: not in v1 — this is a principle
   for prompt authors and dispatch contract designers, not a runtime
   check. If it becomes a recurring problem, a validator could be
   added later.

3. **How does this interact with the wiki?** Wiki articles are
   themselves a form of compaction — synthesizing multiple task
   outcomes into reusable knowledge. Should the principle cover wiki
   synthesis? Leaning toward: mention it as an example of compaction
   at the knowledge layer, but don't prescribe wiki-specific
   constraints here.

4. **Should compaction be a separate principle or part of another
   principle?** CR-13 establishes design principles focused on the
   review-revise loop. Compaction is broader — it applies to every
   phase transition, not just revision. Leaning toward: its own
   principle in the same file, alongside the implementer-reviewer and
   implementer-validator pairings.

## Alignment Notes (CR-17 Execution Session, 2026-05-03)

13. **Compaction is one of several cross-cutting concerns that should
    not be bound to specific workflows.** Token estimation
    (`core/workflows/token-estimation.md`) is currently documented
    per-workflow-file: analytics-workspace mentions it twice,
    agentic-workflow-lifecycle mentions it once, and the new
    task-workflow initially omitted it entirely. This pattern — copying
    cross-cutting references into each workflow definition — doesn't
    scale. CR-20 should formalize compaction AND establish how
    cross-cutting concerns (compaction, token estimation, freshness,
    design alignment triggers) attach to workflows without being
    duplicated in each workflow file. This connects to CR-22's
    skill/process/workflow abstraction: cross-cutting concerns are
    procedures (SOPs) that exist alongside workflows, not inside them.

## Verification Criteria

- Compaction principle is documented in core/design-principles.md
  with a clear definition and examples
- Dispatch protocol specifies output format constraints for research
  outputs, specs/plans, evaluation reports, and sub-agent returns
- Development-workflow and analytics-workspace note compaction
  boundaries at phase transitions
- Anti-patterns are documented (what NOT to do)
- Domain-Language.md defines compaction
- No hard token limits imposed (guideline-based, not rule-based)
- Integration templates mention compaction as a governing principle
