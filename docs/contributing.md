# Contributing Guide

Thank you for contributing to **Agentic Instructions**! Follow these guidelines to keep the codebase clean, consistent, and well-tested.

---

## Development Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/andreassag/agentic-instructions.git
   cd agentic-instructions
   ```

2. **Install prerequisites:**
   Ensure `jq`, `yq`, `shellcheck`, and `yamllint` are installed.

3. **Set up local Git hooks:**
   ```bash
   git config core.hooksPath .githooks
   chmod +x .githooks/*
   ```

4. **Install MkDocs Material (for documentation):**
   ```bash
   pip install mkdocs mkdocs-material
   ```

---

## Running the Test Suite

Run the full automated test suite before opening a pull request:

```bash
# Run all tests
bash tests/run_all.sh

# Or run individual test modules
bash tests/test_syntax.sh
bash tests/test_schemas.sh
bash tests/test_cli_lifecycle.sh
bash tests/test_skills.sh
bash tests/test_cleanup.sh
```

---

## Documentation Development

Preview the documentation locally with live-reload:

```bash
mkdocs serve
```

Build the documentation site in strict mode (fails on broken links or warnings):

```bash
mkdocs build --strict
```

---

## Commit & Pull Request Guidelines

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

[optional body]
[optional footer]
```

- Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`
- Example: `feat(rules): add julia technical guidelines and companion yaml`

### Branch Naming
- Features: `feat/<description>`
- Bug Fixes: `fix/<description>`
- Documentation: `docs/<description>`
- CI/Chore: `chore/<description>`
