# Execution Prompt — Phase 2

Copy and paste the prompt below into a fresh Claude Code chat to
execute each CR. Replace `[NN]` and `[slug]` with the CR number and
filename slug.

---

## Execution Prompt

```
I'm executing a planned change request for Fabrika. Read the following
files to get full context:

1. planning/ROADMAP-v2.md — the Phase 2 roadmap, design philosophy,
   execution order, and design evolution notes
2. planning/CR-[NN]-[slug].md — the specific CR we're executing
3. CLAUDE.md — project-level instructions (Fabrika is an
   agentic-workflow project)
4. core/workflows/agentic-workflow-lifecycle.md — the structural
   update protocol to follow

The roadmap contains the execution order and through-line for all
Phase 2 CRs — read it before starting. It also has design evolution
notes from prior CR execution sessions that may affect this CR.

The CR has "Design Decisions to Align" — resolve these with me during
Step 2 (Align) before executing. If the CR has "Alignment Notes" from
prior sessions, treat those decisions as already resolved.

If a system update plan already exists at docs/plans/CR-[NN]-plan.md,
read it — it may contain resolved decisions and scope boundaries from
a prior alignment session. Confirm the plan with me (Step 2) before
proceeding to execution (Step 3).

You are the ORCHESTRATOR. You do NOT implement, plan, or verify
directly. Your job is to:
- Dispatch subagents (via the Agent tool) for each lifecycle step
- Align with me (the owner) at Step 2 and Step 6
- Handle shipping mechanics at Step 7

For every step that specifies an agent, use the Agent tool to spawn
a subagent with the appropriate dispatch payload from
core/workflows/dispatch-protocol.md. Specifically:
- Step 1: Spawn a workflow-planner subagent to produce the plan
- Step 2: YOU present the plan to me (this is your job)
- Step 3: Spawn an agentic-engineer subagent to execute the plan
- Step 4: Spawn three verifier subagents in parallel
- Step 5: Spawn the agentic-engineer again with verification reports
- Step 6: YOU present the results to me
- Step 7: YOU handle commit, PR, merge, wiki

Never read files and make changes yourself. The orchestrator
orchestrates — it does not do the work.

Start with Step 1: spawn the workflow-planner to produce the
implementation plan. Then present it to me for approval.
```

---

## CR Filenames Reference

The execution order is defined in ROADMAP-v2.md. This table maps CR
numbers to filenames for the prompt above.

| CR | Filename |
|---|---|
| 17 | `CR-17-task-workspace-project-type.md` |
| 28 | `CR-28-workflow-folder-terminology-cleanup.md` |
| 20 | `CR-20-context-compaction-principle.md` |
| 18 | `CR-18-complexity-tiers-sprint-work.md` |
| 19 | `CR-19-adhoc-workflow.md` |
| 21 | `CR-21-freshness-aware-context.md` |
| 22 | `CR-22-agents-as-composable-skills.md` |
| 23 | `CR-23-data-engineering-workflow-realism.md` |

---

## Between CRs

After each CR completes (merged to main), verify version bump and
CHANGELOG before starting the next. Each subsequent chat should see
the changes from prior CRs in the codebase.

If a CR execution reveals something that changes a downstream CR,
update the downstream CR file in the planning/ directory before
starting that chat. This happened extensively during the CR-17
alignment session — check the design evolution notes in ROADMAP-v2.md
for context.
