---
name: code-linting
description: Execute static analysis, type checking, and linter suites.
---

# Code Linting Skill

Runs static analysis and linter checks across all project languages.

## Available Scripts

- `scripts/go.sh`: Run `golangci-lint` / `go vet`.
- `scripts/python.sh`: Run `ruff check` / `mypy`.
- `scripts/rust.sh`: Run `cargo clippy`.
- `scripts/ts.sh`: Run `eslint` / `tsc --noEmit`.
- `scripts/bash.sh`: Run `shellcheck`.
- `scripts/cpp.sh`: Run `clang-tidy` / `cppcheck`.
- `scripts/docker.sh`: Run `hadolint`.
- `scripts/nextflow.sh`: Run `nf-core lint`.
- `scripts/r.sh`: Run `lintr::lint_package()`.
