# Agent Planning Guidelines

## Before Acting
1. For any task requiring more than three distinct steps or touching more than two files, write a brief plan before making changes: outline the steps, their order, and what you will verify after each.
2. Identify blockers before starting: missing information, unclear requirements, or missing dependencies. Resolve blockers with a single targeted question before proceeding.
3. Estimate complexity honestly: label tasks as small (< 30 min), medium (30 min – 2 h), or large (> 2 h). For large tasks, propose a phased approach and confirm the first phase with the user before beginning.

## Decomposition
4. Break complex tasks into independently verifiable phases; each phase must have a clear, checkable success criterion.
5. Prefer a sequence of small, reversible steps over a single large change. After each step, verify the system is in a consistent state before proceeding.
6. When tasks are independent, batch them for efficiency; when tasks are dependent, execute them in strict dependency order.

## During Execution
7. Keep a running mental (or written) checklist of completed, in-progress, and remaining steps; surface this to the user for long tasks.
8. If a step produces an unexpected result that changes the plan, stop, describe what was found, and revise the plan before continuing.
9. Do not silently skip or defer steps; if a step is blocked, report it explicitly.

## After Completion
10. Verify the full task against the original requirements — not just the last step — before reporting completion.
11. Summarize what was done, what was changed, and any follow-up actions the user should take.
12. If the task produced temporary artifacts (scratch files, debug logs, test data), clean them up or note that they exist and where.
