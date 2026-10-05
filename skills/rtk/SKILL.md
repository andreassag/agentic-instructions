]633;E;} > skills/rtk/SKILL.md;4dca41da-d3d2-4e13-b9d9-67c852f2f14a]633;C---
name: rtk
description: RTK token-optimized CLI command proxy. Prefix any CLI command with `rtk` to filter boilerplate and compress outputs (60-90% token savings).
when_to_use: "Always active when running CLI commands, tests, builds, git operations, or any shell command where output verbosity wastes context tokens."
trigger: always_on
version: 1.0.0
---

# Tool: rtk (Token Compressor)
Prefix CLI commands with `rtk` to filter boilerplate and compress outputs (60-90% token savings).

## Meta Wrappers
- `rtk err <cmd>` (errors/warnings only) | `rtk test <cmd>` (failing tests only) | `rtk summary <cmd>` (2-line summary)
- `rtk diff [args]` (compact diff) | `rtk json [--keys-only]` | `rtk deps` | `rtk env` | `rtk pipe <filter>`

## Proxies
- **Git/Forge**: `rtk git (status|diff|log|branch|show|add|commit)`, `rtk gh (pr|issue|run)`, `rtk glab`
- **Files/Search**: `rtk ls`, `rtk tree`, `rtk read <file>`, `rtk find`, `rtk grep|rg "<pat>"`, `rtk wc`
- **Lang/Test**: `rtk cargo (test|build|clippy)`, `rtk go (test|build|vet)`, `rtk pytest`, `rtk ruff (check|format)`, `rtk mypy`, `rtk npm/pnpm run`, `rtk tsc`, `rtk vitest|jest`
- **Infra/Net**: `rtk docker`, `rtk kubectl`, `rtk curl` (auto-json), `rtk wget`, `rtk psql`, `rtk log`
