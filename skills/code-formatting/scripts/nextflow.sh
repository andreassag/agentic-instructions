#!/usr/bin/env bash
set -euo pipefail

# Nextflow Pipeline Formatter
echo "✨ Formatting Nextflow pipelines..."

if command -v prettier >/dev/null 2>&1; then
  prettier --write "*.nf" "workflows/**/*.nf" "modules/**/*.nf" "subworkflows/**/*.nf" "nextflow.config" "$@" 2>/dev/null || true
elif command -v npx >/dev/null 2>&1; then
  npx prettier --write "*.nf" "workflows/**/*.nf" "modules/**/*.nf" "subworkflows/**/*.nf" "nextflow.config" "$@" 2>/dev/null || true
else
  echo "⚠️ Prettier not found in PATH."
fi
