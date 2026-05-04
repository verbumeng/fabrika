# CR-29 Methodology Review

**Verdict: PASS WITH NOTES**

The brief-to-task rename is executed with high consistency across the
codebase. The decomposition hierarchy concept is cleanly introduced.
Design Alignment is coherent after the enhanced brief removal.
Consumer update instructions are complete. Two findings require
attention (one missed rename, one phantom CHANGELOG entry), but
neither breaks functionality or consumer workflows.

---

## Per-Criterion Findings

### 1. Cross-Reference Consistency

**Result: PASS WITH NOTES**

The brief-to-task rename is applied comprehensively across all active
canonical files. Systematic verification:

- `brief.md` as a file path: zero hits in `core/`, `integrations/`,
  consumer-facing docs, and wiki topics
- `brief-check` as an evaluation path: zero hits in active canonical
  files
- `Brief-Template` and `Analysis-Brief-Template`: zero hits in active
  canonical files (only in CHANGELOG history, planning docs, and plan
  files, which correctly describe the rename)
- `Outcome-Report-Template`: zero hits in active canonical files
  (only in CHANGELOG history and plan files)
- `enhanced brief` / `enhanced Analysis Brief`: zero hits in `core/`
  and `integrations/`
- All dispatch contracts use "Task document" consistently (not
  "Brief")
- All agent prompts reference `task.md` and "task document"
  consistently
- Integration templates (CLAUDE.md, copilot-instructions.md) use
  `task.md` in folder structures and "task document" in prose, with
  structural parity confirmed
- Document-Catalog template listings include Task-Template.md,
  Roadmap-Template.md, and Analysis-Outcome-Template.md correctly
- doc-triggers.md references Task-Template.md consistently

**Finding 1 (minor):** `core/agents/archetypes/planner.md` line 51
still says "analytics workspace briefs and plans" in the tool profile
instruction constraint. This should read "analytics workspace task
documents and plans." This file was not in the plan's changed files
list and was not in the "Changed files" dispatch to the implementer.
The miss is understandable -- the planner archetype's tool profile
is a narrow corner of the file, and the word "briefs" is used in a
compound phrase that reads naturally even in isolation. But it is
the document concept (the plural of "brief" as task artifact), not
the English word.

**Fix:** In `core/agents/archetypes/planner.md`, change "analytics
workspace briefs and plans" to "analytics workspace task documents
and plans" at line 51.

### 2. Prompt Pattern Adherence

**Result: PASS**

All agent prompts follow established patterns:

- Analysis planner: writes `task.md`, references Task Template,
  validation output at `plan-check.md`, verdict scale MEETS
  REQUIREMENTS / PARTIALLY MEETS REQUIREMENTS / DOES NOT MEET
  REQUIREMENTS
- Base planner: reads task document, produces plan, validation output
  at `plan-check.md`, same verdict scale
- All reviewer/validator/implementer agents reference `task.md` in
  orientation steps
- Dispatch contract field names ("Task document") are consistent
  between per-archetype contract files
  (`dispatch/planner-contracts.md`, etc.) and the corresponding agent
  prompt dispatch contract sections
- The designer archetype uses "task document" in its dispatch contract
  description, matching `dispatch/designer-contracts.md`

No pattern violations found.

### 3. Instruction Decomposition Quality

**Result: PASS**

The decomposition hierarchy section in Document-Catalog is well
structured:

- Placed after "How to Use This Catalog" and before the folder
  sections, which is the correct position for a conceptual
  orientation section
- Uses a clean table format mapping Level -> Document -> When used
- Includes the key insight that these are layers, not alternatives,
  and that the orchestrator's complexity assessment determines the
  level
- Does not duplicate content from Domain-Language.md -- the two
  complement each other (Document-Catalog shows the hierarchy
  visually, Domain-Language defines the term with cross-references)

The Roadmap-Template is appropriately light: active phases,
completed phases (collapsed), deferred phases, dependency graph,
and execution protocol. It captures structure without constraining
narrative.

