# Methodology Review — CR-20: Context Compaction as Design Principle

**Reviewer:** methodology-reviewer
**Version under review:** 0.28.0
**Plan:** `docs/plans/CR-20-plan.md`
**Date:** 2026-05-03

---

## Verdict: PASS

All six criteria satisfied. The implementation faithfully executes the
approved plan with clean principle/enforcement separation, consistent
cross-references, correct placement and style in every changed file,
and complete consumer update instructions. No smell test violations.
No scope creep. Detailed findings below.

---

## Criterion 1: Cross-reference consistency

**Result: PASS**

All cross-references between changed files resolve correctly and form
coherent bidirectional chains.

Evidence:

- **design-principles.md -> dispatch-protocol.md:** The Compaction
  section's closing paragraph references
  `core/workflows/protocols/dispatch-protocol.md` as the enforcement
  mechanism (line 96). The path is correct.

- **dispatch-protocol.md -> design-principles.md:** The Output Format
  Constraints section's opening paragraph references
  `core/design-principles.md` for the principle and anti-patterns
  (line 1051). The path is correct.

- **Integration templates -> design-principles.md:** Both
  `integrations/claude-code/CLAUDE.md` (line 629) and
  `integrations/copilot/copilot-instructions.md` (line 547) reference
  `[FABRIKA_PATH]/core/design-principles.md`. Consistent with the
  existing pattern used by the "Implementer-reviewer pairing" bullet
  in the same section.

- **Domain-Language.md -> design-principles.md:** The Compaction entry
  (line 300) references `core/design-principles.md` as the definition
  source. Consistent with how Implementer-reviewer pairing and
  Implementer-validator pairing reference the same file.

- **Domain-Language.md -> dispatch-protocol.md:** The Compaction entry
  references `core/workflows/protocols/dispatch-protocol.md` for
  output format constraints. Path is correct.

- **Existing reference in dispatch-protocol.md's Retry Protocol:**
  Line 1013 already references `core/design-principles.md` for
  implementer-reviewer pairing rationale. The new Output Format
  Constraints section adds a second reference to the same file. No
  conflict.

No orphaned or broken references found.

---

## Criterion 2: Prompt pattern adherence

**Result: PASS**

The Compaction section in design-principles.md matches the style and
weight of the two existing principles.

Evidence:

- **Structural pattern:** All three principles follow the same
  structure: section header, definition paragraph, application details
  (either "How it applies" with per-project-type bullets, or a table
  and anti-pattern list), and a closing note on scope. The Compaction
  section uses a phase boundary table and an anti-patterns list, which
  is a reasonable variation that serves the material better than
  per-project-type bullets (compaction is universal, so per-type
  bullets would be redundant).

- **Weight:** Implementer-Reviewer Pairing is ~26 lines.
  Implementer-Validator Pairing is ~18 lines. Compaction is ~35 lines
  (including the table). Slightly larger than the other two but within
  the "roughly the same weight" guideline from the plan. The table is
  inherently wider but remains concise (one row per transition). Not
  over-expanded.

- **Voice:** Direct, lead-with-the-point style. No corporate-framework
  prose. No emojis. Matches VerbumEng writing voice.

- **Domain-Language entry style:** The Compaction entry follows the
  same pattern as Implementer-reviewer pairing and
  Implementer-validator pairing: definition, cross-reference to
  design-principles.md, version tag. Includes anti-patterns inline
  (consistent with how the pairing entries describe their scope
  inline). Tagged with `[Codified in 0.28.0.]` which matches the
  convention of `[Identified in 0.20.0, codified in 0.22.0.]` used
  by the pairing terms.

- **Integration template bullet style:** The compaction bullet in both
  templates uses the same format as neighboring bullets — bold lead
  phrase, action statement, pointer to reference doc. Content length
  and phrasing are consistent with the "Context window hygiene" and
  "Implementer-reviewer pairing" bullets.

- **Output Format Constraints section style:** Uses role-category
  organization with include/exclude lists. This is a new structural
  pattern (no prior section in dispatch-protocol.md uses this exact
  format), but the pattern is well-motivated: the existing per-agent
  tables specify inputs while this section specifies outputs by role
  category. The clear separation via its own section header after the
  Retry Protocol section prevents confusion with the per-agent input
  contracts.

---

## Criterion 3: Instruction decomposition quality

**Result: PASS**

The principle/enforcement split is clean. Principle (WHY) lives in
design-principles.md; enforcement (HOW) lives in
dispatch-protocol.md. No bleed between the two.

Evidence:

- **design-principles.md** contains: the definition of compaction,
  what gets compressed and what gets discarded (phase boundary table),
  what NOT to do (anti-patterns), and where the enforcement lives
  (pointer to dispatch-protocol.md). It does not specify output
  format details for specific agent role categories.

