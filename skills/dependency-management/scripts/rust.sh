#!/usr/bin/env bash
set -euo pipefail

# Rust Dependency Vulnerability Auditor (cargo audit)
echo "🔍 Auditing Rust dependencies for vulnerabilities..."

if command -v cargo-audit >/dev/null 2>&1 || cargo audit --version >/dev/null 2>&1; then
  echo "==> Running cargo audit..."
  cargo audit "$@"
elif command -v cargo >/dev/null 2>&1; then
  echo "⚠️ cargo-audit is not installed. Install with: cargo install cargo-audit"
  exit 0
else
  echo "Error: cargo command not found in PATH."
  exit 1
fi
