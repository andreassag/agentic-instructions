---
name: repro-test
description: Generates a minimal reproduction script from a failing test or error log to isolate the root cause.
---

# Repro Test Skill

Run this skill when a test is failing or an error is difficult to isolate.
It produces a minimal standalone script that reproduces the issue outside the full project context.

## Trigger

`/repro` or `repro-test`

## What this skill does

1. Identifies the failing test or error message in the current context.
2. Extracts the minimal set of inputs, imports, and setup required to reproduce it.
3. Writes a self-contained `repro.py` / `repro.sh` / `repro.r` script to the project root.
4. Confirms the reproduction script actually fails before reporting it.

## Usage notes

- Provide the error log or failing test output before invoking this skill.
- The agent will not modify the production codebase — only create the repro script.
- Delete the repro script after the bug is fixed.
