#!/usr/bin/env bash
set -euo pipefail

# C / C++ Linter (clang-tidy & cppcheck)
echo "🔍 Linting C/C++ codebase..."

EXIT_CODE=0

if command -v clang-tidy >/dev/null 2>&1 && [[ -f "build/compile_commands.json" ]]; then
  echo "==> Running clang-tidy with compile_commands.json..."
  find . -name "*.cpp" -not -path "./build/*" -exec clang-tidy -p build {} + || EXIT_CODE=1
elif command -v cppcheck >/dev/null 2>&1; then
  echo "==> Running cppcheck..."
  cppcheck --enable=all --suppress=missingIncludeSystem . || EXIT_CODE=1
else
  echo "⚠️ Neither clang-tidy (with build/compile_commands.json) nor cppcheck found."
fi

exit $EXIT_CODE
