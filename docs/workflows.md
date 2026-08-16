# Workflows & Command Procedures

Workflows in Agentic Instructions are structured multi-step execution procedures deployed into `.agents/workflows/`. They guide agents through systematic task execution, verification, and multi-agent coordination.

---

## Complete Catalog of Workflows

| Command | Workflow File | Primary Agent | Description |
|---|---|---|---|
| `/brainstorm` | `workflows/brainstorm.md` | `project-planner` | Structured idea exploration and architecture discovery before implementation. |
| `/create` | `workflows/create.md` | `orchestrator`, `project-planner` | End-to-end new application scaffolding with interactive user dialogue. |
| `/debug` | `workflows/debug.md` | `debugger` | Systematic defect isolation, hypothesis testing, and minimal reproduction fixes. |
| `/deploy` | `workflows/deploy.md` | `devops-engineer` | Production release pre-flight verification, deployment execution, and rollback strategies. |
| `/enhance` | `workflows/enhance.md` | `code-archaeologist` | Iterative feature addition and targeted refactoring for existing codebases. |
| `/orchestrate` | `workflows/orchestrate.md` | `orchestrator` | Multi-agent coordination matrix for complex cross-domain objectives. |
| `/plan` | `workflows/plan.md` | `project-planner` | Project planning and implementation blueprint generation (zero code edits). |
| `/preview` | `workflows/preview.md` | `frontend-specialist` | Local development server management and live UI preview validation. |
| `/status` | `workflows/status.md` | `orchestrator` | Displays project progress boards and multi-agent task state. |
| `/test` | `workflows/test.md` | `test-engineer` | Test suite generation, execution, and coverage analysis. |
| `/verify` | `workflows/verify.md` | `test-engineer` | Runtime proof-of-work verification confirming code modifications succeed without regressions. |

---

## Workflow Structure & Schema

Each workflow in `workflows/<name>.md` is defined with YAML frontmatter:

```markdown
---
name: plan
description: Create project plan using project-planner agent. No code writing - only plan file generation.
version: 1.0.0
requires_agents: project-planner
requires_skills: plan-writing, architecture
artifact_outputs: implementation-plan
---

# /plan - Project Planning Mode

When this command is triggered:
1. Initialize the project-planner agent.
2. Formulate implementation milestones and file changes.
3. Generate the implementation plan artifact for user review.
```
