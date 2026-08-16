# CLI Reference

The `hub` CLI is the main command-line interface for managing agentic instruction profiles.

---

## Global Flags

| Flag | Description |
|---|---|
| `--hub-home <path>` | Override root directory of agentic-instructions |
| `--dry-run` | Preview actions without modifying any files on disk |
| `--verbose` | Enable verbose trace output (`set -x`) |
| `--no-color` | Disable colored terminal output |
| `-v, --version` | Display hub version |
| `-h, --help` | Display general help message |
| `--help-all` | Display help with complete profile and platform catalogs |

---

## Commands

### `hub init`

Initializes hub in the current Git repository with a specified profile.

```bash
hub init --profile <name> [--platform <platform>] [--force]
```

**Flags:**
- `--profile <name>` *(Required)*: Profile manifest name (e.g. `backend-go`, `full-stack-ts`, `systems-rust`).
- `--platform <platform>`: Target assistant platform (default: `antigravity`).
- `--force`: Force initialization even if lock or existing files are present.

**Example:**
```bash
hub init --profile backend-go
```

---

### `hub load`

Loads a named stack profile into the current repository (shortcut for switching profiles).

```bash
hub load <profile-name> [--platform <platform>] [--force]
```

**Example:**
```bash
hub load full-stack-ts
```

---

### `hub update`

Re-reads the currently loaded profile from `.agents/state.json` and updates all rules, subagents, and skills.

```bash
hub update [--force]
```

**Example:**
```bash
hub update
```

---

### `hub status`

Displays the active configuration, loaded profile, and initialization metadata.

```bash
hub status [--json]
```

**Flags:**
- `--json`: Output status as structured JSON.

**Example:**
```bash
hub status --json
```

---

### `hub clean`

Removes hub-managed configuration directories and external tool artifacts.

```bash
hub clean [--platform <platform>]
```

**Cleaned Targets:**
- `.agents/` and `.agent/`
- `graphify-out/`
- `.qmd/` and `.cache/qmd/`
- Platform-specific markers

> [!NOTE]
> `hub clean` will **never** alter or overwrite your project's `.gitignore` file.
