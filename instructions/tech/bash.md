# Bash Technical Guidelines

## Safety & Script Robustness
1. Begin every script with `#!/usr/bin/env bash` and `set -euo pipefail` on the next line.
2. Quote all variable expansions: `"$var"`, `"${array[@]}"`. Unquoted expansions cause word-splitting bugs.
3. Use `[[ … ]]` for conditionals (not `[ … ]`).
4. Never use `eval`; use bash arrays for dynamic commands: `cmd=("git" "status"); "${cmd[@]}"`.
5. Check tool availability with `command -v <tool> >/dev/null 2>&1` before execution.

## CLI Conventions & Exit Codes
6. Document and adhere to exit code discipline:
   - `0` — Success
   - `1` — General / runtime error
   - `2` — Invalid arguments or flag parsing error
7. Support POSIX flags (`-h`, `--help`, `-v`, `--verbose`, `--dry-run`, `--json`).
8. Write data output to `stdout` and diagnostic logs/errors to `stderr`.
9. Parse CLI arguments using a `while [[ $# -gt 0 ]]; do case $1 in ... esac; done` loop.

## Variables, Traps & Lifecycle
10. Declare all variables inside functions with `local`.
11. Use `readonly` for script constants.
12. Use `trap 'cleanup' EXIT INT TERM` for guaranteed resource cleanup and temporary file deletion.
13. Lint shell scripts with `shellcheck` and format with `shfmt -i 2`.
