# dotfiles

Personal dotfiles for macOS, Linux, and WSL2.

This repository is a chezmoi source state. `.chezmoiroot` points chezmoi at
`home/`, so files under `home/` are rendered into `$HOME`.

## Quick Start

Install the minimum tools needed to clone this repository and run `make`.

```bash
# macOS
xcode-select --install

# Debian / Ubuntu / WSL2
sudo apt-get update
sudo apt-get install -y curl git make
```

Then apply the dotfiles:

```bash
git clone https://github.com/viasnake/dotfiles.git
cd dotfiles
make init
```

## Tool Ownership

- chezmoi owns configuration deployment and orchestration.
- The OS package manager owns system and bootstrap dependencies.
- mise owns versioned user tools and language runtimes.
- Fisher owns Fish plugins listed in `home/dot_config/fish/fish_plugins`.
- Vendor-specific installers are used only when a tool requires its own distribution. Codex CLI uses OpenAI's standalone installer.

On macOS, Homebrew is used only for system packages that are not provided by
macOS, such as Fish and SQLite. It is not a general-purpose user CLI manager.

The mise bootstrap writes `mise` to `~/.local/bin/mise` when no existing mise
executable is available. The standard shell integrations in the managed Bash
and Fish configuration expose that path and mise-managed tools.

## Local Settings

User-specific chezmoi data belongs in:

```text
~/.config/chezmoi/chezmoi.toml
```

The managed template for that file is:

```text
home/dot_config/chezmoi/create_private_chezmoi.toml.tmpl
```

Use it for profile names, Git identity, Bitwarden item IDs, and SSH attachment
names. To apply a different profile once:

```bash
DOTFILES_PROFILE=work make apply
```

Bitwarden-backed secrets and SSH keys require an unlocked Bitwarden session:

```bash
bw login --apikey
export BW_SESSION="$(bw unlock --raw)"
make apply
```

## Commands

Run `make help` for the current target list.

Common targets:

```bash
make init
make apply
make dry-run
make status
make diff
make verify
make managed
```

Make targets print command boundaries through `script/log-run` so long
`chezmoi`, `gh`, and container logs are easier to scan. Disable color when
needed:

```bash
DOTFILES_LOG_COLOR=never make dry-run
```

Additional maintenance targets:

```bash
make apply-scripts
make skills-check
make skills-install
make skills-update
make skills-update-dry-run
make test-shell-path
make test-ubuntu-container
make test-ubuntu24-container
make test-ubuntu24-container-full
make test-macos-docker-osx-preflight
make test-macos-docker-osx-smoke
make remove-managed
```

## Codex SQLite Diagnostic Logging

On Linux and macOS, each `chezmoi apply` checks the active Codex SQLite
directory and creates a `block_log_inserts` trigger in `logs_2.sqlite`. The
trigger discards new diagnostic records while leaving conversation, goal, and
application-state databases unchanged.

This is an unofficial safeguard for excessive diagnostic-log writes. It
reduces the local data available to `/feedback` and OpenAI Support. To collect
diagnostics again, stop Codex processes and remove the trigger:

```bash
sqlite3 "${CODEX_SQLITE_HOME:-${CODEX_HOME:-$HOME/.codex}}/logs_2.sqlite" \
  "DROP TRIGGER IF EXISTS block_log_inserts;"
```

Adjust the path when `sqlite_home` is set in `config.toml`. A later
`chezmoi apply` recreates the trigger.

## Agent Skills

Desired GitHub-backed skills are listed in:

```text
agent-skills.tsv
```

Install or update them with:

```bash
make skills-check
make skills-install
make skills-update
```

By default, installation targets both `codex` and `opencode`. Override the
target list when needed:

```bash
make skills-install SKILL_AGENTS="codex opencode"
```

For a single target agent, `SKILL_AGENT` remains supported:

```bash
make skills-install SKILL_AGENT=opencode
```

## OpenCode

OpenCode config lives in:

```text
home/dot_config/opencode/
```

Apply it with chezmoi and run OpenCode normally:

```bash
make apply
opencode
```

## Fonts

Font installation is manual. The Ghostty config expects Firge Nerd fonts:

```text
https://github.com/yuru7/Firge/releases
```

## Verification

Use dry-runs before applying broad changes:

```bash
make dry-run
chezmoi --source "$PWD" apply --dry-run --verbose --force --no-pager
```

For Ubuntu container checks:

```bash
make test-ubuntu-container
GITHUB_TOKEN=<github-token> make test-ubuntu-container-full
```

By default, `make test-ubuntu-container` validates Ubuntu 20.04 and 26.04.
Set `UBUNTU_TEST_VERSIONS` to override the matrix:

```bash
make test-ubuntu-container UBUNTU_TEST_VERSIONS="20.04 24.04 26.04"
```

Compatibility targets remain available for single-version checks:

```bash
make test-ubuntu20-container
make test-ubuntu24-container
make test-ubuntu26-container
```

macOS-in-Docker validation uses Docker-OSX and requires an x86_64 host with
KVM exposed at `/dev/kvm` and enough Docker storage for the image/runtime disk.
Check those host prerequisites with:

```bash
make test-macos-docker-osx-preflight
```

To verify that Docker-OSX can actually start QEMU with KVM on the current host:

```bash
make test-macos-docker-osx-smoke
```

This is a container/KVM smoke test. A full macOS guest dotfiles apply still
requires a booted and provisioned macOS image that accepts SSH.
