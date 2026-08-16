# External Tool Proxies

Agentic Instructions integrates directly with external CLI utilities to minimize token consumption and provide rich AST/semantic context to LLMs.

---

## 1. `rtk` (Token Compressor)

[RTK](https://github.com/rtk-ai/rtk) intercepts and wraps common CLI commands (git, grep, test runners, build systems) to filter boilerplate and compress terminal outputs by **60-90%**, saving significant LLM context tokens.

### Common Wrappers
- `rtk err <cmd>`: Filters output to display only errors and warnings.
- `rtk test <cmd>`: Filters test runs to display only failing tests.
- `rtk summary <cmd>`: Produces a 2-line execution summary.
- `rtk diff [args]`: Formats compact, token-dense git diffs.

### Proxied Commands
- **Git**: `rtk git status`, `rtk git diff`, `rtk git log`, `rtk gh pr`
- **Search**: `rtk grep "<pat>"`, `rtk find`, `rtk tree`
- **Build/Test**: `rtk go test`, `rtk cargo clippy`, `rtk pytest`, `rtk npm run test`
- **Infra**: `rtk docker`, `rtk kubectl`, `rtk curl`

---

## 2. `qmd` (Local Markdown & Spec Search)

`qmd` provides fast local hybrid search (BM25 lexical + vector embeddings + reranking) across markdown documentation, technical specs, and ADRs.

### Common Commands
- `qmd query "<question>"`: Hybrid search with query expansion and reranking.
- `qmd search "<keyword>"`: Fast BM25 keyword matching.
- `qmd get <file>[:start[:lines]]`: Retrieves line-numbered document slices.
- `qmd multi-get "<glob>"`: Batch fetches documentation files.

---

## 3. `graphify` (AST & Semantic Knowledge Graph)

`graphify` builds and maintains an AST and semantic dependency graph in `graphify-out/graph.json`, allowing the LLM to trace symbol relationships and impact paths.

### Common Commands
- `graphify query "<question>"`: Traverses code relationships to answer structural questions.
- `graphify path "<source>" "<target>"`: Traces shortest dependency path between symbols.
- `graphify affected "<symbol>"`: Identifies downstream code impacted by modifying a symbol.
- `graphify update .`: Incrementally updates the graph after code modifications.
