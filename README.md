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
make skills-install
make skills-update
make skills-update-dry-run
make test-ubuntu-container
make test-ubuntu24-container
make test-ubuntu24-container-full
make test-macos-docker-osx-preflight
make test-macos-docker-osx-smoke
make remove-managed
```

## Agent Skills

Desired GitHub-backed skills are listed in:

```text
agent-skills.tsv
```

Install or update them with:

```bash
make skills-install
make skills-update
```

The default agent is `codex`. Override it when needed:

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
chezmoi --source "$PWD" apply --dry-run --verbose
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
