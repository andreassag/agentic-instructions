# skills/

Skills are invokable, named capabilities that agents can call during a task. Each skill lives in its own directory containing a `SKILL.md` (the definition and instructions) and one or more shell scripts (the implementation stubs).

## Available Skills

| Skill | Directory | Description |
|---|---|---|
| `git-commit-lint` | [git/](git/) | Validates commit messages against project formatting rules |
| `test-coverage` | [test/](test/) | Runs the test suite and reports branch coverage |
| `refactor-extract` | [refactor/](refactor/) | Extracts a code block into a named function |
| `pr-checklist` | [review/](review/) | Checks a PR against a project-defined review checklist |
| `repro-test` | [debug/](debug/) | Generates a minimal reproduction script from a failing test |
| `changelog-entry` | [docs/](docs/) | Generates a CHANGELOG.md entry from git log since last tag |
| `secret-scan` | [security/](security/) | Scans for accidentally committed secrets (gitleaks / truffleHog) |
| `dep-audit` | [deps/](deps/) | Audits dependencies for known vulnerabilities (pip-audit, npm audit, cargo audit) |

## Skill Directory Layout

```
skills/
├── _lib/                  # Shared bash helpers (imported by skill scripts)
│   ├── fs.sh
│   ├── hash.sh
│   ├── log.sh
│   └── platform.sh
└── <skill-name>/
    ├── SKILL.md           # Frontmatter (name, description) + instructions
    └── <script>.sh        # Implementation stub(s)
```

## SKILL.md Format

```markdown
---
name: skill-name
description: One-sentence description used for auto-discovery.
---

# Skill Title

Instructions the agent follows when the skill is triggered.

## Trigger

`/skill-name` or `skill-name`

## What this skill does

1. Step one
2. Step two
```

## Authoring a New Skill

1. Create a new directory: `skills/my-skill/`
2. Write `SKILL.md` with YAML frontmatter (`name` and `description` required).
3. Add a `my-script.sh` stub (must begin with `#!/usr/bin/env bash` and `set -euo pipefail`).
4. Reference the skill in an agent manifest: `skills: - my-skill/my-script.sh`
5. Run `bash validate.sh` to confirm the frontmatter passes linting.

## Invoking a Skill

Skills are deployed by `hub` when loading an agent. Depending on the platform:

- **Claude Code / Antigravity**: Type the trigger phrase in chat (e.g., `/changelog`)
- **Copilot**: Reference the skill script directly via the agent's configured skill list
- **Manual**: Run the script directly from the repository root: `bash skills/security/secret-scan.sh`
