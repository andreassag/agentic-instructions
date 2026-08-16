#!/usr/bin/env bash
set -euo pipefail

# Go Linter (golangci-lint & go vet)
echo "🔍 Linting Go codebase..."

EXIT_CODE=0

if command -v golangci-lint >/dev/null 2>&1; then
  echo "==> Running golangci-lint..."
  golangci-lint run "$@" || EXIT_CODE=1
elif command -v go >/dev/null 2>&1; then
  echo "==> Running go vet..."
  go vet ./... || EXIT_CODE=1
else
  echo "Error: Neither golangci-lint nor go found in PATH."
  exit 1
fi

exit $EXIT_CODE
