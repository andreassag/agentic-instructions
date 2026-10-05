#!/usr/bin/env bash
# tests/test_cli_lifecycle.sh — Test hub CLI init, load, update, and status lifecycles
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HUB_HOME="$SCRIPT_DIR"
export PATH="$SCRIPT_DIR:$PATH"

PASS=0
FAIL=0

echo "=== [3/5] CLI Lifecycle & Profile Deployment Tests ==="

TMP_TEST_DIR=$(mktemp -d /tmp/hub-test-lifecycle-XXXXXX)
cleanup() {
  rm -rf "$TMP_TEST_DIR"
}
trap cleanup EXIT INT TERM

cd "$TMP_TEST_DIR"
git init -q

# Test profiles
PROFILES=("backend-go-engineer" "full-stack-ts" "systems-rust" "bioinformatics-nextflow" "python-data-scientist" "python-biocomputation-scientist" "r-biostatistician" "powershell" "full-stack-golang-engineer" "full-stack-python-engineer")

for profile in "${PROFILES[@]}"; do
  echo "  -- Testing Profile: $profile --"

  # 1. hub init
  if "$HUB_HOME/hub.sh" init --profile "$profile" >/dev/null 2>&1; then
    echo "  ✓ hub init --profile $profile succeeded"
    PASS=$((PASS + 1))
  else
    echo "  ✗ hub init --profile $profile failed"
    FAIL=$((FAIL + 1))
    continue
  fi

  # 2. Check structure — workflows/ no longer exists as of v1.1
  if [[ -d ".agents/rules" && -d ".agents/agents" && -d ".agents/skills" && -f ".agents/state.json" ]]; then
    echo "  ✓ .agents structure valid for $profile"
    PASS=$((PASS + 1))
  else
    echo "  ✗ .agents structure missing directories for $profile"
    FAIL=$((FAIL + 1))
  fi

  # 3. Check status
  status_out=$("$HUB_HOME/hub.sh" status 2>&1 || true)
  if [[ "$status_out" == *"$profile"* ]]; then
    echo "  ✓ hub status reports profile $profile"
    PASS=$((PASS + 1))
  else
    echo "  ✗ hub status output invalid for $profile"
    echo "    Output was: $status_out"
    FAIL=$((FAIL + 1))
  fi

  # 4. Check status --json
  if "$HUB_HOME/hub.sh" status --json | jq -e '.profile' >/dev/null 2>&1; then
    echo "  ✓ hub status --json valid JSON"
    PASS=$((PASS + 1))
  else
    echo "  ✗ hub status --json failed"
    FAIL=$((FAIL + 1))
  fi

  # 5. Check update idempotency
  if "$HUB_HOME/hub.sh" update >/dev/null 2>&1; then
    echo "  ✓ hub update succeeded"
    PASS=$((PASS + 1))
  else
    echo "  ✗ hub update failed"
    FAIL=$((FAIL + 1))
  fi
done

# Test switching profiles with hub load
echo "  -- Testing Profile Switching (hub load) --"
load_output=$("$HUB_HOME/hub.sh" load full-stack-ts 2>&1 || true)
status_output=$("$HUB_HOME/hub.sh" status 2>&1 || true)

if [[ "$status_output" == *"full-stack-ts"* ]]; then
  echo "  ✓ hub load switched profile to full-stack-ts"
  PASS=$((PASS + 1))
else
  echo "  ✗ hub load failed to switch profile state"
  echo "    load output: $load_output"
  echo "    status output: $status_output"
  FAIL=$((FAIL + 1))
fi

# Test install.sh options
echo "  -- Testing install.sh Options --"
if "$HUB_HOME/install.sh" --help | grep -q -- "--version"; then
  echo "  ✓ install.sh --help documents --version flag"
  PASS=$((PASS + 1))
else
  echo "  ✗ install.sh --help missing --version flag"
  FAIL=$((FAIL + 1))
fi

if "$HUB_HOME/install.sh" --dry-run --version v1.0.0 >/dev/null 2>&1; then
  echo "  ✓ install.sh --dry-run --version succeeded"
  PASS=$((PASS + 1))
else
  echo "  ✗ install.sh --dry-run --version failed"
  FAIL=$((FAIL + 1))
fi

echo "  Passed: $PASS, Failed: $FAIL"
[[ $FAIL -eq 0 ]] || exit 1
