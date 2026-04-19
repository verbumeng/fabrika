---
type: sprint
id: <% tp.system.prompt("Sprint ID (e.g. Sprint-01)") %>
goal: <% tp.system.prompt("Sprint goal (one sentence)") %>
start_date: <% tp.system.prompt("Start date (YYYY-MM-DD)") %>
end_date: <% tp.system.prompt("End date (YYYY-MM-DD)") %>
status: Planned
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
tags: [sprint]
---

# <% tp.frontmatter.id %>

**Goal:** <% tp.frontmatter.goal %>
**Dates:** <% tp.frontmatter.start_date %> → <% tp.frontmatter.end_date %>

---

## Stories

```dataview
TABLE title, epic, status, points
FROM "04-Backlog/Stories"
WHERE sprint = "<% tp.frontmatter.id %>"
SORT status ASC
```

**Total points:** *(calculated from table above)*

---

## Sprint Notes
[Add dated entries during the sprint — decisions, blockers, scope changes]

---

## Retrospective
*Fill in at sprint end.*

**What shipped:**
-

**What carried over (and why):**
-

**What went well:**
-

**What to improve:**
-
