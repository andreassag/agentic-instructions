#!/usr/bin/env bash
set -euo pipefail

# Rust Test & Coverage Runner
echo "🧪 Running Rust test suite & coverage..."

if ! command -v cargo >/dev/null 2>&1; then
  echo "Error: cargo command not found in PATH."
  exit 1
fi

if command -v cargo-llvm-cov >/dev/null 2>&1; then
  cargo llvm-cov --summary-only "$@"
elif command -v cargo-tarpaulin >/dev/null 2>&1; then
  cargo tarpaulin --out-type Stdout "$@"
else
  echo "Running standard cargo test (install cargo-llvm-cov for coverage reports):"
  cargo test "$@"
fi
