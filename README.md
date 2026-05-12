# dotfiles

Personal dotfiles for macOS, Linux, and WSL2.
Main entrypoint: `make init` (first-time setup) or `make apply` (already installed).

## Manual Prerequisites

Install only what is needed to clone this repository and start `make init`.
`make init` installs `chezmoi` when missing, and chezmoi scripts install the managed tools.

Primary supported OS: macOS, Linux, WSL2.

Minimum commands when the base OS does not already provide them:

```bash
# macOS
xcode-select --install

# Linux / WSL2 (Debian/Ubuntu)
sudo apt-get update
sudo apt-get install -y curl git make
```

Linux / WSL2 setup expects a user that can run `sudo`.

This repository is a chezmoi source state. `.chezmoiroot` points chezmoi at `home/`, so files such as `home/dot_config/fish/config.fish` apply to `~/.config/fish/config.fish`.

## Quick Start

```bash
git clone https://github.com/viasnake/dotfiles.git
cd dotfiles
make init
```

`make init` installs `chezmoi` via the official installer (`https://get.chezmoi.io`) only when missing, then applies this source state.

## Make Targets

- `make apply`: apply all managed files and scripts
- `make init`: install chezmoi if missing, then apply all managed files and scripts
- `make ensure-chezmoi`: install chezmoi to `~/.local/bin` only when missing
- `make apply-scripts`: apply only chezmoi scripts (`home/.chezmoiscripts/`)
- `make dry-run`: show verbose apply plan without mutating target files
- `make status`: show what would change
- `make diff`: show detailed diff of pending changes
- `make verify`: verify target state matches rendered source state
- `make managed`: list managed target paths
- `make test-ubuntu24-container`: run an Ubuntu 24.04 container smoke test for fish/mise bootstrap behavior
- `make test-ubuntu24-container-full`: run full first-time setup in an Ubuntu 24.04 container and verify the real mise config; set `GITHUB_TOKEN` to avoid unauthenticated GitHub API rate limits
- `make remove-managed`: remove all currently managed files and symlinks from target

If needed, set your Git identity in `~/.gitconfig`:

```ini
[user]
  name = <your-name>
  email = <your-email>
```

## Optional: Secrets

OpenCode Context7 API key can be injected directly into `~/.config/opencode/opencode.jsonc` from Bitwarden.
Install `bw` (Bitwarden CLI) only when using these Bitwarden-backed optional settings.

1. Log in to Bitwarden and unlock:

```bash
bw login --apikey   # or: bw login <email> / bw login --sso
bw unlock
```

2. Set Bitwarden item metadata in `~/.config/chezmoi/chezmoi.toml`:
   - `data.bitwarden.runtimeEnvItemId`
   - `data.bitwarden.context7FieldName` (default: `CONTEXT7_API_KEY`)
3. Run `make apply` (or `chezmoi apply`).

Environment-variable overrides are also supported:
- `BW_RUNTIME_ENV_ITEM_ID`
- `BW_CONTEXT7_FIELD_NAME`

If no Bitwarden item is configured, the generated config keeps `"{env:CONTEXT7_API_KEY}"` as a fallback.

## Optional: SSH for GitHub

This repo manages SSH config with chezmoi and uses `~/.ssh/id_ed25519_personal` for `github`/`github.com`.
The key pair can be materialized from Bitwarden attachments.

1. Store private/public key as attachments in one Bitwarden item.
2. Set metadata in `~/.config/chezmoi/chezmoi.toml`:
   - `data.bitwarden.sshKeyItemId`
   - `data.bitwarden.sshPrivateAttachment` (default: `id_ed25519_personal`)
   - `data.bitwarden.sshPublicAttachment` (default: `id_ed25519_personal.pub`)
3. Run `make apply`.

Environment-variable overrides are also supported:
- `BW_SSH_KEY_ITEM_ID`
- `BW_SSH_PRIVATE_ATTACHMENT`
- `BW_SSH_PUBLIC_ATTACHMENT`

Then register `~/.ssh/id_ed25519_personal.pub` in your GitHub account and verify with `ssh -T github`.

## Optional: Fonts

Font provisioning is intentionally manual in this repository.
Install `Firge` / `FirgeNerd` by downloading releases from:

- https://github.com/yuru7/Firge/releases

Example (Linux/macOS):

```bash
mkdir -p ~/.local/share/fonts
unzip -o FirgeNerd_v0.3.0.zip -d ~/.local/share/fonts
unzip -o Firge_v0.3.0.zip -d ~/.local/share/fonts
fc-cache -fv
```

## Verification

```bash
make status
make diff
make dry-run
make test-ubuntu24-container
```

For a full fresh-host check that installs every tool in `home/dot_config/mise/config.toml`, run:

```bash
GITHUB_TOKEN=<github-token> make test-ubuntu24-container-full
```

`script/opencode/validate` and `script/lib/load-secrets-env` are retired.
Validation should be done with chezmoi-native checks and rendered-output inspection.

```bash
make verify
chezmoi --source "$PWD" execute-template --file home/dot_config/opencode/opencode.jsonc.tmpl
```

## OpenCode

This repository keeps OpenCode config in `home/dot_config/opencode/` and publishes it into `~/.config/opencode/` with chezmoi.

Apply with chezmoi:

```bash
make apply
```

Run OpenCode:

```bash
opencode
```

## Remove Managed Files

```bash
make remove-managed
```
