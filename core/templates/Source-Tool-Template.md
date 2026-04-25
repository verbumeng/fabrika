---
type: source-tool
name: [Human-readable name — e.g., "Tableau Server", "Power BI Workspace", "Alteryx Server"]
tool_type: [tableau | power-bi | alteryx | looker | excel | other]
status: active
last_verified: YYYY-MM-DD
---

# [Tool Name]

> **Advisory mode:** The agent cannot directly access or modify content in this tool. The agent can write SQL, draft DAX/M/calculated fields, review described logic, and write validation queries. The human executes inside the tool.

## Access Details
- **URL/Location:** [Server URL, workspace URL, or local install path]
- **Authentication:** [How to log in — SSO, separate credentials, license type]
- **Who has access:** [Which team members, what permission levels]

## Key Assets
[Workbooks, reports, workflows, or dashboards that live in this tool.]

| Asset | Description | Data Sources | Refresh Schedule | Owner |
|-------|-------------|-------------|-----------------|-------|
| [e.g., Revenue Dashboard] | [Monthly revenue by region] | [warehouse-prod, finance-sharepoint] | [Daily 6am] | [Analyst name] |
| [e.g., Vendor ETL workflow] | [Cleans vendor data, loads to staging] | [vendor-ftp, warehouse-prod] | [Weekly Monday] | [Engineer name] |

## Data Sources Used
[Which connections or files (from `sources/connections/` and `sources/files/`) feed into this tool's assets.]
- [e.g., `sources/connections/warehouse-prod.md` — used by Revenue Dashboard, Sales Report]
- [e.g., `sources/files/vendor-master-list.md` — used by Vendor ETL workflow]

## What the Agent Can Help With
[Specific ways the agent adds value for work involving this tool.]
- **SQL authoring:** Write queries for data sources feeding this tool
- **Logic review:** Review described calculation logic, filter logic, join logic
- **DAX/M/Calculated fields:** Draft formulas for the human to paste in
- **Validation queries:** Write SQL to independently verify the tool's output
- **Documentation:** Document transformation logic that's currently only inside the tool
- **Migration:** Rewrite tool-specific logic as SQL/Python when migrating away

## Known Quirks
- [e.g., "Tableau extracts refresh at 6am but sometimes fail silently — check the extract refresh log"]
- [e.g., "Power BI gateway goes down when VPN disconnects"]
- [e.g., "Alteryx workflows use absolute file paths that break on different machines"]
