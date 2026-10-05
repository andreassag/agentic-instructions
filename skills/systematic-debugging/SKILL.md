---
name: systematic-debugging
description: 4-phase systematic debugging methodology with root cause analysis and evidence-based verification. Use when debugging complex issues.
when_to_use: "When debugging complex issues, performing root cause analysis, or using evidence-based problem solving. Use with /debug workflow."
allowed-tools: Read, Glob, Grep
version: 1.0.0
---

# Systematic Debugging

> Source: obra/superpowers

## Overview
This skill provides a structured approach to debugging that prevents random guessing and ensures problems are properly understood before solving.

## 4-Phase Debugging Process

### Phase 1: Reproduce
Before fixing, reliably reproduce the issue.

```markdown
## Reproduction Steps
1. [Exact step to reproduce]
2. [Next step]
3. [Expected vs actual result]

## Reproduction Rate
- [ ] Always (100%)
- [ ] Often (50-90%)
- [ ] Sometimes (10-50%)
- [ ] Rare (<10%)
```

### Phase 2: Isolate
Narrow down the source.

```markdown
## Isolation Questions
- When did this start happening?
- What changed recently?
- Does it happen in all environments?
- Can we reproduce with minimal code?
- What's the smallest change that triggers it?
```

### Phase 3: Understand
Find the root cause, not just symptoms.

```markdown
## Root Cause Analysis
### The 5 Whys
1. Why: [First observation]
2. Why: [Deeper reason]
3. Why: [Still deeper]
4. Why: [Getting closer]
5. Why: [Root cause]
```

### Phase 4: Fix & Verify
Fix and verify it's truly fixed.

```markdown
## Fix Verification
- [ ] Bug no longer reproduces
- [ ] Related functionality still works
- [ ] No new issues introduced
- [ ] Test added to prevent regression
```

## Debugging Checklist

```markdown
## Before Starting
- [ ] Can reproduce consistently
- [ ] Have minimal reproduction case
- [ ] Understand expected behavior

## During Investigation
- [ ] Check recent changes (git log)
- [ ] Check logs for errors
- [ ] Add logging if needed
- [ ] Use debugger/breakpoints

## After Fix
- [ ] Root cause documented
- [ ] Fix verified
- [ ] Regression test added
- [ ] Similar code checked
```

## Common Debugging Commands

```bash
# Recent changes
git log --oneline -20
git diff HEAD~5

# Search for pattern
grep -r "errorPattern" --include="*.ts"

# Check logs
pm2 logs app-name --err --lines 100
```

## Anti-Patterns

[NO] **Random changes** - "Maybe if I change this..."
[NO] **Ignoring evidence** - "That can't be the cause"
[NO] **Assuming** - "It must be X" without proof
[NO] **Not reproducing first** - Fixing blindly
[NO] **Stopping at symptoms** - Not finding root cause

---

## /debug Invocation Protocol

When the `/debug` command is used, activate DEBUG mode:

1. **Gather information** — Error message, reproduction steps, expected vs actual, recent changes
2. **Form hypotheses** — List possible causes ordered by likelihood
3. **Investigate systematically** — Test each hypothesis using elimination
4. **Fix and prevent** — Apply fix, explain root cause, add prevention measures

```markdown
## [INSPECT] Debug: [Issue]

### 1. Symptom
[What's happening]

### 2. Information Gathered
- Error: `[error message]`
- File: `[filepath]`

### 3. Hypotheses
1. [Most likely cause]
2. [Second possibility]

### 4. Root Cause
[TARGET] [Explanation]

### 5. Fix
[Code diff or explanation]

### 6. Prevention
[How to prevent recurrence]
```

**Examples:**
```
/debug login not working
/debug API returns 500
/debug form doesn't submit
```
