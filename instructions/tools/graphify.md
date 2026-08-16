# Tool: graphify (AST & Semantic Knowledge Graph)
Maintains AST & semantic dependency graph in `graphify-out/graph.json`.

## Query & Traversal
- `graphify query "<question>"` — Graph-traversal query tracing code context & relationships (primary).
- `graphify path "<src>" "<dst>"` — Shortest execution/dependency path between two symbols.
- `graphify affected "<symbol>"` — Reverse traversal: find downstream code impacted by changing symbol.
- `graphify explain "<concept>"` — Plain-language architectural summary.

## Lifecycle & Memory
- `graphify update .` — Incrementally re-index modified files after edits | `graphify extract <path>` — Full build.
- `graphify tree` — Generate D3 visualization HTML | `graphify export callflow-html` — Mermaid callflow.
- `graphify save-result` & `graphify reflect` — Record query findings & aggregate lessons.
