# CR-28 Architecture Assessment (v3)

**Version:** 0.27.0
**Change:** Workflow folder reorganization + CLAUDE.md restructuring +
structural-validator path reference scoping
**Verdict:** SOUND

---

## Methodology

Read the approved plan (`docs/plans/CR-28-plan.md`) including both
Alignment History rounds. Independently examined every file in the
dispatch scope. Ran repo-wide searches for all 15 old flat-path
patterns (`core/workflows/[filename].md` without `types/` or
`protocols/` subdirectory). Verified new directory structure. Checked
all structural reference pointers. Evaluated the project CLAUDE.md
restructuring against the owner's explicit direction that it should
defer to the workflow file, not restate it.

---

## Findings

### 1. Instruction Decomposition

The types/protocols split is the right structural move. The
distinction is real and load-bearing: types define complete lifecycle
orchestrations that agents execute; protocols are reusable procedures
that types reference. This was already the implicit model -- making it
visible in the file system costs nothing and prevents future confusion
as more workflow types arrive in Phase 2.

`core/workflows/README.md` is appropriately lean (30 lines). It
documents the distinction, gives concrete examples, and points to
ADD-WORKFLOW.md for the full process. No over-engineering.

The project CLAUDE.md restructuring (Round 2) is clean. The old
structure had the workflow exclusion language buried at line 67 in a
way that agents misread. The new structure leads with "How you work on
this project (MANDATORY)" at the top, immediately after the one-line
identity paragraph. This is the highest-value real estate in the file
and the restructuring uses it well: three lines of instruction, three
pointer paths, one scoped exclusion list. The new "Files that must
stay current" section at line 112 is a necessary addition -- it
explicitly names CLAUDE.md and SYNC-AGENTFLOW.md as mandatory update
targets during structural changes, closing the gap that caused the
stale references in the first place.

**Assessment:** Sound. Both the directory split and the CLAUDE.md
restructuring improve clarity without adding weight.

### 2. Pointer Pattern Cleanliness

All 93+ cross-references updated correctly. Verified by exhaustive
grep for all 15 old flat-path patterns across the repo, excluding
historical files (CHANGELOG.md, MIGRATIONS.md, planning/, docs/plans/,
docs/evaluations/). Zero stale references found in canonical files.

Specific verification of key pointer chains:

- **AGENT-CATALOG.md** (line 44): references
  `core/workflows/types/agentic-workflow.md`. Line 98: references
  `core/workflows/protocols/dispatch-protocol.md`. Both correct.
- **Integration templates** (both CLAUDE.md and
  copilot-instructions.md): all 13 references per template updated.
  Verified all point to existing files under `types/` or `protocols/`.
- **Domain-Language.md**: all 8 references updated. File names in
  prose descriptions (dispatch protocol, sprint coordination, etc.)
  match the new file names.
- **BOOTSTRAP.md**: all 4 references updated.
- **Wiki files**: all references in workflow-design.md (Core files
  listing at lines 172-180), agent-model.md (4 references), and
  owner-preferences.md (1 reference) updated.
- **Internal workflow cross-references**: verified types/ files
  reference protocols/ with correct relative paths, and protocols/
  files reference each other correctly.
- **Agent prompt files**: analysis-planner.md, data-architect.md,
  software-architect.md, archetypes/architect.md all reference
  `protocols/dispatch-protocol.md` or `protocols/task-promotion.md`
  correctly.
- **Project CLAUDE.md**: lines 14, 17 reference
  `core/workflows/types/agentic-workflow.md` and
  `core/workflows/protocols/dispatch-protocol.md`. Integration point
  map at lines 160-167 uses updated short names ("agentic-workflow",
  "sprint-coordination").

One historical narrative reference in `wiki/topics/workflow-design.md`
line 13 mentions "sprint-lifecycle.md" by name in a description of
what files were extracted at v0.7.0. This is properly historical
prose -- it describes the file names as they existed at that version,
like the CHANGELOG does. Not a stale reference.

**Assessment:** Sound. Cross-reference sweep is complete and
consistent.

### 3. Context Budget

The project CLAUDE.md is 174 lines. It was already within a
comfortable context budget before CR-28, and the restructuring did
not meaningfully change its size -- it reorganized content rather than
adding it. The "How you work on this project (MANDATORY)" section is
8 lines including blank lines. The "Files that must stay current"
section is 9 lines. Neither adds material context load.

