# PRD-14 Methodology Review

**Reviewer:** methodology-reviewer
**Plan:** `docs/plans/PRD-14-plan.md`
**Version:** 0.23.0
**Verdict:** PASS WITH NOTES

---

## 1. Cross-Reference Consistency

**Finding: PASS**

All cross-references between changed files resolve correctly:

- **BOOTSTRAP.md Phase 2W.1a** references
  `[FABRIKA_PATH]/core/templates/Platform-Connection-Template.md` --
  the file exists on disk.
- **BOOTSTRAP.md Phase 2W.1a** references
  `[FABRIKA_PATH]/core/templates/Source-Connection-Template.md` for
  Level 1 stubs -- the file exists.
- **analytics-workspace.md** Tier 1 Plan phase (line 92-93) references
  `sources/connections/[platform]/README.md` for platform
  configuration -- matches the path convention used in BOOTSTRAP.md
  Phase 2W.1a and the Platform-Connection-Template.
- **analytics-workspace.md** Tier 2 Plan phase (lines 165-171)
  references the same path and notes BOOTSTRAP.md Phase 2W.1a as the
  population mechanism -- consistent with BOOTSTRAP.md.
- **analytics-workspace.md** default cost estimate note (lines
  288-295) references onboarding and
  `sources/connections/[platform]/README.md` -- consistent.
- **Document-Catalog.md** new Platform Connection entry (lines
  577-582) references `core/templates/Platform-Connection-Template.md`
  and notes BOOTSTRAP.md Phase 2W.1a as creation point -- consistent
  with both BOOTSTRAP.md and analytics-workspace.md.
- **Document-Catalog.md** Templates section (line 763) lists
  `Platform-Connection-Template.md` under `analytics-workspace` --
  consistent with the new template file's existence.
- **Document-Catalog.md** Quick Reference analytics-workspace section
  (line 825) includes `sources/connections/[platform]/README.md
  (Platform Connection)` in the Onboarding line -- consistent with
  BOOTSTRAP.md Phase 2W.1a output.
- **CLAUDE.md** integration template (line 329) adds the onboarding
  sentence referencing BOOTSTRAP.md Phase 2W.1a and
  `sources/connections/[platform]/README.md` -- consistent.
- **copilot-instructions.md** (line 240) has the identical sentence --
  consistent with CLAUDE.md.
- **CHANGELOG.md** consumer update instructions reference all five
  changed canonical files plus the new template -- complete.
- **VERSION** reads `0.23.0` -- matches the CHANGELOG's latest entry
  header.

Back-references checked:
- **analytics-workspace.md** references BOOTSTRAP.md Phase 2W.1a in
  two places (Tier 2 Plan and default cost note) -- BOOTSTRAP.md
  Phase 2W.1a references analytics-workspace.md implicitly via the
  cost model structure alignment. Bidirectional.
- **BOOTSTRAP.md Phase 2W.2** (lines 534-538) acknowledges onboarding
  output and instructs the agent to read `sources/connections/`
  before asking -- addresses the redundancy risk from the plan.

No dangling references found.

---

## 2. Prompt Pattern Adherence

**Finding: PASS**

The new `Platform-Connection-Template.md` follows established template
patterns:

- Uses the same structure as `Source-Connection-Template.md` (heading
  hierarchy, field-style entries with `**Label:** [placeholder]`
  format, bracketed placeholder values).
- Does NOT include YAML frontmatter, which is a departure from
  `Source-Connection-Template.md`. However, this is acceptable because
  the Platform Connection README is a directory-level overview file
  (like `sources/README.md`), not a per-instance connection document.
  The Source-Connection-Template has frontmatter because it represents
  an individual trackable entity with status and verification dates.
  The platform README is structural scaffolding -- similar to how
  `sources/README.md` itself has no frontmatter.
- The cost model section structure matches the values and format in
  `analytics-workspace.md`'s Platform-Specific EXPLAIN Mechanisms
  table (lines 281-286). The default pricing values in the template's
  reference table match exactly: BigQuery $6.25/TB, Snowflake
  $2-4/credit-hour, Databricks $0.07-0.22/DBU, SQL Server N/A,
  PostgreSQL N/A, MySQL N/A.
- The template includes an EXPLAIN Mechanism section that aligns with
  the analytics-workspace.md EXPLAIN Mechanisms table.

The BOOTSTRAP.md Phase 2W.1a section follows the established question-
and-scaffold pattern used in Phase 2W.2 -- question, conditional
branching, file creation instructions, skip guidance.

---

## 3. Instruction Decomposition Quality

**Finding: PASS**

The onboarding questionnaire is inline in BOOTSTRAP.md Phase 2W.1a
rather than extracted to a separate file. The plan documents this as
a deliberate alignment decision (the dropped
`Onboarding-Questionnaire-Reference.md`). The rationale is sound:
BOOTSTRAP.md is read once in a bootstrap session -- there is no
context budget concern, and inlining avoids a sync obligation between
two files that would need to stay coordinated.

Phase 2W.1a is approximately 80 lines of instructional content. This
is larger than the 30-50 line decomposition threshold in the project
CLAUDE.md, but the content is a cohesive unit (four question groups
that execute sequentially). Splitting into four separate files would
create more navigation overhead than it saves. The single-purpose
nature of bootstrap instructions (read once, execute linearly) means
the threshold applies differently than for reference material that
gets loaded repeatedly.

