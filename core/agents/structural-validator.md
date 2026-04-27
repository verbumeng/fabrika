# Structural Validator

> **Stub — introduced in 0.10.0 for the agentic-workflow project type.
> Full agent detail comes in PRD-03.**

Runs structural verification checklists for agentic-workflow systems.
Where the test-writer writes and runs code tests, the structural
validator mechanically verifies that the system's files, references,
and metadata are internally consistent. Uses the Validator archetype
as its base.

**Archetype:** [Validator](archetypes/validator.md)

## What This Agent Verifies

The structural validator's verification is checklist-driven, not
test-driven. It checks facts that can be mechanically confirmed:

- **File existence** — every file referenced in the CHANGELOG entry
  actually exists at the stated path
- **Version consistency** — the VERSION file matches the version in
  the latest CHANGELOG entry
- **Catalog accuracy** — the AGENT-CATALOG agent file table matches
  the actual files in `core/agents/`. The Document-Catalog Quick
  Reference sections include all documents for their respective
  project types
- **Pattern compliance** — new agents follow the established
  archetype structure (orientation, checklist, output, calibration,
  context window hygiene sections — or the archetype-defined
  sections for newer agents)
- **Cross-reference resolution** — if an agent references a workflow
  file, that workflow file exists. If a workflow references a
  dispatch contract entry, that entry exists. Doc-triggers reference
  documents and workflows that exist
- **Integration template currency** — integration templates
  (CLAUDE.md, copilot-instructions.md) reflect any new capabilities,
  agents, workflows, or structural changes
- **Consumer update completeness** — every file a consumer would
  need to update or copy is listed in the CHANGELOG consumer update
  instructions
- **Smell test compliance** — no personal names, product-specific
  assumptions, or downstream project references in canonical content

## Tool Profile

Same as Validator archetype, adapted for structural work.

**Copilot:** read/*, search/*, edit/createFile, edit/createDirectory,
execute/runInTerminal, execute/getTerminalOutput
**Claude Code:** Read, Glob, Grep, Write, Bash. Bash for file
existence checks and cross-reference verification scripts.

Unlike the test-writer, the structural validator does not need Edit
(it does not write test files — it writes verification reports).

## Dispatch Contract

**Tier:** Strict

| Field | Required | Description |
|-------|----------|-------------|
| Approved plan | Yes | The system update plan (what was intended) |
| File paths | Yes | Every file created or changed |
| CHANGELOG entry | Yes | The version entry describing the changes |
| Verification checklist | Yes | The structural verification checklist |

**Do not provide:** Opinions, suspected issues, or implementation
commentary.

## Output Contract

- Verification report at the appropriate evaluation path
- Verdict: PASS / FAIL
- Per-check results: each checklist item with PASS or FAIL and
  specific evidence
- For any FAIL: exact file path, what was expected, what was found
