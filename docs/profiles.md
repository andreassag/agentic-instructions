# Profiles Catalog

Profiles combine technical coding guidelines, specialized subagents, and modular skills into complete, stack-specific setups.

---

## Available Profiles

| Profile Name | Description | Key Technologies |
|---|---|---|
| `backend-go` | High-performance Go backend services and CLI tools | Go, Docker, Bash |
| `full-stack-ts` | TypeScript/Node web development and REST APIs | TypeScript, Bash, Docker |
| `systems-rust` | Systems engineering, CLI utilities, and concurrency | Rust, Bash |
| `data-python` | Python data processing, pipelines, and analytics | Python, Bash |
| `ml-python` | Machine learning, experiment tracking, and modeling | Python, PyTorch, MLflow |
| `python-bio` | Computational biology, sequence analysis, and Biopython | Python, Biopython |
| `bioinformatics-nextflow` | Scalable Nextflow DSL2 pipelines and containers | Nextflow, Docker, Bash |
| `r-biostats` | Statistical genetics and Bioconductor workflows | R, Bioconductor, renv |
| `r-sciviz` | Scientific publication graphics and data visualization | R, ggplot2, patchwork |
| `security-audit` | Codebase security review, secret scanning, and SAST | SAST, Semgrep, Gitleaks |
| `docs-writer` | Technical documentation, architecture specs, ADRs | Markdown, MkDocs |

---

## Profile Manifest Schema

Each profile is defined in `profiles/<name>.yaml`:

```yaml
name: backend-go
version: 1.0.0
description: High-performance Go backend services, CLI tools, and containerized microservices.

instructions:
  - tech/go.md
  - tech/docker.md
  - tech/bash.md

skills:
  - test/go.sh
  - lint/go.sh
  - lint/docker.sh
  - format/go.sh
  - format/bash.sh
  - deps/go.sh
  - git/commit-lint.sh
  - security/secret-scan.sh

tools:
  - rtk
  - qmd
  - graphify
```

---

## Authoring Custom Profiles

To create a new custom profile:

1. Create a new file `profiles/my-custom-stack.yaml`.
2. Populate the required fields (`name`, `version`, `description`, `instructions`, `skills`, `tools`).
3. Validate your profile using the test suite:
   ```bash
   bash validate.sh
   ```
4. Load it in your project:
   ```bash
   hub init --profile my-custom-stack
   ```
