# Batch Index Schema

Batch index files are the stable intermediates produced by the
Extract+Index phases of the knowledge pipeline. They live at
`wiki/meta/batch-YYYY-MM-DD.json` and decouple the synthesis step
from source file lifecycle — source files can be renamed, moved, or
deleted without breaking previously indexed content.

## Schema

```json
{
  "batch_id": "batch-YYYY-MM-DD",
  "created": "YYYY-MM-DDTHH:MM:SS",
  "pipeline_version": "0.18.0",
  "artifacts_processed": [
    {
      "source_path": "docs/02-Engineering/ADRs/ADR-003-auth-strategy.md",
      "source_type": "adr",
      "source_hash": "sha256-of-file-contents-at-index-time",
      "salience": "S1",
      "salience_reason": "Accepted ADR — owner-approved design decision",
      "extracted_content": {
        "title": "Authentication Strategy",
        "summary": "One to three sentence summary of the artifact's content",
        "key_concepts": ["session tokens", "OAuth2", "refresh rotation"],
        "decisions": ["Use OAuth2 with refresh token rotation"],
        "open_questions": [],
        "related_domains": ["security", "user-management"]
      },
      "topic_candidates": ["authentication-architecture", "security-decisions"],
      "dedup_key": "adr-003-auth-strategy"
    }
  ],
  "index_stats": {
    "total_artifacts": 1,
    "by_salience": { "S1": 1, "S2": 0, "S3": 0 },
    "by_type": { "adr": 1 },
    "new_since_last_batch": 1
  }
}
```

## Field Definitions

### Top-level fields

| Field | Type | Description |
|-------|------|-------------|
| `batch_id` | string | Unique identifier, format `batch-YYYY-MM-DD`. If multiple batches run on the same day, append a counter: `batch-YYYY-MM-DD-2`. |
| `created` | ISO 8601 | Timestamp when the batch was produced. |
| `pipeline_version` | string | Fabrika version that produced the batch. Used for schema migration if the schema evolves. |
| `artifacts_processed` | array | One entry per source artifact processed in this batch. |
| `index_stats` | object | Summary statistics for quick inspection without reading all entries. |

### Per-artifact fields

| Field | Type | Description |
|-------|------|-------------|
| `source_path` | string | Path to the source artifact at index time. For reference only — the content is captured in `extracted_content`, so the batch survives source file moves. |
| `source_type` | string | Artifact type. Values: `adr`, `evaluation`, `retro`, `session-log`, `sprint-progress`, `maintenance-report`, `research`, `prd`, `charter`, `story`, `epic`, `bug`, `domain-language`, `meeting-notes`, `someday-maybe`, `other`. |
| `source_hash` | string | SHA-256 of file contents at index time. Used for deduplication — if the same hash appears in a later batch, the artifact hasn't changed and can be skipped. |
| `salience` | string | Salience score: `S1`, `S2`, or `S3`. See the salience model in `core/workflows/protocols/knowledge-pipeline.md`. |
| `salience_reason` | string | One-line explanation of why this salience was assigned. Aids transparency and owner override. |
| `extracted_content` | object | Normalized content extracted from the artifact. |
| `topic_candidates` | array | Suggested topic article names this artifact might contribute to. These are proposals — the synthesis step decides which topics actually get created or updated. |
| `dedup_key` | string | Stable identifier for deduplication across batches. Format: `[type]-[identifier]` (e.g., `adr-003-auth-strategy`). If the same `dedup_key` appears in multiple batches, only the most recent is used. |

### Extracted content fields

| Field | Type | Description |
|-------|------|-------------|
| `title` | string | Title of the artifact. |
| `summary` | string | One to three sentence summary of the artifact's core content. Written by the agent during extraction. |
| `key_concepts` | array | Domain concepts mentioned in the artifact. Should use Domain Language terms when they exist. |
| `decisions` | array | Decisions made or recorded in the artifact (empty array if none). |
| `open_questions` | array | Unresolved questions raised in the artifact (empty array if none). |
| `related_domains` | array | Knowledge domains this artifact touches (e.g., "security", "data-pipeline", "user-experience"). Used for topic clustering during synthesis. |

## Deduplication Rules

1. **Within a batch:** Each source file appears at most once per
   batch (deduplicated by `source_path`).
2. **Across batches:** If a file's `source_hash` matches its entry
   in a previous batch, it has not changed and the synthesis step
   may skip re-processing it. If the hash differs, the file was
   updated and the new extraction replaces the old one.
3. **Renamed files:** If a `dedup_key` appears in a new batch with
   a different `source_path`, the file was likely renamed. The new
   entry supersedes the old one.
4. **Deleted files:** Files that existed in a previous batch but no
   longer exist on disk are NOT removed from the batch index. The
   indexed content is preserved — the batch is a stable
   intermediate. Stale entries are cleaned up during quarterly
   reintegration.

## Usage Notes

- Batch indexes are agent-facing artifacts. Humans do not need to
  read them. They live in `wiki/meta/` and are committed to git for
  reproducibility.
- The synthesis step reads all batch indexes since the last synthesis
  pass to determine what new content is available for topic articles.
- During quarterly reintegration, all batch indexes are re-read and
  stale entries (deleted source files, superseded extractions) are
  cleaned up.
