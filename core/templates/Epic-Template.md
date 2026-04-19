---
type: epic
id: <% tp.system.prompt("Epic ID (e.g. E-01)") %>
title: <% tp.system.prompt("Epic title") %>
status: To Do
priority: <% tp.system.prompt("Priority (High / Medium / Low)", "Medium") %>
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
tags: [epic]
---

# <% tp.frontmatter.title %>

## Overview
[Describe the epic in 2-4 sentences. What is the capability being built? Why does it matter?]

## Stories
```dataview
TABLE title, status, points, sprint
FROM "04-Backlog/Stories"
WHERE epic = "<% tp.frontmatter.id %>"
SORT status ASC
```

## Notes
[High-level notes, open questions, decisions spanning multiple stories]
