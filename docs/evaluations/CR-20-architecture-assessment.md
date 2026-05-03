# CR-20 Architecture Assessment

**Verdict: SOUND**

---

## 1. Instruction Decomposition

**Assessment: Clean.**

The WHY/HOW split between `core/design-principles.md` and
`core/workflows/protocols/dispatch-protocol.md` is well-executed.
design-principles.md defines what compaction IS (principle, phase
boundary table, anti-patterns) while dispatch-protocol.md defines
what compaction LOOKS LIKE in practice (output format constraints
organized by role category). Neither file duplicates the other's
content.

The cross-reference is one-directional and appropriate:
design-principles.md points forward to dispatch-protocol.md for the
enforcement mechanism (line 94-96), and dispatch-protocol.md points
back to design-principles.md for the principle and anti-patterns
(line 1051). This bidirectional pointer pair is the same pattern
used for implementer-reviewer pairing between these same two files
(dispatch-protocol.md line 1013-1014 references
design-principles.md for the retry protocol rationale).

No duplication of the anti-patterns list, the phase boundary table,
or the output format constraints between the two files. An agent
loading design-principles.md gets the principle; an agent loading
dispatch-protocol.md gets the enforcement spec. An agent can load
one without the other.

## 2. Pointer Pattern Cleanliness

**Assessment: Clean, consistent with existing patterns.**

The reference chain is:

```
design-principles.md  <-->  dispatch-protocol.md
       |                            |
       v                            v
Domain-Language.md        (already referenced by all
       |                   workflow files for dispatch
       v                   contracts)
integration templates
(CLAUDE.md, copilot-instructions.md)
```

This mirrors the existing pattern for implementer-reviewer pairing:
- Domain-Language.md defines the term and points to
  design-principles.md (lines 286-289, 295-298, now 300-310)
- Integration templates reference design-principles.md in Key
  Constraints (existing pattern for the implementer-reviewer bullet)
- Workflow files reference design-principles.md for the rationale
  (task-workflow.md line 129, agentic-workflow.md line 143,
  analytics-workspace.md line 465, development-workflow.md line 134)

No new reference chains were created. No cycles introduced. The
compaction principle uses the same pointer topology as the two
existing principles. The workflow files were NOT modified -- this is
consistent with the plan's scope boundary (existing references from
workflow files to design-principles.md are sufficient; agents
loading workflow files already have a path to design-principles.md).

## 3. Context Budget Balance

**Assessment: Acceptable, minor note.**

design-principles.md is always-loaded context for agents that
reference it. After CR-20, the file grew from ~62 lines (two
principles) to ~99 lines (three principles). Section sizes:

- Implementer-Reviewer Pairing: ~28 lines (lines 10-37)
- Implementer-Validator Pairing: ~22 lines (lines 40-61)
- Compaction: ~35 lines (lines 64-98)

The Compaction section is the longest of the three, roughly 60%
larger than Implementer-Validator Pairing and 25% larger than
Implementer-Reviewer Pairing. The plan specified "roughly the same
weight as the two existing principles." The overshoot is driven by
the phase boundary table (7 lines of table structure) and the
four anti-patterns (8 lines), both of which are referenced content
that would be hard to compress further without losing signal.

This is within acceptable range. A 35-line principle section in a
99-line file is not a context budget concern. The file remains
substantially smaller than dispatch-protocol.md (~1097 lines),
which is the on-demand file that agents load when they need
contracts.

The Output Format Constraints section in dispatch-protocol.md adds
~53 lines (lines 1045-1097). This is on-demand content (loaded when
the orchestrator reads dispatch contracts), not always-loaded. The
size is appropriate for covering four role categories with
include/exclude guidance for each.

## 4. Pattern Consistency

**Assessment: Consistent across all four surfaces.**

**design-principles.md:** The Compaction section follows the
structural pattern of the two existing sections:
- Section header as an H2 (line 64: `## Compaction`)
- Opening definition paragraph explaining the principle
- "How it applies" content (phase boundary table instead of
  per-project-type bullet list, which is appropriate since
  compaction is universal rather than project-type-specific)
