# Python Technical Guidelines

## Environment & Packaging
1. Use `uv` for all environment management: `uv venv`, `uv pip install`, `uv run`, and `uv lock`.
2. Commit `uv.lock` (or `pyproject.toml` + lock) to ensure reproducible installs — never bare `requirements.txt` without pinning.
3. Declare dependencies in `pyproject.toml` under `[project.dependencies]`; dev dependencies under `[project.optional-dependencies]` or `[tool.uv.dev-dependencies]`.
4. Never modify the system Python environment; always work inside a project venv.

## Type Annotations
5. All public functions, methods, and module-level variables must have explicit type annotations.
6. Use `from __future__ import annotations` at the top of every file for forward-reference compatibility.
7. Prefer `TypeAlias`, `TypeVar`, and `Protocol` over `Any`; `Any` is only acceptable with a comment justifying it.
8. Run `mypy --strict` (or `pyright`) as part of CI; zero type errors required to merge.

## Code Style & Linting
9. Format with `ruff format` (replaces `black`); lint with `ruff check` — both run in pre-commit.
10. Max line length: 100 characters.
11. Imports: standard library → third-party → local, each group separated by a blank line.
12. Avoid wildcard imports (`from x import *`) in all non-`__init__.py` files.
13. Use `ruff`'s `I` (isort), `N` (pep8-naming), and `UP` (pyupgrade) rule sets.

## Testing
14. Write tests with `pytest`; structure under `tests/` mirroring `src/`.
15. Use `pytest-cov` to enforce a minimum branch coverage threshold (set in `pyproject.toml`).
16. Prefer `pytest.fixture` over `setUp`/`tearDown`; use `tmp_path` for filesystem fixtures.
17. Name test functions `test_<unit>_<scenario>` for clear failure messages.

## Error Handling & Logging
18. Raise specific exceptions, never bare `except:` or `except Exception` without re-raise or logging.
19. Use `logging` from the standard library; never `print()` for diagnostic output in library code.
20. Log with `structlog` or the standard `logging` module using structured key-value pairs.
21. Set log levels via environment variable (`LOG_LEVEL`), defaulting to `WARNING` in production.

## Modern Python Idioms
22. Target Python 3.10+ — use `match`/`case`, `X | Y` union syntax, and `TypeGuard` where appropriate.
23. Use `dataclasses` or `pydantic` models for structured data; avoid bare dicts for complex schemas.
24. Prefer `pathlib.Path` over `os.path` for all filesystem operations.
25. Use context managers (`with`) for all resource acquisition (files, connections, locks).
