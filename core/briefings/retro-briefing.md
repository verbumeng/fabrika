# Sprint Retro Briefing Format

Use this format when presenting the sprint retro to the owner. The scrum-master agent writes a detailed retro artifact (`Sprint-XX-retro.md`) with eval tables, token metrics, and agent quality data. That artifact is for agent consumption. This briefing is the human-facing translation.

Do not tell the owner to go read the retro file. Translate it into a plain-language summary that explains what happened this sprint, what it means for the product, and what changes going forward.

## Structure

### 1. What the sprint accomplished
2-4 sentences: what is true about the product now that wasn't true before this sprint started? Frame as end-user impact. If stories slipped, note what didn't get done and why — but lead with what shipped.

### 2. Story-by-story recap
For each story in the sprint, one short paragraph:
- What it was (plain English, not the ticket title)
- Whether it shipped, slipped, or was carried over
- If it shipped: any interesting design decisions or trade-offs worth knowing about
- If it slipped: why, and what happens to it next (backlog, next sprint, dropped)

### 3. What we learned
Translate the retro's "Lessons / Insights" into plain language. For each lesson: what happened, why it matters, and what we're doing differently because of it.

### 4. What's changing next sprint
Explain the concrete process changes in plain terms. For each change: what the change is, what problem it solves, and how the owner will notice it (if at all). Examples:

- "Stories that touch the database will get 30% more time budgeted, because every database story this sprint took longer than expected."
- "Test plans will be written before implementation starts, not after. We caught two edge cases in retro that would have been caught earlier."

### 5. Token efficiency
Lead with the sprint total — this is the headline number the owner
sees first:

```
Sprint total: [X] tokens
Approximate cost: ~$[high] at high-end / ~$[mid] at mid-tier / ~$[low] at economy tier
```

Then include the per-story table from the retro artifact with a cost
column added. This is the primary detail level:

| Story | Predicted | Actual | Cost (mid-tier) | Testing approach |
|-------|-----------|--------|-----------------|-----------------|
| S-XXX | [X] | [Y] | ~$[Z] | TDD / test-informed / test-after |

Explain the calibration pattern in plain language: are predictions
consistently over or under? Which types of stories are hardest to
predict? Do TDD stories consume more tokens than test-after stories
(expected — multiple red-green cycles)? What adjustment should be
made going forward?

Below the per-story table, include a drill-down section with
per-agent breakdown per story. This is detail the owner can gloss
over unless a number catches their eye:

#### Agent cost breakdown (drill-down)

For each story, the per-agent-role split:

| Story | Planner | Implementer | Reviewer | Validator | Total |
|-------|---------|-------------|----------|-----------|-------|
| S-XXX | ~$[X] | ~$[Y] | ~$[Z] | ~$[W] | ~$[T] |

Adjust agent columns to match what was actually dispatched (e.g.,
add Architect column if architect reviews ran this sprint).

### 6. Agent quality and eval accuracy
Include the eval accuracy table from the retro artifact (per-agent scores and deltas). Explain what the numbers mean: which agents are improving, which are regressing, and why. If there are proposed prompt changes or new eval cases, list them with enough context for the owner to approve or reject.

If agent prompts were modified this sprint, summarize what changed and why (from the agent changelog). Frame each change as: what the agent was getting wrong, what was changed, and what the expected improvement is.

### 7. Health check
A brief honest assessment of where things stand:
- Is the codebase in good shape or is there debt piling up?
- Are there maintenance findings that need attention?

Keep this to 2-3 sentences. If everything is fine, say so and move on.

### 8. Anything that needs your input
Decisions that were deferred, scope questions for next sprint, proposed agent prompt changes that need approval. If nothing needs input, say: "No decisions needed from you right now — ready to plan the next sprint."

## Closing

End with: *"The full retro is at `docs/04-Backlog/Sprints/Sprint-XX-retro.md` if you want the details. Ready to open a new chat for next sprint planning."*

## What NOT to include

- Raw maintenance findings without context (translate into the "Health check" section)
- Topology assessment details (mention only if the recommendation is changing and why)
