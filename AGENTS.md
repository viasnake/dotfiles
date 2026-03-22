# AGENTS.md

## Scope
This file is the repository-local operating guide for coding agents in this dotfiles repo.
It applies from `/home/sysadmin/dotfiles` downward.

The repository is mostly Bash scripts plus configuration files.
There is no traditional compile/build artifact.
Verification is done by targeted `make` targets, direct script checks, and Bats tests.

## Rule Sources Checked
- `.cursor/rules/`: not present (searched recursively)
- `.cursorrules`: not present (searched recursively)
- `.github/copilot-instructions.md`: not present (searched recursively)
- existing agent guidance: `config/codex/AGENTS.md`, `config/opencode/AGENTS.md`
- shared style guidance: `config/opencode/instructions/coding-style.md`

If Cursor or Copilot rule files are added later, treat them as additional instructions with repository scope.

## Repository Shape
- `Makefile`: canonical entry point for setup and test workflows.
- `script/bootstrap`: dispatches install/link/unlink operations.
- `script/opencode/validate`: strongest style and validation reference for modern scripts.
- `script/lib/load-secrets-env`: reference for Bash function design and env-file parsing.
- `test/*.bats`: unit tests for shell helpers and validators.
- `config/`: managed dotfiles and agent/tool configuration (JSON/JSONC/TOML/Markdown).

Older scripts under `script/linux/`, `script/macos/`, and `misc/` may use looser patterns.
Preserve behavior there, but prefer modern conventions when touching code.

## Working Principles
- Make small, auditable, reversible changes.
- Inspect before editing; do not guess structure.
- Keep Linux and macOS behavior aligned unless differences are real and documented.
- Avoid machine-specific assumptions unless the repository already requires them.
- Never commit secrets, generated credentials, or host-local runtime state.

## Build, Lint, and Test Commands

### Setup and bootstrap commands
- `make setup` - full local setup (`link` + `install`).
- `make link` / `make unlink` - manage symlinks into `$HOME`.
- `make install` / `make uninstall` - install or remove platform dependencies.
- `make install_fonts` / `make uninstall_fonts` - font installation lifecycle.
- `make clean` - shorthand for `uninstall` + `unlink`.

### Validation and smoke checks
- `make opencode_validate` - validate OpenCode config and skill layout.
- `script/opencode/validate` - same validator without `make` wrapper.
- `make -n setup` - dry-run of setup commands (safe operational preview).
- `make test-smoke` - runs `opencode_validate` and dry-run setup.

### Unit tests (Bats)
- `make test-unit` - run Bats tests if `bats` exists, otherwise fallback via `mise`.
- `make test` - full test suite (`test-smoke` then `test-unit`).
- `bats test` - direct all-unit run (when `bats` is installed).

### Lint and security
- `pre-commit run --all-files` - run all configured hooks.
- `pre-commit run gitleaks --all-files` - run secret scanning hook only.

Current pre-commit config only includes `gitleaks`; there is no separate formatter/linter suite.

## Single-Test Guidance (Important)
Use the narrowest possible check that covers your edit.

### Single Bats file
- `bats test/opencode-validate.bats`
- `bats test/load-secrets-env.bats`

### Single Bats test case
- `bats --filter "validate fails when playwright MCP entry exists" test/opencode-validate.bats`
- If `bats` is missing: `MISE_WARN_MISSING_TOOLS=0 mise x bats -- bats --filter "<test name>" test/<file>.bats`

### Non-Bats targeted checks
- `script/opencode/validate` for config/skill validation changes.
- `make -n setup` for bootstrap wiring and command-flow verification.

If new test frameworks are introduced later, add exact single-test selectors here.

## Change-Based Verification Matrix
- Edited `config/opencode/opencode.jsonc` or `config/opencode/skills/**`: run `make opencode_validate`.
- Edited `script/opencode/validate`: run `script/opencode/validate` and `bats test/opencode-validate.bats`.
- Edited `script/lib/load-secrets-env`: run `bats test/load-secrets-env.bats`.
- Edited `Makefile` test/setup targets: run `make test-smoke` and at least one relevant `bats` file.
- Edited install/link/unlink scripts: run the narrowest script-level check plus `make -n setup`.
- Edited anything potentially affecting secrets/repo safety: run `pre-commit run --all-files` when practical.

## Code Style Guidelines
Follow existing repository patterns first.
Primary references: `script/opencode/validate` and `script/lib/load-secrets-env`.

### Language and typing approach
- Bash is the primary implementation language.
- Embedded Python is allowed for structured parsing/validation tasks.
- There is no static type-checking pipeline; enforce correctness with explicit checks and tests.
- Treat JSON/JSONC/TOML schemas as contracts; validate required keys and value types explicitly.

### Imports and dependencies
- In Python snippets, keep imports at the top and prefer standard library modules.
- In shell scripts, treat external binaries as dependencies and check availability when needed.
- Do not introduce new runtime dependencies unless necessary and documented.

### Formatting
- Bash: 2-space indentation, no tabs.
- Embedded Python: 4-space indentation.
- JSON/JSONC: stable 2-space indentation.
- TOML: preserve existing grouping and key order unless reorganization improves clarity.
- End every file with a trailing newline.

### Naming
- Use descriptive, intention-revealing names.
- Functions: verb phrases (`load_runtime_secrets_env`).
- Variables: lowercase snake_case for locals; uppercase for script-level constants/env-derived config.
- Booleans should read as predicates: `is_*`, `has_*`, `can_*`, `should_*`.
- Avoid unexplained abbreviations except common terms (`JSON`, `URL`, `SSH`, `MCP`).

### Bash conventions
- Prefer `#!/usr/bin/env bash`.
- Prefer `set -euo pipefail` for new or substantially modified scripts.
- Use `[[ ... ]]` for Bash conditionals.
- Quote expansions unless unquoted behavior is intentionally required.
- Use `local` inside functions for non-global variables.
- Prefer `printf` over `echo` when exact output/escaping matters.
- Resolve repo-relative paths via `BASH_SOURCE[0]`, not caller working directory.

### Error handling
- Fail fast on invalid args, missing files, and invalid config shape.
- Never swallow errors silently; if ignoring input is intentional, do it explicitly.
- Emit actionable errors to stderr with failure context and next-check hint.
- Use non-zero exit status on validation/contract failures.
- Prefer diagnosable behavior over compact but opaque helpers.

### Comments and documentation
- Write comments in English.
- Explain why/constraints/trade-offs, not obvious mechanics.
- Keep comments synchronized with behavior; delete stale comments quickly.
- When behavior or workflow changes, update nearby docs (`README.md`, this file, or related docs).

### Configuration editing
- Preserve existing schema and key stability in managed config files.
- Avoid unrelated reformatting/noise diffs.
- Keep skill directory names and frontmatter `name` aligned.
- Use environment-variable placeholders for secret-bearing values.

### Cross-platform compatibility
- Validate both Linux and macOS paths when touching shared setup logic.
- Avoid GNU-only/BSD-only flags unless the same portability pattern already exists in repo.

## Verification and Reporting Expectations
- Report exactly which commands were executed.
- If a command was skipped to avoid machine mutation, state that explicitly.
- Do not claim full validation when only static inspection was performed.
- Prefer targeted checks before broad setup operations.

## Default Behavior for Agents
When uncertain, mimic patterns from `script/opencode/validate` and `script/lib/load-secrets-env`.
Choose the narrowest meaningful validation command for the changed area.
Call out assumptions and any unverified platform-specific behavior.
