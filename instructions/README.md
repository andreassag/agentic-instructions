# instructions/

This directory contains composable instruction fragments loaded by `hub` into agent contexts. Each file is a focused ruleset for a specific technology, project type, or agent behaviour.

## Structure

```
instructions/
├── agent/        # Universal agent behaviour (safety, planning, communication, etc.)
├── context/      # Project-type conventions (API, CLI, library, pipeline, etc.)
└── tech/         # Language and tool-specific coding guidelines
```

## Index

### `agent/` — Agent Behaviour

| File | Purpose |
|---|---|
| [safety.md](agent/safety.md) | Scope limits, destructive-op confirmation, secret handling |
| [communication.md](agent/communication.md) | Response calibration, formatting, trade-off surfacing |
| [code-review.md](agent/code-review.md) | Review order, severity taxonomy, comment quality |
| [planning.md](agent/planning.md) | Task decomposition, checkpointing, completion verification |
| [debugging.md](agent/debugging.md) | Reproduce-first methodology, hypothesis-driven investigation |
| [documentation.md](agent/documentation.md) | Docs alongside code, ADRs, changelog discipline |

### `context/` — Project Type

| File | Purpose |
|---|---|
| [api.md](context/api.md) | REST/gRPC design, versioning, error envelopes, auth |
| [cli.md](context/cli.md) | Flag conventions, exit codes, output discipline, config precedence |
| [data-pipeline.md](context/data-pipeline.md) | Idempotency, observability, quarantine, reproducibility |
| [library.md](context/library.md) | SemVer, API stability, changelog, release process |
| [service.md](context/service.md) | Lifecycle, health probes, structured logging, resilience |
| [ml-experiment.md](context/ml-experiment.md) | Reproducibility, data discipline, experiment tracking, evaluation |

### `tech/` — Language & Tooling

| File | Stack |
|---|---|
| [python.md](tech/python.md) | Python 3.10+, uv, ruff, mypy, pytest |
| [rust.md](tech/rust.md) | Rust, Cargo, tokio, thiserror, clippy |
| [typescript.md](tech/typescript.md) | TypeScript strict, Zod, vitest, ESM |
| [go.md](tech/go.md) | Go, golangci-lint, errgroup, testify |
| [bash.md](tech/bash.md) | Bash 4+, set -euo pipefail, POSIX portability |
| [cpp.md](tech/cpp.md) | C++20, CMake, RAII, clang-tidy, ASan |
| [r.md](tech/r.md) | R, renv, tidyverse, targets, testthat, lintr |
| [docker.md](tech/docker.md) | Docker, Compose, Singularity/Apptainer |
| [nextflow.md](tech/nextflow.md) | Nextflow DSL2, nf-core modules, nf-test |

## Usage

Reference instruction files in an agent manifest:

```yaml
instructions:
  agent:
    - agent/safety.md
    - agent/planning.md
  tech:
    - tech/python.md
  context:
    - context/ml-experiment.md
```

Then deploy with:

```bash
hub load ml-python
```
