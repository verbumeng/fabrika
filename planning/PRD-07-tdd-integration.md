# PRD-07: TDD Integration

**Version target:** 0.16.0
**Dependencies:** PRD-03 (implementer agents exist — TDD changes how
implementers work), PRD-04 (architect — refactor step connects to
architecture principles)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

The current development workflow is: implement the full story → then
invoke test-writer to write tests → then invoke reviewers. Tests come
AFTER implementation. This means:

- The implementer "outruns its headlights" — produces large amounts of
  code without feedback, risking compounding errors
- Tests are written against existing code, not against expected behavior
  — they test what the code does, not what it should do
- There's no mechanism to force small, deliberate implementation steps
- The feedback loop (test → implement → verify) that keeps AI agents
  on track is inverted

This draws from Pocock's TDD skill and the Pragmatic Programmer's
"outrunning your headlights" concept: the rate of feedback is your
speed limit.

## Solution

Integrate a **graduated testing approach** into the development
workflow. The scrum master flags each story with a testing approach
during sprint planning based on complexity and risk.

### Three Testing Approaches

| Approach | When | Flow |
|---|---|---|
| **TDD** | High complexity: new modules, complex logic, new public interfaces, greenfield features | Test-writer writes tests from spec (spec-first mode) → Implementer codes to pass tests in vertical slices (one test → one implementation → next) → Refactor |
| **Test-informed** | Medium complexity: modifying existing modules, adding capabilities | Spec identifies test boundaries and expected behaviors upfront → Implementer writes code → Test-writer writes tests → Refactor |
| **Test-after** | Low complexity: config changes, copy updates, minor fixes, non-behavioral changes | Implementer makes change → Test-writer verifies nothing broke |

### Test-Writer Spec-First Mode (New)

The test-writer agent gets a new mode alongside its existing coverage
mode:

**Spec-first mode:**
- Input: approved spec (not code — code doesn't exist yet)
- Output: behavioral tests that verify the public interface described
  in the spec
- Tests describe WHAT the system should do, not HOW
- Written in vertical slices — one behavior at a time, not all tests
  at once (this is critical — horizontal slicing produces garbage tests)

**Coverage mode (existing):**
- Input: code + spec
- Output: tests filling gaps after implementation
- Used in test-informed and test-after approaches

### Vertical Slice Discipline

For TDD stories, the implementation loop is:

```
RED:   test-writer writes test for behavior 1 → test fails
GREEN: implementer writes minimal code to pass → test passes
RED:   test-writer writes test for behavior 2 → test fails
GREEN: implementer writes minimal code to pass → test passes
... repeat ...
REFACTOR: once all tests pass, improve code structure
```

Each RED→GREEN cycle is one dispatch. The orchestrator manages the loop,
dispatching test-writer and implementer alternately.

### Refactor Step

After all tests pass, the refactor step considers:
- Extract duplication
- Deepen modules (move complexity behind simple interfaces — connects
  to architect principles from PRD-04)
- Apply architectural patterns from the code-review rubric
- Verify tests still pass after each refactor step

The refactor step is performed by the implementer, optionally reviewed
by the architect for stories flagged as architecturally significant.

### Scrum Master Flagging

During sprint planning, the scrum master assigns each story a testing
approach based on:
- Is this greenfield or modification of existing code?
- How many modules/interfaces does it touch?
- Is the expected behavior clearly specifiable from the story?
- What's the risk if this breaks?

The testing approach goes in the sprint contract alongside the story.

## Key Decisions (Already Aligned)

- Graduated approach, not TDD-for-everything
- Scrum master flags per story during sprint planning
- TDD for high-complexity, test-informed for medium, test-after for low
- Vertical slices (one test → one implementation) not horizontal
  (all tests → all implementation)
- Tests verify behavior through public interfaces, not implementation
  details
- Refactor step connects to architecture principles (PRD-04)
- Test-writer gets a new "spec-first mode" for TDD stories

## Scope: What Changes

### New files

None — changes are to existing files.

### Modified files

| File | Change |
|---|---|
| `core/agents/archetypes/validator.md` | Add spec-first mode alongside existing coverage mode. Define when each mode applies. |
| `core/agents/test-writer.md` | Add spec-first mode section: input is spec (not code), output is behavioral tests, vertical slice discipline, anti-pattern warnings (no horizontal slicing). |
| `core/agents/scrum-master.md` | Add testing approach flagging to sprint planning. Define assessment criteria for TDD vs. test-informed vs. test-after. |
| `core/workflows/development-workflow.md` | Rewrite story implementation flow to support all three testing approaches. TDD flow: test-writer (spec-first) → implementer (vertical slices) → refactor. Test-informed flow: implementer → test-writer (coverage) → refactor. Test-after flow: implementer → test-writer (verify). |
| `core/workflows/dispatch-protocol.md` | Add spec-first dispatch contract for test-writer (input: spec only, no code). Update implementer dispatch to include "tests to pass" for TDD stories. |
| `core/rubrics/test-rubric.md` | Add criteria for spec-first tests: behavioral focus, interface-level testing, survives refactor, no implementation coupling. |
| `core/templates/Sprint-Contract-Pipeline.md` | Add testing approach field per story. |
| `core/templates/Sprint-Contract-Mesh.md` | Same. |
| `core/templates/Sprint-Contract-Hierarchical.md` | Same. |
| `integrations/claude-code/CLAUDE.md` | Update testing rules section with graduated approach. Add TDD workflow description. |
| `integrations/copilot/copilot-instructions.md` | Same updates for Copilot parity. |
| `VERSION` | 0.16.0 |
| `CHANGELOG.md` | Entry for 0.16.0 |
| `MIGRATIONS.md` | Consumer migration: update test-writer, scrum-master, validator archetype, sprint contract templates, development workflow, integration templates. Behavioral change — stories now have explicit testing approaches. |

## Open Items (To Resolve During Execution)

- How many RED→GREEN cycles per dispatch? Does the orchestrator
  dispatch test-writer and implementer once per cycle, or batch
  multiple cycles? (Token cost vs. feedback quality trade-off)
- Whether the refactor step should always involve the architect or
  only for architecturally flagged stories
- How test-informed differs from test-after in practice for the
  implementer — does "spec identifies test boundaries upfront" change
  how the implementer codes, or just what the test-writer tests?
- How TDD works for analytics-workspace tasks (test boundaries for
  SQL/analysis work are less clear than for application code)
- Whether existing test-writer baseline evals need new spec-first
  eval cases

## Verification Criteria

- Test-writer has spec-first mode with clear input/output contract
- Scrum master assigns testing approach per story
- Development workflow supports all three approaches with distinct flows
- Sprint contract templates have testing approach field
- Test rubric has spec-first criteria
- Dispatch protocol has spec-first contract
- Vertical slice discipline is explicit (not horizontal)
- Refactor step references architecture principles
- Integration templates reflect graduated approach
- No smell test violations
