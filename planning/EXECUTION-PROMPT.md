# Execution Prompt Template

Copy and paste this prompt into a fresh Claude Code chat to execute
each PRD. Replace `[XX]` and `[description]` with the actual PRD number
and short description.

---

## For PRD-01 and PRD-02 (Bootstrap — uses current SYSTEM-UPDATE.md)

```
I'm executing a planned system update to Fabrika. Read the following
files to get full context:

1. planning/ROADMAP.md — the overall roadmap and sequencing
2. planning/PRD-01-agentic-workflow-project-type.md — the specific
   PRD we're executing
3. SYSTEM-UPDATE.md — the protocol to follow

This PRD was produced during an alignment session where the owner and
I reached agreement on all key decisions. The "Key Decisions" section
in the PRD captures what was already aligned — do not re-litigate those.
The "Open Items" section lists things we acknowledged need resolution
during execution — those are fair game for discussion.

Execute this PRD following SYSTEM-UPDATE.md step by step. Start with
Step 1 (Plan) — produce the detailed implementation plan based on the
PRD, then present it for my approval before proceeding to execution.
```

For PRD-02, change the filename to
`planning/PRD-02-apply-agentic-workflow-to-fabrika.md`.

---

## For PRDs 03-10 (Uses agentic-workflow process)

```
I'm executing a planned system update to Fabrika. Read the following
files to get full context:

1. planning/ROADMAP.md — the overall roadmap and sequencing
2. planning/PRD-[XX]-[description].md — the specific PRD we're
   executing
3. SYSTEM-UPDATE.md — the protocol to follow (should reflect the
   agentic-workflow process after PRD-02 landed)

This PRD was produced during an alignment session where the owner and
I reached agreement on all key decisions. The "Key Decisions" section
in the PRD captures what was already aligned — do not re-litigate those.
The "Open Items" section lists things we acknowledged need resolution
during execution — those are fair game for discussion.

Execute this PRD following the system update protocol step by step.
Start with Step 1 (Plan) — produce the detailed implementation plan
based on the PRD, then present it for my approval before proceeding
to execution.
```

---

## PRD Filenames Reference

| PRD | Filename |
|---|---|
| 01 | `PRD-01-agentic-workflow-project-type.md` |
| 02 | `PRD-02-apply-agentic-workflow-to-fabrika.md` |
| 03 | `PRD-03-implementer-archetype-pure-orchestrator.md` |
| 04 | `PRD-04-architect-archetype.md` |
| 05 | `PRD-05-design-alignment-project-charter-prd.md` |
| 06 | `PRD-06-domain-language.md` |
| 07 | `PRD-07-tdd-integration.md` |
| 08 | `PRD-08-briefing-system-improvements.md` |
| 09 | `PRD-09-wiki-knowledge-layer-consumer-projects.md` |
| 10 | `PRD-10-wiki-knowledge-layer-canonical-fabrika.md` |

---

## Between PRDs

After each PRD completes (merged to main), verify that the version
bump and CHANGELOG are correct before starting the next PRD. Each
subsequent chat should see the changes from prior PRDs in the codebase.

If a PRD execution reveals something that changes a downstream PRD,
update the downstream PRD file in the planning/ directory before
starting that chat.
