---
type: prd
title: [PRD Title — Phase or Feature Name]
version-target: [Target version or phase, e.g., "Phase 1 MVP" or "v2.0"]
dependencies: [List of PRDs or deliverables this depends on, or "none"]
status: Draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
last-validated: YYYY-MM-DD
---

# PRD: [Title]

## Problem Statement

[From the user's perspective: what problem does this phase or feature
solve? Why now? What happens if we don't build it?]

## Solution

[From the user's perspective: what does the product do after this phase
ships? Describe the experience, not the implementation. A user should
be able to read this section and understand what they're getting.]

## User Stories

1. As a [user type], I want to [action] so that [outcome].
2. As a [user type], I want to [action] so that [outcome].
3. As a [user type], I want to [action] so that [outcome].

[Exhaustive list. Every user-facing behavior this phase delivers
should be captured as a story. Stories that are too large for a single
sprint should be noted — the scrum master will decompose them.]

## Module Changes

[Which modules are built or modified, and their interfaces. The
architect reviews this section before owner approval.]

For code projects: modules, components, interfaces.
For analytics-engineering: models, sources, marts.
For data-engineering: pipeline stages, sources, serving layers.

| Module | Change Type | Interface / Contract |
|--------|-------------|---------------------|
| [module name] | new / modified | [public interface, data contract, or API surface] |

## Implementation Decisions

[Architectural choices, schema decisions, API contracts, technology
selections. Document the "why" behind each decision. Do not include
file paths or code snippets — they get outdated. Focus on the
decisions themselves and their rationale.]

## Testing Decisions

[Which modules get tested? What makes a good test for each module?
What is the testing approach — unit, integration, E2E? Are there
modules where testing is less valuable and why?]

## Out of Scope

[What is explicitly excluded from this phase or feature. Be specific
enough that someone could point to this section and say "we agreed
not to do that."]

## Open Questions

- [Unresolved items that need to be addressed during execution]
- [Decisions deferred until more information is available]
- [Risks that need investigation before committing to an approach]
