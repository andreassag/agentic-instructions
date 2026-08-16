#!/usr/bin/env bash
set -euo pipefail

# TypeScript / JavaScript Formatter (Prettier / Biome)
echo "✨ Formatting TypeScript / JavaScript codebase..."

if command -v biome >/dev/null 2>&1; then
  biome format --write . "$@"
elif [[ -f "package.json" ]] && grep -q '"format"' package.json 2>/dev/null; then
  npm run format -- "$@"
elif command -v prettier >/dev/null 2>&1; then
  prettier --write "**/*.{ts,tsx,js,jsx,json,css,md}" "$@"
elif command -v npx >/dev/null 2>&1; then
  npx prettier --write "**/*.{ts,tsx,js,jsx,json,css,md}" "$@"
elif command -v deno >/dev/null 2>&1; then
  deno fmt "$@"
fi
