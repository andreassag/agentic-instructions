# agentic-instructions

Production-grade developer instructions, multi-agent workflows, scoped rules, and skill execution harnesses for AI coding assistants (Google Antigravity).

[![CI](https://github.com/andreassag/agentic-instructions/actions/workflows/ci.yml/badge.svg)](https://github.com/andreassag/agentic-instructions/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

📖 **Full Documentation:** [https://andreassag.github.io/agentic-instructions](https://andreassag.github.io/agentic-instructions)

---

## What is this?

`agentic-instructions` (`hub`) manages:

- **🎯 Scoped Rules (`.agents/rules/`)** — File-glob-triggered coding and architecture rulesets (`always_on` for global tools, `glob` for language guidelines).
- **🤖 7 Core Subagents (`.agents/agents/`)** — Autonomous personas: `pre-planner`, `feature-coder`, `tdd-driver`, `repro-debugger`, `refactor-cleaner`, `pr-preflight`, `orchestrator`.
- **🛠️ Executable Skills (`.agents/skills/`)** — Runnable bash workflows for testing, linting, formatting, dependency auditing, and Git hygiene.
- **⚡ Token-Optimized CLI Proxies (`rtk`, `qmd`, `graphify`)** — 60-90% token compression on tool outputs and instant AST/semantic dependency queries.
- **📦 13 Out-of-the-Box Profiles** — Go, Rust, Python, TypeScript, Nextflow DSL2, R Biostatistics, Machine Learning, PowerShell, Full-Stack (Go/Python/TS), Security Auditing, and Docs.

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
# In any git repository:
hub init --profile backend-go-engineer

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
├── agents/                       # Generic subagent definitions with frontmatter
│   ├── orchestrator/
│   ├── pre-planner/
│   ├── feature-coder/
│   ├── tdd-driver/
│   ├── repro-debugger/
│   ├── refactor-cleaner/
│   └── pr-preflight/
│
├── skills/                       # Runnable bash skill scripts with SKILL.md definitions
│   ├── test/
│   ├── lint/
│   ├── format/
│   ├── deps/
│   ├── git/
│   ├── docs/
│   └── security/
│
├── platforms/                    # Deployment platform drivers
│   └── antigravity/
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
