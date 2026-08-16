#!/usr/bin/env bash
set -euo pipefail

# Rust Formatter (cargo fmt)
echo "✨ Formatting Rust codebase with cargo fmt..."

if ! command -v cargo >/dev/null 2>&1; then
  echo "Error: cargo command not found in PATH."
  exit 1
fi

cargo fmt --all "$@"
