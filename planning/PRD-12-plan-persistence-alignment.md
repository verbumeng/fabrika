# PRD-12: Plan Persistence Alignment

**Version target:** TBD
**Dependencies:** PRD-03 (implementer archetype — defines implementer
dispatch contracts), PRD-10 (wiki — captures the design rationale
for this change)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

The three project types handle planning artifacts inconsistently.
Sprint-based projects persist specs as files at
`docs/plans/[TICKET]-spec.md`. Analytics-workspace projects persist
briefs and plans as files at `tasks/[date]/brief.md` and
`tasks/[date]/plan.md`. But agentic-workflow projects keep the aligned
plan in the conversation only — the workflow-planner's output contract
explicitly says "structured plan in the conversation (not a separate
file)."

This creates three concrete problems:

1. **The implementation contract is ephemeral.** The context-engineer
   receives "the approved plan" as a dispatch field, but that refers to
   something that only exists in conversation history. If the
   conversation is compressed or the context window fills, the plan
   degrades. Sprint-based and analytics-workspace implementers receive
   a file path — a stable, complete reference.

2. **Validators cannot independently assess against the plan.** The
   methodology-reviewer, structural-validator, and context-architect all
   receive "the approved plan" in their strict dispatch. But strict
   dispatch is supposed to give verifiers exactly what they need to form
   independent judgment — not a reference to ephemeral conversation
   content. In sprint-based projects, the product-manager's validation
   mode reads the spec file and independently verifies the
   implementation matches. Agentic-workflow verifiers have no equivalent
   stable artifact.

3. **Alignment feedback doesn't persist.** When the owner pushes back
   on a sprint-based spec during review, the orchestrator re-invokes the
   product-manager, the spec file gets revised in place, and the
   approved version is what's committed. For agentic-workflow projects,
   the owner pushes back, the orchestrator adjusts in conversation, but
   the delta between the original plan and what was actually agreed to
   exists only in the chat. The design rationale for why the plan
   changed — the most valuable part — evaporates.

The general principle is: every project type should have a strict,
persistent plan that captures what was aligned on, that is handed to
the implementer as the implementation contract, and that validators
and reviewers assess the implementation against. This contract pattern
should be consistent across all project types.

## Solution

Align the agentic-workflow planning artifact lifecycle with the
pattern already established by sprint-based and analytics-workspace
projects.

### What Changes

**Workflow-planner output contract:** Change from "structured plan in
the conversation (not a separate file)" to a persistent file. The
workflow-planner writes its plan to a file, analogous to how the
product-manager writes specs and the analysis-planner writes briefs
and plans.

**Alignment feedback loop:** When the owner pushes back on the plan,
the orchestrator re-invokes the workflow-planner with the feedback.
The workflow-planner revises the plan file. This matches how
sprint-based projects handle spec revision — the planner revises,
not the orchestrator.

**Implementation dispatch:** The context-engineer's dispatch contract
changes from receiving "the approved plan" (conversation reference)
to receiving a file path to the approved plan. Same pattern as the
software-engineer receiving a path to the approved spec.

**Verification dispatch:** The methodology-reviewer, structural-
validator, and context-architect receive the plan file path in their
strict dispatch, not a conversation reference. They can read the
complete, unmodified plan and form independent judgment — the same
independence that sprint-based reviewers get from reading the spec
file.

### Where Plans Live

The plan file location should be analogous to where other project
types put their plans:

- Sprint-based: `docs/plans/[TICKET]-spec.md`
- Analytics-workspace: `tasks/[date]/brief.md` and `plan.md`
- Agentic-workflow: needs a convention. Candidate:
  `docs/plans/[identifier]-plan.md` (reuses the same `docs/plans/`
  directory as sprint-based, with a naming convention that
  distinguishes plans from specs)

For Fabrika itself as an agentic-workflow project, the `planning/`
directory already exists with PRDs (which are pre-alignment change
requests). The aligned plan would be a new artifact type alongside
the PRDs — the PRD describes what was proposed, the plan captures
what was agreed.

### Consistency Principle

After this change, all three project types follow the same pattern:

```
[Change request] → [Planner writes plan file] → [Owner reviews]
  → [Owner pushes back] → [Re-invoke planner to revise file]
  → [Owner approves] → [Implementer receives file path]
  → [Validators assess against file]
```

The specific planner, file location, and naming convention vary by
project type, but the lifecycle is identical.

## Key Decisions (To Be Aligned)

These are proposed — the owner should confirm or revise during
alignment.

- **Plan file lives in `docs/plans/` for consumer agentic-workflow
  projects.** This keeps plans co-located with sprint-based specs.
  Alternative: a separate directory like `plans/` at repo root. The
  `docs/plans/` approach is simpler and avoids adding another
  top-level directory.

