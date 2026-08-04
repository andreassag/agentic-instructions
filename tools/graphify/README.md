# graphify Integration

`graphify` generates a visual or text-based graph of a repository's code structure.
It is used **at runtime** by the LLM agent to understand repository composition
when asked to explore, navigate, or reason about the codebase structure.

## Expected CLI Contract

```bash
graphify [<path>]              # Graph the given directory (defaults to cwd)
graphify --format text [<path>] # Text output (suitable for LLM context)
graphify --format dot [<path>]  # DOT format for Graphviz
```

## Invocation Model
`graphify` is symlinked into `.agent/tools/graphify` at `hub init` time.
The LLM agent invokes it directly when needed — hub itself never calls `graphify`.

## Availability
If the binary is absent, the no-op `stub.sh` is symlinked instead.
