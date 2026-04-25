# Progress Files

## STATUS.md (Project Root)

A **snapshot** of current project state, overwritten each session. Always small. Used for quick orientation.

```markdown
## [PROJECT_NAME] — Status
Last updated: YYYY-MM-DD

### Current Sprint: Sprint X
- **Topology:** [pipeline | mesh | hierarchical]
- **Cycle phase:** [planning | story-in-progress | sprint-close | maintenance | retro]
- **Next chat should:** [one-line pointer — e.g., "Start S-007: Add export button" or "Run sprint close-out merge" or "Run sprint retro"]
- **Sprint contract:** docs/04-Backlog/Sprints/Sprint-XX-contract.md
- **Progress file:** docs/04-Backlog/Sprints/Sprint-XX-progress.md

### Active Work
- [TICKET]: [title] — [status: in-progress | blocked | in-review]

### Blockers
- [Any blockers or risks]

### Last Maintenance
- Date: YYYY-MM-DD
- Tag: maintenance-YYYY-MM-DD
```

The `Cycle phase` and `Next chat should:` fields are how a fresh chat orients itself — see the sprint lifecycle workflow for what each phase means.

## Sprint Progress File (Per-Sprint)

`docs/04-Backlog/Sprints/Sprint-XX-progress.md` — append-only log for the current sprint. Archived when the sprint closes. Topology-tagged entries.

## Dev Log Format (`docs/session-logs/`)

Dev logs are the **primary fuel for social media content** via content generation workflows. They must be narrative, not just metrics.

Write each dev log from **the user's first-person perspective** (as if they are telling a colleague what they built today). Include:

- **What was built** — the feature, the implementation approach, what it does
- **What decisions were made and why** — trade-offs considered, alternatives rejected
- **What was interesting or surprising** — edge cases, things that worked unexpectedly well or poorly
- **Lessons learned** — insights about the tech, the domain, or the process
- **What's next** — what the next session should pick up

**Tone:** Casual-smart, thinking-out-loud. Raw material for content generation.
**Length:** 200-500 words. A builder's diary entry, not a formal report.
