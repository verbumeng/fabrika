# PRD-14 Methodology Review (v2)

**Reviewer:** methodology-reviewer
**Plan:** `docs/plans/PRD-14-plan.md`
**Version:** 0.23.0
**Verdict:** PASS

**Context:** This is a re-review after a post-verification owner
decision to extract the onboarding questions from inline in
BOOTSTRAP.md into a standalone file at
`core/workflows/analytics-onboarding.md`. The v1 review evaluated
the inline version and passed with one actionable note (template
copy list gap). This review evaluates the extraction and whether
the v1 note was addressed.

---

## 1. Cross-Reference Consistency

**Finding: PASS**

All cross-references resolve correctly after the extraction. The
reference graph is clean:

- **BOOTSTRAP.md Phase 2W.1a** (lines 457-461) points to
  `[FABRIKA_PATH]/core/workflows/analytics-onboarding.md` with a
  five-line summary of what it does. The pointer is a run
  instruction, not a "see also" -- the orchestrator reads the
  standalone file and executes the protocol. This is the correct
  pattern (matches how other workflow files are referenced, e.g.,
  `core/workflows/design-alignment.md` from Phase 2.7).

- **ADOPT.md** (lines 151-167) has a dedicated section "Analytics
  Workspace Onboarding (Existing Workspaces)" that points to the
  same file. The section explains who it's for (existing workspaces
  adopting Fabrika or upgrading to 0.23.0+), what it does, and that
  existing source registry files are not affected. Self-contained --
  a consumer reading ADOPT.md does not need to read BOOTSTRAP.md to
  understand the reference.

- **analytics-onboarding.md** (lines 3-5) references back to both
  callers: "Run during bootstrap (BOOTSTRAP.md Phase 2W.1a) or
  retroactively via ADOPT.md for existing workspaces." Bidirectional
  references confirmed.

- **analytics-workspace.md** Tier 1 Plan (line 92-93), Tier 2 Plan
  (lines 165-171), and default cost note (lines 288-295) all
  reference `sources/connections/[platform]/README.md` and note
  onboarding as the population mechanism. They reference
  "BOOTSTRAP.md Phase 2W.1a" which now delegates to the standalone
  file -- the indirection is transparent because the workflow cares
  about the output (the platform README files), not the mechanism
  that created them.

- **Document-Catalog.md** Platform Connection entry (lines 577-582)
  references "BOOTSTRAP.md Phase 2W.1a" as the creation point.
  Same transparent indirection -- the catalog documents the consumer
  project output, not the framework workflow file.

- **CHANGELOG.md** (line 25) lists `core/workflows/analytics-onboarding.md`
  as a NEW file with accurate description. Consumer update
  instructions (line 78) include it as a file to copy.

- **VERSION** reads `0.23.0` -- matches CHANGELOG header.

- **Integration templates** (CLAUDE.md line 329, copilot-instructions.md
  line 240) both reference "BOOTSTRAP.md Phase 2W.1a" in the
  onboarding sentence. Same transparent indirection as above.

No dangling references. No circular dependencies.

---

## 2. Extraction Quality

**Finding: PASS**

The extraction to `core/workflows/analytics-onboarding.md` was done
cleanly. Three criteria for a clean extraction:

### 2a. Standalone file is self-contained

The file has everything an agent needs to execute the onboarding
protocol without reading BOOTSTRAP.md:

- **Prerequisites** (lines 12-17): what must exist before running
  (directory structure and templates).
- **Four question groups** with complete question text, conditional
  branching, scaffolding instructions, and skip guidance.
- **Output descriptions** for each group: what files are created,
  where they go, what template to use.

No implicit dependencies on BOOTSTRAP.md context. An agent reading
this file from ADOPT.md (retroactive onboarding) has everything it
needs.

### 2b. BOOTSTRAP.md pointer is sufficient

Phase 2W.1a (lines 455-461) provides a pointer with enough context
for the orchestrator to know what happens without reading the file
until it's time to execute:

- Title: "Platform onboarding (optional)"
- File path for the protocol
- One-sentence summary of what it asks about
- One-sentence summary of what it produces
- "(optional)" marking

This matches the established pointer pattern -- compare Phase 2.7's
pointer to `design-alignment.md` which similarly provides a summary
and file path.

### 2c. Phase 2W.2 integration preserved

The Phase 2W.2 section (lines 463-477) correctly handles both
scenarios:
- Onboarding completed: start from scaffolded stubs, check what
  exists before asking.
- Onboarding skipped: run full inventory.
- Creates platform READMEs during 2W.2 if none exist from
  onboarding (line 477).

This integration logic was present in the v1 (inline) version and
is preserved exactly.

---

## 3. ADOPT.md Reference Quality

**Finding: PASS**

The ADOPT.md section (lines 151-167) makes sense as a standalone
entry point for retroactive onboarding:

- Placed after the conflict handling section and before "After
  Adoption" -- logical location for a type-specific adoption step.
