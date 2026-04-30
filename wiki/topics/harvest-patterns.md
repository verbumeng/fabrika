# Harvest Patterns

## Summary

The harvest workflow is Fabrika's mechanism for flowing generalizable improvements from consumer projects back into the canonical framework. Consumer projects copy Fabrika's files and customize them over time. Some customizations are project-specific (e.g., "pay extra attention to SQL injection in this data app"). Others are generalizable (e.g., "the code-reviewer should always check for unused destructured fields"). The harvest workflow separates the two, proposes canonical updates for generalizable findings, and lets the maintainer review and apply them.

This topic article exists primarily as a placeholder that will grow as consumer projects begin using Fabrika and feeding back findings. As of v0.19.0, the harvest mechanism is fully documented but no harvest data has been collected. The article documents the mechanism itself and what kinds of patterns are expected to accumulate here.

## Key Decisions

- **Human-triggered, not automated (v0.1.0, formalized v0.2.0).** The harvest workflow is triggered by the user (or by an external task management system), not by automation. This is deliberate: harvest involves judgment calls about what is generalizable vs. project-specific, and those calls should not be made unattended. The agent assists analysis and proposes canonical updates, but the human reviews each proposal. Source: HARVEST.md, CHANGELOG 0.2.0.

- **Two input channels: eval artifacts and manifest drift (v0.2.0).** Eval artifacts are structured per-sprint documents (`.fabrika/evals/sprint-NN.md`) with a key `Generalizable?` field marked yes/no/maybe. Manifest drift is detected by comparing current file hashes against install-time hashes in `.fabrika/manifest.yml`. The eval artifact channel catches agent-level improvements; the manifest drift channel catches workflow-level improvements (CLAUDE.md modifications, template additions, rubric adjustments) that the eval artifacts might not cover. Source: HARVEST.md, CHANGELOG 0.2.0.

- **Harvest scope includes all Fabrika-originated files (v0.2.0).** Harvest is not limited to agent prompts. Any file that came from Fabrika can contain generalizable improvements: CLAUDE.md (workflow steps, session lifecycle changes), sprint contract templates (additional stage gates), rubrics (adjusted weights, new criteria), maintenance checklist (new checks), Document Catalog (new document types), hooks (improved logic), and templates (new fields). Source: HARVEST.md.

- **Retro as the harvest signal point (v0.2.0).** The sprint retro template was updated to include a "Fabrika Eval Artifact" section so retros cannot complete without writing the eval artifact. This ensures harvest signals are captured regularly rather than accumulating unnoticed. Source: CHANGELOG 0.2.0.

- **Bidirectional flow formalized with FABRIKA.md (v0.2.0).** The framework relationship document (placed in consumer projects at `.fabrika/FABRIKA.md`) explains the full cycle: eval artifact -> harvest -> canonical update -> propagation to all consumers. This makes the feedback loop visible to agents working in consumer projects, so they understand that local improvements have a path to becoming canonical. Source: CHANGELOG 0.2.0.

- **Version bumping for harvest-sourced changes (established in CLAUDE.md).** When a harvest finding is applied to canonical Fabrika, it follows the same versioning discipline as any other change: core changes produce a minor bump, integration and operational changes produce a patch bump, with a CHANGELOG entry listing every modified file and consumer update instructions. Harvest findings do not get special treatment -- they enter through the normal agentic-workflow structural update lifecycle. Source: CLAUDE.md (project-level), HARVEST.md.

## Current State

As of v0.19.0:

- **The mechanism is fully documented.** HARVEST.md describes the complete workflow: scan both inputs, analyze each finding, classify as generalizable/type-specific/project-specific, propose canonical updates with diffs and rationale, present proposals to the user as a batch, review and apply.

- **No harvest data has been collected.** No consumer projects have completed enough sprints to produce eval artifacts, and no manifest drift has been analyzed through the harvest workflow. The mechanism exists but has not been exercised.

- **The eval artifact template exists** at `core/evals/eval-artifact-template.md` with the structured format agents use to produce per-sprint findings.

- **The manifest tracks customization.** `.fabrika/manifest.yml` records install-time hashes for every Fabrika-originated file, enabling automated detection of which files have been modified by the consumer project.

- **Baseline evals provide a starting point (v0.6.0).** Twelve baseline evaluation cases across four archetypes (planner, reviewer, validator, coordinator) were shipped in v0.6.0, with a spec-first eval case added in v0.16.0. These are reference cases -- consumer projects will produce project-specific evals that may surface generalizable patterns.

## What Will Accumulate Here

As consumer projects begin using Fabrika and the harvest workflow is exercised, this topic is expected to grow with:

- **Recurring pain points.** Patterns that multiple consumers hit independently (e.g., "the maintenance checklist should include X check" or "the code-review rubric underweights Y").

- **Successful agent tunings.** Prompt improvements that work across projects (e.g., a better orientation step for the code-reviewer, a more effective scoping heuristic for the scrum-master).

- **Template improvements.** Fields or sections that consumers consistently add to templates (sprint contract, story, retro) and that should be part of the canonical template.

- **Workflow refinements.** Steps that consumers insert into the development workflow or maintenance checklist that address real gaps in the canonical process.

- **Cross-project calibration data.** Token usage patterns, testing approach effectiveness, and other quantitative observations that inform canonical defaults (e.g., "TDD stories consistently take 1.5x more tokens but produce fewer bugs in evaluation").

- **Type-specific patterns.** Improvements that apply to a subset of project types (e.g., data-engineering pipeline testing patterns, ai-engineering prompt evaluation patterns) that could become canonical for those types.

## Open Questions

- **Harvest cadence.** How often should the harvest workflow run? Per sprint? Per quarter? On demand? The current design leaves this to the user, but a recommended cadence may emerge from practice.

- **Multi-consumer reconciliation.** When multiple consumer projects produce conflicting harvest findings (e.g., one project wants the code-review rubric to weight security higher while another wants it lower), how should the canonical framework reconcile them? The current answer is "maintainer judgment," but a more structured reconciliation process may be needed as the consumer base grows.

- **Automated harvest signal detection.** The manifest drift channel could theoretically be automated (scan all consumer manifests, diff against canonical). Whether this is worth building depends on consumer adoption scale.

- **How the wiki knowledge pipeline interacts with harvest.** Consumer project wikis (v0.18.0) will accumulate synthesized knowledge that may contain generalizable patterns. Whether wiki topic articles should be a third input channel to the harvest workflow (alongside eval artifacts and manifest drift) is not yet decided.

## Related Topics

- [Framework Philosophy](framework-philosophy.md) -- the canonical/consumer separation that harvest bridges
- [Agent Model](agent-model.md) -- agents whose prompts are the primary harvest target
- [Workflow Design](workflow-design.md) -- workflows that produce the artifacts harvest analyzes

## Sources

### CHANGELOG versions
- v0.1.0 -- initial eval harness scaffold
- v0.2.0 -- FABRIKA.md framework relationship guide, retro eval artifact section, harvest workflow formalization
- v0.6.0 -- baseline evaluation cases across four archetypes
- v0.16.0 -- spec-first eval case for TDD

### Core files
- HARVEST.md -- the complete harvest workflow documentation
- core/FABRIKA.md -- framework relationship guide placed in consumer projects
- core/evals/eval-artifact-template.md -- per-sprint eval artifact template
- core/evals/baseline/ -- 13 baseline evaluation cases
- MANIFEST_SPEC.md -- manifest format used for drift detection
