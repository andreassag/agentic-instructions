# Agent Coordination

> How App Builder orchestrates specialist agents.

## Agent Pipeline

```
┌─────────────────────────────────────────────────────────────┐
│                   APP BUILDER (Orchestrator)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              v
┌─────────────────────────────────────────────────────────────┐
│                     PROJECT PLANNER                          │
│  • Task breakdown                                            │
│  • Dependency graph                                          │
│  • File structure planning                                   │
│  • Create {task-slug}.md in project root (MANDATORY)             │
└─────────────────────────────────────────────────────────────┘
                              │
                              v
┌─────────────────────────────────────────────────────────────┐
│              CHECKPOINT: PLAN VERIFICATION                   │
│  [CRITICAL] VERIFY: Does {task-slug}.md exist in project root?       │
│  [CRITICAL] If NO -> STOP -> Create plan file first                    │
│  [CRITICAL] If YES -> Proceed to specialist agents                    │
└─────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          v                   v                   v
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ DATABASE        │ │ BACKEND         │ │ FRONTEND        │
│ ARCHITECT       │ │ SPECIALIST      │ │ SPECIALIST      │
│                 │ │                 │ │                 │
│ • Schema design │ │ • API routes    │ │ • Components    │
│ • Migrations    │ │ • Controllers   │ │ • Pages         │
│ • Seed data     │ │ • Middleware    │ │ • Styling       │
└─────────────────┘ └─────────────────┘ └─────────────────┘
          │                   │                   │
          └───────────────────┼───────────────────┘
                              v
┌─────────────────────────────────────────────────────────────┐
│                 PARALLEL PHASE (Optional)                    │
│  • Security Auditor -> Vulnerability check                   │
│  • Test Engineer -> Unit tests                               │
│  • Performance Optimizer -> Bundle analysis                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              v
┌─────────────────────────────────────────────────────────────┐
│                     DEVOPS ENGINEER                          │
│  • Environment setup                                         │
│  • Preview deployment                                        │
│  • Health check                                              │
└─────────────────────────────────────────────────────────────┘
```

## Execution Order

| Phase | Agent(s) | Parallel? | Prerequisite | CHECKPOINT |
|-------|----------|-----------|--------------|------------|
| 0 | Socratic Gate | [NO] | - | [OK] Ask 3 questions |
| 1 | Project Planner | [NO] | Questions answered | [OK] **{task-slug}.md created** |
| 1.5 | **PLAN VERIFICATION** | [NO] | {task-slug}.md exists | [OK] **File exists in root** |
| 2 | Database Architect | [NO] | Plan ready | Schema defined |
| 3 | Backend Specialist | [NO] | Schema ready | API routes created |
| 4 | Frontend Specialist | [OK] | API ready (partial) | UI components ready |
| 5 | Security Auditor, Test Engineer | [OK] | Code ready | Tests & audit pass |
| 6 | DevOps Engineer | [NO] | All code ready | Deployment ready |

> [CRITICAL] **CRITICAL:** Phase 1.5 is MANDATORY. No specialist agents proceed without {task-slug}.md verification.
