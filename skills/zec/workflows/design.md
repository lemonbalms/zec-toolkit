---
name: zec-workflow-design
description: >
  Strategic consensus workflow through Planner→Architect→Critic deliberation loop.
  Creates consensus-summary.md with RALPLAN-DR structure before SPEC creation.
  Use when planning complex features that need architectural validation.
user-invocable: false
metadata:
  version: "1.0.0"
  category: "workflow"
  status: "active"
  updated: "2026-03-15"
  tags: "design, consensus, architecture, strategy, ralplan"

triggers:
  keywords: ["design", "consult", "architect", "consensus", "strategic"]
  agents: ["manager-strategy", "critic"]
  phases: ["design"]
---

# Design Workflow Orchestration

## Purpose

Strategic consensus through Planner→Architect→Critic deliberation loop. Produces a consensus-summary.md that feeds into `/zec plan` for SPEC creation.

## Scope

- Pre-planning phase: validates approach BEFORE writing SPEC documents
- Output feeds into `/zec plan` as input context
- Optional: skip directly to `/zec plan` for simple features

## Input

- $ARGUMENTS: Feature description (e.g., "사용자 인증 시스템 리팩토링")
- `design review`: Review existing consensus-summary.md
- `--deliberate`: Enable deep analysis (pre-mortem + expanded test plan)

## Supported Flags

- --deliberate: Deep analysis mode for high-risk work (auth, migration, public API, compliance)
- review: Evaluate existing consensus via Critic (e.g., `/zec design review SPEC-AUTH-001`)

## Context Loading

Before execution, load:
- .zec/config/config.yaml
- .zec/project/product.md (product context)
- .zec/project/structure.md (architecture context)
- .zec/project/tech.md (technology context)
- .zec/project/codemaps/ (architecture maps)
- .zec/specs/ directory listing (existing SPECs for context)

---

## Phase Sequence

### Phase 0.1: Planner — Strategy + RALPLAN-DR

Agent: manager-strategy subagent (opus)

Input: User request + project context documents.

Tasks for manager-strategy:
- Analyze the feature request in context of existing architecture
- Identify affected modules, dependencies, and constraints
- Propose implementation strategy with phased approach
- Generate RALPLAN-DR summary:
  - **Principles** (3-5): Core design principles guiding decisions
  - **Decision Drivers** (top 3): Key factors determining the approach
  - **Viable Options** (>=2): Implementation strategies with pros/cons each
  - If only one viable option remains: explicit invalidation rationale for rejected alternatives
- --deliberate mode additions:
  - **Pre-mortem** (3 failure scenarios): What could go wrong
  - **Expanded Test Plan**: unit / integration / e2e / observability coverage

Output: Draft strategy with RALPLAN-DR summary.

[HARD] Phase 0.1 MUST NOT write implementation code. Focus exclusively on analysis and strategy.

### Phase 0.2: Architect Review

Agent: manager-strategy subagent (opus, review mode)

Input: Planner's draft strategy from Phase 0.1.

[HARD] Execute ONLY after Phase 0.1 completes. Do NOT run in parallel.

Tasks:
- Provide strongest steelman counterargument (antithesis) against the favored option
- Identify at least one meaningful tradeoff tension
- Propose synthesis path when possible (combining best aspects of multiple options)
- --deliberate mode: explicitly flag principle violations

Output: Architect review with antithesis, tradeoffs, and synthesis.

### Phase 0.3: Critic Evaluation

Agent: critic subagent (opus)

Input: Planner's strategy + Architect's review from Phase 0.2.

[HARD] Execute ONLY after Phase 0.2 completes. Do NOT run in parallel.

Tasks:
- Verify principle-option consistency
- Verify fair alternative exploration (no shallow dismissals)
- Verify risk mitigation clarity
- Verify testable acceptance criteria
- Verify concrete verification steps
- --deliberate mode: reject if pre-mortem or expanded test plan is missing/weak

Verdict: **APPROVED**, **REVISE** (with specific feedback), or **REJECT** (replanning required)

Output: Critic verdict with detailed reasoning.

### Re-review Loop (max 5 iterations)

If Critic returns REVISE:
1. Collect all feedback from Architect + Critic
2. Pass feedback to Planner (Phase 0.1) for revised strategy
3. Return to Phase 0.2 (Architect reviews revised strategy)
4. Return to Phase 0.3 (Critic evaluates revised strategy)
5. Repeat until APPROVED or max 5 iterations reached
6. If max iterations without approval: present best version to user with note that consensus was not reached

Track iteration count: "Consensus iteration {N}/5"

### Phase 0.4: Consensus Document Creation

Trigger: Critic returns APPROVED.

Create `.zec/specs/SPEC-{ID}/consensus-summary.md` containing:

```markdown
# Consensus Summary — SPEC-{ID}

## RALPLAN-DR

### Principles
1. ...

### Decision Drivers
1. ...

### Viable Options
#### Option A: [Name]
Pros: ...
Cons: ...

#### Option B: [Name]
Pros: ...
Cons: ...

### Recommendation
[Chosen option with rationale]

## ADR (Architecture Decision Record)

- **Decision**: ...
- **Drivers**: ...
- **Alternatives considered**: ...
- **Why chosen**: ...
- **Consequences**: ...
- **Follow-ups**: ...

## Pre-mortem (deliberate mode only)
1. ...
2. ...
3. ...

## Expanded Test Plan (deliberate mode only)
- Unit: ...
- Integration: ...
- E2E: ...
- Observability: ...
```

### Decision Point: Next Action

Tool: AskUserQuestion

Options:
- Start SPEC creation (Recommended): Execute `/zec plan` with consensus-summary.md as input
- Save and continue later: Consensus saved, run `/zec plan` manually when ready
- Revise consensus: Return to Phase 0.1 with additional feedback
- Cancel: Discard consensus

---

## Review Mode

Trigger: `/zec design review` or `/zec design review SPEC-{ID}`

1. Read consensus-summary.md from `.zec/specs/SPEC-{ID}/`
2. Delegate to critic subagent (opus) for re-evaluation
3. Return verdict: APPROVED, REVISE (with feedback), or REJECT

---

## Connection to /zec plan

When `/zec plan` detects `.zec/specs/SPEC-{ID}/consensus-summary.md`:
- Phase 0.5 (Deep Research): Uses consensus direction to scope research
- Phase 1B (SPEC Planning): manager-spec references consensus for EARS conversion
  - Principles → SPEC design principles
  - Decision Drivers → Requirement priorities
  - Chosen Option → Tech stack / architecture decisions
  - ADR → Included in plan.md

When no consensus-summary.md exists:
- `/zec plan` operates normally (direct SPEC creation without strategic consensus)

---

## Completion Criteria

- Planner produced strategy with RALPLAN-DR summary (3-5 principles, top 3 drivers, >=2 options)
- Architect reviewed with antithesis and tradeoff tension
- Critic evaluated and returned APPROVED
- consensus-summary.md created in .zec/specs/SPEC-{ID}/
- ADR section included in final document
- --deliberate: pre-mortem (3 scenarios) + expanded test plan included
- Next action presented to user

---

Version: 1.0.0
Updated: 2026-03-15
