#!/usr/bin/env bash
# tests/run_all.sh — Master test harness for agentic-instructions
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HUB_HOME="$SCRIPT_DIR"
cd "$SCRIPT_DIR"

START_TIME=$(date +%s)

echo "======================================================"
echo "    Agentic Instructions Test & CI Suite"
echo "======================================================"
echo ""

FAILURES=0

run_suite() {
  local suite_name=$1
  local script_path=$2

  echo "Running: $suite_name ($script_path)"
  if bash "$script_path"; then
    echo ">> $suite_name PASSED"
  else
    echo ">> $suite_name FAILED"
    FAILURES=$((FAILURES + 1))
  fi
  echo ""
}

run_suite "Syntax & ShellCheck" "tests/test_syntax.sh"
run_suite "Schemas & Manifests" "tests/test_schemas.sh"
run_suite "CLI Lifecycle & Profiles" "tests/test_cli_lifecycle.sh"
run_suite "Skills Executability" "tests/test_skills.sh"
run_suite "Artifacts Cleanup & Gitignore" "tests/test_cleanup.sh"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo "======================================================"
if [[ $FAILURES -eq 0 ]]; then
  echo "  ALL TEST SUITES PASSED! (${ELAPSED}s)"
  echo "======================================================"
  exit 0
else
  echo "  $FAILURES TEST SUITE(S) FAILED! (${ELAPSED}s)"
  echo "======================================================"
  exit 1
fi
