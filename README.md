# agentic-instructions

Centralized repository for storing, versioning, composing, and deploying LLM agent instructions, skills, tools, and platform hooks into downstream software repositories — without upstream git merge conflicts.

## What is this?

`agentic-instructions` is a hub that manages:

- **Instructions** — Markdown rulesets for agent behaviour, coding standards, and project conventions.
- **Skills** — Modular Bash scripts for repetitive tasks (commit lint, coverage, changelog generation, secret scanning, dependency audits).
- **Tools** — External CLI integrations: `rtk`, `graphify`, `qmd`.
- **Agents** — Pre-composed named configurations declared in YAML manifests.
- **Platforms** — Deployment targets: Claude Code, GitHub Copilot, Antigravity, Mistral Vibe, OpenAI Codex.

The `hub` CLI assembles instructions and deploys them into a target repository in one command. Everything is one-way: changes flow from this repo → into your projects. No upstream sync, no merge conflicts.

---

## Install

```bash
# One-liner (requires: git, wget or curl)
curl -fsSL https://raw.githubusercontent.com/andreassag/agentic-instructions/main/install.sh | bash
```

`install.sh` will:
1. Auto-detect platform and install `jq` and `mikefarah/yq` if missing.
2. Install `graphify` (`pip install graphifyy`), `qmd` (`npm install -g @tobilu/qmd`), and `rtk` (official installer).
3. Clone this repo to `/usr/local/share/agentic-instructions` (with sudo) or `~/.local/share/agentic-instructions`.
4. Symlink `hub` to `PREFIX/bin/hub`.
5. Append `PREFIX/bin` to your `PATH` in `~/.bashrc` or `~/.zshrc`.

**Manual install flags:**

| Flag | Default | Description |
|---|---|---|
| `--prefix PATH` | Auto-detected | Override install prefix |
| `--branch NAME` | `main` | Clone a specific branch |
| `--update` | — | Pull latest from remote |
| `--dry-run` | — | Print actions without executing |
| `--no-path` | — | Skip PATH modification |

---

## Quick Start

```bash
# In any git repository:
hub init --agent systems-rust

# Check current state
hub status

# Update after hub repo changes
hub update

# Load a different agent
hub load ml-python

# Load with specific platforms
hub update --platform claude,copilot,antigravity

# Remove all hub files
hub clean --all
```

---

## Directory Layout

