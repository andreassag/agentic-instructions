#!/usr/bin/env bash
set -euo pipefail

# Nextflow / nf-core Pipeline Linter
echo "🔍 Linting Nextflow pipeline..."

EXIT_CODE=0

if command -v nf-core >/dev/null 2>&1; then
  echo "==> Running nf-core pipelines lint..."
  nf-core pipelines lint . || EXIT_CODE=1
fi

if command -v nextflow >/dev/null 2>&1; then
  echo "==> Validating nextflow config..."
  nextflow config . >/dev/null || EXIT_CODE=1
fi

exit $EXIT_CODE
