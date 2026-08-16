#!/usr/bin/env bash
# tests/test_cleanup.sh — Validate complete artifact cleanup and .gitignore immutability
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HUB_HOME="$SCRIPT_DIR"

PASS=0
FAIL=0

echo "=== [5/5] Artifact Cleanup & Gitignore Immutability Tests ==="

TMP_CLEAN_DIR=$(mktemp -d /tmp/hub-test-cleanup-XXXXXX)
cleanup() {
  rm -rf "$TMP_CLEAN_DIR"
}
trap cleanup EXIT INT TERM

cd "$TMP_CLEAN_DIR"
git init -q

# 1. Create initial .gitignore
echo "# Custom gitignore" > .gitignore
echo "build/" >> .gitignore
initial_gitignore=$(cat .gitignore)

# 2. Init profile
"$HUB_HOME/hub.sh" init --profile backend-go >/dev/null 2>&1

# Verify .gitignore was NOT modified
current_gitignore=$(cat .gitignore)
if [[ "$initial_gitignore" == "$current_gitignore" ]]; then
  echo "  ✓ .gitignore was NOT modified by hub init"
  PASS=$((PASS + 1))
else
  echo "  ✗ .gitignore was modified by hub init"
  FAIL=$((FAIL + 1))
fi

# 3. Simulate tool artifacts
mkdir -p graphify-out .qmd .cache/qmd
touch graphify-out/graph.json .qmd/index.sqlite .cache/qmd/cache.bin

# 4. Run hub clean
"$HUB_HOME/hub.sh" clean >/dev/null 2>&1

# 5. Verify cleanup
if [[ ! -d ".agents" ]]; then
  echo "  ✓ .agents/ removed"
  PASS=$((PASS + 1))
else
  echo "  ✗ .agents/ still exists"
  FAIL=$((FAIL + 1))
fi

if [[ ! -d "graphify-out" ]]; then
  echo "  ✓ graphify-out/ removed"
  PASS=$((PASS + 1))
else
  echo "  ✗ graphify-out/ still exists"
  FAIL=$((FAIL + 1))
fi

if [[ ! -d ".qmd" && ! -d ".cache/qmd" ]]; then
  echo "  ✓ .qmd/ and .cache/qmd/ removed"
  PASS=$((PASS + 1))
else
  echo "  ✗ .qmd/ or .cache/qmd/ still exists"
  FAIL=$((FAIL + 1))
fi

echo "  Passed: $PASS, Failed: $FAIL"
[[ $FAIL -eq 0 ]] || exit 1
