#!/usr/bin/env bash
set -euo pipefail

# Go Formatter (gofmt & goimports)
echo "✨ Formatting Go codebase..."

if command -v goimports >/dev/null 2>&1; then
  echo "==> Running goimports..."
  goimports -w . "$@"
fi

if command -v gofmt >/dev/null 2>&1; then
  echo "==> Running gofmt..."
  gofmt -s -w . "$@"
elif command -v go >/dev/null 2>&1; then
  go fmt ./... "$@"
fi
