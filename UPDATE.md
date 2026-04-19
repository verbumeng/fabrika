# Update Protocol

> **Audience: the AI agent.** This document tells you how to update an existing Fabrika-installed project to a newer Fabrika version. The whole point is to make this cheap — no whole-project diffing. The manifest and changelog do the work.

## Prerequisites

- The target project has a `.fabrika/manifest.yml` (installed via BOOTSTRAP.md or ADOPT.md)
- You have access to the canonical Fabrika repo on this machine

## Update Flow

### 1. Read the manifest

Read the target project's `.fabrika/manifest.yml`. Note:
- `fabrika_version` — the version currently installed
- `installed_files` — every file Fabrika placed, with source paths and hashes

### 2. Read the current Fabrika version

Read `VERSION` from the Fabrika repo. If the version matches the manifest's `fabrika_version`, the project is already up to date. Report this and stop.

### 3. Determine what changed

Read `CHANGELOG.md` from the Fabrika repo. Find all entries between the manifest's `fabrika_version` and the current `VERSION`. Build a list of changed files from those entries.

**This is the cost-saving move.** The agent reads the changelog, not the whole repo. Do NOT fall back to brute-force diffing of every file in Fabrika against every file in the project. The changelog is authoritative for what changed between versions.

### 4. For each changed file

For each file listed in the changelog entries:

**a. Find it in the manifest.** Look up the file's source path in `installed_files[].source`. If it's not in the manifest (new file added in a later version), skip to step 4e.

**b. Read the current file in the target project.** Compute its sha256 hash.

**c. Compare hashes.**

- **Hash matches `installed_files[].hash`** → The file has NOT been customized locally. It's safe to overwrite.
  - Copy the new canonical version from the Fabrika repo into the target project
  - Update the manifest entry: new `hash`, new `source_version`
  - Set `customized: false`

- **Hash differs from `installed_files[].hash`** → The file WAS customized locally.
  - Present the diff to the user: show what changed in canonical Fabrika vs. what the local file looks like
  - Ask the user: **"This file was customized locally. Options: (1) Keep local version, (2) Accept canonical update (overwrites local changes), (3) Merge manually."**
  - If keep local: leave the file alone, update `source_version` in manifest to current, leave `customized: true`
  - If accept canonical: overwrite, update hash and source_version, set `customized: false`
  - If merge manually: the user edits the file, then the agent recomputes the hash and updates the manifest

**d. Move to the next file.**

**e. New files (not in manifest).** If the changelog introduces a new file that doesn't exist in the manifest:
  - Determine if the file is relevant to this project's type and integrations
  - If relevant, copy it into the appropriate location, add a manifest entry
  - If not relevant (e.g., a Copilot file for a Claude-Code-only project), skip it

### 5. Update the manifest

- Set `fabrika_version` to the current Fabrika VERSION
- Set `updated_at` to today's date
- All per-file entries should reflect the new state

### 6. Check for migrations

If a `MIGRATIONS.md` file exists in the Fabrika repo, read it. Check for any entries in the version range being upgraded through. Surface migration instructions to the user — these are manual steps that go beyond file overwrites (e.g., "rename the `docs/evals/` directory to `docs/agent-evals/`").

### 7. Report

Tell the user:
- Which files were updated (overwritten cleanly)
- Which files had local customizations (and what the user chose)
- Which new files were added
- Any migration steps that need attention
- The new Fabrika version installed

## Important Notes

- **Never auto-update customized files.** Always ask the user.
- **The changelog is the source of truth for what changed.** Do not diff the entire Fabrika repo.
- **If the manifest is missing or corrupted,** recommend running ADOPT.md to re-establish it.
- **Multi-version jumps are fine.** If the project is on 0.1.0 and Fabrika is at 0.4.0, process all changelog entries from 0.1.0 through 0.4.0 in order.
