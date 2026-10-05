# Contributing to agentic-instructions

Thank you for contributing! This document explains the development standards, testing workflows, and conventions for maintaining **Agentic Instructions**.

---

## Before You Start

1. **Set Up Local Git Hooks:**
   ```bash
   git config core.hooksPath .githooks
   chmod +x .githooks/*
   ```
   This automatically checks formatting (shfmt), linting (shellcheck, yamllint), secret hygiene, and runs the test suite before every commit.
2. **Run the Test Suite:**
   ```bash
   bash tests/run_all.sh
   # or
   bash validate.sh
   ```
   All test suites must pass cleanly before opening a pull request.
3. **Review Existing Components:**
   Consult the documentation under `docs/` or run `hub init --help-all` to inspect existing profiles, skills, subagents, and rules.

---

## Branch Naming

| Type | Pattern | Example |
|---|---|---|
| New feature | `feat/<description>` | `feat/add-julia-profile` |
| Bug fix | `fix/<description>` | `fix/install-sh-arm64-detection` |
| Documentation | `docs/<description>` | `docs/update-mkdocs-guides` |
| Chore / CI | `chore/<description>` | `chore/update-actions-matrix` |

---

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

[optional body]
[optional footer]
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`

**Examples:**
```
feat(profiles): add julia-science profile manifest
fix(clean): remove graphify-out and qmd cache on hub clean
docs(mkdocs): expand subagents architecture diagrams
```

---

## Adding or Updating Technical Guidelines

1. Create a new skill directory: `skills/<lang>-guidelines/SKILL.md`.
2. Use this frontmatter template:
   ```yaml
   ---
   name: <lang>-guidelines
   description: <Language> technical guidelines, conventions, and best practices.
   when_to_use: "When working with files matching: *.ext,**/*.ext"
   trigger: glob
   globs: "*.ext,**/*.ext"
   version: 1.0.0
   ---
   ```
3. Add the guideline content as the body of the SKILL.md file.
4. Reference the new skill name in appropriate profile manifests under `profiles/*.yaml`.

---

## Adding or Modifying Subagent Roles

1. Place agent definitions in `agents/<name>/agent.md`.
2. Ensure standard YAML frontmatter is present:
   ```markdown
   ---
   name: <agent-name>
   description: <agent-description>
   mainAgent: false
   subagent: true
   ---
   ```

---

## Adding a Skill

1. Create `skills/<name>/SKILL.md` with YAML frontmatter:
   ```yaml
   ---
   name: <skill-name>
   description: <What this skill does and when to use it.>
   when_to_use: "<Trigger description for the agent>"
   version: 1.0.0
   # Optional: for language-guideline skills with glob-based activation:
   # trigger: glob
   # globs: "*.go,**/*.go,go.mod"
   ---
   ```
2. Add skill content (instructions, examples, checklists) as markdown body.
3. Optionally create `skills/<name>/scripts/<script>.sh` for runnable automation.
4. If adding scripts: they must begin with `#!/usr/bin/env bash` and `set -euo pipefail`, and be marked executable: `chmod +x skills/<name>/scripts/<script>.sh`.
5. Reference the skill name in target profiles under `profiles/*.yaml`.

---

## Documentation Development (MkDocs)

All documentation is unified in `docs/` and built using MkDocs Material:

```bash
# Preview documentation locally with live-reload
mkdocs serve

# Verify strict build
mkdocs build --strict
```

> [!NOTE]
> Do not create nested `README.md` files in subdirectories. All documentation must be placed in `docs/` and indexed in `mkdocs.yml`.

---

## What NOT to Commit

- `.agents/` or `.agent/` directories from local test runs.
- `graphify-out/`, `.qmd/`, or `.cache/qmd/` generated tool artifacts.
- `.sif` / `.sqfs` Singularity image files.
- Secrets, API keys, or private certificates.

---

## CI & Automated Checks

GitHub Actions runs [`.github/workflows/ci.yml`](.github/workflows/ci.yml) on every push and PR:
- ShellCheck and Yamllint static analysis.
- Full execution of `tests/run_all.sh` across all profile lifecycles.
- Strict MkDocs documentation site build.
- Git repository hygiene checks.
