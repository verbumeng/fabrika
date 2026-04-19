---
type: feature-spec
title: <% tp.system.prompt("Feature name") %>
status: <% tp.system.prompt("Status (Draft / Approved / Implemented)", "Draft") %>
epic: <% tp.system.prompt("Related epic (e.g. E-01)", "") %>
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
tags: [feature-spec]
---

# <% tp.frontmatter.title %>

## Problem
[What problem does this feature solve? Why does it matter?]

## Proposed Solution
[How does this feature work from the user's perspective?]

## User Flow
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Edge Cases
- [What happens when X?]
- [What if Y is empty/null/invalid?]

## Acceptance Criteria
- [ ] [Specific, testable criterion]
- [ ] [Specific, testable criterion]

## Technical Notes
[Implementation approach, dependencies, data model changes, API changes.]

## Open Questions
- [Anything unresolved]
