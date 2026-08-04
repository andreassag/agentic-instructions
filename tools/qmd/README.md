# qmd (Quick Markdown Query) Integration

`qmd` provides fast searching and querying across Markdown documentation files.
The LLM agent calls `qmd` directly at runtime when searching knowledge bases or project docs.

## Expected CLI Contract

```bash
qmd search "<query>" [--path <dir>]   # Search markdown files for query
qmd grep "<pattern>" [--path <dir>]   # Regex grep across markdown files
```

## Availability
`qmd` is symlinked into `.agent/tools/qmd` at `hub init` time.
If the binary is absent, the no-op `stub.sh` is symlinked instead.
