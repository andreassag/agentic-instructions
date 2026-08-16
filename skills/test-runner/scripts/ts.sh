#!/usr/bin/env bash
set -euo pipefail

# TypeScript / JavaScript Test & Coverage Runner
echo "🧪 Running TypeScript / JavaScript test suite..."

if [[ -f "package.json" ]]; then
  if grep -q '"test:coverage"' package.json 2>/dev/null; then
    npm run test:coverage "$@"
  elif grep -q '"coverage"' package.json 2>/dev/null; then
    npm run coverage "$@"
  elif grep -q '"vitest"' package.json 2>/dev/null; then
    npx vitest run --coverage "$@"
  elif grep -q '"jest"' package.json 2>/dev/null; then
    npx jest --coverage "$@"
  elif grep -q '"test"' package.json 2>/dev/null; then
    npm test -- "$@"
  else
    echo "No test script found in package.json."
    exit 1
  fi
elif command -v bun >/dev/null 2>&1; then
  bun test --coverage "$@"
elif command -v deno >/dev/null 2>&1; then
  deno test --coverage "$@"
else
  echo "Error: No Node/Bun/Deno package.json found in current directory."
  exit 1
fi
