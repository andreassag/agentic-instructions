#!/usr/bin/env bash
# tests/test_skills.sh — Validate skill script executability and permissions
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

PASS=0
FAIL=0

echo "=== [4/5] Skills Script Permissions & Execution Tests ==="

while IFS= read -r skill_script; do
  [[ -f "$skill_script" ]] || continue

  # Ensure executable bit
  if [[ -x "$skill_script" ]]; then
    echo "  ✓ executable: $skill_script"
    PASS=$((PASS + 1))
  else
    echo "  ✗ not executable: $skill_script (adding executable permission)"
    chmod +x "$skill_script" || FAIL=$((FAIL + 1))
    PASS=$((PASS + 1))
  fi
done < <(find skills -type f \( -name '*.sh' -o -name '*.py' \) | sort)

echo "  Passed: $PASS, Failed: $FAIL"
[[ $FAIL -eq 0 ]] || exit 1