- Anti-patterns list (unique to this principle, but justified --
  the other principles don't have named anti-patterns because their
  violations are harder to enumerate)
- Closing paragraph on scope and enforcement mechanism

The structural difference is that the existing two principles use
a "How it applies" section with bullet lists per project type,
while Compaction uses a phase boundary table and anti-patterns.
This is a deliberate design choice: the existing principles vary
by project type (different agents pair in different workflows),
while compaction is universal (same behavior at every phase
boundary regardless of project type). The different structure
matches the different nature.

**Domain-Language.md:** The Compaction entry (lines 300-310) follows
the existing entry format for implementer-reviewer pairing (lines
282-289) and implementer-validator pairing (lines 290-298):
- Bold term name
- Definition with em-dash
- Points to `core/design-principles.md`
- Version tag in brackets at end
- Placed in the Workflow section after the two existing pairing
  entries

**Integration templates:** Both CLAUDE.md (line 629) and
copilot-instructions.md (line 547) add the compaction bullet
immediately after the "Context window hygiene" bullet. The bullet
follows the same structural pattern as other Key Constraints
bullets: bold label, period, explanatory sentence, file pointer.
The read/write pair (hygiene = what agents read, compaction = what
agents produce) is well-placed.

**dispatch-protocol.md:** The Output Format Constraints section
(lines 1045-1097) is cleanly separated from the per-agent dispatch
contracts above it, placed after the Retry Protocol section. The
introductory paragraph (lines 1046-1054) explicitly distinguishes
inputs (dispatch contracts above) from outputs (this section). The
section is organized by role category rather than per-agent, which
avoids duplicating the per-agent dispatch contract structure and
keeps the section compact.

## 5. Integration Surface Completeness

**Assessment: Complete. No missing references, no unnecessary ones.**

Files that SHOULD reference compaction and DO:
- `core/design-principles.md` -- principle definition (changed)
- `core/workflows/protocols/dispatch-protocol.md` -- enforcement
  mechanism (changed)
- `Domain-Language.md` -- term definition (changed)
- `integrations/claude-code/CLAUDE.md` -- consumer awareness
  (changed)
- `integrations/copilot/copilot-instructions.md` -- consumer
  awareness (changed)

Files that reference design-principles.md for other reasons and
do NOT need compaction-specific additions:
- All four workflow type files (task-workflow.md,
  agentic-workflow.md, analytics-workspace.md,
  development-workflow.md) -- these reference design-principles.md
  for the implementer-reviewer pairing rationale in their
  review-revise sections. They do not need a separate compaction
  reference because compaction's enforcement mechanism lives in
  dispatch-protocol.md, which all workflow files already reference
  for dispatch contracts. Adding compaction pointer sections to
  workflow files was explicitly dropped from scope during alignment
  (plan Alignment History, Round 1, point 1).

Files that should NOT reference compaction and do NOT:
- Agent prompt files -- agents enforce compaction through the
  dispatch protocol's output format constraints, not by reading
  the principle by name (plan Scope Boundary confirms this)
- AGENT-CATALOG.md -- catalog of agents, not principles
- Templates -- they already embody compaction implicitly (plan
  Scope Boundary confirms this)

No gaps in the integration surface. The decision to NOT add
cross-cutting pointer sections to workflow files is structurally
sound -- it avoids context bloat in files that already have an
indirect path to design-principles.md.

---

## Summary

The CR-20 changes are structurally sound. The principle/enforcement
split between design-principles.md and dispatch-protocol.md is
clean and follows the same decomposition pattern used for the
existing principles. Reference chains are consistent, no cycles or
redundant pointers exist, and the integration surface is complete
without being over-extended. The Compaction section is slightly
larger than the existing principles but within acceptable range
given the phase boundary table and anti-patterns content. No files
were modified that should not have been, and no files that should
reference the new principle were missed.
