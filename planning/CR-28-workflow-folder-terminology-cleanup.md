# CR-28: Workflow Folder and Terminology Cleanup

**Version target:** TBD (minor bump — renames and reorganizes files
in core/workflows/)
**Dependencies:** CR-17 (base workflow establishes naming precedent),
CR-22 (composable skills may affect terminology further — but CR-28
should ship first to clean the foundation)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

The `core/workflows/` directory has grown organically through Phase 1
and now mixes two conceptually distinct things:

1. **Workflow type definitions** — the main multi-agent patterns a
   project adopts. These are the primary abstraction in the Phase 2
   compositional model. Currently:
   - `analytics-workspace.md` (task-based workflow type)
   - `agentic-workflow-lifecycle.md` (methodology-based workflow type)
   - `development-workflow.md` (sprint-based workflow type)
   - `task-workspace.md` (base workflow type, added in CR-17)

2. **Supporting processes** — protocols, procedures, and reference
   documents used within or across workflow types. Currently:
   - `dispatch-protocol.md` — how agents get dispatched
   - `design-alignment.md` — requirements gathering subprocess
   - `sprint-lifecycle.md` — sprint ceremony coordination
   - `doc-triggers.md` — when documents get created
   - `hooks-reference.md` — hook definitions
   - `knowledge-pipeline.md` — wiki knowledge flow
   - `knowledge-synthesis.md` — wiki synthesis procedure
   - `progress-files.md` — progress tracking
   - `task-promotion.md` — task promotion patterns
   - `token-estimation.md` — token cost estimation
   - `analytics-onboarding.md` — analytics onboarding subprocess

These live side-by-side with no organizational distinction. As
workflows become the primary design abstraction (Phase 2), this flat
structure creates confusion:

- A reader looking for "what workflow types exist" must scan 14 files
  to find the 4 that are workflow definitions.
- New workflow types added in future CRs will push the ratio further
  toward noise.

### Naming Inconsistency

Two workflow type files use "lifecycle" in their name:
- `agentic-workflow-lifecycle.md`
- `sprint-lifecycle.md`

Two do not:
- `analytics-workspace.md`
- `task-workspace.md` (CR-17)

The "lifecycle" suffix is confusing because it conflates the workflow
pattern (what agents do and in what order) with the broader project
lifecycle. The agentic-workflow lifecycle IS a workflow — calling it a
lifecycle doesn't distinguish it from anything. The sprint lifecycle
is less clearly a workflow type definition — it describes the
multi-chat cycle (Design Alignment -> Sprint Planning -> Story chats
-> Sprint Close-Out -> Maintenance -> Retro) which is more of a
coordination protocol than an agent dispatch pattern.

This matters now because:
- Phase 2 elevates "workflow type" to the primary abstraction
- CR-22 will formalize the relationship between skills and workflows
- Every new workflow type added (CRs 18, 19) will face the same
  naming question
- Domain-Language.md now defines "workflow type" as a first-class
  term — the files should match the vocabulary

## Solution Direction

### Option A: Subdirectory Split

Reorganize `core/workflows/` into two subdirectories:

```
core/workflows/
  types/                              <- Workflow type definitions
    task-workspace.md                 <- Base workflow (CR-17)
    analytics-workspace.md            <- Analytics workflow
    agentic-workflow.md               <- Agentic workflow (renamed)
    sprint-workflow.md                <- Sprint workflow (renamed)
  protocols/                          <- Supporting processes
    dispatch-protocol.md
    design-alignment.md
    sprint-coordination.md            <- renamed from sprint-lifecycle
    doc-triggers.md
    hooks-reference.md
    knowledge-pipeline.md
    knowledge-synthesis.md
    progress-files.md
    task-promotion.md
    token-estimation.md
    analytics-onboarding.md
```

**Pros:** Clear structural distinction. A reader immediately knows
where to find workflow types vs. supporting processes. Scales well as
more workflow types are added.

**Cons:** Breaks every cross-reference to these files across the
entire repo. Agent prompts, AGENT-CATALOG, CLAUDE.md template,
copilot-instructions, BOOTSTRAP, Domain-Language — all reference
`core/workflows/[name].md`. The migration surface is large. Risk of
missing a reference is high.

### Option B: Naming Convention (No Move)

Keep all files in `core/workflows/` but establish a naming convention
that makes the distinction clear:

- Workflow type definitions: no suffix, just the type name
  (`task-workspace.md`, `analytics-workspace.md`,
  `agentic-workflow.md`, `sprint-workflow.md`)
