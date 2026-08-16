#!/usr/bin/env bash
# tests/test_syntax.sh — Validate syntax of all shell scripts
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

PASS=0
FAIL=0

echo "=== [1/5] Shell Script Syntax & Lint Validation ==="

while IFS= read -r f; do
  if bash -n "$f" >/dev/null 2>&1; then
    echo "  ✓ syntax: $f"
    PASS=$((PASS + 1))
  else
    echo "  ✗ syntax error in: $f"
    FAIL=$((FAIL + 1))
  fi

  if command -v shellcheck >/dev/null 2>&1; then
    if shellcheck "$f" >/dev/null 2>&1; then
      PASS=$((PASS + 1))
    else
      echo "  ✗ shellcheck warnings in: $f"
      FAIL=$((FAIL + 1))
    fi
  fi
done < <(find . -name '*.sh' -not -path './.git/*' -not -path './.agents/*' -not -path './graphify-out/*' | sort)

echo "  Passed: $PASS, Failed: $FAIL"
[[ $FAIL -eq 0 ]] || exit 1
