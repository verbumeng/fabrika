# CR-22: Agents as Composable Skills

**Version target:** TBD
**Status:** Needs Design Alignment
**Identified:** 2026-05-02 (during PRD-15 alignment)

## Source Material to Bring In

The owner has flagged a YouTube video transcript that should inform
the design-alignment session for this CR. Bring in the transcript
before alignment kicks off so the session can engage with the
specific framing/argument it presents. (Title and link to be added
when alignment is scheduled.)

## Problem Statement

Fabrika's current agent model treats each agent as a workflow-scoped
role definition — a `methodology-reviewer` exists primarily because
agentic-workflow-lifecycle has a methodology-review phase; a
`scrum-master` exists because sprint-lifecycle has sprint planning;
etc. As agents like the `implementer` archetype (PRD-03) get reused
across multiple workflows (sprint-based, agentic-workflow,
analytics-workspace, the proposed task-workspace from CR-17), the
"agent-archetype-in-workflow" framing strains:

1. **Per-(workflow, agent) calibration** (introduced in PRD-15)
   creates separate calibration entries for what is structurally the
   same work in different contexts — duplicating data and slowing
   convergence. If `implementer` does the same kind of work in two
   workflows, why does each workflow get its own calibration?

2. **Agent prompt files conflate** the agent's *capability*
   (what it knows how to do) with the *invocation context* (what
   workflow phase it runs in, what dispatch contract it expects).
   These could plausibly separate.

3. **Adding new workflows** (CR-17 task-workspace, CR-19 ad-hoc)
   pressures the model further — every new workflow that needs an
   implementer/reviewer/architect creates apparent need for new
   agent definitions, when really the same skills are being invoked
   in new contexts.

The alternative framing under consideration: agents as **composable
skills** parameterized by workflow + phase. A skill defines
*capability* (the implementer skill, the methodology-review skill).
An invocation supplies *context* (what workflow, what phase, what
dispatch contract). Calibration keys naturally become
`(skill, invocation-context, model)`.

## Solution Direction (Needs Design Alignment)

This is exploratory — the YouTube transcript and owner's direct
input should drive the actual design. Initial framing for the
alignment session:

- **What is a "skill"** in Fabrika terms? How does it differ from
  the current "agent prompt"?
- **What does a skill's API look like?** Inputs, outputs,
  preconditions, post-conditions.
- **How are skills discovered and dispatched?** Is the dispatch
  protocol skill-based or workflow-based?
- **Migration from current agent model.** How do existing agent
  prompts decompose into (skill + invocation-context) pairs? What's
  the consumer migration impact?
- **Calibration alignment with PRD-15.** PRD-15's per-(workflow,
  agent, model) calibration keys are forward-compatible with
  per-(skill, invocation-context, model) — this CR shouldn't break
  existing calibration data, just reinterpret keys.
- **Boundary cases.** Are some agents inherently workflow-bound (e.g.,
  scrum-master exists because of sprint ceremony, not as a generic
  capability)? If so, do we have two categories — pure skills and
  workflow-bound agents — or does everything become a skill?

## Compatibility With Other Pending CRs

- **CR-17 (Task Workspace):** A skills model would mean
  task-workspace doesn't need new agent definitions — it just
  invokes existing implementer/reviewer/architect skills with
  task-specific dispatch contracts.
- **CR-19 (Ad-Hoc Workflow):** Same — ad-hoc just becomes a
  lightweight invocation context for existing skills.
- **CR-20 (Context Compaction Principle):** Skills with
  well-defined inputs/outputs are a natural fit for compaction —
  each skill's output becomes the compressed artifact for the next
  invocation.
- **CR-21 (Freshness-Aware Context):** Skill metadata could include
  freshness expectations on the context it consumes.

## Out of Scope (For Now)

- Implementation work — this CR is about whether to make this shift
  at all, not how to implement it
- Specific agent renames or restructures
- Changes to PRD-15's calibration design (forward-compatible by
  construction)

## Open Questions for Alignment

These will be sharpened by the YouTube transcript framing:

1. Is the "skill" abstraction actually clearer than the "agent"
   abstraction, or does it just rename the same thing?
2. What concrete pain does the current agent model cause that
   skills would resolve? (Beyond the calibration-key elegance noted
   above.)
