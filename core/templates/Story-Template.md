---
type: story
id: <% tp.system.prompt("Story ID (e.g. S-001)") %>
title: <% tp.system.prompt("Story title") %>
epic: <% tp.system.prompt("Parent epic ID (e.g. E-01)") %>
sprint: <% tp.system.prompt("Sprint (e.g. Sprint-01, or leave blank)", "") %>
status: To Do
points: <% tp.system.prompt("Story points (1/2/3/5/8/13)", "3") %>
priority: <% tp.system.prompt("Priority (High / Medium / Low)", "Medium") %>
tier: <% tp.system.prompt("Complexity tier (patch / story / deep-story)", "story") %>
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
tags: [story]
---

# <% tp.frontmatter.title %>

## Description
[What needs to be built? Describe from the perspective of what the system should do, not how.]

## Acceptance Criteria
- [ ] [Criterion 1 — specific and testable]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Technical Notes
[Optional: implementation approach, constraints, relevant files or docs]

## Notes
[Running log of decisions, blockers, scope deviations. Add dated entries as work progresses.]
