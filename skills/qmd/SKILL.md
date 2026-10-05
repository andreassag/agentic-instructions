]633;E;} > skills/qmd/SKILL.md;4dca41da-d3d2-4e13-b9d9-67c852f2f14a]633;C---
name: qmd
description: qmd (Quick Markdown) — hybrid local search (BM25 + vector + rerank) across project docs and markdown knowledge bases. Use to search project documentation, specs, and knowledge bases efficiently.
when_to_use: "When searching for information in local docs, querying a spec or knowledge base, or retrieving project documentation. Prefer over grep for semantic/conceptual searches."
trigger: always_on
version: 1.0.0
---

# Tool: qmd (Local Markdown & Spec Search)
Hybrid local search (BM25 + vector + rerank) across project docs and markdown knowledge bases.

## Commands
- `qmd query "<text>"` — Hybrid search with expansion & rerank (primary search tool).
- `qmd query $'lex: <kw>\nvec: <sem>'` — Structured lexical + semantic search.
- `qmd search "<kw>"` — Fast BM25 keyword search | `qmd vsearch "<text>"` — Vector similarity.
- `qmd get <file>[:start[:lines]]` — Fetch line-numbered doc | `qmd multi-get "<glob>"` — Batch fetch.
- `qmd init` | `qmd update [--pull]` | `qmd embed` | `qmd status` — Index lifecycle.

## Options
- `-n <N>` (result cap) | `--full` (full doc) | `--format json|files` (piping) | `-c <collection>`
