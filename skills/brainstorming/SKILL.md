---
name: brainstorming
description: Socratic questioning protocol + user communication. MANDATORY for complex requests, new features, or unclear requirements. Includes progress reporting and error handling.
when_to_use: "When exploring options before implementation, clarifying requirements, or when the user needs creative problem-solving. Use with /brainstorm workflow."
allowed-tools: Read, Glob, Grep
version: 1.0.0
---

# Brainstorming & Communication Protocol

> **MANDATORY:** Use for complex/vague requests, new features, updates.

---

## [STOP] SOCRATIC GATE (ENFORCEMENT)

### When to Trigger

| Pattern | Action |
|---------|--------|
| "Build/Create/Make [thing]" without details | [STOP] ASK 3 questions |
| Complex feature or architecture | [STOP] Clarify before implementing |
| Update/change request | [STOP] Confirm scope |
| Vague requirements | [STOP] Ask purpose, users, constraints |

### [THINK] Memory Check (2026.5.13 — Before Questioning)

> Before asking questions, check if past context exists:

```
0. CHECK MEMORY — Does .agents/memory/MEMORY.md exist?
   -> YES: Read index. Apply relevant past decisions silently.
          Skip questions already answered in memory.
   -> NO: Proceed with standard Socratic Gate.
```

### [FORBIDDEN] MANDATORY: 3 Questions Before Implementation

1. **STOP** - Do NOT start coding
2. **CHECK** - Read `.agents/memory/` for past context on this topic
3. **ASK** - Minimum 3 questions (skip any already answered via memory):
   - [TARGET] Purpose: What problem are you solving?
   - [TEAM] Users: Who will use this?
   - [PACKAGE] Scope: Must-have vs nice-to-have?
4. **WAIT** - Get response before proceeding
5. **SAVE** - After brainstorming, save key decisions: `/remember [decision]`

---

## [THINK] Dynamic Question Generation

**[PROHIBITED] NEVER use static templates.** Read `dynamic-questioning.md` for principles.

### Core Principles

| Principle | Meaning |
|-----------|---------|
| **Questions Reveal Consequences** | Each question connects to an architectural decision |
| **Context Before Content** | Understand greenfield/feature/refactor/debug context first |
| **Minimum Viable Questions** | Each question must eliminate implementation paths |
| **Generate Data, Not Assumptions** | Don't guess—ask with trade-offs |

### Question Generation Process

```
1. Parse request -> Extract domain, features, scale indicators
2. Identify decision points -> Blocking vs. deferable
3. Generate questions -> Priority: P0 (blocking) > P1 (high-leverage) > P2 (nice-to-have)
4. Format with trade-offs -> What, Why, Options, Default
```

### Question Format (MANDATORY)

```markdown
### [PRIORITY] **[DECISION POINT]**

**Question:** [Clear question]

**Why This Matters:**
- [Architectural consequence]
- [Affects: cost/complexity/timeline/scale]

**Options:**
| Option | Pros | Cons | Best For |
|--------|------|------|----------|
| A | [+] | [-] | [Use case] |

**If Not Specified:** [Default + rationale]
```

**For detailed domain-specific question banks and algorithms**, see: `dynamic-questioning.md`

---

## Progress Reporting (PRINCIPLE-BASED)

**PRINCIPLE:** Transparency builds trust. Status must be visible and actionable.

### Status Board Format

| Agent | Status | Current Task | Progress |
|-------|--------|--------------|----------|
| [Agent Name] | [OK][SYNC][PENDING][NO][WARNING] | [Task description] | [% or count] |

### Status Icons

| Icon | Meaning | Usage |
|------|---------|-------|
| [OK] | Completed | Task finished successfully |
| [SYNC] | Running | Currently executing |
| [PENDING] | Waiting | Blocked, waiting for dependency |
| [NO] | Error | Failed, needs attention |
| [WARNING] | Warning | Potential issue, not blocking |

---

## Error Handling (PRINCIPLE-BASED)

**PRINCIPLE:** Errors are opportunities for clear communication.

### Error Response Pattern

```
1. Acknowledge the error
2. Explain what happened (user-friendly)
3. Offer specific solutions with trade-offs
4. Ask user to choose or provide alternative
```

### Error Categories

| Category | Response Strategy |
|----------|-------------------|
| **Port Conflict** | Offer alternative port or close existing |
| **Dependency Missing** | Auto-install or ask permission |
| **Build Failure** | Show specific error + suggested fix |
| **Unclear Error** | Ask for specifics: screenshot, console output |

---

## Completion Message (PRINCIPLE-BASED)

**PRINCIPLE:** Celebrate success, guide next steps.

### Completion Structure

```
1. Success confirmation (celebrate briefly)
2. Summary of what was done (concrete)
3. How to verify/test (actionable)
4. Next steps suggestion (proactive)
```

---

## Communication Principles

| Principle | Implementation |
|-----------|----------------|
| **Concise** | No unnecessary details, get to point |
| **Visual** | Use emojis ([OK][SYNC][PENDING][NO]) for quick scanning |
| **Specific** | "~2 minutes" not "wait a bit" |
| **Alternatives** | Offer multiple paths when stuck |
| **Proactive** | Suggest next step after completion |

---

## Anti-Patterns (AVOID)

| Anti-Pattern | Why |
|--------------|-----|
| Jumping to solutions before understanding | Wastes time on wrong problem |
| Assuming requirements without asking | Creates wrong output |
| Over-engineering first version | Delays value delivery |
| Ignoring constraints | Creates unusable solutions |
| "I think" phrases | Uncertainty -> Ask instead |

---

---

## /brainstorm Invocation Protocol

When the `/brainstorm` command is used, activate BRAINSTORM mode:

1. **Understand the goal** — What problem? Who is the user? What constraints?
2. **Generate options** — Provide at least 3 different approaches with pros/cons
3. **Compare and recommend** — Summarize tradeoffs, give a recommendation with reasoning

**No code** — this is about ideas, not implementation.

```markdown
## [THINK] Brainstorm: [Topic]

### Context
[Brief problem statement]

---

### Option A: [Name]
[Description]

[OK] **Pros:** [benefits]
[NO] **Cons:** [drawbacks]
[METRICS] **Effort:** Low | Medium | High

---

### Option B / C: [Name]
[Similar structure]

---

## [NOTE] Recommendation
**Option [X]** because [reasoning].

What direction would you like to explore?
```

**Examples:**
```
/brainstorm authentication system
/brainstorm state management for complex form
/brainstorm database schema for social app
```
