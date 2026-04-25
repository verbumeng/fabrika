---
type: source-connection
name: [Human-readable name — e.g., "Production Warehouse", "Salesforce API"]
connection_type: [warehouse | database | api | odbc | sharepoint | network-share | other]
status: active
last_verified: YYYY-MM-DD
---

# [Source Name]

## Connection Details
- **Type:** [e.g., Snowflake, BigQuery, PostgreSQL, SQL Server, REST API, ODBC, SharePoint]
- **Host/URL:** [Connection string, URL, or path — redact credentials, reference .env vars]
- **Authentication:** [How to authenticate — SSO, service account, API key, Windows auth. Don't put actual credentials here.]
- **Database/Schema:** [Which database and schema(s) are relevant]

## What Lives Here
[Brief description of what data this source contains and why we use it.]

### Key Tables/Endpoints
| Table/Endpoint | Description | Approximate rows | Update frequency |
|---------------|-------------|-----------------|-----------------|
| [e.g., sales.orders] | [Customer orders with line items] | [~2M] | [Real-time / daily / hourly] |
| [e.g., sales.customers] | [Customer master data] | [~50K] | [Daily] |

## Access Notes
- **Who can access:** [Team members, roles, or specific accounts that have access]
- **How to get access:** [Process for requesting access if someone new needs it]
- **Rate limits/restrictions:** [API rate limits, query timeout settings, row limits]

## Known Gotchas
[Data quality issues, quirks, or traps that anyone using this source should know about.]
- [e.g., "Timestamps are in UTC but some older records are in local time"]
- [e.g., "The `status` field uses codes (1=active, 2=inactive) not labels"]
- [e.g., "Historical data before 2024 was migrated and may have gaps"]
- [e.g., "Queries against the reporting schema are throttled during business hours"]

## Reliability
- **SLA:** [Uptime expectations — "99.9% per vendor SLA" or "internal, no formal SLA"]
- **Known outage patterns:** [e.g., "Maintenance window Sunday 2-4am EST"]
- **Data freshness:** [How current is the data? Real-time? 24-hour lag? Updated nightly at 3am?]
