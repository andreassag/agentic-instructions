# Tool Usage: graphify (Knowledge Graph)

`graphify` maintains an AST & semantic knowledge graph of this codebase in `graphify-out/`.

## When to Use
- Before answering questions about overall architecture, dependencies, or data flows.
- When searching for cross-file connections or tracing call paths.

## Usage Commands
- `graphify update .` — Incrementally update graph after code changes.
- `graphify query "<question>"` — Query the knowledge graph for relevant nodes and relationships.
- `graphify path "<source_node>" "<target_node>"` — Find shortest path between two code concepts.
- `graphify explain "<concept>"` — Plain-language explanation of a component or module.
