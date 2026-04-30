# Spec Briefing Format

Use this format when presenting a spec to the owner for approval, after the product-manager agent returns from planning mode.

The full spec artifact lives at `docs/plans/[TICKET]-spec.md` and serves as the implementation contract for downstream agents. This briefing is the human-facing translation — it exists so the owner can make informed decisions about what is being built and catch design problems before implementation begins.

## Structure

### 1. What we're building and why
2-4 sentences in plain English. What does the end user see or experience after this is done? Why does this matter right now — how does it connect to the current phase goal?

### 2. How it works (high level)
Walk through the feature from the user's perspective, not the code's. What happens when they use it? What changes in behavior from what exists today?

### 3. Key design decisions
List the non-obvious choices the spec makes. For each one: what was chosen, what the alternative would be, and why this direction was picked. These are the places where the owner's taste and judgment matter most.

When framing design alternatives, explain in terms of user impact, not implementation technology. Instead of "Option A uses a B-tree index, Option B uses a hash index," say "Option A is faster for range queries (finding all orders between two dates), Option B is faster for exact lookups (finding one specific order by ID)." If technical terminology is necessary for the owner to understand a trade-off, define it in the jargon glossary below AND flag it for addition to the Domain Language document.

### 4. Jargon glossary
Define every technical term, framework concept, data model name, API name, or loaded term that appears in the spec and wouldn't be obvious to someone who hasn't read the codebase recently. Even terms that were defined in previous sprints — the owner may not remember them.

Format: `**Term** — plain-language definition`.

### 5. What's explicitly out of scope
So the owner knows what this does NOT include and can push back if something was cut that shouldn't have been.

### 6. Open questions
Anything the spec flagged as needing owner input, plus anything the orchestrating session noticed that seems underspecified or worth a second opinion.

## Closing

End with: *"The full spec is at `docs/plans/[TICKET]-spec.md`. Review the above and let me know if anything should change before I start building."*

## Success Criterion

If the owner has to read the raw spec to understand what is happening, the briefing failed. The goal is to make the owner comfortable asking "why not X instead?" or "what happens if Y?"
