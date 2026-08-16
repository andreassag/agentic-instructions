# Python Technical Guidelines

## Environment & Packaging
1. Use `uv` for environment management: `uv venv`, `uv pip install`, `uv run`, and `uv lock`.
2. Commit `uv.lock` (or `pyproject.toml` + lock) to ensure reproducible installs — never bare `requirements.txt` without pinning.
3. Declare dependencies in `pyproject.toml` under `[project.dependencies]`; dev dependencies under `[project.optional-dependencies]`.
4. Always work inside a project venv; never modify the system Python environment.

## Type Annotations & Data Modeling
5. All public functions, methods, and module-level variables must have explicit type annotations.
6. Use `from __future__ import annotations` at the top of every file for modern union syntax (`X | Y`).
7. Use `pydantic` (v2) or `dataclasses` for structured data models; avoid bare untyped dictionaries for domain schemas.
8. Run `mypy` as part of verification; zero type errors required.

## Web Services & APIs
9. Use `FastAPI` for REST APIs; validate all incoming requests via Pydantic schemas.
10. Version endpoints explicitly (`/v1/...`); return standard HTTP status codes (`200`, `201`, `400`, `404`, `422`).
11. Return consistent error response envelopes:
    ```json
    { "error": { "code": "VALIDATION_ERROR", "message": "...", "details": [] } }
    ```
12. Use `lifespan` async context managers for clean startup and shutdown resource management.

## CLI & Data/ML Pipelines
13. Use `typer` or `argparse` for CLI applications; support `--help`, `--version`, and `--json`.
14. Ensure pipelines and transformations are idempotent: pure functions where identical inputs produce identical outputs.
15. Never modify raw input data in-place; store raw data in `data/raw/` and write derived artifacts to `data/processed/`.
16. Set deterministic random seeds at script entrypoints (`random.seed(42)`, `np.random.seed(42)`, `torch.manual_seed(42)`).

## Code Style, Linting & Testing
17. Format with `ruff format`; lint with `ruff check --fix`.
18. Write tests with `pytest`; structure under `tests/` mirroring `src/`.
19. Prefer `pytest.fixture` and `tmp_path` over manual file teardown.
20. Prefer `pathlib.Path` over `os.path` for all filesystem operations.