The Task-Template is a clean merge of the former Brief-Template and
Analysis-Brief-Template. The section headings ("The Goal," "Who Needs
This & Why," etc.) work for both analytics and general tasks. The
plan correctly noted that "The Goal" subsumes "The Question."

### 4. Smell Test Compliance

**Result: PASS**

No changed files leak personal, product-specific, or tool-specific
assumptions:

- No references to LifeOS, Obsidian, Motion, or PARA
- No downstream product names (Notnomo, Hearthen, MNEMOS, Opifex,
  edw labs, VerbumEng) in canonical files
- All changed files would make sense to a stranger cloning the repo
- The decomposition hierarchy description is generic -- it references
  Charter, Roadmap, PRD, Epic, Story, Task, Bug without assuming any
  specific project or industry
- The Roadmap-Template is domain-agnostic
- The Task-Template contains no analytics-specific language while
  remaining usable for analytics tasks

### 5. Consumer Update Completeness

**Result: PASS WITH NOTES**

The CHANGELOG consumer update instructions are comprehensive:

1. Task document rename (`brief.md` -> `task.md`) with correct note
   that completed tasks don't need retroactive renaming
2. Template replacement instructions (delete old, copy new, rename
   Outcome-Report-Template)
3. Agent prompt update instructions
4. Evaluation path guidance (existing brief-check files don't need
   renaming)
5. Integration template update instructions
6. MIGRATIONS.md pointer for step-by-step guidance

MIGRATIONS.md covers all consumer actions with clear, numbered steps.

**Finding 2 (minor):** The CHANGELOG at lines 99-100 lists
`core/workflows/protocols/knowledge-synthesis.md` as changed
("brief" -> "task document"), but the file was NOT actually modified
(confirmed via git diff against main). The file's only "brief"
reference is "brief summary" at line 168, which is the English
adjective, not the document concept. This is a phantom entry in the
CHANGELOG. A consumer reading the CHANGELOG would look for changes
in this file and find none. This does not break anything but is
misleading.

**Fix:** Remove the knowledge-synthesis.md line from the 0.33.0
CHANGELOG entry, or add a note that no change was needed after
inspection.

### 6. Dispatch/Output Contract Consistency

**Result: PASS**

All dispatch contracts match what agents expect to receive:

- **Planner contracts:** Analysis Planner outputs task document at
  `tasks/[date-name]/task.md`, validation output at
  `[task-name]-plan-check.md`. Base Planner uses the same paths and
  field names. Both match their respective agent prompt dispatch
  contract sections.
- **Reviewer contracts:** Logic reviewer, performance reviewer, and
  base reviewer all use "Task document" as the field name pointing to
  `tasks/[date-name]/task.md`. Consistent with agent prompt
  orientation steps.
- **Validator contracts:** Data validator and base validator use
  "Task document" pointing to `tasks/[date-name]/task.md`. Consistent
  with agent prompts.
- **Implementer contracts:** Base implementer uses "Task document"
  pointing to `tasks/[date-name]/task.md`. Data analyst contracts use
  the same paths. Consistent with agent prompts.
- **Designer contracts:** Visualization designer uses "task document"
  in requirements description. Consistent with designer archetype.
- **Verdict scales:** Analysis planner and base planner use MEETS
  REQUIREMENTS / PARTIALLY MEETS REQUIREMENTS / DOES NOT MEET
  REQUIREMENTS consistently in both the dispatch contract file and
  their agent prompt files.

### 7. Design Alignment Protocol Coherence

**Result: PASS**

The removal of "enhanced brief" from design-alignment.md is clean:

- The "When to Invoke" section retains its four triggers: new
  project, new phase, owner request, detected ambiguity. No
  analytics-specific triggers remain.
- The "Output" section clearly states: Charter + PRD or PRD only.
  The sentence "It does not produce task documents" is the correct
  boundary statement -- tasks use the standard task/plan flow.
- The Protocol section (steps 1-7) is unchanged and reads coherently
  end-to-end without the enhanced brief concept.
- The analytics-specific subsection ("Analytics-Workspace" or
  "Project-Type-Specific Behavior") is fully removed.
- Domain-Language.md's "Design Alignment" definition correctly states
  "enhanced brief concept removed in 0.33.0."
- Both integration templates describe Design Alignment as producing
  Charter + PRD without any analytics-specific output.
- The analytics-workflow.md correctly retains its complexity triggers
  (3+ data sources, multiple stakeholders, novel domain, etc.) as
  workflow-level triggers, not Design Alignment triggers.

### 8. Domain Language Accuracy

**Result: PASS**

New and updated terms in Domain-Language.md are accurate:

- **"Plan check"** (renamed from "brief check"): definition is
  accurate -- correctly describes the analysis planner validation mode
  output, its path, its purpose (requirements validation, not data
  validation), and its verdict scale. Version history note
  "[Introduced in 0.20.0; renamed in 0.33.0]" is correct.
- **"Design Alignment"** (updated): correctly states it produces
  Charter and PRD, with version note "enhanced brief concept removed
  in 0.33.0."
- **"Decomposition hierarchy"** (new): accurate definition matching
  Document-Catalog's decomposition hierarchy section. Correctly states
  Charter -> Roadmap -> PRD -> Epic -> Story / Task / Bug. Version
  note "[Formalized in 0.33.0]" is correct.
- **"Bug"** definition: correctly uses "task document structure"
  instead of the former "brief structure."
- **"Analytics workflow project"** definition: correctly uses "task ->
  plan" instead of "brief -> plan."
- **"Task lifecycle"** definition: correctly uses "validate + plan
  check" instead of "validate + brief check."
- **"Base workflow"** definition: no "brief" references remain.

All cross-references between Domain-Language.md terms and the files
that implement those terms are consistent.

---

## Summary of Findings

| # | Severity | File | Description |
|---|----------|------|-------------|
| 1 | Minor | `core/agents/archetypes/planner.md` | Line 51: "workspace briefs and plans" should be "workspace task documents and plans" -- missed rename of "brief" as the document concept |
| 2 | Minor | `CHANGELOG.md` | Lines 99-100: lists `knowledge-synthesis.md` as changed ("brief" -> "task document") but the file was not modified -- phantom CHANGELOG entry |

Neither finding breaks consumer workflows or agent behavior. Finding 1
is a cosmetic inconsistency in a tool profile instruction constraint
that does not affect dispatch or agent behavior. Finding 2 is a
documentation accuracy issue that could cause mild confusion for a
consumer reading the CHANGELOG.
