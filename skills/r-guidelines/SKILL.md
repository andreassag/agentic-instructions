---
name: r-guidelines
description: R technical guidelines, tidyverse idioms, renv management, and testthat testing.
when_to_use: "When working with files matching: *.R,**/*.R,*.r,**/*.r,DESCRIPTION,renv.lock"
trigger: glob
globs: "*.R,**/*.R,*.r,**/*.r,DESCRIPTION,renv.lock"
version: 1.0.0
---

# R Technical Guidelines

## Environment & Reproducibility
1. Use `renv` for package management in every project: initialise with `renv::init()`, commit `renv.lock` to version control, and restore with `renv::restore()` to reproduce the environment exactly.
2. Never install packages directly from the R console during development without updating `renv.lock`; use `renv::install()` followed by `renv::snapshot()`.
3. Pin R itself to a specific version using `.Rversion` or document the required version in `README.md`; use `rig` (R installation manager) to switch versions locally.
4. Use `pak` (via `renv`) as the package installer backend for faster, more reliable installs.

## Code Style & Linting
5. Format code with `styler::style_file()` or `styler::style_dir()`; configure style in `.styler.yml` (Tidyverse style by default).
6. Lint with `lintr::lint_dir()`; the project's `.lintr` config defines enabled linters; zero warnings required in CI.
7. Prefer `snake_case` for all identifiers (variables, functions, file names); reserve `PascalCase` for S3/S4/R5/R6 class names.
8. Use `<-` for assignment (not `=`, except in function arguments); keep line length ≤ 100 characters.

## Tidyverse & Modern R Idioms
9. Prefer `tidyverse` style over base R for data manipulation: `dplyr`, `tidyr`, `purrr`, `readr`, `tibble`.
10. Use `purrr::map_*` variants over `lapply`/`sapply` for type-safe iteration; name the mapped function clearly.
11. Pipe with the native `|>` (R 4.1+) for new code; use `magrittr::%>%` only if the codebase already depends on it.
12. Prefer `ggplot2` for all visualisation; use `patchwork` for multi-panel composition and `scales` for axis/legend formatting.
13. Read rectangular data with `readr::read_csv()` / `readr::read_tsv()`; write with `readr::write_csv()` — never `read.csv()` in new code.

## Project Structure
14. Use an RStudio Project (`.Rproj`) as the project root; never use `setwd()` in scripts.
15. Structure: `R/` for function definitions, `scripts/` for analysis scripts, `data/raw/` for unmodified input data, `data/processed/` for derived data, `output/` for results, `reports/` for rendered documents.
16. Raw data is read-only and never modified in place; all transformations produce new files in `data/processed/`.
17. For complex pipelines with dependencies between steps, use the `targets` package; define the plan in `_targets.R` at the project root.

## Documentation
18. Document all exported functions with `roxygen2` (`#'` comments); include `@param`, `@return`, and at least one `@examples` block.
19. Write analysis reports as Quarto (`.qmd`) or R Markdown (`.Rmd`) documents; render to HTML or PDF — never commit rendered outputs to `main`.
20. Include a `sessionInfo()` or `renv::diagnostics()` block at the end of analysis reports for reproducibility.

## Testing & Package Development
21. Write unit tests with `testthat`; test files live in `tests/testthat/` and are named `test-<module>.R`.
22. Run `devtools::check()` (for packages) or `testthat::test_dir("tests/testthat")` (for projects) in CI.
23. Use `withr` to set temporary state in tests (options, env vars, working directories) without side effects.
