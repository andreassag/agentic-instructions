#!/usr/bin/env bash
set -euo pipefail

# R Package Linter (lintr)
echo "🔍 Linting R codebase with lintr..."

if ! command -v Rscript >/dev/null 2>&1; then
  echo "Error: Rscript command not found in PATH."
  exit 1
fi

Rscript -e "
if (requireNamespace('lintr', quietly = TRUE)) {
  lints <- lintr::lint_dir()
  if (length(lints) > 0) {
    print(lints)
    quit(status = 1)
  } else {
    message('No lintr issues found.')
  }
} else {
  message('lintr package is not installed. Install with: install.packages(\"lintr\")')
}
"