```
agentic-instructions/
├── install.sh                    # Bootstrap installer (installs jq, yq, rtk, graphify, qmd)
├── hub.sh                        # CLI entrypoint (symlinked as `hub`)
├── validate.sh                   # CI validation script (syntax, YAML, frontmatter)
├── CHANGELOG.md                  # Release history
├── CONTRIBUTING.md               # Contribution guidelines
├── SECURITY.md                   # Security policy and vulnerability reporting
├── .gitignore
│
├── schema/
│   └── agent.schema.yaml         # YAML schema for agent manifests
│
├── lib/                          # CLI subcommand implementations
│   ├── cmd_init.sh               # hub init
│   ├── cmd_update.sh             # hub update
│   ├── cmd_load.sh               # hub load
│   ├── cmd_clean.sh              # hub clean
│   ├── cmd_status.sh             # hub status
│   ├── build_context.sh          # Instruction concatenation + rtk pipeline
│   ├── platform_write.sh         # Marker-safe platform file writer
│   ├── platform_clean.sh         # Marker-safe platform file cleaner
│   └── skills_deploy.sh          # Per-platform skill registration
│
├── instructions/                 # Composable instruction fragments
│   ├── README.md                 # Full index of all instruction files
│   ├── agent/                    # Agent behaviour rules
│   │   ├── safety.md             # Scope limits, secret handling, validation
│   │   ├── communication.md      # Response calibration, formatting, trade-offs
│   │   ├── code-review.md        # Review order, severity taxonomy, comment quality
│   │   ├── planning.md           # Task decomposition, checkpointing
│   │   ├── debugging.md          # Reproduce-first methodology
│   │   └── documentation.md      # Docs-alongside-code, ADRs, changelogs
│   ├── tech/                     # Language & tooling guidelines
│   │   ├── python.md             # Python 3.10+, uv, ruff, mypy, pytest, pydantic
│   │   ├── rust.md               # Cargo, tokio, thiserror, clippy
│   │   ├── typescript.md         # strict tsconfig, Zod, vitest, ESM
│   │   ├── go.md                 # golangci-lint, errgroup, testify, context
│   │   ├── bash.md               # set -euo pipefail, quoting, trap/cleanup
│   │   ├── cpp.md                # C++20, CMake, RAII, ASan, clang-tidy
│   │   ├── r.md                  # renv, tidyverse, targets, testthat, lintr
│   │   ├── docker.md             # Dockerfile, Compose, Singularity/Apptainer
│   │   └── nextflow.md           # DSL2, nf-core modules, stub blocks, nf-test
│   └── context/                  # Project-type conventions
│       ├── api.md                # REST/gRPC design, versioning, error envelopes
│       ├── cli.md                # Flags, exit codes, output discipline
│       ├── data-pipeline.md      # Idempotency, observability, quarantine
│       ├── library.md            # SemVer, API stability, release process
│       ├── service.md            # Lifecycle, health probes, structured logging
│       ├── ml-experiment.md      # Reproducibility, tracking, evaluation
│       └── tools/                # Tool usage instructions (graphify, rtk, qmd)
│
├── skills/                       # Invokable skill scripts
│   ├── README.md                 # Skill authoring guide
│   ├── _lib/                     # Shared bash helpers
│   │   ├── log.sh
│   │   ├── fs.sh
│   │   ├── platform.sh
│   │   └── hash.sh
│   ├── git/                      # commit-lint.sh — Conventional commit validation
│   ├── test/                     # coverage-report.sh — Test coverage reporting
│   ├── refactor/                 # extract-function.sh — Extract code to function
│   ├── review/                   # pr-checklist.sh — PR review checklist
│   ├── debug/                    # repro-test.sh — Minimal reproduction generator
│   ├── docs/                     # changelog-entry.sh — CHANGELOG from git log
│   ├── security/                 # secret-scan.sh — Secret detection (gitleaks)
│   └── deps/                     # audit.sh — Dependency vulnerability audit
│
├── agents/                       # Named agent YAML manifests
│   ├── README.md                 # Agent quickstart and manifest format
│   ├── systems-rust.yaml
│   ├── backend-go.yaml
│   ├── full-stack-ts.yaml
│   ├── data-python.yaml
│   ├── bioinformatics-nextflow.yaml
│   ├── ml-python.yaml
│   ├── r-biostats.yaml
│   ├── r-sciviz.yaml
│   ├── python-bio.yaml
│   ├── docs-writer.yaml
│   └── security-audit.yaml
│
└── platforms/                    # Per-platform deployment config
    ├── claude/                   # → CLAUDE.md + .claude/commands/
    ├── copilot/                  # → .github/copilot-instructions.md
    ├── antigravity/              # → AGENTS.md + .agents/
    ├── vibe/                     # → .vibe/system_prompt.md
    └── codex/                    # → .codex/instructions.md
```

---

## Agents

| Agent | Description | Key Tech |
|---|---|---|
| `systems-rust` | Systems programming | Rust, Bash |
| `backend-go` | Backend services & CLI tools | Go, Docker, Bash |
| `full-stack-ts` | Full-stack web development | TypeScript, Bash |
| `data-python` | Data engineering and analysis | Python, Bash |
| `bioinformatics-nextflow` | Bioinformatics pipelines | Nextflow DSL2, Python, Bash |
| `ml-python` | ML research and experiment tracking | Python, MLflow/W&B |
| `r-biostats` | Bioinformatics statistics | R, Bioconductor, Nextflow |
| `r-sciviz` | Scientific visualization | R, ggplot2, patchwork |
| `python-bio` | Biological data scripting | Python, Biopython |
| `docs-writer` | Technical documentation | Markdown, ADRs, CHANGELOG |
| `security-audit` | Security review and hardening | gitleaks, pip-audit, SAST |

See [`agents/README.md`](agents/README.md) for the full manifest format and quickstart.

---

## Skills

| Skill | Trigger | Description |
|---|---|---|
| `git-commit-lint` | `/commit-lint` | Validates commit messages (Conventional Commits) |
| `test-coverage` | `/coverage` | Runs tests and reports branch coverage |
| `pr-checklist` | `/pr-check` | Checks PR against project review checklist |
| `refactor-extract` | `/extract` | Extracts a code block into a named function |
| `repro-test` | `/repro` | Generates a minimal reproduction from a failing test |
| `changelog-entry` | `/changelog` | Generates CHANGELOG.md entry from git log since last tag |
| `secret-scan` | `/secret-scan` | Scans for accidentally committed secrets (gitleaks) |
| `dep-audit` | `/dep-audit` | Audits dependencies for known vulnerabilities |

