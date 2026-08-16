#!/usr/bin/env bash
set -euo pipefail

# Bash Script Formatter (shfmt)
echo "✨ Formatting shell scripts..."

if command -v shfmt >/dev/null 2>&1; then
  find . -name "*.sh" -not -path "*/.git/*" -not -path "*/node_modules/*" -exec shfmt -w -i 2 -s {} +
else
  echo "⚠️ shfmt not installed. Install with: brew/apt/go install mvdan.cc/sh/v3/cmd/shfmt@latest"
fi
