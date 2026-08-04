# TypeScript Technical Guidelines

## Compiler Configuration
1. Always use `strict: true` in `tsconfig.json`; additionally enable `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, and `noImplicitReturns`.
2. Target `ESNext` for Node.js apps and the project's minimum supported browser for web apps; set `moduleResolution: "Bundler"` for bundled projects, `"NodeNext"` for Node.
3. Never disable strict checks with `// @ts-ignore` or `// @ts-nocheck` without a documented justification comment.

## Type Design
4. Avoid `any`; use `unknown` as the safe alternative when the type is truly unknown, and narrow it before use.
5. Prefer `type` aliases for unions and intersections; use `interface` for object shapes that may be extended.
6. Use `satisfies` for type-checking literals without widening; use `as const` for immutable data.
7. Use Zod (or Valibot) for runtime validation of external data (API responses, env vars, user input); derive TypeScript types from schemas with `z.infer<>`.
8. Model domain errors as discriminated unions (`{ kind: "NotFound" } | { kind: "Unauthorized" }`), not thrown strings.

## Module Discipline
9. Prefer named exports over default exports; default exports hinder refactoring and IDE rename.
10. Keep module boundaries explicit: each feature has an `index.ts` that re-exports its public API.
11. Use ESM (`"type": "module"` in `package.json`) for new projects; avoid CommonJS in new code.
12. Never use barrel re-exports that create circular dependency risks; validate with `dependency-cruiser`.

## Code Style
13. Format with `prettier`; lint with `eslint` using `typescript-eslint` recommended rules.
14. Prefer `async/await` over `.then()`/`.catch()` chains.
15. Use `const` by default; `let` only when reassignment is required; never `var`.
16. Destructure objects and arrays at the point of use rather than accessing properties repeatedly.

## Testing
17. Test with `vitest` (preferred) or `jest`; keep test files co-located as `*.test.ts`.
18. Mock at the module level using `vi.mock()` / `jest.mock()`; avoid monkey-patching.
19. Use `@testing-library` for UI component tests; avoid testing implementation details.
20. Enforce type coverage in tests — tests should not require excessive casting to pass.

## Node.js Specifics
21. Use `process.env` access only through a validated config module (e.g., `env.ts` with Zod).
22. Prefer the `node:` protocol prefix for built-in modules (`import fs from "node:fs/promises"`).
23. Manage Node.js versions with `.nvmrc` or `.tool-versions`; CI must use the exact pinned version.
