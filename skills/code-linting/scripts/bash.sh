#!/usr/bin/env bash
set -euo pipefail

# Bash / Shell Script Linter (shellcheck)
echo "🔍 Linting shell scripts..."

if ! command -v shellcheck >/dev/null 2>&1; then
  echo "⚠️ shellcheck is not installed. Install with: brew/apt install shellcheck"
  exit 0
fi

FAILURES=0
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  if ! shellcheck "$f"; then
    FAILURES=$((FAILURES + 1))
  fi
done < <(find . -name "*.sh" -not -path "*/.git/*" -not -path "*/node_modules/*")

if [[ $FAILURES -gt 0 ]]; then
  echo "❌ shellcheck reported issues in $FAILURES file(s)."
  exit 1
else
  echo "✓ All shell scripts passed shellcheck."
  exit 0
fi
