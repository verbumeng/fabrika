# Structural Plan Briefing Format

Use this format when presenting a structural update plan to the owner
for approval at Step 2 (Align) of the agentic-workflow lifecycle.

The plan is produced by the workflow-planner as a file at
`docs/plans/[identifier]-plan.md`. This briefing translates the plan
into a human-facing summary so the owner can evaluate whether the
right changes are being made and push back before execution begins.

## Structure

### 1. What this does for the system
Two to four sentences: what capability the system gains, what gap is
being filled, or what problem is being fixed. Frame in terms of what
changes for people using the system, not implementation details.

### 2. What's changing
For each file being created or modified, a short paragraph covering:
- What the file is (or will be)
- What specifically changes
- Why this change matters — how it fits into the broader system

Group by category (new files, modified files) and lead with the most
important changes. Integration template and versioning changes can be
summarized briefly at the end.

### 3. Open items and recommendations
For each open item from the change request, present:
- The question
- The recommended resolution with reasoning
- Alternatives that were considered

Frame recommendations as choices the owner can push back on, not
foregone conclusions.

### 4. What's NOT changing
List the parts of the system that are NOT affected by this change.
This gives the owner confidence about blast radius and makes it easy
to spot missing integration points.

### 5. Execution order
Brief summary of the planned execution sequence and why that order
matters (e.g., "create the canonical format definition first so other
files can reference it").

### 6. Jargon glossary
Define every term that appears in the briefing and wouldn't be
obvious to someone who hasn't worked on the system recently.

When a Domain Language document exists for the project, draw
definitions from it. If a term isn't in the Domain Language, define
it here and flag it for addition.

Format: `**Term** — plain-language definition`.

## Closing

End with: *"Do you want to adjust any of the open item resolutions,
change the scope, or approve the plan so I can proceed to
execution?"*

## Success Criterion

If the owner has to read the raw planner output or trace file
cross-references themselves to understand what is being proposed, the
briefing failed. The goal is to make the owner comfortable saying
"yes, proceed" or "wait, change X" without needing to understand the
internal file structure.
