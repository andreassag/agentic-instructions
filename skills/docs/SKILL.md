---
name: changelog-entry
description: Generates a CHANGELOG.md entry from git log since the last release tag, formatted to Keep a Changelog spec.
---

# Changelog Entry Skill

Run this skill before tagging a release to generate a correctly formatted CHANGELOG.md entry from the git history.

## Trigger

`/changelog` or `changelog-entry`

## What this skill does

1. Finds the most recent git tag (`git describe --tags --abbrev=0`).
2. Collects commits since that tag (`git log <tag>..HEAD --oneline`).
3. Categorizes commits into `Added`, `Changed`, `Fixed`, `Removed`, `Security` based on conventional commit prefixes or message heuristics.
4. Writes the new entry at the top of `CHANGELOG.md` under `## [Unreleased]`.
5. Prints a summary of how many commits were categorized and how many were skipped (e.g., chore/merge commits).

## Format

Follows [Keep a Changelog](https://keepachangelog.com) v1.0.0:

```markdown
## [Unreleased]

### Added
- …

### Fixed
- …
```

## Notes

- Run `git tag -a v1.2.3 -m "release"` after reviewing the generated entry to finalize the release.
- Merge commits and commits prefixed `chore:` / `ci:` / `docs:` are omitted from the user-facing changelog by default.
