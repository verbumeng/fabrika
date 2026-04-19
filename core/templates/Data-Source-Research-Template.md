---
type: research
source: <% tp.system.prompt("Data source name") %>
status: <% tp.system.prompt("Status (Not Started / In Progress / Complete)", "Not Started") %>
priority: <% tp.system.prompt("Priority (1-4)", "2") %>
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
tags: [research, data-source]
---

# <% tp.frontmatter.source %>

## Overview
[What is this data source? What data does it contain? Why do we need it?]

## Access Method
[How do we get data from this source? API, web scraping, file export, database connection, manual download?]

- **Method:** [API / Scraper / File Export / DB Connection / Manual]
- **URL / Endpoint:** [if applicable]
- **Authentication:** [API key / OAuth / Login credentials / None]
- **Rate Limits:** [if applicable]

## Data Format
[What does the data look like?]

- **Format:** [JSON / CSV / HTML / XML / Excel / Parquet]
- **Key Fields:** [list the important fields/columns]
- **Volume:** [approximate row count or file size per pull]
- **Refresh Cadence:** [how often does the source data update?]

## Known Issues
[Quirks, gotchas, inconsistencies, or reliability concerns.]

## Transformation Notes
[Any cleaning, parsing, or transformation needed before the data is usable.]

## Testing / Validation
[How to verify the data was extracted correctly. Expected values, checksums, row counts.]
