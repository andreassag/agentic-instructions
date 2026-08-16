#!/usr/bin/env bash
set -euo pipefail

# R Formatter (styler)
echo "✨ Formatting R codebase with styler..."

if ! command -v Rscript >/dev/null 2>&1; then
  echo "Error: Rscript command not found in PATH."
  exit 1
fi

Rscript -e "
if (requireNamespace('styler', quietly = TRUE)) {
  styler::style_dir()
} else {
  message('styler package is not installed. Install with: install.packages(\"styler\")')
}
"
