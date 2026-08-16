#!/usr/bin/env bash
set -euo pipefail

# Go Test & Coverage Runner
echo "🧪 Running Go test suite & coverage..."

if ! command -v go >/dev/null 2>&1; then
  echo "Error: go command not found in PATH."
  exit 1
fi

go test -v -cover -coverprofile=coverage.out ./... "$@"
if [[ -f "coverage.out" ]]; then
  echo "==> Code Coverage Summary:"
  go tool cover -func=coverage.out | tail -n 1
fi