The integration template CLAUDE.md (consumer-facing) is 644 lines,
unchanged in size by CR-28. All workflow references remain pointers
("read: [path]") rather than inline content. The types/protocols
split does not change the number of pointers or the amount of content
loaded into any session.

`core/workflows/README.md` at 30 lines is appropriately sized. It
will be read infrequently -- only when someone is navigating the
directory structure or adding a new workflow type.

**Assessment:** Sound. No context budget inflation.

### 4. Pattern Consistency

**H1 titles match file names:**
- `agentic-workflow.md` -> "# Agentic Workflow" (correct; dropped
  "Lifecycle" from old name)
- `sprint-coordination.md` -> "# Sprint Coordination" (correct;
  dropped "Lifecycle" from old name)
- All other files: H1 titles match file names as expected.

**CLAUDE.md's relationship to the workflow file:** The owner's
explicit direction (Round 2 Alignment History) is that CLAUDE.md
should point to the workflow, not restate it. The restructured
CLAUDE.md satisfies this:

- Lines 12-14: "All work on canonical files follows the
  agentic-workflow structural update lifecycle. Read and follow it:
  `core/workflows/types/agentic-workflow.md`" -- pure pointer, no
  restatement of the 7 steps.
- Lines 17-18: dispatch contracts and agent roster are pointers, not
  summaries.
- Lines 20-25: the exclusion list is scoped ("The only work that does
  NOT require the lifecycle:") with three bullet points. This is
  CLAUDE.md's legitimate scope -- defining which work triggers the
  lifecycle and which does not. It does not restate what the lifecycle
  does.

The file does not duplicate any workflow step descriptions. The
versioning discipline, smell tests, and verification checklist
sections are CLAUDE.md-specific project configuration, not workflow
restatement. The distinction is correct: CLAUDE.md tells the agent
"what rules apply to this project"; the workflow file tells the agent
"how to execute changes."

**Naming consistency:**
- `types/` contains only workflow type definitions (4 files). Correct.
- `protocols/` contains only supporting processes (11 files). Correct.
- No naming drift -- files that moved without rename kept their names;
  the two renamed files have clean, consistent names.

**Assessment:** Sound. The CLAUDE.md restructuring properly defers to
the workflow file and does not duplicate it.

### 5. Integration Surface

**Consumer awareness:** The CHANGELOG 0.27.0 entry lists every
moved/renamed file with old and new paths (lines 27-56). Consumer
update instructions are 6 steps covering directory creation, renames,
cross-reference updates, file re-copying, integration template
updates, and README copying. The MIGRATIONS.md 0.27.0 entry provides
the complete path mapping table (15 rows) and 6 detailed migration
steps.

**Consumer completeness check:** The CHANGELOG consumer update
instructions (step 4) list 11 files to re-copy. Cross-referencing
against the plan's Modified files list: all agent files with path
changes are covered. The structural-validator.md change is also
included (line 102), which is correct since its path-reference-check
behavior affects consumer projects.

**Future session awareness:** The project CLAUDE.md's "Files that
must stay current" section (lines 112-125) ensures future planners
include CLAUDE.md in their cross-reference update lists. The
structural-validator.md update (lines 172-176) ensures verifiers
check CLAUDE.md for stale path references during future structural
updates. Both fix the systemic gap that caused the Round 2 scope
expansion.

**Integration template parity:** Both integration templates
(claude-code/CLAUDE.md and copilot/copilot-instructions.md) have
the same set of workflow path references, all pointing to the new
paths. No parity drift between tools.

**Assessment:** Sound. Consumers and future sessions have the
information they need.

---

## Summary

CR-28 is a cleanly executed structural reorganization. The
types/protocols directory split, the two file renames, and the 93+
cross-reference updates are all consistent. The Round 2 additions --
CLAUDE.md restructuring and structural-validator scoping fix -- close
a real systemic gap without over-engineering the solution. The
CLAUDE.md properly defers to the workflow file as single source of
truth; the structural-validator now distinguishes between smell test
exemption (preserved) and path reference checking (added). No
concerns found.

**Verdict: SOUND**
