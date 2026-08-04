# Contributing to agentic-instructions

Thank you for contributing. This document explains the conventions for keeping the repository clean, consistent, and functional.

---

## Before You Start

1. **Run `bash validate.sh`** — all 56+ checks must pass before pushing.
2. **Check the existing content** — before adding an instruction file or skill, check `instructions/README.md` and `skills/README.md` to see if something similar already exists.

---

## Branch Naming

| Type | Pattern | Example |
|---|---|---|
| New feature | `feat/<description>` | `feat/add-julia-tech-instructions` |
| Bug fix | `fix/<description>` | `fix/install-sh-arm64-detection` |
| Documentation | `docs/<description>` | `docs/update-r-biostats-readme` |
| Chore / CI | `chore/<description>` | `chore/add-gitignore` |

---

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

[optional body]
[optional footer]
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`

Examples:
```
feat(agents): add julia-science agent manifest
fix(install.sh): handle arm64 on macOS correctly
docs(instructions): expand go.md with error wrapping rules
```

---

## Adding an Instruction File

- **Behavioural** → `instructions/agent/<name>.md`
- **Tech stack** → `instructions/tech/<stack>.md`
- **Project type** → `instructions/context/<type>.md`

Rules:
- File name: `lowercase-with-hyphens.md`
- Length: 20–40 lines of actionable, numbered rules
- Update `instructions/README.md` to add the file to the index table
- Reference in at least one agent manifest

---

## Adding a Skill

1. Create `skills/<category>/SKILL.md` with YAML frontmatter:
   ```yaml
   ---
   name: skill-name
   description: One sentence describing what this skill does.
   ---
   ```
2. Create `skills/<category>/<script>.sh`:
   - Start with `#!/usr/bin/env bash` and `set -euo pipefail`
   - Include a brief comment explaining what the script does
3. Update `skills/README.md` to add the skill to the index table
4. Reference the skill in at least one agent manifest

---

## Adding or Modifying an Agent

1. Copy the closest existing manifest: `cp agents/data-python.yaml agents/my-agent.yaml`
2. Update `name`, `version`, `description`, and the `instructions`/`skills`/`tools` lists
3. Bump `version` in the YAML when modifying an existing agent
4. Update `agents/README.md` to add the agent to the index table
5. Validate: `yq e '.' agents/my-agent.yaml`

---

## Modifying Shell Scripts

- Run `bash -n <script>.sh` to check syntax before committing
- All scripts must pass `bash validate.sh` — CI enforces this
- Follow the conventions in [`instructions/tech/bash.md`](instructions/tech/bash.md)

---

## What NOT to Commit

- `.agents/` directories from target repositories
- Rendered instruction outputs (these are written by `hub`, not stored here)
- `.sif` / `.sqfs` Singularity image files
- Any file matching `.gitignore` patterns
- Secrets, API keys, or tokens — run `bash skills/security/secret-scan.sh` before pushing

---

## CI

CI runs [`validate.sh`](validate.sh) on every push and pull request. It checks:
- Bash syntax for all `.sh` files
- YAML validity for all agent manifests
- Platform config completeness
- SKILL.md frontmatter (required `name` and `description` fields)

PRs will not be merged if CI is failing.
