#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

echo "=== Bash syntax check ==="
while IFS= read -r f; do
  if bash -n "$f" > /dev/null 2>&1; then
    echo "  ✓ $f"; PASS=$((PASS + 1))
  else
    echo "  ✗ $f"; FAIL=$((FAIL + 1))
  fi
done < <(find . -name '*.sh' -not -path './.git/*' | sort)

echo ""
echo "=== Agent manifest YAML validation ==="
for f in agents/*.yaml; do
  if yq e '.' "$f" > /dev/null 2>&1; then
    echo "  ✓ $f"; PASS=$((PASS + 1))
  else
    echo "  ✗ $f"; FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "=== Platform config validation ==="
for f in platforms/*/platform.yaml; do
  dest=$(yq e '.destination' "$f" 2>/dev/null)
  ms=$(yq e '.marker.start' "$f" 2>/dev/null)
  me=$(yq e '.marker.end' "$f" 2>/dev/null)
  if [[ -n "$dest" && -n "$ms" && -n "$me" ]]; then
    echo "  ✓ $f"; PASS=$((PASS + 1))
  else
    echo "  ✗ $f (missing required fields)"; FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "=== Skill SKILL.md frontmatter check ==="
for f in skills/*/SKILL.md; do
  if grep -q '^name:' "$f" && grep -q '^description:' "$f"; then
    echo "  ✓ $f"; PASS=$((PASS + 1))
  else
    echo "  ✗ $f (missing frontmatter)"; FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "=== Results ==="
echo "  Passed: $PASS"
echo "  Failed: $FAIL"
[[ $FAIL -eq 0 ]] && echo "  All checks passed!" || { echo "  Some checks failed."; exit 1; }
