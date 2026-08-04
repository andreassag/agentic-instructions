# CLI Project Guidelines

## Invocation & Flags
1. Follow POSIX flag conventions: single-character flags use `-f`, long flags use `--flag`, boolean flags do not take a value, value flags use `--flag value` or `--flag=value`.
2. Provide both short and long forms for common flags (`-v` / `--verbose`, `-o` / `--output`).
3. Every CLI tool must support `--help` / `-h` (print usage to stdout, exit 0) and `--version` (print version to stdout, exit 0).
4. Implement `--dry-run` for any command that modifies state: print what would happen without doing it.
5. Implement `--verbose` / `--quiet` flags; default output should be informative but not noisy.

## Exit Codes
6. Exit codes must be consistent and documented:
   - `0` — success
   - `1` — general error / usage error
   - `2` — invalid arguments or flag parsing failure
   - `3+` — domain-specific, documented in `--help`
7. Never exit 0 when an error occurred; never exit non-zero when the operation succeeded.

## Output Discipline
8. Write human-readable output to stdout; write error messages and diagnostics to stderr.
9. Support `--json` output for machine-readable results; the JSON schema must be stable (versioned with the tool).
10. Do not use ANSI color codes when stdout is not a terminal (`[ -t 1 ]` check) or when `NO_COLOR` env var is set.
11. Truncate long lines only when writing to a terminal; pipe-safe output should never truncate.

## Configuration Precedence
12. Layer configuration in this order (later overrides earlier): built-in defaults → config file → environment variables → CLI flags.
13. Support a config file in `~/.config/<tool>/config.toml` (or `$XDG_CONFIG_HOME`); document the path in `--help`.
14. Prefix environment variables with the tool name in UPPER_CASE (`MYTOOL_OUTPUT_DIR`, not `OUTPUT_DIR`).

## User Experience
15. On error, print a concise message to stderr with enough context to act on it; avoid stack traces for expected errors.
16. For long-running operations, write a progress indicator to stderr (not stdout); support `--quiet` to suppress it.
17. Prompt for confirmation before destructive operations when running interactively; skip prompts and proceed (or abort) when `--yes` / `--no-interactive` is passed.
18. Provide a `completion` subcommand (or `--completion`) that outputs shell completion scripts for bash, zsh, and fish.
