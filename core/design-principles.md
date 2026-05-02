# Design Principles

Cross-cutting principles that govern how agents interact across all
project types. These are not aspirational — they are structural
constraints that workflow files, agent prompts, and integration
templates implement mechanically.

---

## Implementer-Reviewer Pairing

Every implementer output gets an independent review before it is
considered complete or acted upon downstream. The implementer
produces, the reviewer independently assesses, the implementer
revises based on findings, and the reviewer re-checks.

How it applies:

- **Sprint-based projects.** The code reviewer (and supplemental
  reviewers) independently evaluate implementation against the spec
  and rubrics. The implementer reads review reports directly during
  revision. All evaluators re-review after every revision.
- **Analytics-workspace projects.** The logic reviewer reviews all
  code before execution. The performance reviewer (Tier 2) reviews
  the execution manifest. The implementer reads review reports
  directly during revision. Both reviewers re-review after every
  revision, including performance-triggered revisions.
- **Agentic-workflow projects.** The methodology reviewer, structural
  validator, and context architect independently verify changes. The
  context engineer reads verification reports directly during
  revision. All three verifiers re-check after every revision.

The orchestrator routes review report paths to the implementer — it
does not synthesize, interpret, or translate findings. The implementer
is the domain expert who wrote the output and is better positioned to
interpret review findings in context.

---

## Implementer-Validator Pairing

Every implementer output that produces observable results gets
validated against expected outcomes. The nature of validation differs
by project type, but the principle is universal: production is
followed by verification.

How it applies:

- **Sprint-based projects.** The test writer (or specialized
  validator) verifies that implementation passes tests and meets
  coverage targets. The planner in validation mode checks acceptance
  criteria fulfillment.
- **Analytics-workspace projects.** The data validator runs
  post-execution checks (row counts, distributions, cross-references)
  and produces a human-facing validation report. The analysis planner
  in validation mode checks that the output answers the brief.
- **Agentic-workflow projects.** The structural validator mechanically
  verifies structural facts (file existence, version consistency,
  catalog accuracy). The methodology reviewer and context architect
  verify methodology quality and structural design.
