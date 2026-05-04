---
type: system-update-plan
change-request: planning/CR-29-unified-document-hierarchy.md
status: executed
created: 2026-05-04
---

# System Update Plan: CR-29 Unified Document Hierarchy

CR-29 formalizes that the decomposition hierarchy IS the alignment
hierarchy. There is no separate "alignment artifact" concept. The
documents at each decomposition level are already the alignment
artifacts:

```
Charter        -> project inception
  Roadmap      -> execution sequence meta-layer
    PRD        -> phase or feature
      Epic     -> grouping envelope
        Story  -> sprint-scoped (patch/story/deep story tiers)
        Task   -> bounded work (simple/standard modes)
        Bug    -> defect (task + reproduction context)
```

The work has three axes: (1) merge Brief-Template.md and
Analysis-Brief-Template.md into a single Task-Template.md, (2) rename
"brief" to "task" throughout the codebase (the task document IS the
brief — it captures the ask), and (3) rename Outcome-Report-Template.md
to Analysis-Outcome-Template.md to follow the naming convention. The
"enhanced brief" concept is killed. The "brief check" term is retired
in favor of "plan check" or "plan validation."

## Design Decisions

All five design decisions from the CR have been resolved through
alignment:

1. **Stories and tasks are parallel concepts at the same decomposition
   level.** Stories are NOT briefs with sprint metadata. Stories and
   tasks serve different workflow contexts — stories live in sprint-based
   domain workflows, tasks live in the task workflow and analytics
   workflow. Both sit under Epic in the decomposition hierarchy.

2. **Brief merges into Task.** The "brief" was the task document all
   along — it captures the ask/context from stakeholders. Brief-Template
   and Analysis-Brief-Template merge into a single Task-Template.md. The
   file path `tasks/[date-name]/brief.md` becomes
   `tasks/[date-name]/task.md`.

3. **"Enhanced brief" is killed.** The concept is removed from Design
   Alignment. Complexity is already handled by the CR-18/19 spectrum
   (simple mode -> standard mode -> story with tiers). Design Alignment
   produces Charter+PRD or PRD only.

4. **"Brief check" is retired.** Planner validation mode validates
   against the PLAN, not the task document. Renamed to "plan check" /
   "plan validation." Domain Language and all references updated.

5. **Roadmaps get a light template.** A new Roadmap-Template.md is
   created with active phases, completed phases (collapsed to one-line
   summaries), and future phases (deferred). It is an index/sequence
   document that points to PRDs/epics.

6. **Outcome-Report-Template.md renamed to Analysis-Outcome-Template.md.**
   Follows the naming convention where specialized templates use
   descriptor + base name (e.g., Analysis-Plan-Template.md).

7. **"Alignment artifact" and "alignment hierarchy" as new Domain
   Language terms are NOT needed.** The decomposition hierarchy already
   serves this purpose. Existing terms are updated to reference how the
   decomposition hierarchy relates to alignment.

---

## File Change Inventory

### New files

| File | Purpose |
|------|---------|
| `core/templates/Task-Template.md` | Merged from Brief-Template.md + Analysis-Brief-Template.md. The unified task document template. |
| `core/templates/Roadmap-Template.md` | Light template: active phases, completed phases (one-line), future phases (deferred), execution order, dependency graph. |

### Renamed files

| Old path | New path | Reason |
|----------|----------|--------|
| `core/templates/Outcome-Report-Template.md` | `core/templates/Analysis-Outcome-Template.md` | Naming convention: specialized = descriptor + base name |

### Deleted files

| File | Reason |
|------|--------|
| `core/templates/Brief-Template.md` | Merged into Task-Template.md |
| `core/templates/Analysis-Brief-Template.md` | Merged into Task-Template.md |

### Modified files — Tier 1 (core concept changes)

| File | Change summary |
|------|----------------|
| `core/Document-Catalog.md` | Add decomposition hierarchy section; rename all "brief" -> "task" in document listings; update template references (add Task-Template, Roadmap-Template; remove Brief-Template, Analysis-Brief-Template; rename Outcome-Report-Template); update task folder path from brief.md to task.md; rename "brief check" -> "plan check" |
| `core/workflows/protocols/design-alignment.md` | Remove "enhanced brief" concept; remove Analytics-Workspace subsection that produces enhanced briefs; reframe output as Charter+PRD or PRD only; remove category-specific Project-Type-Specific Behavior section |
| `Domain-Language.md` | Retire "brief check" -> "plan check/validation"; update Design Alignment definition to remove enhanced brief; update all terms referencing "brief" to reference "task"; add decomposition hierarchy note to relevant terms |
| `integrations/claude-code/CLAUDE.md` | Update Design Alignment section to remove enhanced brief; rename all "brief" -> "task" for task documents; update task folder paths (brief.md -> task.md); rename brief check -> plan check |
| `integrations/copilot/copilot-instructions.md` | Same changes as CLAUDE.md |

### Modified files — Tier 2 (workflow files)

| File | Change summary |
|------|----------------|
| `core/workflows/types/task-workflow.md` | Rename "brief" -> "task" throughout (the document, the file path, the lifecycle diagram, the folder structure); update Brief Template reference -> Task Template; rename "brief check" references; update Design Alignment section to remove "enhanced brief" |
| `core/workflows/types/analytics-workflow.md` | Rename "brief" -> "task" throughout; update "enhanced Analysis Brief" -> remove concept; rename brief.md -> task.md in folder structure and phase details; rename "brief check" -> "plan check"; update template references (Analysis-Brief-Template -> Task-Template, Outcome-Report-Template -> Analysis-Outcome-Template) |

### Modified files — Tier 3 (agent prompts)

| File | Change summary |
|------|----------------|
| `core/agents/analysis-planner.md` | Rename "brief" -> "task" where it refers to the task document; update file path references (brief.md -> task.md); rename "brief check" -> "plan check" in validation mode output path |
| `core/agents/planner.md` | Rename "brief" -> "task" where it refers to the task document; update dispatch contract field names; update output contract references |
| `core/agents/reviewer.md` | Rename "brief" -> "task" where it refers to the task document |
| `core/agents/validator.md` | Rename "brief" -> "task" where it refers to the task document |
| `core/agents/implementer.md` | Rename "brief" -> "task" where it refers to the task document |
| `core/agents/data-analyst.md` | Rename "brief" -> "task" where it refers to the task document (orientation step referencing brief) |
| `core/agents/data-validator.md` | Rename "brief" -> "task" (orientation step referencing brief.md) |
| `core/agents/logic-reviewer.md` | Rename "brief" -> "task" (orientation step referencing brief.md) |
| `core/agents/performance-reviewer.md` | Rename "brief" -> "task" (orientation step referencing brief.md) |
| `core/agents/visualization-designer.md` | Rename "brief" -> "task" (orientation step referencing brief.md) |

