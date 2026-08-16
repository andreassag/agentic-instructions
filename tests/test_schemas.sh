#!/usr/bin/env bash
# tests/test_schemas.sh — Validate profile manifests, companion rules, agents, workflows, and skills
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

PASS=0
FAIL=0

echo "=== [2/5] Schemas & Manifest Validation ==="

# 1. Profile Manifests
echo "  -- Checking Profiles --"
for f in profiles/*.yaml; do
  [[ -f "$f" ]] || continue
  name=$(yq e '.name // ""' "$f" 2>/dev/null)
  version=$(yq e '.version // ""' "$f" 2>/dev/null)
  desc=$(yq e '.description // ""' "$f" 2>/dev/null)
  ins=$(yq e '.instructions // ""' "$f" 2>/dev/null)

  if [[ -n "$name" && -n "$version" && -n "$desc" && -n "$ins" && "$ins" != "null" ]]; then
    echo "  ✓ profile: $f"
    PASS=$((PASS + 1))
  else
    echo "  ✗ profile invalid: $f"
    FAIL=$((FAIL + 1))
  fi
done

# 2. Companion Rules YAML
echo "  -- Checking Instruction Rules Metadata --"
for f in instructions/tech/*.yaml instructions/tools/*.yaml; do
  [[ -f "$f" ]] || continue
  desc=$(yq e '.antigravity.description // ""' "$f" 2>/dev/null)
  trig=$(yq e '.antigravity.trigger // ""' "$f" 2>/dev/null)
  glob=$(yq e '.antigravity.glob // ""' "$f" 2>/dev/null)

  if [[ -n "$desc" && -n "$trig" ]]; then
    if [[ "$trig" == "glob" && -z "$glob" ]]; then
      echo "  ✗ rule companion: $f (trigger is glob but glob missing)"
      FAIL=$((FAIL + 1))
    else
      echo "  ✓ rule companion: $f ($trig)"
      PASS=$((PASS + 1))
    fi
  else
    echo "  ✗ rule companion missing fields: $f"
    FAIL=$((FAIL + 1))
  fi
done

# 3. Agent Roles
echo "  -- Checking Agent Roles --"
for f in agents/*.md; do
  [[ -f "$f" ]] || continue
  if [[ -s "$f" ]] && grep -q '^name:' "$f" && grep -q '^description:' "$f"; then
    echo "  ✓ agent: $f"
    PASS=$((PASS + 1))
  else
    echo "  ✗ agent frontmatter missing: $f"
    FAIL=$((FAIL + 1))
  fi
done

# 4. Workflows
echo "  -- Checking Workflows --"
for f in workflows/*.md; do
  [[ -f "$f" ]] || continue
  if [[ -s "$f" ]] && grep -q '^name:' "$f" && grep -q '^description:' "$f"; then
    echo "  ✓ workflow: $f"
    PASS=$((PASS + 1))
  else
    echo "  ✗ workflow frontmatter missing: $f"
    FAIL=$((FAIL + 1))
  fi
done

# 5. Skills Frontmatter
echo "  -- Checking Skill Metadata --"
for f in skills/*/SKILL.md; do
  [[ -f "$f" ]] || continue
  if grep -q '^name:' "$f" && grep -q '^description:' "$f"; then
    echo "  ✓ skill: $f"
    PASS=$((PASS + 1))
  else
    echo "  ✗ skill frontmatter missing: $f"
    FAIL=$((FAIL + 1))
  fi
done

# 6. Platform Configs
echo "  -- Checking Platform Configs --"
for f in platforms/*/platform.yaml; do
  [[ -f "$f" ]] || continue
  dest=$(yq e '.destination // ""' "$f" 2>/dev/null)
  if [[ -n "$dest" && "$dest" != "null" ]]; then
    echo "  ✓ platform: $f"
    PASS=$((PASS + 1))
  else
    echo "  ✗ platform config invalid: $f"
    FAIL=$((FAIL + 1))
  fi
done

echo "  Passed: $PASS, Failed: $FAIL"
[[ $FAIL -eq 0 ]] || exit 1
