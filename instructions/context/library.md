# Library Project Guidelines

## API Stability
1. Follow Semantic Versioning (SemVer): `MAJOR.MINOR.PATCH`. Increment MAJOR for breaking changes, MINOR for backwards-compatible additions, PATCH for bug fixes.
2. Minimize the public API surface: only export what consumers genuinely need; keep internals unexported/private.
3. Mark experimental APIs explicitly (`@experimental`, `#[doc(hidden)]`, or equivalent); they may change without a version bump.
4. Add `@deprecated` annotations (with the version deprecated in and a migration path) before removing any public symbol; keep deprecated symbols for at least one minor release cycle.

## Documentation
5. Every public symbol must have a documentation comment that explains its purpose, parameters, return value, and any exceptions/errors it may raise.
6. Documentation must include at least one working `@example` or `# Examples` block per public function; examples are part of the test suite (doctest / rustdoc / doctests).
7. Maintain a `CHANGELOG.md` in [Keep a Changelog](https://keepachangelog.com) format; update it for every release under `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.
8. Keep the README runnable: the quickstart example must work by copy-pasting it into a fresh environment.

## Design Principles
9. No runtime side effects at import time: importing the library must not perform network calls, write files, modify global state, or start background threads.
10. Accept inputs as the most general type your logic can handle; return the most specific type that is useful — be liberal in what you accept, precise in what you return.
11. Prefer composition over inheritance; use interfaces/protocols/traits to define behaviour contracts.
12. Fail fast and loudly on invalid inputs: raise/return a meaningful error at the API boundary rather than propagating bad state into the library's internals.

## Testing
13. Maintain a test suite covering: happy paths, boundary conditions, invalid inputs, and documented error paths.
14. Use property-based testing (Hypothesis, proptest, QuickCheck) for functions with non-trivial invariants.
15. Run the test suite against all supported runtime/language versions in CI.
16. Measure and track code coverage; no PR should decrease it without justification.

## Release Process
17. Tag releases with annotated git tags (`git tag -a v1.2.3`); never push to a package registry without a corresponding tag.
18. Build and publish from CI only; do not publish from local developer machines.
19. Sign releases (GPG or Sigstore) and publish a checksum file alongside release artifacts.
