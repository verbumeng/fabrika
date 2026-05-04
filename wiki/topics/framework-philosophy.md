# Framework Philosophy

## Summary

Fabrika is a methodology framework for agentic project workflows, not a code framework. It provides structured agent prompts, workflow definitions, evaluation rubrics, templates, and integration instructions that consumer projects copy into their repositories. The "product" is the methodology itself: how AI agents plan, implement, review, and maintain work across different project types. This distinction matters because it determines everything about how Fabrika is maintained, versioned, and consumed.

The framework rests on a set of design principles that emerged incrementally from v0.1.0 through v0.18.0, each principle driven by concrete problems observed in practice. These principles are not abstract ideals imposed top-down; they are practical constraints that prevent specific categories of failure. Understanding them is essential for anyone maintaining Fabrika or contributing to its canonical files.

Fabrika's approach is opinionated about process and agnostic about technology. The agents carry domain expertise about *how* to plan, review, and implement work in categories like web-app, data-engineering, or analytics-workspace, but they do not prescribe specific tech stacks, libraries, or platforms. This allows the same methodology to govern a Python data pipeline and a TypeScript web application without modification to the canonical framework.

## Key Decisions

- **Methodology, not code (v0.1.0).** Fabrika was designed from the outset as a set of agent prompts, workflow definitions, and templates rather than a library or runtime dependency. Consumer projects copy files from Fabrika into their own repositories. This means consumers own their copies and can customize them, while Fabrika remains the upstream source of truth. The alternative would have been a package dependency model, but that would couple consumer project execution to Fabrika's release cycle and make local customization difficult. Source: CHANGELOG 0.1.0, BOOTSTRAP.md.

- **Canonical vs. consumer separation (v0.1.0, refined v0.2.0).** Fabrika is the source repository; consumer projects are downstream copies. The BOOTSTRAP.md/ADOPT.md/UPDATE.md trilogy manages this lifecycle: bootstrap installs fresh, adopt adds Fabrika to existing projects, update brings consumers forward when Fabrika evolves. The HARVEST.md workflow provides the reverse flow: generalizable improvements from consumer projects flow back into canonical Fabrika. This bidirectional relationship was formalized in v0.2.0 with the FABRIKA.md framework relationship guide placed in consumer projects. Source: CHANGELOG 0.1.0, 0.2.0.

- **Smell tests for leakage prevention (established pre-v0.10.0, documented in CLAUDE.md).** Every change to canonical files must pass four smell tests: Does this leak personal product names (Notnomo, Hearthen, MNEMOS, etc.)? Does this assume the user is a specific person? Does this embed LifeOS, Obsidian, Motion, or PARA assumptions? Would this make sense to a stranger cloning the repo for a greenfield project? These tests prevent Fabrika from drifting into a personal tool. They are enforced by methodology-reviewer and structural-validator agents (v0.12.0) during the verification step of every structural update. Source: CLAUDE.md (project-level), PRD-02.

- **Stack-agnostic agents with domain expertise (v0.6.0).** When Fabrika expanded from 4 agents to 13 in v0.6.0, the design decision was to organize agents by *methodology role* and *project type*, not by technology. A data-engineer agent carries expertise about pipeline construction, orchestration, and data quality regardless of whether the consumer uses dbt, Airflow, or a custom solution. The expertise travels with the agent prompt, not with the consumer project's CLAUDE.md. Source: CHANGELOG 0.6.0, PRD-03.

- **Context decomposition and progressive disclosure (v0.4.0, v0.7.0).** Two related principles that emerged from context window pressure. Context decomposition says: keep instruction files lean; when a section grows beyond 30-50 lines of instructional content, extract it into its own file and leave a pointer. Progressive context disclosure says: always-loaded content should be minimal (project identity, key constraints, session lifecycle), with phase-specific and reference-only content loaded on demand when relevant. In v0.7.0, this drove the extraction of six workflow files from the integration templates, reducing CLAUDE.md from ~676 to ~470 lines (30%) and copilot-instructions.md from ~490 to ~347 lines (29%). Source: CHANGELOG 0.4.0, 0.7.0.

- **The bootstrap/adopt/update model (v0.1.0, evolved through v0.18.0).** Three entry points for consumers: BOOTSTRAP.md (new project, full setup from scratch), ADOPT.md (existing project, incremental installation at three tiers), UPDATE.md (bring existing consumer forward when Fabrika releases a new version). The CHANGELOG serves as the authoritative guide for update scope: each version lists every changed file and whether consumers need to copy, update, or create it. This model was chosen over automated migration tooling because the file-copy approach keeps consumers in control and avoids runtime dependencies. Source: CHANGELOG 0.1.0, BOOTSTRAP.md, ADOPT.md, UPDATE.md.

