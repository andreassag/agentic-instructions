---
name: dep-audit
description: Runs language-specific dependency audits (pip-audit, npm audit, cargo audit) and surfaces high/critical severity findings.
---

# Dependency Audit Skill

Run this skill to check for known vulnerabilities in project dependencies before shipping.

## Trigger

`/dep-audit` or `dep-audit`

## What this skill does

1. Auto-detects the project type from lockfiles present in the working directory.
2. Runs the appropriate audit tool:
   - **Python** (`uv.lock` / `requirements.txt`): `pip-audit`
   - **Node.js** (`package-lock.json` / `yarn.lock` / `bun.lockb`): `npm audit --audit-level=high`
   - **Rust** (`Cargo.lock`): `cargo audit`
   - **R** (`renv.lock`): checks packages against the OSV database via `pak::pkg_security_check()` (if available)
3. Filters results to `HIGH` and `CRITICAL` severity only; summarizes lower-severity findings as a count.
4. Outputs: number of vulnerable packages, CVE IDs, severity, and the upgrade path if one exists.
5. Exits non-zero if any HIGH or CRITICAL findings are present.

## Installing the auditors

```bash
pip install pip-audit          # Python
npm install -g npm              # npm audit is built-in
cargo install cargo-audit       # Rust
```

## Notes

- Run this in CI on every push to the main branch and on dependency updates.
- If a vulnerability has no fix, document it in `SECURITY.md` with a mitigation strategy.
- Findings should be triaged: not every CVE is exploitable in your usage context.
