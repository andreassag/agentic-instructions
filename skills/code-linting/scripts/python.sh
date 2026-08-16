#!/usr/bin/env bash
set -euo pipefail

# Python Linter (Ruff & MyPy)
echo "🔍 Linting Python codebase..."

EXIT_CODE=0

if command -v ruff >/dev/null 2>&1; then
  echo "==> Running ruff check..."
  ruff check . "$@" || EXIT_CODE=1
elif command -v uv >/dev/null 2>&1; then
  uv run ruff check . "$@" || EXIT_CODE=1
elif command -v flake8 >/dev/null 2>&1; then
  flake8 . "$@" || EXIT_CODE=1
else
  echo "⚠️ ruff is not installed. Install with: pip install ruff (or uv tool install ruff)"
fi

if command -v mypy >/dev/null 2>&1 && [[ -f "pyproject.toml" || -f "mypy.ini" || -f "setup.cfg" ]]; then
  echo "==> Running mypy type checker..."
  mypy . || EXIT_CODE=1
fi

exit $EXIT_CODE
