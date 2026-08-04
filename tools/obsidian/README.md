# obsidian Integration

`obsidian` provides notes and knowledge base synchronisation.
The LLM agent calls `obsidian` directly at runtime when syncing or reading notes.

## Expected CLI Contract

```bash
obsidian sync [--vault <path>]      # Sync vault to/from remote
obsidian search "<query>" [--vault <path>]  # Search notes
```

## Availability
`obsidian` is symlinked into `.agent/tools/obsidian` at `hub init` time.
If the binary is absent, the no-op `stub.sh` is symlinked instead.