3. Is this a v0.30+ direction or sooner?
4. Does this affect the agent archetypes pattern (implementer,
   reviewer, architect, validator) or just the agent definitions
   underneath them?

## Alignment Notes (Design Philosophy Session, 2026-05-02)

The following context was established during a design philosophy
session that produced the Phase 2 roadmap (ROADMAP-v2.md):

1. **This CR is the mechanism for Fabrika's design shift.** The
   broader insight: "project types" are becoming "workflow types" —
   composable multi-agent patterns. CR-22 provides the structural
   mechanism that makes this composition work. Without it, projects
   are still locked into single-type lanes.

2. **CR-17 is the first expression.** The base workflow (CR-17)
   demonstrates that domain-agnostic agents work across workflow
   contexts without domain-specific agent definitions. CR-22
   formalizes what CR-17 proves by example.

3. **The abstraction stack clarifies the model:**
   - Skills = single agent capabilities, parameterized by context
   - Workflows = multi-agent patterns composing skills
   - Projects = compose multiple workflow types as needed

4. **Execution may be phased.** CR-22 is the most architecturally
   ambitious CR in Phase 2. It may execute as: (a) design alignment
   producing a formal specification, then (b) partial restructuring
   that proves the pattern, with (c) full restructuring deferred to
   Phase 3 if scope warrants. The key is that the conceptual insight
   is already in play — CR-17's base agents are designed with this
   model in mind.

5. **Open question #1 is resolved: yes, the skill abstraction IS
   clearer.** The design session demonstrated that thinking in terms
   of "what workflow types does your project need?" is more intuitive
   than "what project type are you?" Skills as the unit of agent
   capability naturally follows from this framing.

6. **Open question #3 is partially resolved.** CR-22's design
   alignment should happen in Phase 2 (sequenced 6th of 7 CRs); full
   restructuring scope will be determined during alignment. The
   conceptual insight is already informing CR-17's design, so the
   idea is in play before CR-22 formally executes.

## Additional Alignment Notes (CR-17 Execution Session, 2026-05-02)

The following insight emerged during CR-17's execution and adds scope
to CR-22:

7. **The three project type categories dissolve.** The current
   framework organizes project types into three categories:
   sprint-based (8 types), task-based (analytics-workspace), and
   methodology-based (agentic-workflow). These categories appear in
   AGENT-CATALOG, Document-Catalog, BOOTSTRAP, integration templates,
   Domain-Language, and README. With workflow composition, these
   categories stop being meaningful boundaries.

   Instead: a project composes whatever workflow types it needs, and
   the orchestrator dynamically assesses what level of ceremony each
   piece of work requires (see CR-18 alignment notes on universal
   complexity assessment). The category labels were a consequence of
   the taxonomic model — remove the taxonomy, remove the categories.

   CR-22 should include the structural removal of these three-category
   divisions from the codebase. This means:
   - AGENT-CATALOG: agents organized by archetype/role, not by
     project type category
   - Document-Catalog: documents organized by relevance/tier, not
     by project type category
   - BOOTSTRAP: a unified onboarding flow that assesses what
     workflow types the project needs, rather than branching into
     Phase 2 / Phase 2W / Phase 2A
   - Integration templates: remove "your project type determines
     your workflow" framing, replace with "compose the workflows
     you need"

8. **Base agents (CR-17) are the foundation.** CR-17 creates
   `planner.md`, `implementer.md`, `reviewer.md`, `validator.md` —
   the domain-agnostic base agents. All specialized agents (product-
   manager, code-reviewer, data-analyst, etc.) are parameterized
   versions of these base agents with domain-specific knowledge
   added. CR-22 should formalize this relationship: the base agent
   is the skill, the domain specialization is the parameterization,
   and the workflow supplies the invocation context.

## Additional Alignment Notes (Terminology Session, 2026-05-03)

The following insight emerged while reviewing the full CR-17–29
landscape and trying to locate where terminology distinctions belong:

