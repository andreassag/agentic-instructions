# Rust Technical Guidelines

## Workspace & Project Structure
1. Use Cargo workspaces for multi-crate projects; each logical component is its own crate.
2. Organize: `src/lib.rs` for library entry points, `src/main.rs` for binaries, `src/bin/` for multiple binaries.
3. Keep `Cargo.lock` committed for binaries; exclude it (via `.gitignore`) for pure libraries.
4. Pin dependency versions in `Cargo.toml` with `^` constraints; audit with `cargo audit` in CI.

## Error Handling & Safety
5. Use `thiserror` to define domain errors in library crates; use `anyhow` for application-level error propagation.
6. Never use `unwrap()` or `expect()` in library code; in application code, `expect()` is acceptable with a meaningful message.
7. Propagate errors with `?`; avoid `match` on `Result`/`Option` when `?` or combinators suffice.
8. Avoid `unsafe` blocks unless absolutely required; every `unsafe` block must have a comment explaining the invariant being upheld.
9. Prefer borrowing over cloning; document with a `// clone justified: …` comment when cloning is intentional.

## Async & Service Patterns
10. Use `tokio` as the async runtime; do not mix runtimes.
11. Annotate async functions and avoid blocking calls inside async context (use `tokio::task::spawn_blocking` for CPU-heavy work).
12. Use `tracing` and `tracing-subscriber` for structured logging; emit JSON in production.
13. Implement graceful shutdown on `tokio::signal::ctrl_c()` to flush buffers and close connections.

## CLI & Library Ergonomics
14. Use `clap` (derive API) for command-line parsing; support POSIX flags (`-v`, `--help`, `--version`).
15. Write human-readable data to `stdout`, diagnostic logs to `stderr`, and support `--json` output.
16. Return `anyhow::Result<()>` or `std::process::ExitCode` from `main()` to map exit codes cleanly.
17. Enable `#![deny(missing_docs)]` for public library crates; include runnable `# Examples` in doc comments (`///`).

## Code Style, Testing & Performance
18. Run `cargo fmt --all` before every commit (enforced in CI with `cargo fmt --check`).
19. Run `cargo clippy --all-targets -- -D warnings`; zero clippy warnings required to merge.
20. Unit tests live in `#[cfg(test)]` modules; integration tests live in `tests/`.
21. Prefer zero-copy types (`&str`, `&[u8]`, `Cow<str>`) at API boundaries.
