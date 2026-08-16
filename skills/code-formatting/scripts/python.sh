#!/usr/bin/env bash
set -euo pipefail

# Python Formatter (Ruff / Black / isort)
echo "✨ Formatting Python codebase..."

if command -v ruff >/dev/null 2>&1; then
  echo "==> Running ruff format & fix..."
  ruff format . "$@"
  ruff check --fix . "$@" 2>/dev/null || true
elif command -v uv >/dev/null 2>&1; then
  uv run ruff format . "$@"
  uv run ruff check --fix . "$@" 2>/dev/null || true
elif command -v black >/dev/null 2>&1; then
  black . "$@"
  command -v isort >/dev/null 2>&1 && isort . "$@"
else
  echo "⚠️ Neither ruff nor black found. Install with: pip install ruff"
fi
