# AGENTS.md

## Scope
This file is the repository-local operating guide for coding agents in this dotfiles repo.
It applies from `/home/sysadmin/dotfiles` downward.

The repository is a chezmoi source state plus managed configuration files.
There is no traditional compile/build artifact.
Verification is done by targeted `make` targets and chezmoi dry-runs.

## Rule Sources Checked
- `.cursor/rules/`: not present (searched recursively)
- `.cursorrules`: not present (searched recursively)
- `.github/copilot-instructions.md`: not present (searched recursively)
- existing agent guidance: `home/dot_codex/AGENTS.md`, `home/dot_config/opencode/AGENTS.md`
- shared style guidance: `home/dot_config/opencode/instructions/coding-style.md`

If Cursor or Copilot rule files are added later, treat them as additional instructions with repository scope.

## Repository Shape
- `Makefile`: canonical entry point for chezmoi apply/inspect workflows.
- `.chezmoiroot`: points chezmoi at `home/` as the source state.
- `home/`: chezmoi-managed dotfiles, templates, and scripts.
- `home/.chezmoiscripts/`: chezmoi-native setup hooks (`run_onchange_before_` / `run_onchange_after_`).

## Working Principles
- Make small, auditable, reversible changes.
- Inspect before editing; do not guess structure.
- Keep Linux and macOS behavior aligned unless differences are real and documented.
- Avoid machine-specific assumptions unless the repository already requires them.
- Never commit secrets, generated credentials, or host-local runtime state.

## Build and Validation Commands

### Setup commands
- `make apply` - full chezmoi apply.
- `make apply-scripts` - run only chezmoi scripts (`chezmoi apply --include=scripts`).
- `make remove-managed` - remove current chezmoi-managed file/symlink targets from the target home.

### Inspection commands
- `make status` - show managed target differences.
- `make diff` - show full managed diff.
- `make managed` - list managed target paths.

### Validation checks
- `make dry-run` - dry-run apply flow.
- `make verify` - verify managed target state.
- `chezmoi --source "$PWD" apply --dry-run --verbose` - template/render validation without mutation.

## Change-Based Verification Matrix
- Edited `home/.chezmoiscripts/**`: run `make dry-run` and `chezmoi --source "$PWD" apply --include=scripts --dry-run --verbose`.
- Edited `home/dot_config/opencode/**`: run `chezmoi --source "$PWD" apply --dry-run --verbose`.
- Edited `Makefile` targets: run `make help`, `make dry-run`, and `make managed`.
- Edited Bitwarden-backed templates (`*.tmpl` under `home/`): run `chezmoi --source "$PWD" execute-template --file <template>` and `chezmoi --source "$PWD" apply --dry-run --verbose`.
- Edited anything potentially affecting secrets/repo safety: inspect the diff and run the narrowest relevant checks.

## Code Style Guidelines
Follow existing repository patterns first.
Primary references: `home/.chezmoiscripts/*` and existing `home/**.tmpl` files.

### Language and typing approach
- Bash is used in chezmoi scripts where shell behavior is required.
- Template logic should stay in chezmoi templates (`*.tmpl`) when possible.
- For JSON/JSONC/TOML, treat schemas as contracts and preserve key stability.

### Formatting
- Bash: 2-space indentation, no tabs.
- JSON/JSONC: stable 2-space indentation.
- TOML: preserve existing grouping and key order unless reorganization improves clarity.
- End every file with a trailing newline.

### Bash conventions
- Prefer `#!/usr/bin/env bash`.
- Prefer `set -euo pipefail` for new or substantially modified scripts.
- Use `[[ ... ]]` for Bash conditionals.
- Quote expansions unless unquoted behavior is intentionally required.
- Prefer `printf` over `echo` when exact output/escaping matters.

### Comments and documentation
- Write comments in English.
- Explain why/constraints/trade-offs, not obvious mechanics.
- Keep comments synchronized with behavior; delete stale comments quickly.
- When behavior or workflow changes, update nearby docs (`README.md`, this file, or related docs).

### Configuration editing
- Preserve existing schema and key stability in managed config files.
- Avoid unrelated reformatting/noise diffs.
- Keep skill directory names and frontmatter `name` aligned.
- Use Bitwarden-backed templates or environment placeholders for secret-bearing values.

## Verification and Reporting Expectations
- Report exactly which commands were executed.
- If a command was skipped to avoid machine mutation, state that explicitly.
- Do not claim full validation when only static inspection was performed.
- Prefer targeted checks before broad setup operations.

## Default Behavior for Agents
When uncertain, prefer chezmoi-native mechanisms over ad-hoc shell wrappers.
Choose the narrowest meaningful validation command for the changed area.
Call out assumptions and any unverified platform-specific behavior.
