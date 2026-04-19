---
type: adr
id: ADR-<% tp.system.prompt("ADR number (e.g. 001)") %>
title: <% tp.system.prompt("Decision title") %>
status: <% tp.system.prompt("Status (Proposed / Accepted / Deprecated / Superseded)", "Proposed") %>
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
tags: [adr]
---

# ADR-<% tp.frontmatter.id %>: <% tp.frontmatter.title %>

## Status
<% tp.frontmatter.status %>

## Context
[What is the issue or decision that needs to be made? What forces are at play — technical constraints, business requirements, team capabilities, timeline?]

## Decision
[What was decided and why. State the decision clearly in one sentence, then elaborate.]

## Consequences
**Positive:**
- [What becomes easier or better as a result]

**Negative:**
- [What trade-offs are accepted]

**Neutral:**
- [What changes but isn't clearly better or worse]

## Alternatives Considered
[What other options were evaluated and why they were rejected.]
