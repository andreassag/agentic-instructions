#!/usr/bin/env bash
set -euo pipefail

# Rust Linter (Cargo Clippy)
echo "🔍 Linting Rust codebase with clippy..."

if ! command -v cargo >/dev/null 2>&1; then
  echo "Error: cargo command not found in PATH."
  exit 1
fi

cargo clippy --all-targets --all-features -- -D warnings "$@"
