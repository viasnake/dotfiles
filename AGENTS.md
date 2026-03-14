# AGENTS.md

## Scope
This is the repository-local guide for coding agents working in this dotfiles repo.
It applies at the repository root and below.

This repository is primarily shell scripts plus configuration files.
There is no conventional application build step.
Verification is mostly done through targeted `make` targets, script entry points, and config validation.

## Rule Sources Checked
- `.cursor/rules/`: not present
- `.cursorrules`: not present
- `.github/copilot-instructions.md`: not present
- existing agent guidance: `config/codex/AGENTS.md`, `config/opencode/AGENTS.md`
- shared style guidance: `config/opencode/instructions/coding-style.md`

If Cursor or Copilot rules are added later, treat them as additional repository instructions.

## Repository Shape
- `Makefile` is the main entry point for repeatable operations.
- `script/` contains operational Bash scripts.
- `config/` contains dotfiles, agent config, JSON/JSONC/TOML config, and instruction docs.
- `script/dot` is the strongest reference for current shell style.
- older scripts under `script/linux/`, `script/macos/`, and `misc/` are looser; preserve behavior, but prefer the newer conventions when editing.

## Working Principles
- make small, auditable changes
- inspect before editing
- prefer reversible changes
- keep Linux and macOS behavior aligned unless the difference is real and documented
- avoid machine-specific assumptions unless the repo already relies on them
- never commit secrets, generated credentials, or machine-local runtime state

## Canonical Commands

### Setup / bootstrap
- `make setup` - full setup: `link`, `install`, `dot-bootstrap`
- `make link` - create symlinks into the home directory
- `make install` - install platform dependencies
- `make dot-bootstrap` - link public repo, then run work sync and SSH sync when applicable

### Validation / sync
- `make opencode_validate` - validate OpenCode provider catalog/profile consistency
- `script/opencode/validate personal` - validate a specific profile
- `script/opencode/validate work` - validate a specific profile
- `make opencode_sync` - regenerate `config/opencode/opencode.jsonc`
- `script/opencode/sync personal` - sync a specific profile

### Operational checks
- `make dot-work-status` - inspect work-profile state
- `make dot-work-sync` - update and relink the work repository
- `make dot-ssh-status` - inspect SSH key presence, modes, and fingerprints
- `make dot-ssh-test` - run SSH config checks for `github` and optional work host
- `./script/dot ssh test` - direct targeted SSH verification

### Lint / security
- `pre-commit run --all-files` - run configured hooks
- `pre-commit run gitleaks --all-files` - run the only configured hook directly

## Single-Test Guidance
There is no unit-test framework with per-test selectors such as `pytest path::test_name` or `go test -run`.

For the closest equivalent of a single targeted check, run the narrowest script or target that covers the edited area:
- `script/opencode/validate personal`
- `script/opencode/sync personal`
- `./script/dot ssh test`
- `./script/dot ssh status`
- `./script/dot work status`
- `./script/dot work sync`

If a real test framework is added later, update this file with exact single-test syntax.

## When To Run Which Check
- after editing `config/opencode/providers/*` or `config/opencode/opencode.jsonc`, run `make opencode_validate` and usually `make opencode_sync`
- after editing `script/dot` or SSH config, run `make dot-ssh-status` and `make dot-ssh-test` when safe
- after editing bootstrap/install/link logic, run the narrowest affected script or `make` target rather than `make setup` unless end-to-end verification is necessary
- after editing anything that could affect secrets or repo contents, run `pre-commit run --all-files` when practical

## Code Style
Use repository conventions first.
The best concrete references are `script/dot`, `script/opencode/validate`, `script/opencode/sync`, and `script/lib/load-secrets-env`.

### Language mix
- Bash is the primary implementation language.
- Small embedded Python snippets are used for structured JSON validation and transformation.
- JSON, JSONC, TOML, SSH config, and shell config files are maintained source, not generated noise.

### Imports and dependencies
- in embedded Python, keep imports at the top of the snippet
- prefer standard library imports unless the repo already depends on something external
- in shell, treat external commands as dependencies and validate them with `require_cmd` when absence would make behavior unclear

### Formatting
- use 2 spaces for shell indentation
- use 4 spaces for embedded Python indentation
- keep JSON and JSONC pretty-printed with 2-space indentation
- keep TOML compact and stable; preserve existing grouping unless regrouping helps comprehension
- end files with a trailing newline

### Bash conventions
- prefer `#!/usr/bin/env bash`
- prefer `set -euo pipefail` for new or significantly edited Bash scripts
- use uppercase names for script-level constants and env-derived configuration
- use lowercase snake_case for function names and local variables
- quote expansions unless unquoted behavior is intentionally required
- prefer `[[ ... ]]` in Bash-specific code
- declare non-global function variables with `local`
- prefer `printf` over `echo` when escaping or exact output matters
- resolve repo-relative paths from `BASH_SOURCE[0]`, not from the caller's working directory

### Python conventions
- keep Python snippets small, explicit, and single-purpose
- prefer straightforward loops and checks over compact clever expressions
- use descriptive names like `catalog_path`, `profile_path`, `allowed_ids`, and `enabled_count`
- use explicit UTF-8 file reads/writes
- exit non-zero on validation failure and print actionable messages to stderr

### Naming
- use descriptive names that reveal intent
- functions should use verbs
- types or classes, if introduced later, should use nouns
- boolean names should read as predicates: `is_*`, `has_*`, `can_*`, `should_*`
- avoid negative boolean names when a positive form is possible
- avoid unexplained abbreviations except standard ones like `SSH`, `JSON`, `MCP`, and `URL`

### Error handling
- fail fast on invalid arguments, missing files, and missing required commands
- never swallow errors silently
- if continuing after a failure is intentional, do it explicitly and log why
- make error messages say what failed and what to check next
- use stderr for error output
- prefer diagnosable behavior over over-abstracted helpers

### Comments and docs
- write comments in English
- comment the reason, constraint, or trade-off, not the obvious mechanics
- avoid comments that only narrate the next line
- when workflow changes, update nearby docs such as `README.md` or this file

### Configuration editing
- preserve stable schemas in JSON/TOML config files
- avoid unrelated reformatting
- keep provider IDs unique and profile `allowed_ids` aligned with the catalog
- prefer environment-variable placeholders for secret-bearing commands

### Cross-platform behavior
- check both Linux and macOS script paths before changing shared setup behavior
- do not assume GNU-only or BSD-only flags without checking compatibility patterns already used in the repo

## Verification Expectations
- report exactly which commands were run
- if a command was skipped because it would mutate machine state, say so explicitly
- do not claim full validation when only static inspection was done
- prefer targeted validation before broad bootstrap commands

## Default Behavior
When unsure, follow the patterns in `script/dot` and `script/opencode/validate`, run the narrowest relevant validation command, and call out any unverified platform-specific behavior.
