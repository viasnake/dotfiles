# OpenCode Custom Agents

## Purpose

This directory expands OpenCode with a layered subagent system optimized for high-output engineering work across many repositories, not only this dotfiles repo.

This design is intentionally layered while remaining practical to operate inside stock OpenCode. The goal is not to maximize agent count. The goal is to maximize delivered results by separating control, research, execution, and review responsibilities.

## Location

- Source of truth in this repository: `config/opencode/agents/`
- Runtime location used by OpenCode: `~/.config/opencode/agents/`

The repository directory is the maintained source. Link scripts publish it into the runtime location.

## Design Principles

- Maximize outcomes, not novelty.
- Separate routing, planning, execution, and review.
- Prefer repository fit over generic best practice when the repository already has a clear pattern.
- Keep specialists narrow enough that the caller can choose them reliably.
- Add guardrails for both repository consistency and security.

## Primary Agents

- `build`: default execution mode for implementation, verification, and end-to-end delivery.
- `plan`: read-only planning mode for analysis, design, and change proposals.
- `research`: investigation mode for repository questions, comparisons, and technical discovery.
- `docs`: writing mode for technical documentation, guides, and decision records.

The primary agents are the entrypoints. They own the user-facing workflow. The specialized agents below are supporting workers that the primary agents can call when useful.

## Subagent Inventory

### Control Layer

- `orchestrator`: triages requests, chooses the next specialist, and decides the next best action.
- `planner`: turns a goal into an executable plan with constraints and verification.
- `plan-reviewer`: checks whether a plan is actually executable and blocks only on real issues.
- `work-orchestrator`: drives a multi-step plan to completion and coordinates specialists during execution.

### Research Layer

- `repo-explorer`: finds relevant files, patterns, and impact inside the current repository.
- `docs-researcher`: gathers authoritative external documentation and implementation references.

### Execution Layer

- `implementer`: performs scoped code or config changes end-to-end and verifies results.
- `architect`: provides read-only structural guidance for trade-offs, boundaries, and maintainability.

### Review Layer

- `pattern-guardian`: checks whether a change fits the repository's existing conventions and maintenance style.
- `security-auditor`: checks for security, permission, credential, and secret-handling risks.

## Why There Are 14 Agents

This set is intentionally larger than a minimal setup because outcome quality usually fails at different stages:

- poor routing
- weak planning
- incomplete execution
- repository mismatch
- security blind spots
- weak entrypoint selection for common day-to-day tasks

This configuration is intentionally split into task-oriented primary agents and narrower subagents so that common failure modes can be handled by the right specialist without overloading a single general-purpose agent.

## Which Mode To Start With

- Start with `build` when the expected outcome is a working change.
- Start with `plan` when you want analysis, design, or a safe implementation plan first.
- Start with `research` when the main job is understanding, comparison, or discovery.
- Start with `docs` when the deliverable is documentation.

## Typical Flow

For a large or ambiguous task:

1. A primary agent accepts the task based on the intended outcome.
2. `orchestrator` classifies the request and picks the next specialists when routing is not obvious.
3. `repo-explorer` and `docs-researcher` gather repository and external context.
4. `planner` produces an executable plan when the work is non-trivial.
5. `plan-reviewer` checks for blockers.
6. `work-orchestrator` executes the plan through specialists.
7. `implementer` performs the actual changes.
8. `pattern-guardian` reviews repository fit.
9. `security-auditor` reviews security-sensitive changes.

For a clear implementation task, `build` may route directly to `implementer`, with `pattern-guardian` and `security-auditor` added only when needed.

## Naming Rationale

- `architect` is more explicit than `oracle` because it says what kind of advice is expected.
- `implementer` is broader and more repository-agnostic than `shell-implementer`.
- `pattern-guardian` exists because repository fit is not the same thing as architecture quality.
- `work-orchestrator` is intentionally separate from `orchestrator` so execution tracking does not overload intake and routing.
- `research` and `docs` exist as primary modes because they are common day-to-day workflows, not niche edge cases.

## Maintenance Notes

- Prefer editing prompts incrementally instead of adding more agents.
- Add new agents only when a failure mode cannot be covered by the current layers.
- If future work needs stronger up-front clarification, consider adding a dedicated pre-planning consultant.
- If future work frequently uses screenshots, PDFs, or UI state inspection, consider adding a multimodal reviewer.
