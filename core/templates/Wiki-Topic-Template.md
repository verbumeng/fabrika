---
type: wiki-topic
status: active
salience: S2
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: []
tags: [wiki]
---

# [Topic Name]

## Summary

[Two to four sentences: what this topic is, why it matters to this
project, and what someone needs to know at a glance. Write as if
explaining to a colleague who just joined the project. Lead with
context, not jargon.]

## Key Decisions

[Synthesized from ADRs, retro findings, design alignment sessions,
and PRDs. Each entry: what was decided, why, and what alternatives
were considered. Link to the source artifact.]

- **[Decision summary]** — [rationale]. Source: [artifact link]

## Current State

[What is true now — not what was true 3 sprints ago. This section
gets rewritten during each synthesis pass, not appended to. Include
the current implementation approach, any active constraints, and
how this topic connects to the broader system.]

## Open Questions

[Unresolved items that have appeared across multiple artifacts.
Each entry: the question, where it surfaced, and any partial
answers or leading hypotheses.]

- [Question] — surfaced in [artifact 1], [artifact 2]

## Related Topics

[Links to other wiki topic articles that connect to this one.
Brief note on the nature of the relationship.]

- [[topic-name]] — [how they relate]

## Sources

[Every artifact this topic was synthesized from. Grouped by type
for readability. Include the artifact path and a one-line note on
what it contributed to this topic.]

### ADRs
- [path] — [what it contributed]

### Evaluation Reports
- [path] — [what it contributed]

### Retro Findings
- [path] — [what it contributed]

### Other
- [path] — [what it contributed]

---

## Writing Guidelines (remove this section from actual articles)

These guidelines govern how the synthesis step writes topic articles.

**Audience:** Both humans and agents. Humans need readable narrative
with plain language. Agents need structured sections they can parse.
The template satisfies both — narrative prose within structured
sections.

**Domain Language alignment:** Use terms from the project's Domain
Language document (`docs/00-Index/Domain-Language.md`). If a concept
appears that isn't in Domain Language, flag it for addition — do not
define it only in the wiki. The Glossary pipeline phase (Phase 5)
handles this feedback loop.

**Synthesis threshold:** A topic article requires content from at
least 2 independent source artifacts. Do not create articles that
merely restate a single ADR or evaluation report — those are
already readable on their own.

**Current State accuracy:** The Current State section reflects what
is true at the time of the last synthesis pass. During updates,
rewrite this section entirely rather than appending — stale state
mixed with current state is worse than no state at all.

**Progressive depth:** Topic articles sit in the middle tier of the
wiki hierarchy. They should be deeper than the summary in
wiki/index.md but not as detailed as the source artifacts
themselves. A reader should be able to understand the topic from
the article alone, then follow source links for full detail.
