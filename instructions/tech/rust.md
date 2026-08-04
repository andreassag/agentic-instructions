# Rust Technical Guidelines

## Workspace & Project Structure
1. Use Cargo workspaces for multi-crate projects; each logical component is its own crate.
2. Organize: `src/lib.rs` for library entry points, `src/main.rs` for binaries, `src/bin/` for multiple binaries.
3. Keep `Cargo.lock` committed for binaries; exclude it (via `.gitignore`) for libraries.
4. Pin dependency versions in `Cargo.toml` with `^` constraints; audit with `cargo audit` in CI.

## Error Handling
5. Use `thiserror` to define domain errors in library crates; use `anyhow` for application-level error propagation.
6. Never use `unwrap()` or `expect()` in library code; in application code, `expect()` is acceptable with a meaningful message.
7. Propagate errors with `?`; avoid `match` on `Result`/`Option` when `?` or combinators suffice.
8. Define a single `Error` enum per crate; avoid ad-hoc `String` errors.

## Ownership & Safety
9. Avoid `unsafe` blocks unless absolutely required; every `unsafe` block must have a comment explaining the invariant being upheld.
10. Prefer borrowing over cloning; document with a `// clone justified: …` comment when cloning is intentional.
11. Use `Arc<Mutex<T>>` for shared mutable state across threads; prefer message-passing (`std::sync::mpsc` or `tokio::sync::mpsc`) over shared state.

## Async
12. Use `tokio` as the async runtime; do not mix runtimes.
13. Annotate async functions and avoid blocking calls inside async context (use `tokio::task::spawn_blocking` for CPU-heavy work).
14. Prefer `tokio::select!` for concurrent futures; document cancellation safety in comments.

## Code Style & Linting
15. Run `cargo fmt` before every commit (enforced in CI with `cargo fmt --check`).
16. Run `cargo clippy -- -D warnings`; zero clippy warnings required to merge.
17. Enable `#![deny(missing_docs)]` for all public library crates.
18. Write doc comments (`///`) for all public items; include at least one `# Examples` section.

## Testing
19. Unit tests live in `#[cfg(test)]` modules in the same file as the code they test.
20. Integration tests live in `tests/`; each file is a separate test binary.
21. Use `proptest` or `quickcheck` for property-based testing of non-trivial logic.
22. Benchmark with `criterion`; store results in CI artifacts for regression tracking.

## Performance
23. Profile before optimizing; use `cargo flamegraph` or `perf` to identify hotspots.
24. Prefer zero-copy types (`&str`, `&[u8]`, `Cow<str>`) at API boundaries.
25. Use `RUSTFLAGS="-C target-cpu=native"` for local benchmarks; document performance assumptions.
