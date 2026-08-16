#!/usr/bin/env bash
set -euo pipefail

# Go Dependency Vulnerability Auditor (govulncheck)
echo "🔍 Auditing Go dependencies for vulnerabilities..."

if command -v govulncheck >/dev/null 2>&1; then
  echo "==> Running govulncheck..."
  govulncheck ./... "$@"
elif command -v go >/dev/null 2>&1; then
  echo "⚠️ govulncheck is not installed. Install with: go install golang.org/x/vuln/cmd/govulncheck@latest"
  exit 0
else
  echo "Error: go command not found in PATH."
  exit 1
fi
