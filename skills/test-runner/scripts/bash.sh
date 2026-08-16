#!/usr/bin/env bash
set -euo pipefail

# Bash Script Test Runner
echo "🧪 Running Bash test suite & syntax checks..."

if command -v bats >/dev/null 2>&1 && [[ -d "test" || -d "tests" ]]; then
  echo "Running bats tests..."
  bats test*/*.bats "$@"
else
  echo "Running bash -n syntax checks on all shell scripts..."
  FAILURES=0
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    if ! bash -n "$f"; then
      FAILURES=$((FAILURES + 1))
    fi
  done < <(find . -name "*.sh" -not -path "*/.git/*" -not -path "*/node_modules/*")
  
  if [[ $FAILURES -gt 0 ]]; then
    echo "❌ $FAILURES shell script(s) failed syntax validation."
    exit 1
  else
    echo "✓ All shell scripts passed syntax checks."
  fi
fi
