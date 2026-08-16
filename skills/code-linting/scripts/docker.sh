#!/usr/bin/env bash
set -euo pipefail

# Dockerfile & Docker Compose Linter (hadolint)
echo "🔍 Linting Dockerfile(s) and compose configs..."

EXIT_CODE=0

if command -v hadolint >/dev/null 2>&1; then
  for df in Dockerfile* */Dockerfile*; do
    if [[ -f "$df" ]]; then
      echo "==> Linting $df with hadolint..."
      hadolint "$df" || EXIT_CODE=1
    fi
  done
else
  echo "⚠️ hadolint is not installed. Install with: brew/apt install hadolint"
fi

if command -v docker >/dev/null 2>&1; then
  for comp in docker-compose.yml compose.yaml compose.yml; do
    if [[ -f "$comp" ]]; then
      echo "==> Validating $comp..."
      docker compose -f "$comp" config >/dev/null || EXIT_CODE=1
    fi
  done
fi

exit $EXIT_CODE
