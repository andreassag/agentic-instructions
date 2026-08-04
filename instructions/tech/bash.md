# Bash Technical Guidelines

## Safety & Robustness
1. Begin every script with `#!/usr/bin/env bash` and `set -euo pipefail` on the very next line — no exceptions.
2. Quote all variable expansions: `"$var"`, `"${array[@]}"`. Unquoted expansions cause word-splitting bugs.
3. Use `[[ … ]]` for conditionals (not `[ … ]`); `[[ ]]` avoids word-splitting and supports `=~` regex.
4. Never use `eval`; if dynamic command construction is unavoidable, use arrays: `cmd=("git" "commit" "-m" "$msg"); "${cmd[@]}"`.
5. Check command availability with `command -v tool >/dev/null 2>&1 || { echo "tool not found"; exit 1; }` before use.

## Variable & Scope Discipline
6. Declare all local variables inside functions with `local`; avoid polluting the global namespace.
7. Use `readonly` for constants: `readonly VERSION="1.0.0"`.
8. Prefer `UPPER_CASE` for environment variables and exported names; `lower_case` for local variables.
9. Use `${VAR:-default}` for optional env vars with fallbacks; `${VAR:?error message}` for required ones.

## Functions & Structure
10. Every script longer than 30 lines should define a `main()` function called at the end: `main "$@"`.
11. Keep functions short and single-purpose; a function that doesn't fit on a screen is too long.
12. Print usage/help via a `usage()` function; call it for `-h`/`--help` and on unrecognized flags.
13. Parse flags with a `while [[ $# -gt 0 ]]; do case $1 in … esac; done` loop, not `getopts`, for long-flag support.

## Output & Logging
14. Write error and diagnostic messages to stderr: `echo "ERROR: …" >&2`.
15. Use consistent log prefixes: `[INFO]`, `[WARN]`, `[ERROR]` for parseable output.
16. Use `--dry-run` flags that print commands without executing them; implement via a `run_cmd()` wrapper.
17. Avoid color codes in output unless writing to a terminal (check `[ -t 1 ]`).

## Portability & Compatibility
18. Prefer POSIX tools (`awk`, `sed`, `grep`) over GNU-specific extensions when the script must run on macOS/Alpine.
19. Avoid bashisms in scripts intended to be sourced by `sh`; keep `.sh` (bash) and `.sh` (sh-compatible) scripts clearly separate.
20. Test on at least bash 4.0; macOS ships bash 3.2 — use `brew install bash` or `#!/usr/bin/env bash` with a version guard.

## Error Patterns
21. Capture command output and exit code safely: `output=$(cmd 2>&1); rc=$?`.
22. Cleanup on exit with `trap 'cleanup' EXIT INT TERM`; define `cleanup()` before the trap.
23. Never silently swallow errors with `cmd || true` without a comment explaining why failure is acceptable.
