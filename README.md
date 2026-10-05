# agentic-instructions

Production-grade developer instructions, multi-agent workflows, scoped rules, and skill execution harnesses for AI coding assistants (Google Antigravity).

[![CI](https://github.com/andreassag/agentic-instructions/actions/workflows/ci.yml/badge.svg)](https://github.com/andreassag/agentic-instructions/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

📖 **Full Documentation:** [https://andreassag.github.io/agentic-instructions](https://andreassag.github.io/agentic-instructions)

---

## What is this?

`agentic-instructions` (`hub`) manages:

- **🎯 Scoped Rules (`.agents/rules/`)** — Always-on and file-glob-triggered coding and architecture rulesets.
- **🤖 Core Subagents (`.agents/agents/`)** — Autonomous personas: `orchestrator`, `project-planner`, `backend-specialist`, `frontend-specialist`, `debugger`, `devops-engineer`, `test-engineer`, and more.
- **🛠️ Executable Skills (`.agents/skills/`)** — Runnable bash workflows for testing, linting, formatting, dependency auditing, Git hygiene, and more.
- **📐 Tech-Guideline Skills** — Language-specific guidelines (Go, Python, TypeScript, Rust, Bash, Docker, C++, R, Nextflow, PowerShell) deployed as glob-triggered skills.
- **⚡ Token-Optimized CLI Proxies (`rtk`, `qmd`, `graphify`)** — 60-90% token compression on tool outputs and instant AST/semantic dependency queries.
- **📦 13 Out-of-the-Box Profiles** — Go, Rust, Python, TypeScript, Nextflow DSL2, R Biostatistics, ML, PowerShell, Full-Stack (Go/Python/TS), Security Auditing, and Docs.
- **🌐 Multi-Platform Deployment** — Deploy to Antigravity, VSCode Copilot, Mistral Vibe, and JetBrains AI Assistant from the same profile.

Everything is deployed one-way: changes flow from this repo → into downstream projects with zero merge conflicts.

---

## Quick Install

```bash
# Automated installer (latest version)
curl -fsSL https://raw.githubusercontent.com/andreassag/agentic-instructions/main/install.sh | bash

# Install a specific version (e.g. v1.0.0)
curl -fsSL https://raw.githubusercontent.com/andreassag/agentic-instructions/main/install.sh | bash -s -- --version v1.0.0
```

---

## Quick Start

```bash
# In any git repository — deploy to Antigravity (default):
hub init --profile backend-go-engineer

# Deploy for VSCode Copilot:
hub init --profile backend-go-engineer --platform copilot

# Deploy for Mistral Vibe:
hub init --profile backend-go-engineer --platform vibe

# Deploy for JetBrains AI Assistant:
hub init --profile backend-go-engineer --platform jetbrains

# Check loaded profile and state
hub status

# Switch to a different profile
hub load full-stack-ts

# Update after pulling new instruction versions
hub update

# Clean all hub-managed directories and tool artifacts
hub clean
```

---

## Directory Layout

```
agentic-instructions/
├── install.sh                    # Bootstrap installer
├── hub.sh                        # CLI entrypoint (symlinked as `hub`)
├── validate.sh                   # Entrypoint for test and validation suite
├── mkdocs.yml                    # MkDocs Material configuration
├── CHANGELOG.md                  # Release history
├── CONTRIBUTING.md               # Contribution guidelines
├── SECURITY.md                   # Security policy
│
├── profiles/                     # Stack profile manifests (13 curated profiles)
│   ├── backend-go-engineer.yaml
│   ├── bioinformatics-nextflow.yaml
│   ├── docs-writer.yaml
│   ├── full-stack-golang-engineer.yaml
│   ├── full-stack-python-engineer.yaml
│   ├── full-stack-ts.yaml
│   ├── ml-python.yaml
│   ├── powershell.yaml
│   ├── python-biocomputation-scientist.yaml
│   ├── python-data-scientist.yaml
│   ├── r-biostatistician.yaml
│   ├── security-audit.yaml
│   └── systems-rust.yaml
│
├── instructions/                 # Instruction fragments
│   ├── tech/                     # Plain markdown tech guidelines + companion .yaml metadata
│   └── tools/                    # Tool guides (rtk, qmd, graphify) + companion .yaml metadata
│
├── agents/                       # Subagent definitions with YAML frontmatter
│   ├── orchestrator.md
│   ├── backend-specialist.md
│   └── ...                       # (15+ agent roles)
│
├── skills/                       # Skill directories — each contains SKILL.md + optional scripts/
│   ├── go-guidelines/            # Tech guideline skills (glob-triggered)
│   ├── python-guidelines/
│   ├── typescript-guidelines/
│   ├── bash-guidelines/
│   ├── ...                       # (10 language guidelines total)
│   ├── rtk/                      # Tool skills
│   ├── qmd/
│   ├── graphify/
│   ├── clean-code/               # Executable skills
│   ├── test-runner/
│   ├── verify-changes/
│   ├── systematic-debugging/
│   ├── app-builder/
│   └── ...                       # (30+ skills total)
│
├── platforms/                    # Deployment platform drivers
│   ├── antigravity/              # Google Antigravity / AGY
│   ├── copilot/                  # VSCode GitHub Copilot
│   ├── vibe/                     # Mistral Vibe
│   └── jetbrains/                # JetBrains AI Assistant
│
├── docs/                         # MkDocs documentation site
└── tests/                        # Modular CI test suite
    ├── run_all.sh
    ├── test_syntax.sh
    ├── test_schemas.sh
    ├── test_cli_lifecycle.sh
    ├── test_skills.sh
    └── test_cleanup.sh
```

---

## Testing & CI

Run the complete test suite locally:

```bash
bash tests/run_all.sh
# or
bash validate.sh
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and [docs/contributing.md](docs/contributing.md) for full development, testing, and contribution standards.

---

## License

MIT — see [LICENSE](LICENSE).
