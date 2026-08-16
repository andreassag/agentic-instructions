#!/usr/bin/env bash
set -euo pipefail

# Bash Script Formatter (shfmt)
echo "✨ Formatting shell scripts..."

if command -v shfmt >/dev/null 2>&1; then
  echo "==> Running shfmt with 2-space indentation..."
  shfmt -w -i 2 -s $(find . -name "*.sh" -not -path "*/.git/*" -not -path "*/node_modules/*")
else
  echo "⚠️ shfmt not installed. Install with: brew/apt/go install mvdan.cc/sh/v3/cmd/shfmt@latest"
fi