See [`skills/README.md`](skills/README.md) for authoring and invocation details.

---

## Platform Support

| Platform | Primary File | Skills Deployed |
|---|---|---|
| `claude` | `CLAUDE.md` | `.claude/commands/<skill>.md` |
| `copilot` | `.github/copilot-instructions.md` | Documented inside file |
| `antigravity` | `AGENTS.md` | `.agents/skills/<name>/` |
| `vibe` | `.vibe/system_prompt.md` | Documented inside file |
| `codex` | `.codex/instructions.md` | Documented inside file |

---

## `hub` CLI Reference

### Global Flags

```
--hub-home PATH    Override HUB_HOME (default: resolved from symlink)
--dry-run          Print actions without executing
--verbose          Enable trace logging (set -x)
--no-color         Disable ANSI color output
--no-strip         Skip rtk token stripping
```

### Commands

#### `hub init`
Initialize hub in the current git repository.

```bash
hub init [--platform <p1,p2>] [--stack <s1,s2>] [--agent <name>] [--force]
```

#### `hub update`
Re-apply configuration. Hash-gated: only rewrites platform files whose source changed.

```bash
hub update [--platform <p1,p2>] [--agent <name>] [--force]
```

#### `hub load <agent>`
Load a named pre-composed agent.

```bash
hub load backend-go
hub load ml-python
hub load r-biostats --force
```

#### `hub status`
Show current hub state for the project.

```bash
hub status
hub status --json
```

#### `hub clean`
Remove hub-managed files. Marker-aware: preserves content outside hub markers.

```bash
hub clean                       # Clean all active platforms
hub clean --platform claude     # Clean a specific platform
hub clean --all                 # Also remove .agents/ directory
```

---

## Agent Schema Reference

See [`schema/agent.schema.yaml`](schema/agent.schema.yaml) for the full schema.

Key fields in every `agents/*.yaml`:

| Field | Required | Description |
|---|---|---|
| `name` | ✓ | Unique identifier (lowercase, hyphens) |
| `version` | ✓ | Semantic version (e.g. `1.0.0`) |
| `description` | ✓ | Human-readable purpose |
| `instructions.agent[]` | ✓ | Behavioural instruction files |
| `instructions.tech[]` | — | Stack-specific guideline files |
| `instructions.context[]` | — | Project-type context files |
| `skills[]` | — | Skill scripts to deploy |
| `tools.required[]` | — | Tools that must exist (warn if missing) |
| `tools.optional[]` | — | Tools used if available |
| `platforms.default[]` | ✓ | Platforms activated by default on `hub init` |
| `rtk.max_tokens` | ✓ | Token budget for rtk strip |

---

## Tool Integration

| Tool | Install | When Used | Invoked By |
|---|---|---|---|
| `rtk` | `curl \| sh` | Runtime: intercepts shell commands and compresses output to save LLM context | LLM agent (e.g. `rtk git status`, `rtk grep`) |
| `graphify` | `pip install graphifyy` | Runtime: graphs repo structure for LLM context | LLM agent directly |
| `qmd` | `npm install -g @tobilu/qmd` | Runtime: queries markdown docs | LLM agent directly |

---

## CI / Validation

```bash
# Run all checks locally (syntax, YAML, frontmatter)
bash validate.sh

# Or run individual checks:
find . -name "*.sh" -not -path "./.git/*" | xargs bash -n        # syntax
for f in agents/*.yaml; do yq e '.' "$f" > /dev/null; done       # YAML
```

CI runs on every push and pull request via [`.github/workflows/validate.yml`](.github/workflows/validate.yml).

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Quick rules:
- Branch naming: `feat/<description>`, `fix/<description>`, `docs/<description>`
- Run `bash validate.sh` before pushing — CI will reject failures.
- Agent manifest changes require a `version:` bump.
- Do not commit `.agents/` directories from target projects.

---

## Security

See [SECURITY.md](SECURITY.md) for the vulnerability reporting policy.

---

## License

MIT — see [LICENSE](LICENSE).
