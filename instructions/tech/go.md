# Go Technical Guidelines

## Project Structure
1. Organize packages by domain responsibility, not by layer (avoid `util/`, `common/`, `helpers/`).
2. Use the standard Go module layout: `cmd/` for binaries, `internal/` for private packages, `pkg/` for shared packages intended for external use.
3. Keep `go.sum` committed; run `go mod tidy` before every PR to remove unused dependencies.
4. Pin dependencies to specific versions in `go.mod`; run `govulncheck` in CI.

## Package & Naming Conventions
5. Package names: lowercase, single word, no underscores or mixedCase; the package name should match what it does, not what it contains.
6. Exported names need no package-name prefix — prefer `http.Client` over `http.HTTPClient`.
7. Interface names: single-method interfaces are named after the method + `er` (e.g., `io.Reader`); multi-method interfaces describe behaviour.
8. Unexported names use `camelCase`; exported names use `PascalCase`.

## Error Handling
9. Always handle errors explicitly — never discard with `_` without a comment.
10. Wrap errors with context using `fmt.Errorf("operation failed: %w", err)` so callers can `errors.Is`/`errors.As`.
11. Define sentinel errors as `var ErrFoo = errors.New("…")` at package level; define error types only when callers need to inspect fields.
12. Return errors as the last return value; never panic for expected failure conditions.

## Interfaces & Dependency Injection
13. Accept interfaces, return concrete types — this makes functions testable without a mocking framework.
14. Define interfaces at the point of use (in the consumer's package), not the producer's.
15. Keep interfaces small: prefer one or two methods; compose large interfaces from smaller ones.

## Context Propagation
16. Every function that does I/O, calls an external service, or spawns a goroutine must accept `context.Context` as its first argument.
17. Never store a `context.Context` in a struct; pass it through the call chain.
18. Respect context cancellation: check `ctx.Err()` in long loops and propagate to downstream calls.

## Concurrency
19. Document goroutine ownership: who creates it, who is responsible for ensuring it exits.
20. Use `sync.WaitGroup`, `errgroup.Group`, or channels for goroutine lifecycle management.
21. Prefer channels for communication; use mutexes only for protecting simple shared state.

## Tooling & CI
22. Format with `gofmt` (enforced); lint with `golangci-lint` using the project's `.golangci.yml`.
23. Write table-driven tests using `t.Run(name, func(t *testing.T) {…})`; name subtests descriptively.
24. Use `testify/assert` and `testify/require` for assertions; `require` stops the test on failure (use for setup), `assert` continues.
25. Generate mocks with `mockery` from interfaces; commit generated files and regenerate in CI.
