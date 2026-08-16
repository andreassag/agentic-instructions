---
name: dependency-management
description: Audit, update, and synchronize package dependencies and lockfiles.
---

# Dependency Management Skill

Automates dependency auditing and synchronization for project packages.

## Available Scripts

- `scripts/go.sh`: Run `go mod tidy` and verify dependencies.
- `scripts/python.sh`: Sync and audit dependencies with `uv` or `pip`.
- `scripts/rust.sh`: Run `cargo audit` and update `Cargo.lock`.
- `scripts/ts.sh`: Run `npm audit` / `pnpm audit` / `bun audit`.
- `scripts/r.sh`: Restore and update R environment via `renv`.
