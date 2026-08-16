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