- **Versioning discipline as a framework rule (established pre-v0.10.0, codified in CLAUDE.md).** Every change to canonical files requires a version bump and CHANGELOG entry in the same commit. Core changes produce minor bumps, integration and operational doc changes produce patch bumps. This is not a suggestion; it is a mechanical constraint enforced during the verification step (v0.12.0+). The rationale: consumers rely on the CHANGELOG to determine what to update, so an unversioned change is invisible to them. Source: CLAUDE.md (project-level), CHANGELOG (all versions).

- **Fabrika eats its own cooking (v0.11.0).** Starting in v0.11.0, Fabrika was configured as an agentic-workflow project (structural mode only) that uses its own agent model. The legacy SYSTEM-UPDATE.md protocol was retired. All subsequent PRDs (03 through 09) executed through Fabrika's agentic-workflow structural update lifecycle. This decision eliminated the contradiction of a methodology framework that did not follow its own methodology. Source: PRD-02, CHANGELOG 0.11.0.

- **Two audiences for documentation (v0.18.0).** The wiki knowledge layer (v0.18.0) codified a principle that had been implicit: Fabrika's documentation serves both humans and agents. Humans need readable narrative with plain language; agents need structured sections they can parse. The design response is narrative prose within structured sections, not separate human/agent documents. This applies to wiki topic articles, briefings, and integration templates. Source: PRD-09, Wiki-Topic-Template.md.

- **Implementer-reviewer pairing as a universal principle (v0.20.0).** Identified and articulated during the PRD-11 alignment session: every implementer output gets an independent review before it is considered complete or acted upon downstream. The implementer produces, the reviewer independently assesses, the implementer revises based on findings, and the reviewer re-checks. The orchestrator routes but does not interpret or synthesize findings. This principle was implicit in how the evaluation cycle worked since v0.12.0, but was never stated explicitly as a framework philosophy. The PRD-11 alignment made it explicit and extended it to cover: all code the data analyst writes (main queries, metadata queries, revisions), revisions after review (mandatory re-review, not just re-review-on-failure), and the orchestrator's role (routing, not translating). The corollary — implementer-validator pairing — states that every output producing observable results gets validated, with the nature of validation varying by workspace type (data output for analytics, test passage for sprint-based, structural correctness for agentic). Source: PRD-11, CHANGELOG 0.20.0.

- **Workflow composition over project taxonomy (identified 2026-05-02, Phase 2 roadmap).** Fabrika's original model was taxonomic: a project picks one project type at bootstrap, gets a fixed workflow and agent roster, works within that lane. This works when a project fits cleanly into one type, but real projects need multiple kinds of work — a data engineering project needs sprint planning for pipeline builds AND ad-hoc fixes for quick SQL changes AND a lightweight task flow for routine transforms. The taxonomic model forces a choice that real work does not present. The design shift: what Fabrika calls "project types" are really **workflow types** — reusable multi-agent patterns that can be composed by any project. A project declares which workflow types it needs rather than declaring a single type. Each workflow type is a multi-agent pattern built from composable skills (agent capabilities separated from invocation context). The base workflow (CR-17) is the most generic pattern — task, plan, implement, review, validate, deliver — with zero domain assumptions. Specialized workflows like the analytics workflow add domain knowledge on top of the same engineering patterns. This is not yet implemented — CRs 17-23 form a coherent Phase 2 roadmap to build it. The shift resolves a practical problem: the framework needs to serve teams with different domain specializations without requiring each team to use Fabrika's specific workflows. The compositional model means Fabrika provides the engineering patterns (dispatch contracts, implementer-reviewer pairing, compaction, validation) and each team or project composes workflows that fit their domain. Source: Phase 2 design session 2026-05-02, planning/ROADMAP-v2.md.

## Current State

As of v0.27.0, these principles are woven throughout the framework:

- **Canonical/consumer separation** is managed through BOOTSTRAP.md (with project-type-specific setup since v0.6.0), ADOPT.md (three-tier adoption), UPDATE.md (version-forward migration), and HARVEST.md (reverse flow). The manifest (MANIFEST_SPEC.md) tracks installed files and their hashes to detect customization.

- **Smell tests** are enforced mechanically by structural-validator and methodology-reviewer during Step 4 (Verify) of every agentic-workflow structural update, per the verification checklist in the project CLAUDE.md. As of v0.27.0, the structural-validator also checks CLAUDE.md path references during structural updates while preserving the smell test exclusion for CLAUDE.md content — a surgical distinction between validating pointers and auditing prose.

