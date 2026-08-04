# rtk (Token Stripper) Integration

`rtk` is invoked **at build time** by `hub init` and `hub update` to strip redundant tokens
from the composed instruction context before writing to platform files.
`rtk` is **never** symlinked into target projects — it is only used by hub itself.

## Expected CLI Contract

```bash
# Reads from stdin, writes stripped output to stdout
rtk strip --max-tokens <N>
```

Example:
```bash
cat instructions.md | rtk strip --max-tokens 8000
```

## Enforcement
`hub init` will **fail** if `rtk` is not installed unless `--no-strip` is passed.