- **Re-invoke the planner for revisions, don't let the orchestrator
  edit the file directly.** This preserves the separation of concerns:
  the planner plans, the orchestrator orchestrates. The orchestrator
  passes feedback to the planner, the planner produces the revision.
  Same as sprint-based.

- **Plan files persist after execution.** They become validation
  artifacts and historical records, analogous to how specs persist in
  `docs/plans/` after implementation. Future sessions can read the
  plan to understand what was intended.

- **Plan file format is structured markdown** with sections matching
  the workflow-planner's current output structure: file change
  inventory, integration point analysis, risk identification,
  mitigations, version bump determination. Adding YAML frontmatter
  (status: draft/approved, created date) aligns with the spec format.

## Scope: What Changes

### Modified files

| File | Change |
|---|---|
| `core/agents/workflow-planner.md` | Change output contract from conversation-only to file-based. Add file path convention. Update planning procedure to write to file instead of conversation. |
| `core/workflows/agentic-workflow-lifecycle.md` | Update Step 1 (Plan) to reference plan file creation. Update Step 2 (Align) to describe plan file revision via planner re-invocation. Update Steps 4-5 (Verify/Incorporate) to reference plan file path in dispatch. |
| `core/workflows/dispatch-protocol.md` | Update workflow-planner output contract. Update context-engineer dispatch contract (plan field becomes file path). Update methodology-reviewer, structural-validator, and context-architect dispatch contracts (plan field becomes file path). |
| `core/Document-Catalog.md` | Add system update plan to the agentic-workflow Quick Reference (currently listed as "in conversation" — becomes a file). |
| `integrations/claude-code/CLAUDE.md` | Update agentic-workflow lifecycle summary to reflect plan-as-file. |
| `integrations/copilot/copilot-instructions.md` | Parallel update. |
| `VERSION` | Bump (minor — core changes). |
| `CHANGELOG.md` | Entry for the new version. |

### What does NOT change

- Sprint-based spec lifecycle (already correct)
- Analytics-workspace brief/plan lifecycle (already correct)
- Agent prompts other than workflow-planner (reviewers and validators
  already accept "approved plan" as a dispatch field — the change is
  that it becomes a file path instead of a conversation reference)
- Consumer project structure (the `docs/plans/` directory already
  exists in sprint-based projects; adding agentic-workflow plans to it
  is additive)

## Terminology Issue: Fabrika's "PRDs"

This PRD also addresses a terminology confusion specific to canonical
Fabrika. The documents in `planning/` are called "PRDs" but they
function as stories — individual change requests, not product
requirement documents. In sprint-based projects, PRDs are high-level
feature descriptions that decompose into stories which expand into
specs. Fabrika's "PRDs" skip straight to the story level.

This creates confusion because "PRD" means something different in
Fabrika's own repo than it does in the methodology Fabrika teaches.
Options to resolve:

1. **Rename to "stories"** — Accurate to their function. Fabrika's
   change requests are stories that get expanded into plans (just like
   sprint-based stories get expanded into specs). The `planning/`
   directory becomes a story backlog.

2. **Rename to "change requests"** — More neutral. Acknowledges they
   are inputs to the planning process without implying a specific
   abstraction level.

3. **Keep "PRD" but acknowledge the distinction** — Document that
   Fabrika uses "PRD" as shorthand for a change request, not in the
   sprint-based sense. Least disruptive but perpetuates the confusion.

The owner should decide which approach to take during alignment. The
rename (if chosen) would be a mechanical find-and-replace across the
planning directory and any references to it.

## Open Items (To Resolve During Execution)

- Whether Fabrika itself should backfill aligned plans from previously
  executed PRDs (historical plan artifacts would require reconstructing
  alignment decisions from CHANGELOG entries and wiki topics)
- Whether the plan file should include an "alignment history" section
  capturing what changed from the initial plan and why (this would be
  the persistent home for the design rationale that currently
  evaporates)
- How the plan file interacts with the wiki — should the wiki's
  workflow-design topic reference specific plan files as sources, or
  synthesize across them?
- The naming convention for Fabrika's own plan files (currently PRDs
  use `PRD-XX-name.md` — plans would need their own convention)

## Verification Criteria

- Workflow-planner writes plan to a file, not the conversation
- Owner alignment feedback triggers planner re-invocation (not
  orchestrator direct edit)
- Context-engineer dispatch contract references a file path
- All three verification agents receive plan file path in strict
  dispatch
- Plan file persists after execution
- Pattern is consistent with sprint-based spec lifecycle
- Document-Catalog reflects the new artifact type
- Integration templates reflect the change
- No regression to sprint-based or analytics-workspace plan handling
