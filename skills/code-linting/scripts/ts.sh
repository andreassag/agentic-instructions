#!/usr/bin/env bash
set -euo pipefail

# TypeScript / JavaScript Linter (ESLint / Biome / TSC)
echo "🔍 Linting TypeScript / JavaScript codebase..."

EXIT_CODE=0

if [[ -f "package.json" ]]; then
  if grep -q '"lint"' package.json 2>/dev/null; then
    npm run lint || EXIT_CODE=1
  elif command -v biome >/dev/null 2>&1; then
    biome check . || EXIT_CODE=1
  elif command -v eslint >/dev/null 2>&1; then
    eslint . || EXIT_CODE=1
  fi

  if grep -q '"typecheck"' package.json 2>/dev/null; then
    npm run typecheck || EXIT_CODE=1
  elif command -v tsc >/dev/null 2>&1 && [[ -f "tsconfig.json" ]]; then
    tsc --noEmit || EXIT_CODE=1
  fi
elif command -v deno >/dev/null 2>&1; then
  deno lint || EXIT_CODE=1
elif command -v bun >/dev/null 2>&1; then
  bunx eslint . || EXIT_CODE=1
fi

exit $EXIT_CODE
