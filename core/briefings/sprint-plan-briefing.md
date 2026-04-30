# Sprint Plan Briefing Format

Use this format when presenting a sprint plan to the owner for approval, after the scrum-master agent returns from sprint planning.

The sprint contract lives at `docs/04-Backlog/Sprints/Sprint-XX-contract.md` and defines the technical execution plan. This briefing is the human-facing translation — it exists so the owner can evaluate whether the right work is being done in the right order.

## Structure

### 1. Sprint goal in plain English
One sentence: what will be true about the product at the end of this sprint that isn't true now?

### 2. Why these stories, in this order
For each proposed story: what it does (user-facing impact), why it's in this sprint (priority, dependency, or logical sequencing), and roughly how big it is. Don't just list ticket IDs and titles — explain what each one means for the product.

### 3. Topology choice and why
Explain in plain terms which topology (pipeline, mesh, or hierarchical) was chosen. Define what that topology means practically: will stories be worked one at a time through a full cycle, in parallel because they don't touch the same code, or in a specific order because they depend on each other? Explain why this topology fits these particular stories.

#### Translation examples

**Pipeline** —
- NOT: "Pipeline topology — stories have sequential dependencies and shared state."
- YES: "These stories need to be done in order: Story 2 builds on what Story 1 creates, and Story 3 connects them together. We'll finish each one completely before starting the next."

**Mesh** —
- NOT: "We chose mesh topology because stories don't share state."
- YES: "Each story can be worked independently because they touch different parts of the system. No one is waiting on anyone else, so we can work them in whatever order makes sense."

**Hierarchical** —
- NOT: "Hierarchical topology with a foundation story and dependent feature stories."
- YES: "Story 1 builds the base that the other two depend on, so it goes first. After that, Stories 2 and 3 can be worked in either order — they both use what Story 1 created but don't depend on each other."

### 4. Jargon glossary
Define topology terms, any backlog/sprint terminology that isn't self-evident, technology names, data model concepts, and any other loaded terms. Even terms defined in previous sprints — the owner may not remember them.

Format: `**Term** — plain-language definition`.

### 5. What was considered but deferred
Stories that were candidates but didn't make the cut, and why. Helps the owner push back if priorities seem wrong.

### 6. Risks or things to watch
Dependencies, areas of the codebase that are fragile, stories that might be harder than estimated.

## Closing

End with: *"The sprint contract is at `docs/04-Backlog/Sprints/Sprint-XX-contract.md`. Let me know if the scope, ordering, or topology should change."*