- Clearly scoped: "For analytics-workspace projects adopting
  Fabrika -- or existing workspaces upgrading to 0.23.0+."
- Explains the purpose (scaffold platform configuration and cost
  model documentation).
- Points to the standalone protocol file.
- Notes that existing files are not affected.

One small observation: ADOPT.md's section does not mention the
prerequisite that `sources/connections/` must already exist. For
adoption scenarios, this directory would have been created by the
standard Tier 1/2/3 adoption steps. For 0.23.0+ upgrades, the
directory would already exist from the original bootstrap. The
standalone file's Prerequisites section covers this, so the agent
will see it when it reads the file. Not a gap -- just noting the
indirection.

---

## 4. V1 Actionable Note Resolution

**Finding: RESOLVED**

The v1 review flagged that `Platform-Connection-Template.md` was
missing from the BOOTSTRAP.md Phase 2W.1 template copy list. This
has been addressed -- line 444 now includes:

```
Platform-Connection-Template.md -> docs/Templates/Platform-Connection-Template.md
```

This is consistent with the Document-Catalog Templates section
(line 763) and the pattern established by the other analytics-
workspace templates.

---

## 5. Prompt Pattern Adherence

**Finding: PASS**

The standalone `analytics-onboarding.md` follows the established
workflow file patterns:

- **Location:** `core/workflows/` -- consistent with other workflow
  files (analytics-workspace.md, design-alignment.md, etc.).
- **Opening structure:** Title, one-line description, separator,
  then content sections. Matches the pattern used by other workflow
  files.
- **Question format:** Bold quoted question text with explanation
  of what to do with the answer and what files to create. Matches
  the pattern used in BOOTSTRAP.md Phase 2W.2.
- **Conditional branching:** "If yes/no" and skip guidance for each
  question group. Consistent with the existing BOOTSTRAP.md style.

No frontmatter. This is consistent with other workflow files in
`core/workflows/` (analytics-workspace.md, design-alignment.md,
etc.) which also lack frontmatter. Workflow files are framework-
internal instructions, not consumer project documents -- frontmatter
is for trackable project docs.

---

## 6. Instruction Decomposition Quality

**Finding: PASS**

The v1 review evaluated the inline version and judged it acceptable
despite exceeding the 30-50 line decomposition threshold. The owner
decision to extract reverses that judgment -- the content is now in
its own file, which is the cleaner decomposition.

The extraction improves decomposition in two ways:

1. **BOOTSTRAP.md is shorter.** The Phase 2W.1a section went from
   ~80 lines of inline questionnaire to 7 lines (pointer +
   summary). BOOTSTRAP.md's Phase 2W is now focused on sequencing
   (what steps happen in what order) while the content of each step
   lives in referenced files.

2. **ADOPT.md can reference the protocol directly** without
   duplicating the questionnaire or pointing into a specific section
   of BOOTSTRAP.md. Before the extraction, ADOPT.md would have
   needed to say "read BOOTSTRAP.md Phase 2W.1a" -- which is
   awkward because ADOPT.md exists precisely for scenarios where
   BOOTSTRAP.md is not the entry point.

The decomposition principle in the project CLAUDE.md says to extract
when "the same information would need to be duplicated across
multiple files without extraction." This is exactly the case here.

---

## 7. Smell Test Compliance

**Finding: PASS**

No changes from the v1 assessment. The new standalone file
contains no personal, product-specific, or tool-specific leakage.
All platform names are industry-standard. All questions use "you"
(the consumer). The data governance question explicitly notes that
Fabrika does not have built-in catalog integration.

---

## 8. Consumer Update Completeness

**Finding: PASS**

The CHANGELOG consumer update instructions (lines 77-91) are
complete for the extraction:

1. `core/workflows/analytics-onboarding.md` is listed as a new
   file to copy (line 78).
2. BOOTSTRAP.md replacement is noted (line 82) -- consumers will
   get the pointer version.
3. ADOPT.md update is noted (line 83) -- consumers will get the
   new onboarding section.
4. Retroactive guidance (line 87) points to the standalone file.

All files a consumer would need to update or copy are listed.

---

## 9. Dispatch/Output Contract Consistency

**Finding: PASS**

No change from v1. No new agents. The standalone file is an
orchestrator-executed protocol, not an agent prompt. The dispatch
contracts in `core/workflows/dispatch-protocol.md` are unaffected.

---

## Summary

The extraction of onboarding questions from BOOTSTRAP.md inline
content to `core/workflows/analytics-onboarding.md` was done
cleanly. The standalone file is self-contained, the BOOTSTRAP.md
pointer follows established patterns, the ADOPT.md reference
provides a natural entry point for retroactive onboarding, and
the CHANGELOG accurately reflects the new file.

The v1 actionable note (Platform-Connection-Template missing from
the template copy list) has been resolved.

No actionable findings. All cross-references consistent. No smell
test violations. Consumer update instructions complete.
