---
type: design
title: <% tp.system.prompt("Dashboard/report name") %>
status: <% tp.system.prompt("Status (Draft / Approved / Implemented)", "Draft") %>
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
tags: [design, dashboard]
---

# <% tp.frontmatter.title %>

## Purpose
[What question does this dashboard answer? Who uses it and how often?]

## Layout
[Describe or sketch the layout. ASCII wireframe is ideal.]

```
+--------------------------------------------------+
| TITLE BAR / FILTERS                              |
+--------------------------------------------------+
| Summary Cards     | Summary Cards                |
| [metric] [metric] | [metric] [metric]            |
+--------------------------------------------------+
| Main Chart / Table                               |
|                                                  |
|                                                  |
+--------------------------------------------------+
| Detail Table                                     |
|                                                  |
+--------------------------------------------------+
```

## Components
| Component | Data Source | Description |
|-----------|------------|-------------|
| [card/chart/table] | [table.column] | [what it shows] |

## Filters & Interactions
- [Filter 1]: [what it controls]
- [Filter 2]: [what it controls]
- [Click behavior]: [what happens when user clicks X]

## Data Refresh
[How often does the data update? Real-time, daily, on-demand?]

## Permissions
[Who can see this dashboard? Any row-level security?]
