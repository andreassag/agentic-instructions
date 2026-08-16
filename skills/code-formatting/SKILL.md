---
name: code-formatting
description: Format source code files in-place according to language standards.
---

# Code Formatting Skill

Applies AST-based code formatting in-place across supported languages.

## Available Scripts

- `scripts/go.sh`: Run `gofmt` / `goimports`.
- `scripts/python.sh`: Run `ruff format` / `black`.
- `scripts/rust.sh`: Run `cargo fmt` / `rustfmt`.
- `scripts/ts.sh`: Run `prettier` / `biome` / `eslint --fix`.
- `scripts/bash.sh`: Run `shfmt -i 2 -w`.
- `scripts/cpp.sh`: Run `clang-format -i`.
- `scripts/nextflow.sh`: Run Nextflow formatter.
- `scripts/r.sh`: Run `styler::style_pkg()`.
