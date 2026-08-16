# Skills & Execution Harnesses

Agentic Instructions deploys a unified suite of **50+ skills** into `.agents/skills/`. This combines automated language execution harnesses with specialized cognitive procedures and domain guides (API design, React performance, database schema design, red-team tactics, and more).

---

## 1. Automated Language Execution Harnesses

| Category | Scripts Location | Description |
|---|---|---|
| **Test Runner** | `skills/test-runner/scripts/{go,rust,python,ts,cpp,bash,nextflow,r}.sh` | Runs language test suites with failure isolation |
| **Code Linting** | `skills/code-linting/scripts/{go,rust,python,ts,cpp,bash,docker,nextflow,r}.sh` | Static analysis, type checking, and style linters |
| **Code Formatting** | `skills/code-formatting/scripts/{go,rust,python,ts,cpp,bash,nextflow,r}.sh` | In-place AST-based source code formatters |
| **Dependency Management** | `skills/dependency-management/scripts/{go,rust,python,ts,r}.sh` | Dependency tree audits and lockfile synchronization |
| **Secret Scanning** | `skills/secret-scanning/scripts/secret-scan.sh` | Git commit history secret scanner |
| **Git Workflow** | `skills/git-workflow/scripts/commit-lint.sh` | Conventional Commit validator |
| **Changelog Automation** | `skills/changelog-automation/scripts/changelog-entry.sh` | Automated changelog entry generator |

---

## 2. Cognitive & Domain Specialized Skills

| Domain | Skills | Description |
|---|---|---|
| **Architecture & Planning** | `architecture`, `plan-writing`, `brainstorming`, `parallel-agents`, `context-compression`, `design-spec`, `documentation-templates` | Systems architecture, milestone planning, multi-agent dispatch, and context compression |
| **Full-Stack & Web** | `nextjs-react-expert`, `frontend-architecture`, `frontend-design`, `tailwind-patterns`, `nodejs-best-practices`, `app-builder` | React / Next.js optimization, UI/UX audits, accessibility checks, Tailwind, and Node.js best practices |
| **Backend & APIs** | `api-patterns`, `database-design`, `server-management`, `python-patterns`, `rust-pro`, `bash-linux`, `deployment-procedures` | REST/GraphQL/tRPC patterns, schema validation, indexing, server operations, and deployment procedures |
| **Quality & Verification** | `clean-code`, `systematic-debugging`, `tdd-workflow`, `test-runner`, `verify-changes`, `code-linting`, `webapp-testing` | Code simplification, hypothesis-driven debugging, TDD, Playwright, pre-flight checklists, and verification runners |
| **Security & Auditing** | `vulnerability-scanner`, `red-team-tactics`, `code-review-checklist`, `secret-scanning` | OWASP threat detection, penetration vectors, and dependency risk analysis |
| **Specialized Capabilities** | `mcp-builder`, `intelligent-routing`, `i18n-localization`, `geo-fundamentals`, `seo-fundamentals`, `performance-profiling`, `batch-operations`, `skillify` | MCP server development, request routing, SEO, profiling, batch editing, and meta-skill creation |

> [!NOTE]
> Codebase knowledge graphing is powered by the **Graphify** tool proxy (`instructions/tools/graphify.md`) which builds SQLite AST graphs and calculates dependency blast radiuses.

---

## Skill Architecture

Each skill in `skills/<name>/` contains:
1. `SKILL.md`: YAML frontmatter and step-by-step instructions loaded by the agent on demand.
2. Optional `scripts/` directory containing executable automation tools.

```markdown
---
name: clean-code
description: Apply clean code principles, refactoring heuristics, and code simplification patterns.
version: 1.0.0
---

# Clean Code Guidelines
...
```
