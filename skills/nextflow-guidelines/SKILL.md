---
name: nextflow-guidelines
description: Nextflow DSL2 pipeline guidelines, process definitions, and channel dataflow.
when_to_use: "When working with files matching: *.nf,**/*.nf,nextflow.config,conf/*.config"
trigger: glob
globs: "*.nf,**/*.nf,nextflow.config,conf/*.config"
version: 1.0.0
---

# Nextflow Technical Guidelines

## Language & Version
1. Use DSL2 exclusively (`nextflow.enable.dsl=2` or `dsl2 = true` in `nextflow.config`); never mix DSL1 syntax.
2. Pin the Nextflow version in `.github/workflows` and CI scripts; use `NXF_VER` env var for reproducibility.
3. Use the nf-core module template as the baseline for new process definitions, even outside nf-core pipelines.

## Project Structure
4. Organize: `main.nf` → workflow entry, `modules/local/` → project-specific processes, `modules/nf-core/` → community modules (imported, not modified), `subworkflows/` → composed workflow units, `conf/` → config profiles.
5. Each process lives in its own file: `modules/local/<tool>/<function>/main.nf`.
6. Define a `lib/` directory for Groovy helper functions; keep helpers small and well-named.

## Process Definitions
7. Every process must declare explicit `input:` and `output:` blocks using typed channels (`path`, `val`, `tuple`).
8. Include a `stub:` block in every process for fast pipeline testing without running the actual tool.
9. Use `label` directives (e.g., `label 'process_medium'`) to control resource allocation; define labels in `conf/base.config`.
10. Capture tool versions inside the process script and emit them via a `versions` channel; aggregate with the nf-core `CUSTOM_DUMPSOFTWAREVERSIONS` module or equivalent.
11. Never hardcode paths or parameters inside process scripts; pass them via `params`, channel values, or task environment.

## Channels & Data Flow
12. Use `Channel.fromPath`, `Channel.fromFilePairs`, and `Channel.fromSamplesheet` (nf-schema) as data sources.
13. Name intermediate channels descriptively (`ch_bam_sorted`, not `ch1`).
14. Use `multiMap` to fan out a single channel to multiple consumers; use `join` and `combine` explicitly — document the key being joined on.
15. Avoid stateful operators (`collect`, `groupTuple`) unless the pipeline logic explicitly requires them; they block parallelism.

## Configuration & Portability
16. Define profiles for each execution environment: `standard` (local), `docker`, `singularity`, `conda`, `test`.
17. Every process must have a `container` directive pointing to a tagged (not `latest`) image.
18. Prefer Singularity/Apptainer containers in HPC contexts; define `singularity.enabled = true` and `singularity.autoMounts = true` in the `singularity` profile.
19. Expose all tuneable parameters in `nextflow.config` under `params {}` with sensible defaults and validation via `nf-schema` or `nf-validation`.

## Testing & CI
20. Provide a `test` profile with a small, publicly downloadable dataset; the full pipeline must complete in under 10 minutes on a laptop.
21. Use `nf-test` for process-level and workflow-level testing; test files live alongside the modules they test.
22. Run `nf-core lint` (or equivalent) in CI to catch common config and metadata issues.
