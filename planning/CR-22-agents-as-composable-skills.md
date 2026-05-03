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

## Verification Criteria (Pre-Alignment Placeholder)

To be defined during design alignment.