- **dispatch-protocol.md** contains: the concrete output constraints
  per role category (research, plan, evaluation, sub-agent returns),
  with specific include/exclude lists. It references
  design-principles.md for the principle and anti-patterns. It does
  not re-state the phase boundary table or anti-patterns.

- **Integration templates** contain: a one-line operational constraint
  with a pointer to design-principles.md. They do not attempt to
  summarize the enforcement mechanism or the output format
  constraints. This is correct — the detailed constraints are loaded
  on demand via the dispatch protocol, not front-loaded into the
  session instruction file.

This decomposition follows the existing pattern: design-principles.md
defines WHY (implementer-reviewer pairing principle), dispatch-protocol.md
defines HOW (per-agent contracts that enforce independence), and
integration templates carry a one-line awareness pointer.

---

## Criterion 4: Smell test compliance

**Result: PASS**

- **No personal references.** No references to LifeOS, Obsidian,
  Motion, PARA, or any personal workflow tools.
- **No downstream product names.** No references to Notnomo,
  Hearthen, MNEMOS, Opifex, edw labs, or VerbumEng in any changed
  canonical content.
- **Stranger test.** All content would make sense to a stranger
  cloning the repo for a greenfield project. The compaction principle
  is described in universal terms applicable to any multi-agent
  workflow. The phase boundary table uses generic transitions
  (Research -> Plan, Plan -> Implement, etc.) not project-specific
  ones.

---

## Criterion 5: Consumer update completeness

**Result: PASS**

The CHANGELOG 0.28.0 consumer update instructions list four actions:

1. Update `core/design-principles.md` — correct, this file changed
2. Update `core/workflows/protocols/dispatch-protocol.md` — correct,
   this file changed
3. Update `Domain-Language.md` (if maintained) — correct, with
   appropriate conditional
4. Update project instruction file from integration template — correct,
   covers both CLAUDE.md and copilot-instructions.md

All five changed canonical files are accounted for. VERSION is not
listed in consumer update instructions (correct — consumers track
their own versions). The "Changed files" section lists all five
modified files with accurate change descriptions. No file is missing.

---

## Criterion 6: Dispatch/output contract consistency

**Result: PASS**

The new Output Format Constraints section in dispatch-protocol.md
aligns with the existing dispatch contract structure without conflict.

Evidence:

- **Input vs. output separation:** The section opening paragraph
  explicitly states: "The dispatch contracts above specify what the
  orchestrator sends to each agent (inputs). This section specifies
  what agents return (outputs)." This distinction is clear and avoids
  confusion with the per-agent dispatch tables.

- **Role-category organization:** The output constraints are organized
  by four role categories (research/exploration, plan/spec, evaluation
  report, sub-agent returns) rather than per-agent. This complements
  the existing per-agent input contracts without duplicating them.
  Each category maps cleanly to existing agent archetypes: research
  outputs map to exploration sub-tasks; plan outputs map to Planner
  archetype outputs; evaluation outputs map to Reviewer and Validator
  archetype outputs; sub-agent returns are universal.

- **No conflicts with existing per-agent "Output expected" fields:**
  Each per-agent dispatch contract already has an "Output expected"
  line (e.g., "Review report at `docs/evaluations/[TICKET]-code-review.md`").
  The new Output Format Constraints do not contradict these — they
  add content-level guidance (lead with verdict, include file paths)
  while the existing per-agent fields specify the artifact location.
  Complementary, not conflicting.

- **No hard token limits:** The plan explicitly required no hard token
  limits. The implementation uses guideline language ("should return",
  "exclude", "lead with") not hard rules ("must be under N tokens").
  Confirmed.

- **Alignment with anti-patterns:** The output format constraints
  directly address the anti-patterns defined in design-principles.md.
  "Here's everything I found" -> research outputs specify "exclude
  full file contents." "I'll include this just in case" -> all
  categories specify what to include and what to exclude, pushing
  toward signal over noise. Consistent enforcement of the principle.

---

## Additional verification (from the plan's checklist)

- No workflow type files were modified (confirmed via `git diff
  --name-only HEAD -- core/workflows/types/` — empty)
- No agent prompt files were modified (confirmed via `git diff
  --name-only HEAD -- core/agents/` — empty)
- VERSION is 0.28.0 (confirmed)
- CHANGELOG 0.28.0 entry exists and lists all changed files (confirmed)
- Compaction bullet placed after "Context window hygiene" bullet in
  both integration templates (confirmed via diff)
- Compaction term placed after "Implementer-validator pairing" in
  Domain-Language.md Workflow section (confirmed at line 300)
