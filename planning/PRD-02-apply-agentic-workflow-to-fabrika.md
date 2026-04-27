# PRD-02: Apply Agentic-Workflow to Canonical Fabrika

**Version target:** 0.11.0
**Dependencies:** PRD-01
**Execution method:** Current SYSTEM-UPDATE.md protocol (last time —
after this, Fabrika uses its own agentic-workflow process)

## Problem Statement

Fabrika is maintained using a manual SYSTEM-UPDATE.md protocol where the
orchestrating agent does everything: plans, implements, and then spins
up a single sub-agent for verification. This contradicts the pure
orchestrator principle that the rest of the roadmap is built on. Fabrika
should eat its own cooking — it should be an agentic-workflow project
that uses the agent model it defines.

## Solution

Configure canonical Fabrika as an agentic-workflow project (structural
mode only, no operational component). Adapt SYSTEM-UPDATE.md to dispatch
work to agents: planner for planning, implementer for execution,
reviewer/validator for verification.

After this PRD lands, all subsequent PRDs (03-10) execute through
Fabrika's own agentic-workflow process rather than the legacy
SYSTEM-UPDATE protocol.

## Key Decisions (Already Aligned)

- Structural mode only — no daily/weekly/monthly operational cadences
- Full 7-step protocol for all changes to canonical files
- The orchestrator's role becomes: facilitate alignment with the owner
  (Design Alignment), dispatch to agents, synthesize results, present
  to owner
- Existing SYSTEM-UPDATE.md gets replaced or significantly rewritten
  to reflect agent-dispatched workflow
- Fresh-chat boundaries remain — each step that benefits from clean
  context gets its own chat

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `.fabrika/manifest.yml` (or equivalent) | Fabrika's own project manifest declaring type: agentic-workflow |

### Modified files

| File | Change |
|---|---|
| `SYSTEM-UPDATE.md` | Rewrite to use agent dispatch model. Step 1 (Plan) uses planner agent. Step 3 (Execute) dispatches to implementer. Step 4 (Verify) dispatches to reviewer + validator independently. Steps 2, 5, 6 remain orchestrator responsibilities (alignment, feedback incorporation, presentation). |
| `CLAUDE.md` (project-level, gitignored) | Update to reflect Fabrika as an agentic-workflow project. Add agent dispatch instructions for system updates. |
| `VERSION` | 0.11.0 |
| `CHANGELOG.md` | Entry for 0.11.0 |

### What does NOT change

- The 7-step protocol structure itself — plan, align, execute, verify,
  incorporate, present, ship. This is sound. What changes is WHO does
  each step (agents instead of the orchestrator doing everything).
- The verification checklist in SYSTEM-UPDATE.md — still valid, now
  given to reviewer/validator agents as dispatch context.

## Open Items (To Resolve During Execution)

- Whether Fabrika needs a `.fabrika/manifest.yml` or if the project-level
  CLAUDE.md is sufficient (since Fabrika is not a consumer of itself)
- Exactly which existing agents get Fabrika-specific adaptations vs.
  which work as-is (e.g., does the planner need to understand Fabrika's
  versioning discipline, or is that in the dispatch context?)
- How to handle the transition — PRDs 01-02 use the old protocol,
  PRDs 03+ use the new one. Need a clean handoff point.
- Whether SYSTEM-UPDATE.md should be renamed to align with the
  agentic-workflow structural update workflow naming

## Verification Criteria

- Fabrika is configured as an agentic-workflow project
- SYSTEM-UPDATE.md (or replacement) dispatches to agents, not the
  orchestrator
- The verification step uses independent sub-agents (reviewer +
  validator), not a single generic verifier
- The protocol still produces all required artifacts (CHANGELOG,
  VERSION, MIGRATIONS)
- CLAUDE.md reflects the new workflow
- Smell tests pass
