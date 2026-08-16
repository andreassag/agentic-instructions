#!/usr/bin/env bash
set -euo pipefail

# TypeScript / JavaScript Dependency Auditor (npm / pnpm / yarn audit)
echo "🔍 Auditing Node.js / TypeScript dependencies for vulnerabilities..."

if [[ -f "pnpm-lock.yaml" ]] && command -v pnpm >/dev/null 2>&1; then
  echo "==> Running pnpm audit..."
  pnpm audit --audit-level high "$@"
elif [[ -f "yarn.lock" ]] && command -v yarn >/dev/null 2>&1; then
  echo "==> Running yarn audit..."
  yarn audit --level high "$@" || true
elif command -v npm >/dev/null 2>&1; then
  echo "==> Running npm audit..."
  npm audit --audit-level=high "$@"
elif command -v bun >/dev/null 2>&1; then
  echo "==> Running bun audit..."
  bun pm audit "$@" 2>/dev/null || true
else
  echo "Error: Neither npm, pnpm, yarn nor bun found in PATH."
  exit 1
fi