### Modified files — Tier 4 (dispatch contracts)

| File | Change summary |
|------|----------------|
| `core/workflows/protocols/dispatch/planner-contracts.md` | Rename "Brief" field -> "Task document" in base planner contracts; rename brief.md paths -> task.md; update analysis planner output path; rename brief-check.md -> plan-check.md in validation mode outputs |
| `core/workflows/protocols/dispatch/reviewer-contracts.md` | Rename "Brief" field -> "Task document" in base reviewer and analytics reviewer contracts; update brief.md paths -> task.md |
| `core/workflows/protocols/dispatch/validator-contracts.md` | Rename "Brief" field -> "Task document" in base validator and data validator contracts; update brief.md paths -> task.md |
| `core/workflows/protocols/dispatch/implementer-contracts.md` | Rename "Brief" field -> "Task document" in base implementer contract; update brief.md paths -> task.md |
| `core/workflows/protocols/dispatch/designer-contracts.md` | Rename "task brief" -> "task document" in visualization designer dispatch |

### Modified files — Tier 5 (protocols and supporting files)

| File | Change summary |
|------|----------------|
| `core/workflows/protocols/doc-triggers.md` | Update trigger for new task: "write brief using Brief-Template" -> "write task document using Task-Template"; update "Task brief approved" trigger; rename Brief-Template.md -> Task-Template.md |
| `core/workflows/protocols/knowledge-pipeline.md` | Rename "brief" -> "task document" in pipeline cadence table (indexes task's brief -> task document) |
| `core/workflows/protocols/knowledge-synthesis.md` | Rename "brief" -> "task document" in synthesis summary references |
| `core/workflows/protocols/task-promotion.md` | Rename "brief template" -> "task template" in promotion level 1 description |
| `core/templates/Task-Contract-Template.md` | Rename brief.md path -> task.md; update "Pull from the brief and plan" -> "Pull from the task document and plan" |
| `core/templates/Plan-Template.md` | Update any reference to "brief" as the task document -> "task document" |
| `core/templates/Outcome-Template.md` | Update "question from the brief" -> "question from the task document" |

### Modified files — Tier 6 (briefings and archetypes)

| File | Change summary |
|------|----------------|
| `core/briefings/task-plan-briefing.md` | Rename references to "the brief" as task document -> "the task document" where it refers to the task artifact |
| `core/agents/archetypes/reviewer.md` | Rename "task brief" -> "task document" |
| `core/agents/archetypes/designer.md` | Rename "brief (analytics workflow)" -> "task document" |

### Modified files — Tier 7 (consumer-facing and lifecycle docs)

| File | Change summary |
|------|----------------|
| `BOOTSTRAP.md` | Rename Brief-Template.md references -> Task-Template.md; rename Outcome-Report-Template.md -> Analysis-Outcome-Template.md; remove "enhanced Analysis Brief" reference from Design Alignment note; update bootstrap checklist |
| `ADOPT.md` | Rename Brief-Template.md references -> Task-Template.md |
| `ADD-WORKFLOW.md` | Rename Brief-Template.md reference -> Task-Template.md |
| `MIGRATIONS.md` | Add migration entry for brief.md -> task.md rename, Brief-Template -> Task-Template, Analysis-Brief-Template deletion, Outcome-Report-Template -> Analysis-Outcome-Template rename |
| `core/design-principles.md` | Rename "the brief" -> "the task document" where it refers to the task artifact |
| `core/FABRIKA.md` | Rename "brief" -> "task document" if it references the task artifact (check: only "brief" in this file is "brief reasoning" in eval artifact — no change needed if so) |

### Modified files — Tier 8 (wiki and CR doc)

| File | Change summary |
|------|----------------|
| `wiki/topics/workflow-design.md` | Rename "brief" -> "task" in lifecycle descriptions, folder structure, brief check -> plan check |
| `wiki/topics/framework-philosophy.md` | Rename "brief" -> "task" where it refers to the task document |
| `wiki/topics/agent-model.md` | Rename "brief" -> "task" where it refers to the task document |
| `planning/CR-29-unified-document-hierarchy.md` | Update Alignment Notes section with v2 alignment decisions |

### Modified files — Tier 9 (meta)

| File | Change summary |
|------|----------------|
| `README.md` | Update to mention the decomposition hierarchy and unified task document |
| `VERSION` | 0.32.0 -> 0.33.0 |
| `CHANGELOG.md` | Add 0.33.0 entry |

### Files NOT changed (important exclusions)

| File | Reason |
|------|--------|
| `core/templates/Story-Template.md` | No hierarchy positioning note needed (rejected in alignment). Stories are parallel to tasks, not a brief subtype. |
| `core/templates/PRD-Template.md` | No hierarchy positioning note needed (rejected). |
| `core/templates/Project-Charter-Template.md` | No hierarchy positioning note needed (rejected). |
| `core/templates/Bug-Report-Template.md` | No hierarchy positioning note needed (rejected). Bug is already described as a task with reproduction context in the workflow and Domain Language. |
| `core/templates/Analysis-Plan-Template.md` | Stays separate. Analysis Plan is a genuine domain specialization, not redundancy. No rename needed. |
| Software engineer, ml-engineer, ai-engineer, data-engineer agent prompts | Their "brief" references are the English word ("Brief implementation summary"), not the task document concept. No rename needed. |
| `core/briefings/task-outcome-briefing.md` | Its "brief descriptions" is the English adjective, not the document concept. No rename needed. |
| `core/briefings/briefing-principles.md` | "When to Brief" uses the English verb. No rename needed. |
| `core/briefings/structural-plan-briefing.md` | "Brief summary" is the English adjective. No rename needed. |

---

## Detailed Change Specifications

### 1. `core/templates/Task-Template.md` (NEW)

Merge of Brief-Template.md (the base task document) and
Analysis-Brief-Template.md (the analytics-specific version). The
merged template keeps the base structure with an optional analytics
section:

```markdown
---
type: task
task: [YYYY-MM-DD-short-name]
status: draft
requested_by: [Name, team, or "self"]
deadline: [Date or "no deadline"]
---

# Task: [Short descriptive title]

## The Goal
[What exactly needs to be done or answered? Be specific.]

## Who Needs This & Why
- **Requested by:** [Name, title, team — or "self"]
- **Decisions this informs:** [What will happen with this output?]
- **Audience:** [Who will see the results? What is their context?]

## Desired Output
- **Format:** [Document / spreadsheet / presentation / code / etc.]
- **Level of detail:** [Executive summary / detailed / raw / all]
- **Delivery method:** [Where does the output go when done?]

## Deadline
- **When:** [Specific date/time, or "when you can" with priority]
- **Hard or soft:** [Is this blocking something?]

## Known Constraints
- [Access limitations — tools, data, systems]
- [Scope boundaries — what is explicitly out of scope]
- [Quality caveats — known issues or limitations]
- [Format requirements — must work in a specific tool]

## Context
[Additional background. Prior work, related deliverables, why now.]
```

The analytics workflow uses this same template. The section headings
work for both analytics questions ("The Goal" = "The Question") and
general tasks. The Analysis-Brief-Template's "The Question" heading
was just a more specific way of saying "The Goal." The merged template
uses the more general heading.

### 2. `core/templates/Roadmap-Template.md` (NEW)

```markdown
---
type: roadmap
title: [Project or Phase Name] Roadmap
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Roadmap: [Project or Phase Name]

## Through-Line

[The narrative thread connecting all phases. What is the design shift,
capability evolution, or product transformation that ties these phases
together?]

## Active Phases

| Order | Item | Target | Dependency | Status | Summary |
|-------|------|--------|------------|--------|---------|
| 1 | [PRD/CR/Phase] | [version/date] | -- | [status] | [one-line] |
| 2 | [PRD/CR/Phase] | [version/date] | Item 1 | [status] | [one-line] |

## Completed Phases

| Item | Completed | Summary |
|------|-----------|---------|
| [PRD/CR/Phase] | [version/date] | [one-line summary of what shipped] |

## Deferred Phases

| Item | Reason Deferred | Depends On |
|------|-----------------|------------|
| [PRD/CR/Phase] | [why it was deferred] | [what must complete first] |

## Dependency Graph

[Which items depend on which. Simple list, ASCII diagram, or table.
The goal: make it clear which items can be reordered and which cannot.]

## Execution Protocol

[How each item is executed — the workflow, the fresh-chat boundary
pattern, what context carries between items.]
```

### 3. `core/templates/Analysis-Outcome-Template.md` (RENAMED from Outcome-Report-Template.md)

No content changes to the template itself. Only the filename changes.
All references to `Outcome-Report-Template.md` across the codebase
are updated to `Analysis-Outcome-Template.md`.

### 4. `core/Document-Catalog.md`

**Change A: Add decomposition hierarchy section.** Insert after "How
to Use This Catalog" (before "## 00-Index/"):

```markdown
## Decomposition Hierarchy

Fabrika's documents follow a decomposition hierarchy that also serves
as the alignment hierarchy — the documents at each level capture
shared understanding between orchestrator and owner about what work
needs to be done.

| Level | Document | When used |
|-------|----------|-----------|
| Project inception | **Charter** | Created once at project start or major pivot |
| Execution sequence | **Roadmap** | Organizes PRDs/phases into execution order with dependencies |
| Phase or feature | **PRD** | Features or phases complex enough for module-level planning |
| Grouping envelope | **Epic** | Groups related stories and tasks toward a larger goal |
| Sprint-scoped work | **Story** | Sprint-based work with acceptance criteria, points, tier |
| Bounded work | **Task** | Individual work items in task and analytics workflows |
| Defect | **Bug** | Task with reproduction context (observed/expected, steps) |

These are layers, not alternatives. A complex project might have a
charter, then a roadmap, then PRDs, then epics, then stories. A
simple task just has a task document. The orchestrator's complexity
assessment determines how much alignment ceremony is needed — the
same assessment that determines execution ceremony.
```

**Change B: Rename "brief" references throughout.** In the Base
Documents section:

- `tasks/[date-name]/brief.md (Brief)` -> `tasks/[date-name]/task.md (Task Document)`
- "Brief-Template.md (base)" -> "Task-Template.md"
- "Analysis-Brief-Template.md (analytics-specific)" -> removed (merged into Task-Template)
- "Outcome-Report-Template.md (analytics-specific)" -> "Analysis-Outcome-Template.md"
- All prose references to "brief" as the task document -> "task document"
- "brief check" -> "plan check" throughout

In the Analytics Workflow Documents section:
- `tasks/[date-name]/brief.md (Analysis Brief)` -> `tasks/[date-name]/task.md (Task Document)`
- "See Analysis-Brief-Template.md" -> "See Task-Template.md"
- "See Outcome-Report-Template.md" -> "See Analysis-Outcome-Template.md"
- `[task-name]-brief-check.md (Brief Check)` -> `[task-name]-plan-check.md (Plan Check)`

In the Base Documents blockquote:
- Remove "Brief" references, update to "Task document"
- "Briefs apply to tasks and bugs" -> "Task documents apply to tasks and bugs"

In the Templates section:
- Remove `Brief-Template.md` and `Analysis-Brief-Template.md`
- Add `Task-Template.md` and `Roadmap-Template.md`
- Rename `Outcome-Report-Template.md` -> `Analysis-Outcome-Template.md`

In the Quick Reference sections:
- Update "brief.md" -> "task.md" in per-task listings
- Update template names in listings

**Change C: Add Roadmap-Template.md and Task-Template.md to Templates
section.**

### 5. `core/workflows/protocols/design-alignment.md`

**Change A: Remove "enhanced brief" concept.** The Design Alignment
protocol produces Charter+PRD (new project) or PRD only (new phase).
It does NOT produce an "enhanced brief." Remove this concept from the
file header if present.

**Change B: Remove "Project-Type-Specific Behavior" section.** Replace
entirely. The current section has two subsections: "Sprint-Based
Projects and Agentic-Workflow" (standard behavior) and
"Analytics-Workspace" (produces enhanced Analysis Brief). The
analytics-specific subsection is removed because the "enhanced brief"
concept is killed. Replace with:

```markdown
## Output

Design Alignment produces Charter + PRD or PRD only. It does not
produce task documents — tasks use the standard task/plan flow
without Design Alignment unless complexity triggers escalation to
a PRD.

### Charter + PRD (new project or major pivot)

The Charter captures the problem space, target user, core
capabilities, constraints, and design principles. The PRD captures
feature-level requirements. Uses templates at
`core/templates/Project-Charter-Template.md` and
`core/templates/PRD-Template.md`.

### PRD only (new phase or feature)

The Charter already exists. Design Alignment produces only a PRD for
the new phase or feature.
```

**Change C: Update "When to Invoke" bullets.** Remove any bullet
referencing enhanced briefs or analytics-specific behavior. Keep:
new project, new phase, owner request, detected ambiguity.

### 6. `Domain-Language.md`

**Change A: Retire "Brief check" -> "Plan check."** Replace the
existing "Brief check" definition:

```markdown
**Plan check** — Analysis planner validation mode output at
`docs/evaluations/[task-name]-plan-check.md`. Verifies that the
analysis output answers the business question from the task document
in the format the stakeholder needs. Requirements validation (does the
output answer the right question?), not data validation (are the
numbers correct?). Verdict: MEETS REQUIREMENTS / PARTIALLY MEETS
REQUIREMENTS / DOES NOT MEET REQUIREMENTS. Formerly "brief check."
[Introduced in 0.20.0; renamed in 0.33.0.]
```

**Change B: Update "Design Alignment" definition.** Remove "For the
analytics workflow, produces an enhanced Analysis Brief instead of a
Charter/PRD." Replace with:

```markdown
**Design Alignment** — An orchestrator protocol for structured
requirements gathering. The orchestrator runs this directly (not a
sub-agent dispatch) because the iterative back-and-forth with the
owner requires conversational context. Produces a **Project Charter**
(first time) and a **PRD** (per phase or feature). Triggers: new
project, new phase, owner request, or detected ambiguity. [Formalized
in 0.14.0; enhanced brief concept removed in 0.33.0.]
```

**Change C: Update all terms that reference "brief" as the task
document.** Systematic replacements:

- "Brief check" -> "Plan check" (covered above)
- In "Task lifecycle" definition: "validate + brief check" -> "validate + plan check"
- In "Bug" definition: "specific brief structure" -> "specific task document structure"
- In "Analytics workflow project" definition: "brief -> plan" -> "task -> plan" in the lifecycle description
- In "Task-workspace project" definition: "brief -> plan" -> "task -> plan"
- In "Base workflow" definition: any "brief" reference to the document -> "task document"

**Change D: Add note about decomposition hierarchy.** Add to the
"Workflow" section, near the "Universal complexity spectrum" term:

```markdown
**Decomposition hierarchy** — The structural hierarchy of project
documents that also serves as the alignment hierarchy. Charter ->
Roadmap -> PRD -> Epic -> Story / Task / Bug. The documents at each
level capture shared understanding between orchestrator and owner.
The orchestrator's complexity assessment determines which level of
alignment ceremony is needed — the same assessment that determines
execution ceremony. [Formalized in 0.33.0.]
```

### 7. `integrations/claude-code/CLAUDE.md`

**Change A: Update Design Alignment section.** Remove "enhanced
Analysis Brief" concept. Design Alignment produces Charter+PRD or PRD
only. Remove the bullet about enhanced briefs. Update the description
to match the new design-alignment.md.

**Change B: Rename "brief" -> "task" for task documents.** In the
task folder structure, lifecycle descriptions, and agent dispatch
tables:
- `brief.md` -> `task.md`
- "reads brief" -> "reads task document"
- "produces briefs" -> "produces task documents"
- "brief check" -> "plan check"
- "Brief-Template" -> "Task-Template"

**Change C: Update analytics workflow section.** Remove "enhanced
Analysis Brief" references. Update template names. Update lifecycle
flow diagrams.

### 8. `integrations/copilot/copilot-instructions.md`

Same changes as CLAUDE.md (items 7A, 7B, 7C). These two files must
stay in sync.

### 9. `core/workflows/types/task-workflow.md`

**Change A: Rename "brief" -> "task document" throughout.** This is
the most heavily affected workflow file. Specific changes:

- Opening paragraph: "brief, plan, implement" -> "task, plan, implement"
- Agent Roster table: "Reads brief" -> "Reads task document"; "satisfies the brief" -> "satisfies the task document"
- Design Alignment section: Remove "enhanced brief" concept. The
  section should say Design Alignment produces a PRD when complexity
  warrants it, not an enhanced brief.
- Lifecycle diagram: `brief -> plan -> implement` -> `task -> plan -> implement`
- "### Brief" section heading -> "### Task Document"; update content
- File path: `tasks/[date-name]/brief.md` -> `tasks/[date-name]/task.md`
- Template reference: `Brief Template (core/templates/Brief-Template.md)` -> `Task Template (core/templates/Task-Template.md)`
- Bug Tasks section: "a brief that includes" -> "a task document that includes"
- Task Folder Structure: `brief.md <- What is needed` -> `task.md <- What is needed`
- Exploratory Iteration section: "the brief for context" -> "the task document for context"
- Knowledge Pipeline Cadence: "task's brief, plan" -> "task's task document, plan"

### 10. `core/workflows/types/analytics-workflow.md`

**Change A: Remove "enhanced Analysis Brief" concept.** In "Design
Alignment for Complex Analyses" section, remove the entire paragraph
about producing an enhanced Analysis Brief. Replace with: Design
Alignment produces a PRD when the analysis is complex enough to
warrant feature-level planning. Simple and standard analyses use the
standard task/plan flow.

**Change B: Rename "brief" -> "task document" throughout.** Same
pattern as task-workflow.md:
- `brief.md` -> `task.md` in all file paths
- "brief check" -> "plan check" in lifecycle diagrams and phase details
- `[task-name]-brief-check.md` -> `[task-name]-plan-check.md`
- "Brief type: Basic vs. enhanced" -> remove this from Pre-Workflow Assessment (enhanced is killed)
- Template references: Analysis-Brief-Template -> Task-Template; Outcome-Report-Template -> Analysis-Outcome-Template
- Task Folder Structure: `brief.md <- What is the question` -> `task.md <- What is the question`
- "brief/plan flow" -> "task/plan flow"

### 11. Agent prompt changes (systematic)

For each of these agents, the change is narrow and mechanical:

**`core/agents/analysis-planner.md`:**
- "Step 1: Write the Brief" -> "Step 1: Write the Task Document"
- "Write `brief.md`" -> "Write `task.md`"
- "using the Analysis Brief Template" -> "using the Task Template"
- "present the brief to the owner" -> "present the task document to the owner"
- "brief is confirmed" -> "task document is confirmed"
- Validation mode output: `brief-check.md` -> `plan-check.md`
- "MEETS BRIEF" -> "MEETS REQUIREMENTS" (etc.)
- "answers the business question from the brief" -> "answers the business question from the task document"

**`core/agents/planner.md`:**
- "Reads a brief" -> "Reads a task document"
- "Read the brief" -> "Read the task document" (orientation, planning procedure)
- "the brief's question" -> "the task document's question"
- "Brief" field in dispatch contract -> "Task document"
- "brief.md" -> "task.md" in all paths
- Validation mode output: `brief-check.md` -> `plan-check.md`
- "MEETS BRIEF" -> "MEETS REQUIREMENTS" (etc.)

**`core/agents/reviewer.md`:**
- "against the plan and brief" -> "against the plan and task document"

**`core/agents/validator.md`:**
- "satisfy the brief" -> "satisfy the task document"
- "brief's question" -> "task document's question"
- "brief satisfaction" -> "task document satisfaction"

**`core/agents/implementer.md`:**
- "Read the brief" -> "Read the task document"
- "brief.md" -> "task.md" in orientation

**`core/agents/data-analyst.md`:**
- "read the task brief and plan" -> "read the task document and plan"

**`core/agents/data-validator.md`:**
- "Read the task's `brief.md`" -> "Read the task's `task.md`"

**`core/agents/logic-reviewer.md`:**
- "Read the task's `brief.md`" -> "Read the task's `task.md`"

**`core/agents/performance-reviewer.md`:**
- "Read the task's `brief.md`" -> "Read the task's `task.md`"

**`core/agents/visualization-designer.md`:**
- "Read the task's `brief.md`" -> "Read the task's `task.md`"

### 12. Dispatch contract changes (systematic)

**`core/workflows/protocols/dispatch/planner-contracts.md`:**
- Analysis Planner output: "Brief at `tasks/[date-name]/brief.md`" -> "Task document at `tasks/[date-name]/task.md`"
- Base Planner "Brief" field -> "Task document" field; update path
- Base Planner validation: "brief.md" -> "task.md"; output path `brief-check.md` -> `plan-check.md`
- Analysis Planner validation: same brief-check -> plan-check rename

**`core/workflows/protocols/dispatch/reviewer-contracts.md`:**
- Logic Reviewer: "Task brief" -> "Task document"; "brief.md" -> "task.md"
- Performance Reviewer (analytics): same rename
- Reviewer (Base): "Brief" -> "Task document"; "brief.md" -> "task.md"

**`core/workflows/protocols/dispatch/validator-contracts.md`:**
- Data Validator: "Task brief" -> "Task document"; "brief.md" -> "task.md"
- Validator (Base): "Brief" -> "Task document"; "brief.md" -> "task.md"

**`core/workflows/protocols/dispatch/implementer-contracts.md`:**
- Implementer (Base): "Brief" -> "Task document"; "brief.md" -> "task.md"

**`core/workflows/protocols/dispatch/designer-contracts.md`:**
- Visualization Designer: "task brief" -> "task document"

### 13. Supporting file changes

**`core/workflows/protocols/doc-triggers.md`:**
- "New task in task-workspace | Create task folder, write brief using Brief-Template" -> "...write task document using Task-Template"
- "Task brief approved" -> "Task document approved"
- "Brief-Template.md" -> "Task-Template.md" in the trigger text

**`core/workflows/protocols/knowledge-pipeline.md`:**
- "Index the task's brief, plan, and outcome" -> "Index the task's task document, plan, and outcome"

**`core/workflows/protocols/knowledge-synthesis.md`:**
- Same "brief" -> "task document" rename in pipeline references

**`core/workflows/protocols/task-promotion.md`:**
- "brief template" -> "task template" in Level 1 description
- "brief, plan, and key SQL" -> "task document, plan, and key SQL"

**`core/templates/Task-Contract-Template.md`:**
- "Brief: `tasks/[date-name]/brief.md`" -> "Task document: `tasks/[date-name]/task.md`"
- "Pull from the brief and plan" -> "Pull from the task document and plan"

**`core/templates/Plan-Template.md`:**
- Update any "brief" references to "task document"

**`core/templates/Outcome-Template.md`:**
- "question from the brief" -> "question from the task document"

**`core/agents/archetypes/reviewer.md`:**
- "task brief" -> "task document"

**`core/agents/archetypes/designer.md`:**
- "brief (analytics workflow)" -> "task document"

### 14. Consumer-facing file changes

**`BOOTSTRAP.md`:**
- "Brief-Template.md" -> "Task-Template.md" in all template copy references
- "Outcome-Report-Template.md" -> "Analysis-Outcome-Template.md"
- Remove "enhanced Analysis Brief" from Design Alignment note
- Update bootstrap checklist: "Brief-Template" -> "Task-Template"

**`ADOPT.md`:**
- "Brief-Template" -> "Task-Template"

**`ADD-WORKFLOW.md`:**
- "Brief template" row -> "Task template"; path update

**`MIGRATIONS.md`:**
- Add 0.33.0 migration entry (see below)

### 15. Wiki topic changes

**`wiki/topics/workflow-design.md`:**
- "brief -> plan -> implement" -> "task -> plan -> implement"
- "brief check" -> "plan check" in lifecycle diagrams
- "base templates (Brief, Plan, Outcome)" -> "base templates (Task, Plan, Outcome)"

**`wiki/topics/framework-philosophy.md`:**
- Update any "brief" references to "task document" where appropriate

**`wiki/topics/agent-model.md`:**
- Update any "brief" references to "task document" where appropriate

### 16. CR-29 alignment notes update

**`planning/CR-29-unified-document-hierarchy.md`:**
Add new alignment notes section:

```markdown
## Alignment Notes (v2 — Design Alignment Walk, 2026-05-04)

1. **The decomposition hierarchy IS the alignment hierarchy.** There
   is no separate "alignment artifact hierarchy." The documents at
   each decomposition level (charter, roadmap, PRD, epic, story,
   task, bug) are already the alignment artifacts. No new Domain
   Language terms ("alignment artifact," "alignment hierarchy") needed.

2. **Brief merges into Task.** Brief-Template.md and
   Analysis-Brief-Template.md merge into Task-Template.md. The file
   path `tasks/[date-name]/brief.md` becomes
   `tasks/[date-name]/task.md`. The "brief" was the task document
   all along.

3. **"Enhanced brief" is killed.** Removed from Design Alignment.
   Complexity is handled by CR-18/19 spectrum. Design Alignment
   produces Charter+PRD or PRD only.

4. **"Brief check" retired.** Replaced with "plan check" / "plan
   validation." Planner validates against the plan, not the task
   document.

5. **Stories are NOT briefs with sprint metadata.** Stories and tasks
   are parallel concepts at the same decomposition level, serving
   different workflow contexts. The v1 plan's framing was wrong.

6. **Analysis Plan and Outcome templates stay separate.** Genuine
   domain specializations. Outcome-Report-Template.md renamed to
   Analysis-Outcome-Template.md (naming convention: specialized =
   descriptor + base name).

7. **No hierarchy positioning notes on templates.** The v1 plan's
   approach of adding blockquote notes to every template was
   rejected. The decomposition hierarchy is documented in
   Document-Catalog.md and Domain-Language.md, not scattered across
   template files.

8. **Roadmap is a single living document.** Active phases, completed
   phases (collapsed to one-line), future phases (deferred). An
   index/sequence document pointing to PRDs/epics.
```

### 17. `core/design-principles.md`

- "checks that the output answers the brief" -> "checks that the output answers the task document"

### 18. `VERSION`

Change contents from `0.32.0` to `0.33.0`.

### 19. `CHANGELOG.md`

Add entry at the top:

```markdown
## 0.33.0 — Unified document hierarchy: brief -> task, decomposition = alignment

Formalizes the decomposition hierarchy as the alignment hierarchy.
The "brief" concept merges into "task" — the task document captures
the ask, and the plan captures the approach. The "enhanced brief"
concept is killed; Design Alignment produces Charter+PRD or PRD only.
"Brief check" is retired in favor of "plan check." Adds a unified
Task-Template.md (merged from Brief-Template and
Analysis-Brief-Template) and a Roadmap-Template.md.

### Changed files

**Templates**
- `core/templates/Task-Template.md` — NEW: merged from
  Brief-Template.md and Analysis-Brief-Template.md. The unified task
  document template.
- `core/templates/Roadmap-Template.md` — NEW: light template for
  roadmaps (active/completed/deferred phases, execution order,
  dependency graph).
- `core/templates/Brief-Template.md` — DELETED: merged into
  Task-Template.md
- `core/templates/Analysis-Brief-Template.md` — DELETED: merged into
  Task-Template.md
- `core/templates/Outcome-Report-Template.md` — RENAMED to
  `core/templates/Analysis-Outcome-Template.md` (naming convention:
  specialized = descriptor + base name)
- `core/templates/Task-Contract-Template.md` — brief.md -> task.md,
  "brief" -> "task document"
- `core/templates/Plan-Template.md` — "brief" -> "task document"
- `core/templates/Outcome-Template.md` — "brief" -> "task document"

**Document hierarchy and protocols**
- `core/Document-Catalog.md` — added decomposition hierarchy section;
  renamed all "brief" -> "task" in document listings and templates;
  added Task-Template.md and Roadmap-Template.md to templates list;
  removed Brief-Template.md and Analysis-Brief-Template.md; renamed
  Outcome-Report-Template.md -> Analysis-Outcome-Template.md; renamed
  "brief check" -> "plan check"
- `core/workflows/protocols/design-alignment.md` — removed "enhanced
  brief" concept; removed Analytics-Workspace subsection; reframed
  output as Charter+PRD or PRD only
- `Domain-Language.md` — retired "brief check" -> "plan check"; added
  "decomposition hierarchy" term; updated Design Alignment definition;
  renamed "brief" -> "task document" across all affected terms

**Workflow files**
- `core/workflows/types/task-workflow.md` — renamed all "brief" ->
  "task document" (file paths, lifecycle, folder structure, template
  references); removed "enhanced brief" from Design Alignment section
- `core/workflows/types/analytics-workflow.md` — renamed all "brief"
  -> "task document"; removed "enhanced Analysis Brief" concept;
  renamed "brief check" -> "plan check"; updated template references

**Agent prompts**
- `core/agents/analysis-planner.md` — "brief" -> "task document";
  brief.md -> task.md; brief-check -> plan-check; MEETS BRIEF ->
  MEETS REQUIREMENTS
- `core/agents/planner.md` — "brief" -> "task document"; brief.md ->
  task.md; brief-check -> plan-check; MEETS BRIEF -> MEETS
  REQUIREMENTS
- `core/agents/reviewer.md` — "brief" -> "task document"
- `core/agents/validator.md` — "brief" -> "task document"
- `core/agents/implementer.md` — "brief" -> "task document"
- `core/agents/data-analyst.md` — "brief" -> "task document"
- `core/agents/data-validator.md` — brief.md -> task.md
- `core/agents/logic-reviewer.md` — brief.md -> task.md
- `core/agents/performance-reviewer.md` — brief.md -> task.md
- `core/agents/visualization-designer.md` — brief.md -> task.md
- `core/agents/archetypes/reviewer.md` — "task brief" -> "task
  document"
- `core/agents/archetypes/designer.md` — "brief" -> "task document"

**Dispatch contracts**
- `core/workflows/protocols/dispatch/planner-contracts.md` — "Brief"
  field -> "Task document"; brief.md -> task.md; brief-check ->
  plan-check in validation outputs
- `core/workflows/protocols/dispatch/reviewer-contracts.md` — "Task
  brief" / "Brief" -> "Task document"; brief.md -> task.md
- `core/workflows/protocols/dispatch/validator-contracts.md` — "Task
  brief" / "Brief" -> "Task document"; brief.md -> task.md
- `core/workflows/protocols/dispatch/implementer-contracts.md` —
  "Brief" -> "Task document"; brief.md -> task.md
- `core/workflows/protocols/dispatch/designer-contracts.md` — "task
  brief" -> "task document"

**Supporting protocols**
- `core/workflows/protocols/doc-triggers.md` — Brief-Template ->
  Task-Template; "task brief approved" -> "task document approved"
- `core/workflows/protocols/knowledge-pipeline.md` — "task's brief"
  -> "task's task document"
- `core/workflows/protocols/knowledge-synthesis.md` — "brief" ->
  "task document"
- `core/workflows/protocols/task-promotion.md` — "brief template" ->
  "task template"
- `core/design-principles.md` — "answers the brief" -> "answers the
  task document"

**Integration templates**
- `integrations/claude-code/CLAUDE.md` — removed "enhanced Analysis
  Brief" from Design Alignment; renamed all "brief" -> "task" for
  task documents; brief.md -> task.md; brief check -> plan check
- `integrations/copilot/copilot-instructions.md` — same changes as
  CLAUDE.md

**Consumer-facing**
- `BOOTSTRAP.md` — Brief-Template -> Task-Template;
  Outcome-Report-Template -> Analysis-Outcome-Template; removed
  "enhanced Analysis Brief" reference
- `ADOPT.md` — Brief-Template -> Task-Template
- `ADD-WORKFLOW.md` — Brief-Template -> Task-Template
- `MIGRATIONS.md` — added 0.33.0 migration entry

**Wiki**
- `wiki/topics/workflow-design.md` — "brief" -> "task"; "brief check"
  -> "plan check"
- `wiki/topics/framework-philosophy.md` — "brief" -> "task document"
- `wiki/topics/agent-model.md` — "brief" -> "task document"

**Meta**
- `planning/CR-29-unified-document-hierarchy.md` — updated Alignment
  Notes with v2 decisions
- `README.md` — added decomposition hierarchy mention
- `VERSION` — bumped 0.32.0 to 0.33.0

### Consumer update instructions

1. **Rename task documents.** In existing task folders, rename
   `brief.md` to `task.md`. This is not required for completed tasks
   — only active/future tasks.
2. **Replace templates.** Delete `Brief-Template.md` and
   `Analysis-Brief-Template.md` from your templates directory. Copy
   new `Task-Template.md`. Rename `Outcome-Report-Template.md` to
   `Analysis-Outcome-Template.md`. Copy new `Roadmap-Template.md`.
3. **Update agent prompts.** Copy updated agent prompts (any that
   reference brief.md or brief check).
4. **Update evaluation paths.** Existing `*-brief-check.md` files in
   `docs/evaluations/` do not need to be renamed retroactively. New
   evaluations will use `*-plan-check.md`.
5. **Update your CLAUDE.md or copilot-instructions.md.** Copy the
   Design Alignment section and task workflow sections from the
   updated integration templates.
6. **MIGRATIONS.md has the full migration checklist** for consumer
   projects that need step-by-step guidance.
```

### 20. `MIGRATIONS.md`

Add migration entry:

```markdown
## 0.33.0 — Brief -> Task rename, template consolidation

**What changed:** The "brief" concept is now "task document." The file
`brief.md` in task folders becomes `task.md`. Brief-Template.md and
Analysis-Brief-Template.md are merged into Task-Template.md.
Outcome-Report-Template.md is renamed to Analysis-Outcome-Template.md.
"Brief check" evaluation artifacts become "plan check."

**Consumer action required:**

1. Delete `Brief-Template.md` and `Analysis-Brief-Template.md` from
   your templates directory
2. Copy `Task-Template.md` and `Roadmap-Template.md` to your
   templates directory
3. Rename `Outcome-Report-Template.md` to
   `Analysis-Outcome-Template.md` in your templates directory
4. In new task folders, create `task.md` instead of `brief.md`.
   Existing completed task folders do NOT need retroactive renaming.
5. Copy updated agent prompts to `.claude/agents/` (or equivalent)
6. Copy updated integration template (CLAUDE.md or
   copilot-instructions.md)
7. Existing `*-brief-check.md` evaluation files do not need renaming.
   New evaluations will be created as `*-plan-check.md`.
```

---

## Integration Point Analysis

| Changed file | References from | Sync required |
|-------------|----------------|---------------|
| `core/templates/Task-Template.md` (NEW) | Document-Catalog.md (template listing), doc-triggers.md (new task trigger), BOOTSTRAP.md (template copy), ADD-WORKFLOW.md (template path), analysis-planner.md (creates task documents), planner.md (reads task documents) | Must be listed in Document-Catalog templates section; path must match doc-triggers reference; BOOTSTRAP must copy it |
| `core/templates/Roadmap-Template.md` (NEW) | Document-Catalog.md (template listing), BOOTSTRAP.md (may copy) | Must be listed in Document-Catalog templates section |
| `core/templates/Analysis-Outcome-Template.md` (RENAMED) | Document-Catalog.md (template listing), BOOTSTRAP.md (template copy), analytics-workflow.md (references outcome report template) | All references to Outcome-Report-Template.md must be updated |
| `core/Document-Catalog.md` | BOOTSTRAP.md (reads catalog), integration templates, agent prompts, doc-triggers.md | Decomposition hierarchy section must use Domain Language terms; template paths must match actual files |
| `core/workflows/protocols/design-alignment.md` | Integration templates (summarize Design Alignment), Domain-Language.md (defines the term), sprint-coordination.md (references it) | Removal of enhanced brief must be reflected in integration templates and Domain Language |
| `Domain-Language.md` | All canonical files use this vocabulary; wiki topics reference terms | "Plan check" must replace "brief check" consistently; "decomposition hierarchy" term must cross-reference correctly |
| `integrations/claude-code/CLAUDE.md` | Consumer projects copy this | Must accurately reflect design-alignment.md changes; task.md paths must be consistent |
| `integrations/copilot/copilot-instructions.md` | Consumer projects copy this | Must mirror CLAUDE.md for parity |
| Agent prompts (all affected) | Dispatch contracts reference field names | Dispatch contract field names ("Task document" vs "Brief") must match agent prompt expectations |
| Dispatch contracts (all affected) | Agent prompts read these contracts | Field names and file paths must be consistent with agent prompts and workflow files |
| `core/workflows/protocols/doc-triggers.md` | Integration templates reference triggers | Task-Template path must match actual file |
| `BOOTSTRAP.md` | Consumer projects follow this | Template names must match actual files in `core/templates/` |

---

## Risk Identification

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | Incomplete "brief" -> "task" rename | All files in the codebase | Some files still say "brief.md" while others say "task.md," causing agents to look for a file that does not exist. Partial rename is worse than no rename. |
| 2 | English word "brief" accidentally renamed | Agent prompts, briefings | "Brief implementation summary" becomes "Task document implementation summary" which is wrong — "brief" there is an adjective meaning "short," not the document concept. |
| 3 | Evaluation path inconsistency | Agent prompts, dispatch contracts, workflow files | Some files reference `brief-check.md` while others reference `plan-check.md`. Agents write to one path and validators look for the other. |
| 4 | Template merge loses analytics-specific structure | Task-Template.md, analytics-workflow.md | The merged Task-Template loses the "The Question" framing that analytics users find natural. The "The Goal" heading must work for analytics questions too. |
| 5 | Outcome-Report-Template rename missed somewhere | Document-Catalog, BOOTSTRAP, analytics-workflow | A reference to the old name causes bootstrap or analytics workflow to fail to find the template. |
| 6 | Design Alignment loses complexity triggers | design-alignment.md, analytics-workflow.md | The analytics workflow's complexity triggers (3+ data sources, multiple stakeholders, etc.) are currently documented in design-alignment.md. Removing the analytics subsection could lose these triggers. They must be preserved in analytics-workflow.md. |
| 7 | Integration template parity drift | CLAUDE.md, copilot-instructions.md | One gets updated, the other does not. |
| 8 | Consumer projects with existing brief.md files | MIGRATIONS.md | Migration instructions must be clear that retroactive renaming of completed tasks is optional. |

---

## Mitigations

| Risk # | Mitigation |
|--------|-----------|
| 1 | After implementation, grep the entire codebase for `brief\.md` (as a file path, not the English word). Every hit should be either (a) in a planning/evaluation document describing the rename or (b) in a historical CHANGELOG entry. Zero hits in active canonical files. |
| 2 | The implementer must distinguish between "brief" as a document concept (rename) and "brief" as an English adjective/adverb (do not rename). The "Files NOT changed" section in this plan explicitly lists files where "brief" is the English word. After implementation, verify: no instance of "Task document implementation summary" or similar nonsensical constructions. |
| 3 | Standardize on `plan-check.md` for the evaluation output path. Grep for `brief-check` after implementation — zero hits in active canonical files. |
| 4 | The merged Task-Template uses "The Goal" which subsumes "The Question." The analytics-workflow.md can note that for analytics tasks, "The Goal" typically states the business question. This is a documentation note, not a template change. |
| 5 | After implementation, grep for `Outcome-Report-Template` — zero hits in active canonical files. |
| 6 | The complexity triggers (3+ data sources, multiple stakeholders, novel domain, >2 day effort, significant decision) MUST remain in analytics-workflow.md even after design-alignment.md loses its analytics subsection. They are workflow-level triggers, not Design Alignment triggers. The analytics workflow already has these in its "Design Alignment for Complex Analyses" section — that section stays but changes its output description (produces a PRD instead of an enhanced brief). |
| 7 | Write CLAUDE.md changes first. Diff the corresponding sections of copilot-instructions.md to ensure structural parity. |
| 8 | MIGRATIONS.md explicitly states that retroactive renaming of completed task folders is NOT required. Only active and future tasks use the new naming. |

---

## Version Bump Determination

**Bump type:** Minor
**New version:** 0.33.0
**Reasoning:** Changes to `core/**` files (Document-Catalog.md,
templates, workflow files, agent prompts, dispatch contracts,
design-alignment.md) require a minor bump per Fabrika's bump rules.
`core/**` changes are the most impactful changes in this CR and
determine the bump type.

---

## CHANGELOG Draft

See "### 19. `CHANGELOG.md`" in the Detailed Change Specifications
section above for the complete CHANGELOG entry.

---

## Owner Decision Points (all resolved)

1. **Task-Template heading: "The Goal."** Approved. Analytics-workflow.md
   can contextualize it for analytics tasks.

2. **Plan check verdict: MEETS REQUIREMENTS / PARTIALLY MEETS
   REQUIREMENTS / DOES NOT MEET REQUIREMENTS.** Approved.

3. **Retroactive rename: not required.** Completed tasks keep
   `brief.md`. New tasks use `task.md`.

4. **Analytics workflows don't need Design Alignment for individual
   tasks.** Design Alignment fires at project/phase level per standard
   triggers (new project, new phase, owner request, ambiguity). Individual
   analytics tasks use the task/plan flow regardless of complexity. If
   work is truly a new phase/feature, the orchestrator recognizes that
   and Design Alignment fires via its standard triggers, not via
   analytics-specific complexity triggers. The analytics-workflow.md's
   "Design Alignment for Complex Analyses" section is simplified
   accordingly.

---

## Alignment History

- **v1:** Initial plan based on "brief as base alignment artifact"
  framing. Proposed hierarchy positioning blockquotes on all templates,
  "alignment artifact" and "alignment hierarchy" as new Domain Language
  terms, "enhanced brief" as moderate ceremony output, story as "brief
  with sprint metadata." 2026-05-04.

- **v2:** Complete rewrite after owner alignment walk. Key rejections:
  hierarchy positioning notes on templates, "alignment artifact" /
  "alignment hierarchy" as new terms, "enhanced brief" concept, story
  as brief subtype. Key decisions: decomposition hierarchy IS alignment
  hierarchy, brief merges into task, enhanced brief killed, brief check
  retired to plan check, Analysis-Outcome-Template rename. Scope
  expanded from conceptual framing to a codebase-wide "brief" -> "task"
  rename. 2026-05-04.
