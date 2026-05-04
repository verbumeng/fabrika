# Library Workflow

Domain workflow for **library** projects (reusable packages, SDKs,
shared modules published for other developers to import). This file
defines the domain-specific agents, review criteria, and testing
approach that compose with the shared story execution mechanics in
`core/workflows/protocols/story-execution.md`.

The shared story execution mechanics are defined in the story-execution
protocol — this file adds the library-specific layer.

---

## Agent Roster

| Role | Agent | Notes |
|------|-------|-------|
| Planner | [api-designer](../../agents/api-designer.md) | Designs API surface; validates public API conformance |
| Reviewer | [code-reviewer](../../agents/code-reviewer.md) | Reviews implementation against spec, rubric, API conventions |
| Supplemental Reviewer | [performance-reviewer](../../agents/performance-reviewer.md) | Bundle size, runtime performance |
| Validator | [test-writer](../../agents/test-writer.md) | Unit, integration, backward compatibility, API contract tests |
| Coordinator | [scrum-master](../../agents/scrum-master.md) | Sprint coordination (complexity-triggered) |
| Implementer | [software-engineer](../../agents/software-engineer.md) | Writes library code against approved spec |
| Architect | [software-architect](../../agents/software-architect.md) | Evaluates module depth, public interface design |

---

## Domain-Specific Gates

### API Surface Review

Every story that modifies the public API must verify:
- Public exports match the API Design Guide
- Backward compatibility is maintained (or a breaking change is
  documented with migration steps)
- Type signatures are complete and accurate
- Documentation is updated

The api-designer (planner) validates API conformance in validation
mode. The software-architect reviews structural design of the public
interface.

### Backward Compatibility Checks

For stories that change public API:
- Existing consumers must not break (tested via backward compat tests)
- If breaking: semver major bump, migration guide entry, deprecation
  notice for the previous API
- The code-reviewer specifically checks for accidental public surface
  changes

### Publishing Readiness

The code-reviewer checks publishing readiness for stories that
produce a release:
- Version bumped correctly (semver)
- Changelog updated
- Tests pass (full suite, not fast mode)
- No unreleased breaking changes without migration docs

---

## Testing Approach

- **TDD** — new public API, new modules, new utility functions
- **Test-informed** — modifications to existing public API, internal
  refactoring
- **Test-after** — documentation changes, configuration, internal
  cleanup

**Verification method:** Unit + integration + backward compatibility +
API contract tests via standard test runner.

---

## Story Execution

For all story execution mechanics, follow
`core/workflows/protocols/story-execution.md`.
