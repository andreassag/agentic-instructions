#!/usr/bin/env bash
set -euo pipefail

# Python Test & Coverage Runner
echo "🧪 Running Python test suite & coverage..."

if command -v pytest >/dev/null 2>&1; then
  pytest --cov=. --cov-report=term-missing "$@" 2>/dev/null || pytest "$@"
elif command -v uv >/dev/null 2>&1 && [[ -f "pyproject.toml" ]]; then
  uv run pytest --cov=. --cov-report=term-missing "$@" 2>/dev/null || uv run pytest "$@"
elif command -v python3 >/dev/null 2>&1; then
  python3 -m unittest discover -s tests "$@"
else
  echo "Error: Neither pytest nor python3 found in PATH."
  exit 1
fi