- **Context decomposition** has been applied to integration templates (v0.7.0), the dispatch protocol (v0.9.0, extracted from development-workflow.md), the briefing system (v0.17.0, with nine briefing format files rather than inline instructions), and the workflow directory itself (v0.27.0, splitting `core/workflows/` into `types/` for workflow type definitions and `protocols/` for supporting processes). The workflow directory split is context decomposition applied at the filesystem level: readers looking for "what lifecycle does this project follow?" go to `types/`, while readers looking for "how does dispatch work?" go to `protocols/`.

- **Stack-agnostic agents** cover 11 project types (10 consumer types plus agentic-workflow) with 32 agent files organized under 7 archetypes. Each agent carries domain expertise in its prompt, not in the consumer's project configuration.

- **Implementer-reviewer pairing** is codified as a cross-cutting framework principle in `core/design-principles.md` (v0.22.0). All project types use the same pattern: the implementer reads review reports directly during revision (the orchestrator routes file paths, it does not synthesize findings), all evaluators re-review after every revision, and the cycle cap is 3 with orchestrator diagnosis after cap. Originally implemented for analytics-workspace in v0.20.0, converged across all project types in v0.22.0 (PRD-13).

- **Versioning discipline** has produced 27 releases from v0.1.0 through v0.27.0, each with a detailed CHANGELOG entry listing every file change and consumer update instructions.

- **The wiki knowledge layer** (v0.18.0) adds a persistent knowledge pipeline with five phases (Extract, Index, Synthesize, Link, Glossary), operating on cadences appropriate to each project type.

## Open Questions

- **How should Fabrika's own wiki differ from the consumer wiki template?** The wiki knowledge layer was designed for consumer projects (v0.18.0) and extended to canonical Fabrika in v0.19.0. Fabrika's wiki topics are framework-level (design rationale, agent model evolution) rather than project-level (ADR synthesis, retro findings). The consumer template's YAML frontmatter (salience scores, source arrays) is omitted from Fabrika's articles because they are hand-curated during system updates rather than synthesized from batch indexes. Future experience may suggest further template adaptation.

- **When does context decomposition go too far?** The current guideline (extract at 30-50 lines) is rough. Some files are naturally dense and should stay monolithic; others are thin wrappers around pointers. There is no formal heuristic for when decomposition hurts navigability.

- **How should multi-type project philosophy evolve?** The workflow composition model (Phase 2, CRs 17-23) proposes an answer: projects compose workflow types rather than declaring a single project type. This shifts the question from "how do we handle multi-type agent directories?" to "how do we make workflow types composable?" CR-22 (Composable Skills) is the mechanism — agent capabilities separated from invocation context. Whether this fully resolves the multi-type question will be determined during Phase 2 execution.

## Related Topics

- [Agent Model](agent-model.md) -- how agents implement the philosophy
- [Workflow Design](workflow-design.md) -- how workflows embody the principles
- [Harvest Patterns](harvest-patterns.md) -- the canonical/consumer feedback loop
- [Owner Preferences](owner-preferences.md) -- communication design decisions

## Sources

### CHANGELOG versions
- v0.1.0 -- initial release establishing canonical/consumer separation, bootstrap model, stack-agnostic agents
- v0.2.0 -- framework relationship documentation (FABRIKA.md)
- v0.4.0 -- progressive context disclosure, canonical patterns, structural constraints
- v0.6.0 -- project type taxonomy expansion (4 to 9 types, 4 to 13 agents), stack-agnostic domain expertise
- v0.7.0 -- context decomposition applied to integration templates (6 workflow files extracted)
- v0.9.0 -- dispatch protocol extraction as a standalone workflow file
- v0.11.0 -- Fabrika configured as agentic-workflow project (eating its own cooking)
- v0.18.0 -- wiki knowledge layer, dual-audience documentation principle
- v0.20.0 -- implementer-reviewer pairing codified as explicit framework principle
- v0.22.0 -- implementer-reviewer pairing converged across all project types (PRD-13), codified in core/design-principles.md

### PRDs
- PRD-01 -- agentic-workflow project type definition
- PRD-02 -- applying agentic-workflow to canonical Fabrika
- PRD-03 -- implementer archetype and pure orchestrator principle
- PRD-09 -- wiki knowledge layer design rationale
- PRD-11 -- analytics pre-execution review, implementer-reviewer pairing principle
- PRD-13 -- review-revise loop redesign, convergence across all project types

### Core files
- CLAUDE.md (project-level) -- smell tests, versioning discipline, context decomposition principle
- BOOTSTRAP.md, ADOPT.md, UPDATE.md, HARVEST.md -- the canonical/consumer lifecycle
- core/templates/Wiki-Topic-Template.md -- dual-audience writing guidelines

### Planning artifacts
- planning/ROADMAP-v2.md -- Phase 2 roadmap establishing workflow composition model
- planning/CR-17 through CR-23 -- change requests implementing the compositional shift
