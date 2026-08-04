# agents/

Agent manifests define fully composed agents by combining instruction fragments, skills, and tool dependencies.

## Available Agents

| Agent | Description | Key Tech |
|---|---|---|
| [bioinformatics-nextflow](bioinformatics-nextflow.yaml) | Bioinformatics pipelines with Nextflow DSL2 | Nextflow, Python, Bash |
| [data-python](data-python.yaml) | Data engineering and analysis | Python, Bash |
| [full-stack-ts](full-stack-ts.yaml) | Full-stack web development | TypeScript, Bash |
| [systems-rust](systems-rust.yaml) | Systems programming | Rust, Bash |
| [ml-python](ml-python.yaml) | ML research and experiment tracking | Python, MLflow/W&B |
| [r-biostats](r-biostats.yaml) | Bioinformatics statistics | R, Bioconductor, Nextflow |
| [r-sciviz](r-sciviz.yaml) | Scientific visualization | R, ggplot2, patchwork |
| [python-bio](python-bio.yaml) | Biological data scripting | Python, Biopython |
| [docs-writer](docs-writer.yaml) | Technical documentation | Markdown, ADRs, Changelogs |
| [security-audit](security-audit.yaml) | Security review and hardening | SAST, gitleaks, pip-audit |

## Manifest Format

```yaml
name: my-agent
version: 1.0.0
description: One-line description of what this agent does.

instructions:
  agent:
    - agent/safety.md          # behaviour rules
  tech:
    - tech/python.md           # language guidelines
  context:
    - context/ml-experiment.md # project-type conventions

skills:
  - git/commit-lint.sh         # invokable skill scripts
  - deps/audit.sh

tools:
  required:
    - rtk       # LLM uses: rtk git status, rtk grep, etc. for compact output
  optional:
    - graphify
    - qmd
  default:
    - claude
    - antigravity
  supported:
    - claude
    - copilot
    - antigravity
    - vibe
    - codex

rtk:
  strip: true
  max_tokens: 10000
```

## Quickstart

```bash
# Load an agent into the current project
hub load ml-python

# Preview what would be written (no changes)
hub load ml-python --dry-run

# Update after pulling new instruction versions
hub update

# Check which agents are loaded in the current project
hub status
```

## Adding a New Agent

1. Copy the closest existing manifest: `cp agents/data-python.yaml agents/my-agent.yaml`
2. Update `name`, `description`, and the instruction/skill lists.
3. Run `hub load my-agent` in a test project to verify.
4. Validate with `bash validate.sh` from the repo root.
