#!/usr/bin/env bash
set -euo pipefail

# C / C++ Test Runner
echo "🧪 Running C/C++ test suite..."

if command -v ctest >/dev/null 2>&1 && [[ -d "build" ]]; then
  echo "Running ctest in build directory..."
  ctest --test-dir build --output-on-failure "$@"
elif [[ -d "build" ]]; then
  for test_bin in build/*test* build/bin/*test*; do
    if [[ -x "$test_bin" && ! -d "$test_bin" ]]; then
      echo "Running $test_bin..."
      "$test_bin" "$@"
    fi
  done
else
  echo "No CMake build directory found. Please build the project before running tests."
  exit 1
fi
