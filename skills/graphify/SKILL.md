]633;E;} > skills/graphify/SKILL.md;4dca41da-d3d2-4e13-b9d9-67c852f2f14a]633;C---
name: graphify
description: graphify — AST and semantic knowledge graph for codebases. Maintains a persistent dependency graph in `graphify-out/graph.json`. Use for graph-traversal queries, impact analysis, and architectural understanding.
when_to_use: "When you need to understand code relationships, trace dependencies, find what code is impacted by a change, or answer architectural questions about a codebase."
trigger: always_on
version: 1.0.0
---

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
