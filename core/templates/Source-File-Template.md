---
type: source-file
name: [Human-readable name — e.g., "Monthly Revenue Extract", "Vendor Master List"]
file_type: [csv | excel | yxdb | hyper | parquet | json | other]
status: active
last_verified: YYYY-MM-DD
---

# [File Source Name]

## Delivery Details
- **Who sends it:** [Person, team, or system that produces this file]
- **Delivery method:** [Email attachment, shared drive drop, SFTP, SharePoint, automated export]
- **Delivery frequency:** [Daily, weekly, monthly, ad hoc, on-request]
- **Typical delivery time:** [e.g., "First business day of the month by noon"]
- **File location:** [Where to find it — network path, SharePoint URL, email from X]
- **Landing folder:** [Where it goes in `data/input/` — e.g., `data/input/finance/`]

## File Format
- **Type:** [CSV, Excel (.xlsx), YXDB, Hyper, Parquet, JSON, other]
- **Encoding:** [UTF-8, Windows-1252, etc. — note if it's caused issues before]
- **Delimiter:** [For CSV: comma, tab, pipe, etc.]
- **Header row:** [Yes/no, which row]
- **Typical size:** [Row count and file size — e.g., "~50K rows, ~5MB"]

## Schema
[Expected columns/fields. Document what you know — this may be incomplete for messy files.]

| Column | Type | Description | Notes |
|--------|------|-------------|-------|
| [e.g., Order_ID] | [string] | [Unique order identifier] | [Primary key] |
| [e.g., Revenue] | [decimal] | [Order revenue in USD] | [May be negative for returns] |
| [e.g., Region] | [string] | [Sales region code] | [Codes vary between files — see Known Issues] |

## Known Issues
- [e.g., "Sometimes includes a trailing blank row that breaks CSV parsers"]
- [e.g., "Date format changes between months — sometimes MM/DD/YYYY, sometimes YYYY-MM-DD"]
- [e.g., "Revenue column occasionally has commas in numbers (e.g., '1,234.56' as text)"]
- [e.g., "Header names change slightly between deliveries — 'OrderID' vs 'Order_ID'"]
- [e.g., "File is sometimes late by 1-2 days with no notification"]
