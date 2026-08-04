# C / C++ Technical Guidelines

## Language Standard
1. Default to C++20; use C++17 only when the target compiler mandates it — document the constraint in `CMakeLists.txt`.
2. Enable at least `-Wall -Wextra -Wpedantic` in all build targets; treat warnings as errors in CI (`-Werror`).
3. Use `#pragma once` as the include guard; avoid traditional `#ifndef` guards for new files.

## Build System
4. Use CMake (3.20+) as the build system; define targets with `add_library` / `add_executable` and use target-scoped properties (`target_include_directories`, `target_compile_options`).
5. Manage dependencies with `vcpkg` (manifest mode, `vcpkg.json`) or `FetchContent`; never commit vendored source trees.
6. Provide `Debug`, `Release`, and `RelWithDebInfo` build configurations; CI runs tests in `Debug` and benchmarks in `Release`.
7. Use `cmake --preset` with `CMakePresets.json` to standardize configure/build invocations across developer machines.

## Memory & Resource Safety
8. Prohibit raw `new`/`delete`; use `std::unique_ptr`, `std::shared_ptr`, or stack allocation.
9. Apply RAII for every resource: files, sockets, mutexes, GPU handles. Destructors must release resources unconditionally.
10. Every `unsafe` operation (raw pointer arithmetic, `reinterpret_cast`, `std::bit_cast`) requires a comment explaining the safety invariant.
11. Enable Address Sanitizer (`-fsanitize=address`) and Undefined Behavior Sanitizer (`-fsanitize=undefined`) in Debug builds.

## Code Style
12. Format with `clang-format` using the project's `.clang-format` file; enforced in CI with `--dry-run --Werror`.
13. Lint with `clang-tidy`; the project's `.clang-tidy` defines enabled checks; zero warnings required.
14. Naming: `PascalCase` for types/classes, `snake_case` for variables and functions, `kPascalCase` for compile-time constants, `UPPER_CASE` for macros (avoid macros for anything expressible as `constexpr`).
15. Prefer `constexpr` and `const` over `#define` for constants; prefer `inline` functions over function-like macros.

## Modern C++ Idioms
16. Prefer `std::span`, `std::string_view`, `std::ranges` over raw pointer + length pairs.
17. Use structured bindings, `if constexpr`, fold expressions, and concepts (C++20) where they improve clarity.
18. Prefer `[[nodiscard]]` on functions whose return values must not be ignored (e.g., error codes, resource handles).
19. Avoid exceptions in performance-critical or embedded contexts; use `std::expected` (C++23) or error-code returns.

## Testing
20. Test with GoogleTest (preferred) or Catch2; integration tests link against a `test` CMake target.
21. Name test suites and cases descriptively; each test verifies exactly one behaviour.
22. Mock with GoogleMock; keep mock headers in `tests/mocks/`.
23. Measure coverage with `lcov`/`gcov` (GCC) or `llvm-cov` (Clang); enforce a minimum threshold in CI.
