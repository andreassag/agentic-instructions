---
name: test-runner
description: Execute automated unit and integration tests with coverage reporting.
---

# Test Runner Skill

Executes test suites and coverage reports across supported language toolchains.

## Available Scripts

- `scripts/go.sh`: Run `go test -v -race -cover ./...`.
- `scripts/python.sh`: Run `pytest --cov`.
- `scripts/rust.sh`: Run `cargo test`.
- `scripts/ts.sh`: Run `vitest run` / `jest` / `npm test`.
- `scripts/bash.sh`: Run `bats` / `bash tests/run_all.sh`.
- `scripts/cpp.sh`: Run `ctest --output-on-failure`.
- `scripts/nextflow.sh`: Run `nf-core test`.
- `scripts/r.sh`: Run `devtools::test()`.
