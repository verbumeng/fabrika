---
type: evaluation
status: complete
created: 2026-05-03
evaluator: structural-validator
verdict: PASS
---

# CR-20 Structural Validation

**Verdict: PASS**

All 11 checks pass. No structural issues found.

---

## Check 1: VERSION matches CHANGELOG

**PASS**

- VERSION file contains: `0.28.0`
- Latest CHANGELOG entry heading: `## 0.28.0 — Context compaction as design principle`
- Values match.

## Check 2: All files referenced in CHANGELOG exist

**PASS**

Every file path named in the 0.28.0 CHANGELOG entry exists at the
stated path:

| File path | Exists |
|-----------|--------|
| `core/design-principles.md` | Yes |
| `core/workflows/protocols/dispatch-protocol.md` | Yes |
| `Domain-Language.md` | Yes |
| `integrations/claude-code/CLAUDE.md` | Yes |
| `integrations/copilot/copilot-instructions.md` | Yes |

## Check 3: Cross-references resolve

**PASS**

- `dispatch-protocol.md` line 1051: references
  `core/design-principles.md` ("See `core/design-principles.md` for
  the principle and anti-patterns"). Path is correct.
- `dispatch-protocol.md` line 1014: references
  `core/design-principles.md` in the Retry Protocol section ("See
  `core/design-principles.md` for the rationale"). Path is correct.
- `integrations/claude-code/CLAUDE.md` line 629: references
  `[FABRIKA_PATH]/core/design-principles.md` in the compaction
  bullet. Path template is correct (uses `[FABRIKA_PATH]` placeholder
  consistently with all other references in the file).
- `integrations/copilot/copilot-instructions.md` line 547: references
  `[FABRIKA_PATH]/core/design-principles.md` in the compaction bullet.
  Path template is correct.
- `Domain-Language.md` lines 304-305: references
  `core/design-principles.md` in the Compaction definition ("Defined
  in `core/design-principles.md`."). Path is correct.
- `design-principles.md` line 96: references
  `core/workflows/protocols/dispatch-protocol.md` for the enforcement
  mechanism. Path is correct.

## Check 4: No workflow type files were modified

**PASS**

`git diff --name-only HEAD` against all four workflow type files
returned empty output:
- `core/workflows/types/task-workflow.md` — not modified
- `core/workflows/types/development-workflow.md` — not modified
- `core/workflows/types/analytics-workspace.md` — not modified
- `core/workflows/types/agentic-workflow.md` — not modified

## Check 5: No agent prompt files were modified

**PASS**

`git diff --name-only HEAD -- core/agents/` returned empty output. No
files under `core/agents/` were changed.

## Check 6: Integration templates have compaction bullet

**PASS**

- `integrations/claude-code/CLAUDE.md` Key Constraints section:
  "Context window hygiene" bullet at line 628, followed immediately by
  "Compaction at phase transitions" bullet at line 629. Placement is
  correct (after context window hygiene).
- `integrations/copilot/copilot-instructions.md` Key Constraints
  section: "Context window hygiene" bullet at line 546, followed
  immediately by "Compaction at phase transitions" bullet at line 547.
  Placement is correct.

Both bullets reference `[FABRIKA_PATH]/core/design-principles.md`.

## Check 7: Domain-Language.md has compaction term

**PASS**

The Compaction term is defined at lines 300-311 in the Workflow
section, after the "Implementer-validator pairing" entry. Definition
includes: compressed artifact principle, signal preservation, dispatch
protocol output format constraints as enforcement mechanism, four
anti-patterns, pointer to `core/design-principles.md`, and version
tag "[Codified in 0.28.0.]".

## Check 8: Design-principles.md has three principles

**PASS**

Three principle sections exist:
1. **Implementer-Reviewer Pairing** — lines 10-37
2. **Implementer-Validator Pairing** — lines 40-61
3. **Compaction** — lines 64-98

All three are at the same structural level (H2 headings under the
file's H1). The Compaction section is roughly comparable in weight to
the existing two principles (~35 lines vs. ~28 and ~22 lines for the
existing principles).

## Check 9: Dispatch-protocol.md has Output Format Constraints

**PASS**

The "Output Format Constraints" section exists at line 1045, after
the "Retry Protocol" section (which ends at line 1040). The section
contains four subsections:
1. Research and exploration outputs (line 1057)
2. Plan and spec outputs (line 1068)
3. Evaluation report outputs (line 1078)
4. Sub-agent returns (line 1089)

The section is clearly separated from the per-agent dispatch contracts
that precede it (the last per-agent contract is Data Architect — Ad
Hoc, ending before the Retry Protocol).

## Check 10: No hard token limits

**PASS**

Searched all five changed files for patterns matching specific token
numbers used as limits (e.g., "1000 tokens", "50k tokens"). No
matches found in any changed file. Compaction constraints are
guideline-based (e.g., "compressed artifact," "exclude full file
contents") rather than rule-based with specific token counts.

## Check 11: Consumer update instructions are complete

**PASS**

The CHANGELOG lists four consumer update instructions:

1. `core/design-principles.md` — listed, this is a consumer file
2. `core/workflows/protocols/dispatch-protocol.md` — listed, this is
   a consumer file
3. `Domain-Language.md` — listed with conditional ("if your project
   maintains a Domain Language file"), correct since Domain Language
   is optional
4. Project instruction file (CLAUDE.md or copilot-instructions.md) —
   listed, covers both integration template variants

VERSION and CHANGELOG.md are not listed in consumer update
instructions, which is correct — consumers maintain their own VERSION
and CHANGELOG.
