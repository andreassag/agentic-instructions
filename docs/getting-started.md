# Getting Started

Get up and running with `agentic-instructions` in seconds.

---

## 1. Installation

### Quick Install (Automated)

Run the bootstrap installer to download prerequisites (`jq`, `yq`, `rtk`, `graphify`, `qmd`) and add `hub` to your PATH:

```bash
curl -fsSL https://raw.githubusercontent.com/andreassag/agentic-instructions/main/install.sh | bash
```

### Install Specific Version

You can pin the installation to a specific release tag or branch using `--version`:

```bash
curl -fsSL https://raw.githubusercontent.com/andreassag/agentic-instructions/main/install.sh | bash -s -- --version v1.0.0
```

### Manual Install / From Source

Clone the repository and install dependencies locally:

```bash
git clone https://github.com/andreassag/agentic-instructions.git ~/.agentic-instructions
cd ~/.agentic-instructions
bash install.sh
```

To install a specific version from source:

```bash
git clone --depth=1 -b v1.0.0 https://github.com/andreassag/agentic-instructions.git ~/.agentic-instructions
cd ~/.agentic-instructions
bash install.sh --version v1.0.0
```

Ensure `~/.local/bin` is in your `$PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

---

## 2. Initialize in a Project

Navigate to any Git repository and initialize a profile tailored to your stack:

```bash
cd /path/to/your/project

# Example: Initialize Go backend profile
hub init --profile backend-go-engineer

# Example: Initialize TypeScript web profile
hub init --profile full-stack-ts

# Example: Initialize Rust systems profile
hub init --profile systems-rust
```

---

## 3. What Gets Deployed?

When you run `hub init`, Hub automatically scaffolds the target workspace:

1. **`.agents/rules/`**:
   - Technical guidelines with trigger frontmatter (e.g. `go.md`, `typescript.md`, `docker.md`, `bash.md`).
   - Global tool rules (`rtk.md`, `qmd.md`, `graphify.md`).
2. **`.agents/agents/`**:
   - 7 autonomous subagents ready for task delegation.
3. **`.agents/skills/`**:
   - Runnable skill scripts for testing, linting, formatting, and security auditing.
4. **`.agents/state.json`**:
   - Metadata tracking active profile, initialization timestamp, and platform targets.

---

## 4. Basic Workflow

```bash
# Check current project status
hub status

# Switch to a different profile
hub load ml-python

# Re-apply configuration after repository updates
hub update

# Remove hub configurations and generated tool artifacts
hub clean
```
