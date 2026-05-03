# Sprint Coordination

A sprint runs across **multiple chats**, not one long conversation. Each phase boundary is a hard new-chat handoff. This is deliberate — see Sprint Coordination Hygiene below.

## Phases (in order)

```
Design Alignment chat (when triggered — new project, new phase, ambiguity)
    ↓ (alignment produces Charter + PRD, owner approves → prompts for new chat)
Sprint Planning chat
    ↓ (planning produces sprint file, contract, progress file → prompts for new chat)
Story 1 chat ─┐
Story 2 chat  │  (one chat per story; close-out prompts for next story chat)
...           │
Story N chat ─┘ (last story close-out prompts for sprint close-out chat)
    ↓
Sprint Close-Out (Merge) chat   → prompts for new chat: maintenance
    ↓
Maintenance chat                → prompts for new chat: retro
    ↓
Sprint Retro chat               → produces Sprint-XX-retro.md → prompts for new chat: next planning
    ↓
Next Sprint Planning chat (or Design Alignment if new phase begins)
```

**Design Alignment is a pre-planning phase** that runs when triggered — it is not part of every sprint cycle. See `core/workflows/protocols/design-alignment.md` for the full protocol. After alignment produces an approved Charter/PRD, the orchestrator prompts for a new chat to begin sprint planning.

**Four chats between sprints**: close-out merge, maintenance, retro, planning. They are not bundled.

## Cycle Phase Indicator

`STATUS.md` carries a `Cycle phase` field that any new chat reads during orientation to know where it is and what to do next. Allowed values:

- `alignment` — Design Alignment is in progress (pre-planning phase for new projects, new phases, or when ambiguity is detected)
- `planning` — sprint planning chat is in progress or just finished
- `story-in-progress` — a story chat is active or the previous story chat just closed (a non-last story)
- `sprint-close` — last story is approved; merge chat needs to run
- `maintenance` — merge done; maintenance chat needs to run
- `retro` — maintenance done; retro chat needs to run

## What Each Phase Chat Does

**Design Alignment chat (when triggered)** — The orchestrator runs the Design Alignment protocol (`core/workflows/protocols/design-alignment.md`). This is not a sub-agent dispatch — the orchestrator conducts the alignment conversation directly. Produces Charter (first time) + PRD. After owner approval, set `Cycle phase: planning` in STATUS.md. **Close-out prompt:** *"Charter and PRD approved. Start a new chat to invoke the scrum master for sprint planning."*

**Sprint Planning chat** — Invoke the scrum-master (coordinator) agent. Produces `Sprint-XX.md`, `Sprint-XX-contract.md`, `Sprint-XX-progress.md`, `features.json` entries, and external task system entries (if configured). Sets `Cycle phase: story-in-progress` in STATUS.md. **Close-out prompt:** *"Sprint planning complete. Open a new chat to start [TICKET] — [Story 1 title]."*

**Story chat (each)** — Standard Session Lifecycle. One story per chat. **Close-out prompt branches on whether more stories remain in the sprint:**
- More stories remain → set `Cycle phase: story-in-progress`. Prompt: *"Story [TICKET] complete and reviewed. Open a new chat to start [NEXT-TICKET] — [Next title]."*
- This was the last story → set `Cycle phase: sprint-close`. Prompt: *"Last sprint story is complete and reviewed. Open a new chat for sprint close-out (merge all sprint branches)."*

**Sprint Close-Out (Merge) chat** — Verify branch hygiene gate before doing anything else:
1. Working tree clean
2. All `feature/[PROJECT_KEY]-S-XXX-*` branches for this sprint either merged to `main` or explicitly deferred (deferral noted in `Sprint-XX-progress.md`)
3. `main` is the active branch
4. Archive any sprint-specific scratch files; ensure `Sprint-XX-progress.md` is final

Set `Cycle phase: maintenance` in STATUS.md. **Close-out prompt:** *"Sprint branches merged. Working tree clean. Open a new chat to run maintenance."*

**Maintenance chat** — Run the full checklist at `docs/02-Engineering/maintenance-checklist.md`. Tag git: `git tag maintenance-YYYY-MM-DD && git tag -f maintenance-latest`. Set `Cycle phase: retro` in STATUS.md. **Close-out prompt:** *"Maintenance complete. Open a new chat with the scrum-master to run the sprint retro."*

**Sprint Retro chat** — Invoke the scrum-master (coordinator) agent. It reads `Sprint-XX-progress.md`, the latest `docs/maintenance/*-YYYY-MM-DD.md` outputs, the previous sprint's retro file (if any), and writes `docs/04-Backlog/Sprints/Sprint-XX-retro.md` using `docs/Templates/Sprint-Retro-Template.md`. Present the retro to the owner using the **Retro Briefing** format (see briefing docs). Set `Cycle phase: planning` in STATUS.md. **Close-out prompt:** *"Retro file written at Sprint-XX-retro.md. Open a new chat with the scrum-master to plan the next sprint."*

**Next Sprint Planning chat** — Scrum-master orientation must read the previous sprint's retro file before proposing scope. The retro's "process changes for next sprint" items are inputs to planning, not optional reading.

## Sprint Coordination Hygiene (Why Fresh Chats Matter)

The phase boundaries are hard new-chat handoffs for three reasons:

1. **Context window stays clean.** A single chat that spans planning → 5 stories → maintenance → retro will accumulate hundreds of file reads and tool calls irrelevant to the current task. Fresh chats start with the orientation routine reading the small set of files actually needed.
2. **Fresh evaluator agents make better evaluators.** A code-reviewer that has already sat through three story implementations has anchored on patterns that are not necessarily good. A new chat re-invokes the agent against the rubric without that bias.
3. **Failure modes don't leak across stories.** If story 1 had a flaky test that got worked around, story 2 should not inherit "we ignore that test class." A new chat starts from STATUS.md and the sprint contract, not from the previous story's running context.

Do not "optimize" away the new-chat boundaries by combining phases. The friction is the feature.

---

## Knowledge Pipeline Cadence

When a project has a `wiki/` directory, the knowledge pipeline runs
at defined cadences tied to the sprint coordination phases. The pipeline
transforms scattered project artifacts into synthesized wiki
knowledge. For the full pipeline specification, see
`core/workflows/protocols/knowledge-pipeline.md`. For the step-by-step
maintenance procedure, see `core/workflows/protocols/knowledge-synthesis.md`.

| Cadence | Pipeline Phases | What Happens |
|---------|----------------|--------------|
| Per sprint (during maintenance) | Phases 1-2 (Extract + Index) | Scan artifacts created since last maintenance, assign salience, produce batch index in `wiki/meta/` |
| Every 2-3 sprints or on demand | Phases 3-4 (Synthesize + Link) | Write/update topic articles in `wiki/topics/`, run cross-reference pass, update `wiki/index.md` narrative. Triggered when 3+ batch indexes exist without a synthesis pass, or on owner request. |
| Quarterly or on demand | All phases (full reintegration) | Re-score salience, rewrite stale articles, merge/retire topics, rebuild `wiki/index.md` narrative, clean up stale batch entries. Triggered when 3+ months since last reintegration (tracked in `wiki/meta/last-reintegration.md`). |

The maintenance chat handles Phases 1-2 as part of the Knowledge
Synthesis checklist section. Phases 3-4 trigger automatically when
the batch index count threshold is met. The quarterly reintegration
runs as a deeper pass within the same maintenance session — it does
not require its own chat unless the project has an unusually large
artifact base.
