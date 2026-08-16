# Scoped Rules & Protocols

Rules in Agentic Instructions are focused, language- and domain-specific markdown guidelines deployed into `.agents/rules/`. They include core protocols, universal behavioral rules, technology guidelines, and tool proxies.

---

## Trigger Types

Rules use YAML frontmatter to define when and how they are injected into the agent's context:

| Trigger | Description | Usage |
|---|---|---|
| `always_on` | Injected unconditionally into every agent context | Core protocol, universal safety rules, request routing, tool proxies (`rtk`, `qmd`, `graphify`) |
| `glob` | Injected dynamically when files matching the glob pattern are read or edited | Language guidelines (`go`, `rust`, `python`, `typescript`, `docker`, `bash`, `nextflow`, `r`, `cpp`) and UI design rules |
| `model_decision` | Injected on-demand when the model decides it is relevant | Code writing rules, quick reference lookups |
| `manual` | Injected only when explicitly referenced by the user | Manual checklists and runbooks |

---

## Core & Universal Rules Catalog

| Rule File | Trigger | Description |
|---|---|---|
| **`core-protocol.md`** | `always_on` | Root execution protocol: load agents/skills first, plan before coding, verify after changes. |
| **`universal-rules.md`** | `always_on` | Safety standards: non-destructive edits, secret protection, zero unwanted file deletion. |
| **`request-routing.md`** | `always_on` | Auto-classification matrix to route user prompts to the best specialist agent. |
| **`code-rules.md`** | `model_decision` | Coding heuristics: Socratic gate, plan mode enforcement, type safety standards. |
| **`design-rules.md`** | `glob` (`*.tsx,*.jsx,*.css,...`) | Modern aesthetic rules: design systems, typography, color harmony, responsiveness. |
| **`quick-reference.md`** | `model_decision` | Fast index of all agents, skills, and validation scripts. |

---

## Companion YAML Architecture

In source control (`instructions/tech/` and `instructions/tools/`), instructions remain **pure markdown** to preserve platform portability. Platform-specific trigger metadata is co-located in a companion `.yaml` file:

```
instructions/
├── tech/
│   ├── go.md          # Pure Markdown guidelines
│   └── go.yaml        # Antigravity trigger metadata
```

### Generated Rule in `.agents/rules/go.md`
During `hub init`, the engine combines the metadata and markdown into the finalized rule:

```markdown
---
trigger: glob
glob: "*.go,**/*.go,go.mod,go.sum"
description: Go (Golang) technical guidelines, package architecture, error handling, and service lifecycle.
---

# Go Technical Guidelines
...
```
