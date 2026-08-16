#!/usr/bin/env bash
set -euo pipefail

# Nextflow Pipeline Test Runner
echo "🧪 Running Nextflow pipeline tests..."

if command -v nf-test >/dev/null 2>&1; then
  echo "Running nf-test..."
  nf-test test "$@"
elif command -v nextflow >/dev/null 2>&1; then
  echo "Running nextflow smoke test with test profile..."
  nextflow run . -profile test,docker -stub "$@"
else
  echo "Error: Neither nf-test nor nextflow found in PATH."
  exit 1
fi
