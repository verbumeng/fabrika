---
type: reference
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
last-validated: YYYY-MM-DD
tags: [domain-language, glossary, terminology]
---

# Domain Language — [PROJECT_NAME]

The shared vocabulary of this project. Every domain concept that
matters to how we think, talk, and build is defined here.

**How to use this document:**

- Organized by domain area, not alphabetically. Terms live near the
  concepts they relate to.
- Add terms during alignment, planning, and implementation. If a new
  concept surfaces during implementation, flag it for addition here.
- The **code-level name** field is mandatory on every entry. Mark it
  "not yet implemented" until the concept is implemented in code, then
  fill in the actual class names, table names, or variable names the
  codebase uses. Implementers populate this field as they build;
  code review enforces it.
- In multi-type projects, use domain area sections to disambiguate
  terms that mean different things in different contexts. Populate
  anti-terms to prevent confusion.
- This document serves as the project's canonical term glossary. If a
  wiki knowledge layer is configured, the wiki's glossary phase draws
  from this document rather than defining terms independently.

---

## [Domain Area Name]

### [Term Name]
- **Definition:** [Plain-language definition — what this term means in the context of this project]
- **Code-level name:** [not yet implemented]
- **Relationships:** [How this term relates to other terms in the Domain Language]
- **Anti-terms:** [What this term is NOT — prevents confusion with similar concepts]

---

## Cross-Domain Terms

Terms that span multiple domain areas or apply project-wide.

### [Term Name]
- **Definition:** [Plain-language definition]
- **Code-level name:** [not yet implemented]
- **Relationships:** [How this term relates to other terms]
- **Anti-terms:** [What this term is NOT]

---

## Example Entry

> This section demonstrates the format. Remove it once real terms are
> added.

### Order Management

#### Customer
- **Definition:** A person or organization that places orders. Distinct from "user" (someone who logs into the system) — a customer may have multiple users acting on their behalf.
- **Code-level name:** class `Customer`, table `customers`, variable `current_customer`
- **Relationships:** A Customer has many Orders. A Customer belongs to one Account. A Customer is served by one or more Sales Representatives.
- **Anti-terms:** Not "user" (a user is a login identity; a customer is a business entity). Not "contact" (a contact is a person associated with a customer but may not place orders). Not "account" (an account is the billing/organizational wrapper around one or more customers).
