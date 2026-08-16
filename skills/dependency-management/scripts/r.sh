#!/usr/bin/env bash
set -euo pipefail

# R Package Dependency Auditor
echo "🔍 Auditing R package dependencies..."

if ! command -v Rscript >/dev/null 2>&1; then
  echo "Error: Rscript command not found in PATH."
  exit 1
fi

Rscript -e "
if (requireNamespace('pak', quietly = TRUE)) {
  pak::pkg_security_check()
} else {
  message('pak package is not installed. Install with: install.packages(\"pak\")')
}
"