9. **Three-tier abstraction: workflows, processes, skills.** The
   abstraction stack from alignment note #3 (skills → workflows →
   projects) is missing a middle layer. The refined model:

   - **Skill** — the most atomic unit. A single agent capability
     that does not decompose further. The base agents (planner,
     implementer, reviewer, validator) are skills. Domain-specialized
     agents are parameterized skills. A skill is invoked, does its
     work, and returns output.
   - **Process** — a composed unit that orchestrates multiple skills
     to govern a specific concern. The moment something is too complex
     to be a single skill invocation and needs to decompose into
     steps that invoke other skills, it becomes a process.
   - **Workflow** — a broad end-to-end pattern where an agent (or
     agents) produce a complete unit of work. Workflows are the
     primary abstraction consumers adopt. They may invoke skills
     directly, invoke processes, or both.

   This gives Fabrika a clean answer to "what do we call this thing?"
   — if it doesn't decompose, it's a skill; if it decomposes into
   skills, it's a process; if it's the end-to-end pattern producing
   a deliverable, it's a workflow.

10. **Workflows don't decompose — by design.** Workflows structure
    how work gets done. The base task workflow (plan → implement →
    review → validate) IS what the lowest-level workflow looks like.
    Workflows are fundamentally different from procedures and skills
    because they define the shape of work itself. You layer
    procedures and skills onto and around workflows — workflows
    don't break down into sub-workflows or processes. This is a
    design principle, not a current limitation waiting to be
    addressed.

11. **CR-28's "supporting" files are procedures — SOPs, not
    processes or protocols.** The files CR-28 groups alongside
    workflow types (dispatch-protocol, design-alignment, sprint-
    coordination, etc.) are standing operating procedures: documented
    instructions for how specific concerns should be handled.
    They are not decompositions of workflows, not agent-to-agent
    communication protocols, and not "processes" in the three-tier
    sense. They exist alongside workflows as independent governance
    concerns — dispatch procedure describes HOW agents get invoked
    across all workflows; design-alignment describes a procedure
    that PRECEDES workflow execution; sprint-coordination describes
    the multi-chat cycle AROUND stories.

    This has implications for CR-28's directory naming. The current
    proposal uses `protocols/` — but "procedures" or "sops" may be
    more accurate given that these are operational instructions, not
    agent-to-agent communication contracts. This is an open
    terminology question for CR-28's alignment.

12. **The "process" layer is named vocabulary, not a current
    structural need.** Nothing in Fabrika today is a process in the
    three-tier sense (a composed unit orchestrating multiple skills).
    Workflows invoke skills directly. The process concept exists so
    Fabrika has vocabulary for the middle ground IF something emerges
    that is too complex to be a skill but is not an end-to-end
    workflow. The term is defined; the need hasn't materialized.

## Additional Alignment Notes (CR-17 Execution Session, 2026-05-03)

13. **Procedures and protocols must be liberated from workflow
    binding, same as agents.** Just as project types are becoming
    workflow types (liberating projects from single-type lock-in),
    the procedures documented in `core/workflows/` — dispatch
    protocol, token estimation, design alignment, knowledge pipeline,
    sprint coordination — should not be bound to specific workflows.
    Token estimation is currently copy-pasted as a reference in each
    workflow file. Design alignment triggers are documented separately
    in each workflow. These are cross-cutting concerns: SOPs that
    exist alongside workflows, not inside them.

    CR-22 should assess ALL procedures/protocols in `core/workflows/`
    and determine which are:
    - **Workflow-bound** (legitimately part of one workflow's
      definition — e.g., the tiered review structure is specific to
      analytics-workspace)
    - **Cross-cutting** (apply to all workflows and should be
      referenced once, not per-workflow — e.g., token estimation,
      compaction, dispatch protocol)

    This connects to alignment note #11 (SOPs, not protocols) and
    to CR-28 (folder reorganization). The naming and organization
    should reflect which procedures are universal and which are
    workflow-specific.

14. **The orchestrator must dispatch to subagents via the Agent tool,
    not implement directly.** During CR-17 execution, the orchestrator
    read the approved plan and started creating/editing files directly
    instead of spawning agentic-engineer as a subagent. This violates
    the lifecycle's dispatch model. The execution prompt
    (EXECUTION-PROMPT-v2.md) contributed by framing the task as
    "execute this CR" rather than clearly establishing that the
    orchestrator's only direct work is alignment (Step 2), presentation
    (Step 6), and shipping mechanics (Step 7). The prompt has been
    revised to make subagent dispatch explicit.

## Verification Criteria (Pre-Alignment Placeholder)

To be defined during design alignment.
