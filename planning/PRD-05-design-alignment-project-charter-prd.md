# PRD-05: Design Alignment + Project Charter + PRD Document

**Version target:** 0.14.0
**Dependencies:** PRD-03 (pure orchestrator — alignment is orchestrator
work, PRD feeds into implementer dispatch)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

When a user brain dumps a new project or feature, the orchestrator
currently takes the raw input and immediately creates epics and stories.
There is no formal step to ensure the agent actually understands what
the user wants. The user has been doing this informally — going back and
forth with the agent — but nothing codifies how requirements gathering
should work, what it produces, or when it's done.

Additionally, there is no document that captures the full design concept
above the level of individual per-story specs. Stories get created from
the brain dump, but the holistic picture lives only in conversation
context — which evaporates between chats.

## Solution

Three interconnected additions:

### 1. Design Alignment (Orchestrator Protocol)

A structured requirements gathering protocol the orchestrator follows
when starting new work. Inspired by Pocock's "grill-me" skill and
Frederick P. Brooks' "design concept" from The Design of Design.

**Triggers:**
- New project starting (brain dump → Project Charter)
- New phase or major feature starting (brain dump → PRD)
- Owner explicitly requests alignment
- Orchestrator detects ambiguity (can't describe what user wants in
  2-3 sentences)

**Protocol:**
1. **Acknowledge the design concept.** State back what you understand
   the user wants, in your own words. Immediately surfaces misalignment.
2. **Walk the design tree.** For each branch:
   - Ask one question at a time (not batches)
   - Provide a recommended answer (user can say yes/no)
   - If answerable by reading the codebase, read it instead of asking
   - Resolve dependencies between decisions before moving on
3. **Question categories** (orchestrator thinking prompts, not a
   user-visible checklist):
   - Scope: what's in, what's out, what's deferred
   - Users: who uses this, how, in what context
   - Behavior: what happens when X, edge cases
   - Constraints: performance, cost, platform
   - Integration: how does this fit with existing work
   - Success criteria: how will we know this works
   - Terminology: what do we call things (seeds Domain Language)
4. **Convergence check.** Every ~10 questions, summarize shared
   understanding and ask: "Is this accurate? Anything I'm missing?"
5. **Output.** Project Charter (first time) or PRD (subsequent).
   Owner approves before proceeding.

**Key distinction from Pocock's grill-me:** More collaborative than
adversarial. The orchestrator offers recommendations and reads the
codebase to self-answer where possible. Respects that the user is
working within a system with existing context.

**For analytics-workspace:** The existing brief/plan structure handles
simple analyses. But when the back-and-forth gets complex or the
orchestrator detects upfront complexity, the full Design Alignment
protocol applies. Lighter trigger, same protocol when warranted.

### 2. Project Charter (New Document Type)

The overarching "what is this thing and why does it exist" document.
Unifies all PRDs for a project.

