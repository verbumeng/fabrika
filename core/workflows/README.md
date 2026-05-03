# Workflow Directory Structure

This directory contains two categories of workflow files, organized
into subdirectories to make the distinction visible.

## types/

Workflow type definitions. Each file defines a complete workflow that
an orchestrator can run — it specifies the lifecycle phases, agent
roster, dispatch contracts, and verification criteria for a category
of work. Examples: agentic-workflow.md (structural/methodology
projects), development-workflow.md (sprint-based software projects),
task-workflow.md (single-session tasks), analytics-workspace.md
(analytical investigations).

When adding a new workflow type, place it here. See ADD-WORKFLOW.md
for the full process.

## protocols/

Supporting processes that workflow types reference but do not own.
Protocols are reusable across multiple workflow types — design
alignment, dispatch contracts, token estimation, sprint coordination,
knowledge synthesis, and similar cross-cutting concerns. A protocol
file never runs on its own; it is invoked by or consulted from a
workflow type definition.

When adding a new protocol, place it here and reference it from the
workflow types that use it.
