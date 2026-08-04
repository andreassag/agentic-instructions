---
name: secret-scan
description: Scans the repository for accidentally committed secrets using gitleaks (or truffleHog as fallback) before a push.
---

# Secret Scan Skill

Run this skill before pushing to a remote to catch accidentally committed secrets, API keys, tokens, or passwords.

## Trigger

`/secret-scan` or `secret-scan`

## What this skill does

1. Checks if `gitleaks` is available; falls back to `truffleHog3` if not.
2. Runs the scanner against the current repository (staged changes, committed history since origin, or full history depending on context).
3. Reports any findings with the file, line, and rule that matched.
4. Exits non-zero if any findings are found, blocking the push.

## Severity

All findings are treated as **BLOCKING** — secrets must be removed from history (via `git filter-repo` or BFG) before pushing.

## Installing the scanner

```bash
# gitleaks (preferred)
brew install gitleaks
# or
pip install gitleaks

# truffleHog (fallback)
pip install trufflehog3
```

## Notes

- This skill does not automatically remove secrets; it only detects them.
- If a finding is a false positive, add a `gitleaks:allow` inline comment or update `.gitleaks.toml`.
- Consider adding this as a pre-push git hook: `hub load <agent> --hooks`.