- Supporting processes: descriptive names that signal their nature
  (already mostly fine — `dispatch-protocol.md`, `design-alignment.md`,
  etc.)
- Rename the two inconsistent files:
  - `agentic-workflow-lifecycle.md` -> `agentic-workflow.md`
  - `sprint-lifecycle.md` -> `sprint-coordination.md` (or
    `sprint-workflow.md` if it's actually a workflow type)

Add a README.md or comment block at the top of the directory
documenting the distinction.

**Pros:** Smaller blast radius — only the renamed files need cross-
reference updates. Naming convention is self-documenting.

**Cons:** Flat directory still requires the reader to know the
convention. Less discoverable than subdirectories.

### Option C: Hybrid — Subdirectory + Redirects

Subdirectory split (Option A) with backward-compatible redirects:
leave stub files at the old paths that say "This file moved to
[new path]" for one version, then remove in the next.

**Pros:** Clean organization AND migration path.

**Cons:** Temporary file duplication. Consumer projects that don't
update will have stale references.

### Recommendation: Option A

The subdirectory split is the right long-term structure. Yes, the
cross-reference update surface is large — but:

1. Fabrika already has structural-validator machinery to catch broken
   cross-references (Step 4 of the lifecycle). This is exactly the
   kind of change it exists for.
2. The blast radius is well-defined: every file that references a
   `core/workflows/*.md` path needs to be checked. This is mechanical
   work, not design work.
3. Phase 2 is actively adding workflow types. Getting the structure
   right now avoids repeated reorganization later.
4. Consumer projects need a MIGRATIONS.md entry either way (for
   renames or moves). The consumer cost is similar.

## Scope

### New files

| File | Purpose |
|------|---------|
| `core/workflows/types/` (directory) | Contains workflow type definitions |
| `core/workflows/protocols/` (directory) | Contains supporting processes |
| `core/workflows/README.md` | Documents the distinction between types and protocols |

### Moved/renamed files

| Current path | New path | Rationale |
|-------------|----------|-----------|
| `core/workflows/task-workspace.md` | `core/workflows/types/task-workspace.md` | Workflow type |
| `core/workflows/analytics-workspace.md` | `core/workflows/types/analytics-workspace.md` | Workflow type |
| `core/workflows/agentic-workflow-lifecycle.md` | `core/workflows/types/agentic-workflow.md` | Workflow type; drop "lifecycle" suffix |
| `core/workflows/development-workflow.md` | `core/workflows/types/sprint-workflow.md` | Workflow type; rename to match pattern |
| `core/workflows/dispatch-protocol.md` | `core/workflows/protocols/dispatch-protocol.md` | Supporting process |
| `core/workflows/design-alignment.md` | `core/workflows/protocols/design-alignment.md` | Supporting process |
| `core/workflows/sprint-lifecycle.md` | `core/workflows/protocols/sprint-coordination.md` | Supporting process; rename to clarify role |
| `core/workflows/doc-triggers.md` | `core/workflows/protocols/doc-triggers.md` | Supporting process |
| `core/workflows/hooks-reference.md` | `core/workflows/protocols/hooks-reference.md` | Supporting process |
| `core/workflows/knowledge-pipeline.md` | `core/workflows/protocols/knowledge-pipeline.md` | Supporting process |
| `core/workflows/knowledge-synthesis.md` | `core/workflows/protocols/knowledge-synthesis.md` | Supporting process |
| `core/workflows/progress-files.md` | `core/workflows/protocols/progress-files.md` | Supporting process |
| `core/workflows/task-promotion.md` | `core/workflows/protocols/task-promotion.md` | Supporting process |
| `core/workflows/token-estimation.md` | `core/workflows/protocols/token-estimation.md` | Supporting process |
| `core/workflows/analytics-onboarding.md` | `core/workflows/protocols/analytics-onboarding.md` | Supporting process |

### Modified files (cross-reference updates)

Every file that references a `core/workflows/*.md` path needs its
references updated. The exhaustive list must be determined during
planning (Step 1 of the lifecycle), but the known high-impact files
are:

- All agent prompts in `core/agents/` that reference workflow files
- `core/agents/AGENT-CATALOG.md` — workflow file references
- `core/Document-Catalog.md` — workflow file references
- `BOOTSTRAP.md` — workflow file references throughout
- `ADOPT.md` — workflow file references
- `CLAUDE.md` (project-level, gitignored) — workflow file references
- `Domain-Language.md` — workflow file path references
- `integrations/claude-code/CLAUDE.md` — workflow file references
- `integrations/copilot/copilot-instructions.md` — workflow references
- `wiki/topics/*.md` — any topics referencing workflow files
- `planning/EXECUTION-PROMPT-v2.md` — workflow lifecycle reference
- `CHANGELOG.md` — historical references (leave as-is, they describe
  the state at that version)

### What does NOT change

- Agent prompts content (no behavioral changes to any agent)
- Workflow type definitions content (only file paths change, not
  substance)
- Supporting process content (only file paths change)
- The agentic-workflow lifecycle's 7-step protocol (unchanged)
- Sprint-based workflow structure (unchanged)
- analytics-workspace workflow structure (unchanged)

## Design Decisions to Align

1. **Option A vs B vs C?** The recommendation is Option A (subdirectory
   split). Option B (naming convention only) is lighter but less
   discoverable. Option C (hybrid with redirects) adds temporary
   complexity. The owner should weigh blast radius vs. long-term
   clarity.

2. **What to call `sprint-lifecycle.md`?** It currently describes the
   multi-chat cycle (Design Alignment -> Sprint Planning -> Story
   chats -> Sprint Close-Out -> Maintenance -> Retro). Is this a
   "workflow type" definition (like analytics-workspace.md describes
   the task workflow) or a "coordination protocol" (like dispatch-
   protocol.md describes how agents are invoked)?

   If it's a workflow type: move to `types/sprint-workflow.md` and
   merge with or replace `development-workflow.md`.

   If it's a coordination protocol: move to
   `protocols/sprint-coordination.md`.

   **Recommendation:** The sprint lifecycle is a coordination protocol.
   The actual sprint workflow type definition is `development-workflow.md`
   (which describes what agents do during a story). The sprint lifecycle
   describes the multi-chat orchestration pattern AROUND stories —
   when to start a new chat, what happens between sprints, how phases
   connect. That's coordination, not workflow. Move it to
   `protocols/sprint-coordination.md`.

3. **What about `development-workflow.md`?** Its current name doesn't
   follow the `[type]-workspace.md` or `[type]-workflow.md` pattern.
   Should it become `sprint-workflow.md`? Or should it stay as-is
   since not all workflow types use the same naming pattern?

   **Recommendation:** Rename to `sprint-workflow.md`. The pattern
   should be consistent: `task-workspace.md`,
   `analytics-workspace.md`, `sprint-workflow.md`,
   `agentic-workflow.md`. The "-workspace" vs "-workflow" suffix
   distinguishes task-based types (workspaces, no sprints) from
   sprint-based and methodology-based types (workflows with more
   ceremony). Or — if we want full consistency — consider whether
   everything should just be `[type].md` with no suffix. This is an
   alignment decision.

4. **Should CHANGELOG historical references be updated?** Old
   CHANGELOG entries reference `core/workflows/agentic-workflow-
   lifecycle.md` and similar paths. These were accurate at the time.
   **Recommendation:** Leave historical CHANGELOG entries as-is.
   They describe what the state WAS at that version.

5. **Execution order relative to other Phase 2 CRs.** CR-28 touches
   every file that references a workflow path. If executed after CRs
   18-19 (which add more workflow references), the cross-reference
   update surface grows. If executed immediately after CR-17, fewer
   files reference the new paths.

   **Recommendation:** Execute immediately after CR-17 (as the owner
   suggested). This means the execution order becomes: CR-17, CR-28,
   CR-20, CR-18, CR-19, CR-21, CR-22, CR-23. All subsequent CRs
   benefit from the clean structure and never learn the old paths.

## Verification Criteria

- All files in `core/workflows/types/` are workflow type definitions
  (and ONLY workflow type definitions)
- All files in `core/workflows/protocols/` are supporting processes
  (and ONLY supporting processes)
- No file references a `core/workflows/[old-name].md` path that no
  longer exists (grep the entire repo)
- `core/workflows/README.md` documents the distinction clearly
- Domain-Language.md definitions for workflow-related terms reference
  the correct new paths
- Agent prompts that reference workflow files point to the new paths
- Integration templates reference the new paths
- BOOTSTRAP.md references the new paths
- MIGRATIONS.md entry documents exactly what consumers need to do
  (rename their local copies)
- Consumer update instructions in CHANGELOG are complete — every moved
  file is listed with old and new path
