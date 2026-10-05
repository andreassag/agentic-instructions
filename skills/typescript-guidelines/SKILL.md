---
name: typescript-guidelines
description: TypeScript technical guidelines, strict typing, Zod validation, and REST services.
when_to_use: "When working with files matching: *.ts,**/*.ts,*.tsx,**/*.tsx,*.js,**/*.js,package.json,tsconfig.json"
trigger: glob
globs: "*.ts,**/*.ts,*.tsx,**/*.tsx,*.js,**/*.js,package.json,tsconfig.json"
version: 1.0.0
---

# TypeScript Technical Guidelines

## Compiler Configuration & Types
1. Always use `strict: true` in `tsconfig.json`; enable `noUncheckedIndexedAccess` and `exactOptionalPropertyTypes`.
2. Avoid `any`; use `unknown` and narrow types explicitly before access.
3. Model domain errors as discriminated unions (`{ kind: "NotFound" } | { kind: "Unauthorized" }`), not thrown raw strings.
4. Use `zod` for runtime boundary validation (HTTP bodies, environment variables, config files); infer types with `z.infer<>`.

## Web Services & REST APIs
5. Use standard HTTP status codes (`200`, `201`, `204`, `400`, `401`, `403`, `404`, `422`, `500`).
6. Return structured error envelopes on failures:
    ```json
    { "error": { "code": "VALIDATION_ERROR", "message": "...", "details": [] } }
    ```
7. Handle `SIGTERM`/`SIGINT` signals for graceful process shutdown and connection draining.

## Module & Library Discipline
8. Prefer named exports over default exports for IDE refactoring safety.
9. Each feature folder should expose its public surface via an explicit `index.ts`.
10. Ensure zero side-effects at import time (no immediate network calls or global state mutations).
11. Follow Semantic Versioning (SemVer) for public libraries and package releases.

## Code Style & Testing
12. Format with `prettier` (or `biome format`); lint with `eslint` (or `biome check`).
13. Prefer `async/await` over `.then()`/`.catch()` promise chains.
14. Test with `vitest` (or `jest`); co-locate test files as `*.test.ts`.
15. Use `@testing-library` for UI component testing.
