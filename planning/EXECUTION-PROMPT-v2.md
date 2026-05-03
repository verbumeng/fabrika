# Execution Prompt — Phase 2

Copy and paste the prompt below into a fresh Claude Code chat to
execute each CR. Replace `[NN]` and `[slug]` with the CR number and
filename slug.

---

## Execution Prompt

```
Execute CR-[NN]. The CR is at planning/CR-[NN]-[slug].md.
Read planning/ROADMAP-v2.md for Phase 2 through-line context.
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
