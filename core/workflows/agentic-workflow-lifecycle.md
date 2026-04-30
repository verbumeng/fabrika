# Agentic-Workflow Lifecycle

The structural update lifecycle for agentic-workflow projects. This
workflow governs how changes are made to systems where the methodology
itself is the product — agent prompts, workflow definitions,
instruction files, integration templates, catalogs, and hooks.

For the dispatch contracts that govern each agent invocation below,
see `core/workflows/dispatch-protocol.md`.

---

## Modes

Agentic-workflow projects have two modes:

**Structural mode (required):** Modifying the system's infrastructure.
Uses the 7-step change protocol below. Feature branch + PR required.
All agentic-workflow projects have this.

**Operational mode (optional):** Running the system day-to-day —
executing tasks, logging, reviewing, maintaining state. Operational
sessions are human-initiated and interactive. There is no agent
orchestration for operational work — the human drives these sessions
directly. Not all agentic-workflow projects need this. See the
Operational Mode section at the end of this file.

---

## Structural Update Lifecycle

Seven steps. Each step has a clear owner (agent or orchestrator) and
defined inputs/outputs. The protocol is not purely linear — Step 5
can loop back to Step 2 if verifier findings change the scope.

### Step 1: Plan

**Owner:** Planner agent (planning mode, contextual dispatch)

The planner receives the change request (PRD, issue, or conversation
context) and produces a structured plan covering:

1. **What is changing** — every file that will be created, modified,
   or deleted
2. **How it integrates** — for each changed file, what other files
   reference it, depend on it, or need to stay in sync
3. **What could go wrong** — for each integration point, what breaks
   if the change is inconsistent
4. **Mitigation** — for each risk, how to prevent it

The plan is written in the conversation (not a separate file) as a
structured summary. It must be explicit — not "I'll update related
files" but "AGENT-CATALOG.md needs a new row in the archetype table
for X; dispatch-protocol.md needs entries for Y and Z."

**Output:** Structured plan in conversation

### Step 2: Align

**Owner:** Orchestrator (presents to the project owner)

Present the plan using the **Structural Plan Briefing** format
(`core/briefings/structural-plan-briefing.md`). Follow the briefing
principles (`core/briefings/briefing-principles.md`):
- Lead with what the change does for the system, not implementation
  details
- Define any jargon
- Explain WHY each part matters
- Make trade-offs explicit so the owner can push back
- If open items need resolution, present options with recommendations

**Gate:** Owner approves the plan before execution proceeds. An
unreviewed plan encodes potentially wrong assumptions that compound
through every subsequent step.

**Output:** Owner approval (or revision and re-plan)

### Step 3: Execute

**Owner:** Implementer agent (contextual dispatch)

1. Create a feature branch: `feat/[version]-[short-description]`
2. Make the changes according to the approved plan
3. Follow versioning discipline: bump VERSION, add CHANGELOG entry,
   add MIGRATIONS.md entry if needed
4. Run smell tests on every canonical file touched:
   - Does this leak personal, product-specific, or tool-specific
     assumptions?
   - Does this name downstream projects?
   - Would this make sense to a stranger cloning the repo?

**Output:** Changed files on a feature branch

### Step 4: Verify

**Owner:** Three independent agents, invoked in parallel with strict
dispatch

The orchestrator invokes three agents. Each receives the plan, file
paths, and verification criteria — nothing else. No opinions, no
hints, no pre-digested summaries. Each must form its own judgment.

**Methodology Reviewer** — evaluates the changes against methodology
quality criteria: cross-reference consistency, prompt pattern
adherence, instruction decomposition quality, smell test compliance,
consumer update completeness, dispatch/output contract consistency.

**Structural Validator** — mechanically verifies structural facts:
files exist at stated paths, VERSION matches CHANGELOG, catalogs
match actual files, cross-references resolve, integration templates
are current.

**Architect** — evaluates structural design: instruction
decomposition appropriateness, pointer pattern cleanliness, context
budget balance (always-loaded vs. on-demand), pattern consistency
with existing components.

Each agent writes its findings directly — no filtering or softening.

**Output:** Three independent evaluation reports

### Step 5: Incorporate Feedback

**Owner:** Orchestrator + Implementer agent

Read all three evaluation reports. For each finding:
- Fix it if it is a real problem (implementer executes fixes)
- If you disagree with a finding, explain why to the owner and let
  them decide

If findings change the scope of the plan (not localized fixes but
fundamental rethinking), loop back to Step 2 and re-align with the
owner.

**Retry limit:** Maximum 2 retry cycles through Steps 4-5. After 2
failed verification rounds, stop and present all reports to the
owner with a summary of what was tried.

**Output:** Fixed files (or escalation to owner)

### Step 6: Present

**Owner:** Orchestrator (presents to the project owner)

Present the completed changes using the **Change Summary Briefing**
format (`core/briefings/change-summary-briefing.md`). The briefing
covers:
- What specifically changed
- Why it matters — how it fits into the broader system
- Verification results (translated to plain language)
- Implications for consumer projects
- Token efficiency with per-agent breakdown

The owner should be able to read this and understand whether the
changes align with their intent.

**Output:** Owner understanding and approval to ship

### Step 7: Ship

**Owner:** Orchestrator

1. Commit with conventional format (all changes in one commit,
   including VERSION and CHANGELOG)
2. Create a pull request against main
3. After owner approval, merge

**Output:** Changes on main

---

## Agent Roster for Agentic-Workflow

### Structural mode

| Role | Agent | Invoked at |
|------|-------|-----------|
| Planner | workflow-planner | Step 1 (planning mode) |
| Reviewer | methodology-reviewer | Step 4 |
| Validator | structural-validator | Step 4 |
| Implementer | context-engineer | Steps 3, 5 |
| Architect | context-architect | Step 4 |
| Coordinator | scrum-master | When multiple PRDs/changes need sequencing |

The coordinator is not part of the 7-step protocol itself. It is
invoked when the project has a backlog of planned changes (PRDs,
issues) that need dependency analysis and execution sequencing —
similar to sprint planning in sprint-based projects.

### Note on agent maturity

The five agentic-workflow-specific agents (workflow-planner,
methodology-reviewer, structural-validator, context-engineer,
context-architect) reached full maturity in 0.12.0 — detailed
evaluation criteria, calibration examples, and step-by-step
procedures were added to each. Five specialist implementer agents
(software-engineer, data-engineer, data-analyst, ml-engineer,
ai-engineer) were also introduced in 0.12.0, covering all sprint-based
and task-based project types.

---

## Operational Mode

Operational mode is an opt-in flag for agentic-workflow systems that
have day-to-day operational work beyond structural changes. Examples:
a personal operating system that runs daily reviews, weekly planning,
and monthly retrospectives alongside structural system updates.

### What operational mode means

- The system has recurring operational sessions (daily, weekly,
  monthly, or custom cadences)
- These sessions are **human-initiated and interactive** — the human
  starts the session, drives the work, and makes decisions throughout
- There is no agent orchestration for operational work. No coordinator
  manages the cadence. The human decides when to run each session

### What operational mode does NOT mean

- It does not add agents to the structural roster
- It does not change the 7-step structural update protocol
- It does not schedule or automate operational sessions

### Documents for operational mode

When operational mode is enabled, the project may include:
- A status file tracking current system state
- Operational logs from recurring sessions
- Ritual definitions (what each cadence session covers)

These are project-specific and human-maintained — they are not
Fabrika-managed artifacts with catalogs and templates.
