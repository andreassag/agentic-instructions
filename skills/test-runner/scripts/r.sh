#!/usr/bin/env bash
set -euo pipefail

# R Package Test & Coverage Runner
echo "🧪 Running R test suite & coverage..."

if ! command -v Rscript >/dev/null 2>&1; then
  echo "Error: Rscript command not found in PATH."
  exit 1
fi

Rscript -e "
if (requireNamespace('devtools', quietly = TRUE)) {
  devtools::test()
} else if (requireNamespace('testthat', quietly = TRUE)) {
  testthat::test_dir('tests')
} else {
  message('Neither devtools nor testthat is available.')
}
" "$@"