The Document-Catalog entry for Platform Connection (lines 577-582) is
appropriately sized -- five lines of description, template reference,
and creation notes. Consistent with the neighboring
`sources/connections/[platform]/[instance]/*.md` entry.

---

## 4. Smell Test Compliance

**Finding: PASS**

No personal, product-specific, or tool-specific leakage detected:

- **No LifeOS, Obsidian, Motion, or PARA assumptions.** The
  onboarding questions are generic ("What database platforms do you
  work with?") with no assumption about which answer is expected.
- **No downstream product names.** No references to Notnomo,
  Hearthen, MNEMOS, Opifex, edw labs, or VerbumEng in any changed
  canonical file.
- **No person-specific assumptions.** The questions use "you" (the
  consumer) throughout. The platform list is representative, not
  prescriptive -- includes "other" as an option.
- **Stranger test:** A stranger cloning the repo for a greenfield
  analytics workspace would find the onboarding questionnaire
  self-explanatory. The platform types listed are industry-standard.
  The cost model questions are generic. The data governance question
  acknowledges that Fabrika does not have built-in catalog integration
  and defaults to Markdown-based dictionaries.

---

## 5. Consumer Update Completeness

**Finding: PASS WITH NOTE**

The CHANGELOG consumer update instructions list six steps:

1. Copy `core/templates/Platform-Connection-Template.md` -- correct
2. Replace `BOOTSTRAP.md` Phase 2W section -- correct
3. Update `core/workflows/analytics-workspace.md` -- correct
4. Update `core/Document-Catalog.md` -- correct
5. Update integration template -- correct
6. Retroactive guidance for existing workspaces -- correct, with
   actionable instructions for creating platform READMEs manually

**NOTE:** The BOOTSTRAP.md Phase 2W.1 template copy list (lines
439-446) does NOT include a line to copy
`Platform-Connection-Template.md` to `docs/Templates/`. This means
consumers who bootstrap a new analytics workspace will not get the
Platform-Connection-Template copied to their local `docs/Templates/`
directory alongside the other templates (Source-Connection-Template,
Source-Tool-Template, etc.), even though the Document-Catalog
Templates section (line 763) lists it as an analytics-workspace
template.

During onboarding (2W.1a), the template is read directly from
`[FABRIKA_PATH]/core/templates/`, so bootstrapping still works. But
the local copy is missing from the consumer's `docs/Templates/` for
future reference or manual use. The consumer update instructions
tell consumers to copy the template to their repo (step 1), but new
bootstraps would not get it automatically.

**Recommendation:** Add
`Platform-Connection-Template.md -> docs/Templates/Platform-Connection-Template.md`
to the Phase 2W.1 template copy list (after line 446) for
consistency with the other templates and the Document-Catalog's
Templates section.

---

## 6. Dispatch/Output Contract Consistency

**Finding: PASS**

No new agents were introduced by this change. The existing dispatch
contracts in `core/workflows/dispatch-protocol.md` are unaffected.
The analytics-workspace workflow changes are within the Plan phase
descriptions -- they add context about where platform configuration
comes from, but do not change what the analysis-planner or
performance-reviewer agents receive in their dispatch or produce as
output.

The integration templates (CLAUDE.md and copilot-instructions.md)
both add the same one-sentence note about onboarding pre-populating
platform configuration. This is a summary-level addition that
correctly points readers to the full workflow file for detail --
consistent with the existing pattern in those templates.

---

## Additional Observations

### README.md accuracy

The README does not mention workspace onboarding specifically. This
is appropriate -- the README is a high-level overview that describes
analytics-workspace as "Ad hoc analysis, investigations, data
requests" and points to BOOTSTRAP.md for the full workflow. The
onboarding protocol is a sub-step of bootstrap, not a top-level
framework feature. No README update needed.

### BOOTSTRAP.md readiness checklist

Line 874 adds a new checklist item for platform connection stubs
under the analytics-workspace section. This is correctly conditional
("if onboarding (2W.1a) was completed") since onboarding is optional.
Consistent with the 2W.1a section being marked "(optional)."

### BOOTSTRAP.md Phase 2W.2 integration

The Phase 2W.2 source inventory conversation (lines 534-547) now
correctly:
- Checks what exists before asking (line 536: "Read
  `sources/connections/` to see what already exists before asking")
- Falls back to full inventory if onboarding was skipped (line 540)
- Creates platform READMEs during 2W.2 if none exist from onboarding
  (line 547: "If no platform README exists, create both the
  platform-level README")

This addresses the redundancy risk identified in the plan.

### Template cost model structure alignment

The Platform-Connection-Template's cost model section uses the same
field names and structure that analytics-workspace.md expects:
- "Pricing model" field with matching options
- "Cost model source" with "actual" vs "default" distinction
- Default Pricing Reference table with matching values

This addresses the template structure mismatch risk from the plan.

---

## Summary

The implementation is well-executed against the plan. All files
referenced in the CHANGELOG exist. Cross-references are consistent
and bidirectional. The new template follows established patterns.
No smell test violations. Consumer update instructions are complete.

**One actionable note:** The `Platform-Connection-Template.md` should
be added to the BOOTSTRAP.md Phase 2W.1 template copy list for
consistency with the Document-Catalog's Templates section and the
pattern established by the other analytics-workspace templates.
This is a minor gap -- bootstrapping still works because 2W.1a reads
the template from the Fabrika path -- but the local copy should be
present in `docs/Templates/` for parity with the catalog listing.