**Tier:** 1 (created once at project inception or major pivot)
**Applies to:** All sprint-based project types + agentic-workflow
**Template sections:**
- Problem space (what problem exists in the world)
- Target user (who has this problem, in what context)
- Core capabilities (the 3-5 things this product must do)
- Key constraints (budget, timeline, platform, regulatory)
- Success criteria (how we'll know it works)
- What this is NOT (explicit exclusions)
- Design principles (guiding values for decision-making)

**Relationship to existing docs:**
- Vision & Positioning becomes the external-facing "why" (marketing,
  stakeholders)
- Project Charter becomes the internal design document (shared
  understanding between user and agents)
- Phase Definitions stays as the scope breakdown across phases
- All three must be tightly aligned and in lockstep

### 3. PRD (New Document Type)

The detailed plan for a specific phase or major feature. Multiple PRDs
reference back to the Project Charter.

**Tier:** 1 (created per phase or major feature)
**Applies to:** All sprint-based project types + agentic-workflow
**Template sections:**
- Problem Statement (user's perspective)
- Solution (user's perspective)
- User Stories (exhaustive numbered list)
- Module Changes (which modules built/modified, their interfaces —
  this is where the architect from PRD-04 reviews)
- Implementation Decisions (architectural choices, schema, API
  contracts — no file paths or code snippets, they get outdated)
- Testing Decisions (which modules get tested, what makes a good test,
  testing approach per module)
- Out of Scope
- Open Questions

### Document Hierarchy

Brain dump → **Design Alignment** → **Project Charter** (first time)
→ **PRD** (per phase/feature) → **Sprint Planning** (scrum master
dispatched) → **Per-story specs** (planner dispatched) →
**Implementation** (implementer dispatched)

### Fresh-Chat Boundaries

Each phase transition gets an explicit prompt telling the user to start
a new chat:

1. Design Alignment complete → "Start a new chat to create the
   Project Charter / PRD from this alignment session."
2. Project Charter / PRD approved → "Start a new chat to invoke the
   scrum master for sprint planning."
3. Sprint planned → existing lifecycle takes over (story chats,
   close-out, maintenance, retro)

The orchestrator MUST prompt for new chats at these boundaries. This is
not optional — it keeps context windows clean and separates concerns.

### Handoff Change

After the PRD is approved, the orchestrator **hands off to the scrum
master** for sprint planning. The orchestrator no longer directly
creates epics and stories from brain dumps. The scrum master receives
the PRD and derives the sprint plan from it.

## Key Decisions (Already Aligned)

- Design Alignment is an orchestrator mode, not a sub-agent dispatch
  (iterative back-and-forth with the user requires the orchestrator)
- Project Charter is a separate document above PRDs (not a beefed-up
  first PRD)
- Phase Definitions and Vision & Positioning stay but must be tightly
  integrated with the new documents
- Fresh-chat boundaries are explicit at every phase transition
- Analytics-workspace gets Design Alignment for complex analyses
- The first PRD is created at project inception alongside the Charter;
  subsequent PRDs are created as new phases/features start
- Convergence checks every ~10 questions prevent infinite grilling

## Scope: What Changes

### New files

| File | Purpose |
|---|---|
| `core/workflows/design-alignment.md` | The orchestrator protocol for requirements gathering |
| `core/templates/Project-Charter-Template.md` | Project Charter template |
| `core/templates/PRD-Template.md` | PRD template with module/interface sections |

### Modified files

| File | Change |
|---|---|
| `core/Document-Catalog.md` | Add Project Charter (Tier 1, all sprint-based + agentic-workflow). Add PRD (Tier 1, per phase/feature). Update Phase Definitions and Vision & Positioning descriptions to clarify relationship with new docs. |
| `core/workflows/doc-triggers.md` | Add trigger for Project Charter (new project) and PRD (new phase or major feature). |
| `core/workflows/sprint-lifecycle.md` | Add Design Alignment + Charter/PRD as pre-sprint phases. Add fresh-chat boundary prompts. |
| `core/workflows/development-workflow.md` | Add Design Alignment section. Update sprint planning to reference PRD as input. Clarify that orchestrator hands off to scrum master after PRD approval. |
| `core/workflows/analytics-workspace.md` | Add Design Alignment trigger for complex analyses. Define "complex" threshold. |
| `core/agents/scrum-master.md` | Update dispatch contract — scrum master now receives PRD as primary input for sprint planning, not raw brain dump. |
| `integrations/claude-code/CLAUDE.md` | Add Design Alignment, Project Charter, PRD sections. Update session lifecycle with new fresh-chat prompts. |
| `integrations/copilot/copilot-instructions.md` | Same updates for Copilot parity. |
| `VERSION` | 0.14.0 |
| `CHANGELOG.md` | Entry for 0.14.0 |
| `MIGRATIONS.md` | Consumer migration: copy new workflow + templates, update integration templates. Major behavioral change — orchestrator now does alignment before creating stories. |

## Open Items (To Resolve During Execution)

- Exact convergence check frequency (every ~10 questions is a
  guideline — should this be adaptive based on complexity?)
- Whether the Project Charter template needs project-type-specific
  sections or stays generic
- How Design Alignment interacts with the architect (PRD-04) — does
  the architect review the PRD's module section immediately, or is
  that a separate step?
- How the PRD's "Module Changes" section works for project types where
  "modules" aren't the natural unit (e.g., analytics-engineering where
  the unit is transformations/models, or data-engineering where the
  unit is pipeline stages)
- Whether the first sprint planning (Sprint 0 / Sprint 1) has any
  special handling since it derives from the initial PRD + Charter

## Verification Criteria

- Design Alignment workflow is documented with clear triggers,
  protocol, and output
- Project Charter and PRD templates exist with all specified sections
- Document-Catalog includes both new document types at Tier 1
- Sprint lifecycle includes pre-sprint phases with fresh-chat boundaries
- Development workflow shows handoff from orchestrator to scrum master
  after PRD approval
- Analytics-workspace workflow includes Design Alignment trigger
- Integration templates reflect all new capabilities
- No steps where the orchestrator creates epics/stories directly from
  brain dumps (must go through alignment → PRD → scrum master)
- No smell test violations
