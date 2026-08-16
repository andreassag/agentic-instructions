---
name: secret-scanning
description: Scan git commits and workspace for leaked credentials, API keys, and sensitive tokens.
---

# Secret Scanning Skill

Scans workspace files and git staging areas for hardcoded secrets, private keys, and API tokens.

## Available Scripts

- `scripts/secret-scan.sh`: Runs Gitleaks / TruffleHog / regex heuristics to detect leaked secrets.
