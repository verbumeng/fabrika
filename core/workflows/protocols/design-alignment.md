# Design Alignment

An orchestrator protocol for structured requirements gathering. The
orchestrator runs this directly — it is an orchestrator mode, not a
sub-agent dispatch. The iterative back-and-forth with the owner
requires the orchestrator's conversational context.

## When to Invoke

- **New project starting** — produces Charter + first PRD
- **New phase or major feature** — produces PRD
- **Owner explicitly requests alignment** — "let's align on what I want"
- **Orchestrator detects ambiguity** — can't describe what the user wants in 2-3 sentences

## Protocol

### 1. Acknowledge the Design Concept

State back what you understand in your own words. Don't parrot — show
you've internalized the idea. If you don't understand enough to
restate it, say so and ask for a broader description before starting
the question walk.

### 2. Walk the Design Tree

One question at a time. For each question:

- Provide a recommended answer based on what you know so far
- Read the codebase instead of asking when the answer is already there
- Resolve dependencies between decisions before moving on (don't ask
  about API pagination before you know whether there's an API)

Question categories (orchestrator thinking prompts — NOT a
user-visible checklist to march through):

- **Scope** — what's in, what's out, what's deferred
- **Users** — who has this problem, how they encounter it
- **Behavior** — what the product does, how it responds
- **Constraints** — budget, timeline, platform, regulatory
- **Integration** — what it connects to, what it replaces
- **Success criteria** — how you know it's working
- **Terminology** — domain terms that need shared definitions (captured to the Domain Language document — see Terminology Capture below)

The orchestrator may informally mention expected token cost when a
scope decision would significantly change it — this is conversational
awareness, not a structured estimate (see `core/workflows/protocols/token-estimation.md`
for when structured estimates surface).

### Terminology Capture

As domain terms crystallize during the question walk, collect them.
At document drafting time (Step 4):

- If a Domain Language document exists at `docs/00-Index/Domain-Language.md`,
  append new terms to it
- If no Domain Language document exists, create one from the template
  at `core/templates/Domain-Language-Template.md`

Each term entry captures: term name, plain-language definition,
code-level name (mark "not yet implemented" at this stage — the
implementer fills this in during implementation), relationships to
other terms, and anti-terms (what this term is NOT).

Organize terms by domain area. In multi-type projects, use domain
area sections to disambiguate when the same word means different
things in different contexts.

### 3. Convergence Check

Default: every ~10 questions. Range: 8-15. Use judgment based on
complexity — simple projects or features can converge sooner, complex
or novel domains may need more exploration.

At each convergence check:

1. Summarize the shared understanding so far
2. Ask: "Is this accurate? Anything I'm missing?"
3. If the owner adds significant new information, continue the walk
4. If the owner confirms, move to document drafting

### 4. Draft the Document

After alignment converges, draft the document in the same chat. No
fresh-chat boundary between alignment and document drafting — the
alignment converges INTO the document as its natural output.

- **First time (new project):** Draft Charter + first PRD using the
  templates at `core/templates/Project-Charter-Template.md` and
  `core/templates/PRD-Template.md`
- **Subsequent phases/features:** Draft PRD only

### 5. Architect Review

Before presenting the document to the owner for final approval,
dispatch the appropriate architect (software-architect or
data-architect based on project type) in design mode with the PRD's
Module Changes section. This is a lightweight "does this direction
make sense" check, not a full design review. Incorporate any architect
feedback into the document.

### 6. Owner Approval

Present the final document to the owner. The owner approves, requests
changes, or rejects.

### 7. Handoff

After the owner approves:

1. Save the Charter and/or PRD to `docs/01-Product/`
2. Create or update Domain Language at `docs/00-Index/Domain-Language.md`
3. Update `STATUS.md` cycle phase to `planning`
4. Prompt: *"Charter and PRD approved. Start a new chat to invoke the
   scrum master for sprint planning."*

This is the one fresh-chat boundary in the process: alignment
complete, approved documents in place, new chat for sprint planning.

## Key Distinctions

**Collaborative, not adversarial.** The orchestrator offers
recommendations. It reads the codebase to self-answer where possible.
It respects existing system context. This is not an interrogation — it
is a conversation between a builder and a designer who are trying to
arrive at shared understanding.

**Conversation protocol, not project management methodology.** The
orchestrator asks questions to understand what the user wants, captures
that understanding in a Charter/PRD, and hands off to the scrum master
for sprint planning. It does not define phases, assign work, or
manage timelines — that is the scrum master's job.

## Project-Type-Specific Behavior

### Sprint-Based Projects and Agentic-Workflow

Standard behavior described above. Produces Charter (first time) + PRD.

### Analytics-Workspace

Analytics-workspace is task-based, not sprint-based. Design Alignment
does NOT produce Charter/PRD for analytics-workspace projects. Instead,
it produces an enhanced Analysis Brief when the analysis is complex
enough to warrant structured alignment.

**Complexity triggers** (any one is sufficient):
- 3+ data sources involved
- Multiple stakeholder groups with different needs
- Novel domain requiring terminology alignment
- Estimated effort exceeds 2 days
- Analysis informs a significant decision (budget, strategy, headcount)

When triggered, the orchestrator runs the alignment protocol and
produces an enhanced Analysis Brief using the standard brief template
with deeper coverage of scope, terminology, and success criteria.

Simple analyses continue using the existing brief/plan flow unchanged.
