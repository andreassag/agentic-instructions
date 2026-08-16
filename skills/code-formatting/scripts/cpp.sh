#!/usr/bin/env bash
set -euo pipefail

# C / C++ Formatter (clang-format)
echo "✨ Formatting C/C++ codebase with clang-format..."

if ! command -v clang-format >/dev/null 2>&1; then
  echo "⚠️ clang-format is not installed."
  exit 0
fi

find . \( -name "*.cpp" -o -name "*.hpp" -o -name "*.c" -o -name "*.h" -o -name "*.cc" \) -not -path "*/build/*" -not -path "*/.git/*" -exec clang-format -i {} +
