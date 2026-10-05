#!/usr/bin/env bash
# tests/test_schemas.sh — Validate profile manifests, agents, skills, and platform configs
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

PASS=0
FAIL=0

echo "=== [2/5] Schemas & Manifest Validation ==="

# 1. Profile Manifests — must use unified 'skills' array (no 'instructions' or 'tools')
echo "  -- Checking Profiles --"
for f in profiles/*.yaml; do
  [[ -f "$f" ]] || continue
  name=$(yq e '.name // ""' "$f" 2>/dev/null)
  version=$(yq e '.version // ""' "$f" 2>/dev/null)
  desc=$(yq e '.description // ""' "$f" 2>/dev/null)
  skills=$(yq e '.skills // ""' "$f" 2>/dev/null)
  old_instructions=$(yq e '.instructions // ""' "$f" 2>/dev/null)
  old_tools=$(yq e '.tools // ""' "$f" 2>/dev/null)

  ok=1
  if [[ -z "$name" || -z "$version" || -z "$desc" || -z "$skills" || "$skills" == "null" ]]; then
    echo "  ✗ profile invalid (missing required fields): $f"
    ok=0
  fi
  if [[ -n "$old_instructions" && "$old_instructions" != "null" && "$old_instructions" != '""' ]]; then
    echo "  ✗ profile has deprecated 'instructions' key: $f"
    ok=0
  fi
  if [[ -n "$old_tools" && "$old_tools" != "null" && "$old_tools" != '""' ]]; then
    echo "  ✗ profile has deprecated 'tools' key: $f"
    ok=0
  fi

  if [[ $ok -eq 1 ]]; then
    echo "  ✓ profile: $f"
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
  fi
done

# 2. Tech-Guideline Skills (new: skills/*-guidelines/SKILL.md)
echo "  -- Checking Tech-Guideline Skills --"
for lang in go python typescript rust bash docker cpp r nextflow powershell; do
  f="skills/${lang}-guidelines/SKILL.md"
  if [[ -f "$f" ]] && grep -q "^name:" "$f" && grep -q "^description:" "$f"; then
    echo "  ✓ tech-guideline skill: $f"
    PASS=$((PASS + 1))
  else
    echo "  ✗ tech-guideline skill missing or invalid: $f"
    FAIL=$((FAIL + 1))
  fi
done

# 3. Tool Skills (new: skills/rtk, skills/qmd, skills/graphify)
echo "  -- Checking Tool Skills --"
for tool in rtk qmd graphify; do
  f="skills/${tool}/SKILL.md"
  if [[ -f "$f" ]] && grep -q "^name:" "$f" && grep -q "^description:" "$f"; then
    echo "  ✓ tool skill: $f"
    PASS=$((PASS + 1))
  else
    echo "  ✗ tool skill missing or invalid: $f"
    FAIL=$((FAIL + 1))
  fi
done

# 4. Agent Roles
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

# 5. Skills Frontmatter (all skills)
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

# 6. Platform Configs (all 4 platforms now)
echo "  -- Checking Platform Configs --"
for f in platforms/*/platform.yaml; do
  [[ -f "$f" ]] || continue
  platform=$(yq e '.platform // ""' "$f" 2>/dev/null)
  if [[ -n "$platform" && "$platform" != "null" ]]; then
    echo "  ✓ platform: $f ($platform)"
    PASS=$((PASS + 1))
  else
    echo "  ✗ platform config invalid: $f"
    FAIL=$((FAIL + 1))
  fi
done

# 7. Verify deleted directories are gone
echo "  -- Checking Deleted Directories --"
if [[ -d "workflows" ]]; then
  echo "  ✗ workflows/ directory still exists (should be deleted)"
  FAIL=$((FAIL + 1))
else
  echo "  ✓ workflows/ correctly removed"
  PASS=$((PASS + 1))
fi
if [[ -d "instructions" ]]; then
  echo "  ✗ instructions/ directory still exists (should be deleted)"
  FAIL=$((FAIL + 1))
else
  echo "  ✓ instructions/ correctly removed"
  PASS=$((PASS + 1))
fi

echo "  Passed: $PASS, Failed: $FAIL"
[[ $FAIL -eq 0 ]] || exit 1
