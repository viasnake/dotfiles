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

Profile support can manage your Git identity. If you do not use profiles, set it in `~/.config/git` or another local Git include:

```ini
[user]
  name = <your-name>
  email = <your-email>
```

## Profiles

Profiles separate work/personal credentials while keeping a single chezmoi source state.
The active profile is selected at apply time from `~/.config/chezmoi/chezmoi.toml`:

```toml
[data.profile]
active = "personal"

[data.profiles.personal]
runtimeEnvItemId = "<personal-bitwarden-item-id-with-api-key-custom-fields>"
sshKeyItemId = "<personal-bitwarden-item-id-with-ssh-key-attachments>"
sshPrivateAttachment = "id_ed25519_personal"
sshPublicAttachment = "id_ed25519_personal.pub"

[data.profiles.personal.git]
name = "<your-personal-name>"
email = "<your-personal-email>"

[data.profiles.work]
runtimeEnvItemId = "<work-bitwarden-item-id-with-api-key-custom-fields>"
sshKeyItemId = "<work-bitwarden-item-id-with-ssh-key-attachments>"
sshPrivateAttachment = "id_ed25519_work"
sshPublicAttachment = "id_ed25519_work.pub"

[data.profiles.work.git]
name = "<your-work-name>"
email = "<your-work-email>"
```

Run `make apply` after changing `data.profile.active`.
For one-off renders, override the selected profile with `DOTFILES_PROFILE=work make apply`.

The generated Git identity is written to `~/.config/dotfiles/git-profile` and included from `~/.gitconfig`.
The existing `~/.config/git` include remains available for local machine-specific Git settings.

## Secrets with Bitwarden

Bitwarden is the standard place for SSH keys and API keys in this repository.
Using the repository without Bitwarden is still supported; in that case secret-backed files are skipped and commands that need those credentials must receive them another way.

`bw` (Bitwarden CLI) is managed by mise. Before applying Bitwarden-backed secrets, log in and export a session:

```bash
bw login --apikey   # or: bw login <email> / bw login --sso
export BW_SESSION="$(bw unlock --raw)"
```

Set Bitwarden item metadata under the active profile in `~/.config/chezmoi/chezmoi.toml`:

```toml
[data.profile]
active = "personal"

[data.profiles.personal]
runtimeEnvItemId = "<bitwarden-item-id-with-api-key-custom-fields>"
sshKeyItemId = "<bitwarden-item-id-with-ssh-key-attachments>"
```

The runtime env item is read from custom fields and rendered to private shell env files:

- `~/.config/dotfiles/secrets.env` for Bash-compatible shells
- `~/.config/dotfiles/secrets.fish` for Fish

Default custom field names:

- `CONTEXT7_API_KEY`
- `GITHUB_TOKEN`

Override the rendered field list with `data.profiles.<name>.runtimeEnvFields`.
`BW_RUNTIME_ENV_ITEM_ID` can be used as an environment-variable override.
The legacy `data.bitwarden.runtimeEnvItemId` and `data.bitwarden.runtimeEnvFields` keys are still supported when no active profile is configured.

OpenCode reads Context7 through `"{env:CONTEXT7_API_KEY}"`, so the same generated env files are the source of truth for local shells and OpenCode.

## SSH for GitHub

This repo manages SSH config with chezmoi and uses `~/.ssh/id_ed25519_personal` for `github`/`github.com`.
The key pair can be materialized from Bitwarden attachments.

1. Store private/public key as attachments in one Bitwarden item.
2. Set metadata in `~/.config/chezmoi/chezmoi.toml`:
   - `data.profiles.<name>.sshKeyItemId`
   - `data.profiles.<name>.sshPrivateAttachment` (default: `id_ed25519_personal`)
   - `data.profiles.<name>.sshPublicAttachment` (default: `id_ed25519_personal.pub`)
3. Run `make apply`.

Environment-variable overrides are also supported:
- `BW_SSH_KEY_ITEM_ID`
- `BW_SSH_PRIVATE_ATTACHMENT`
- `BW_SSH_PUBLIC_ATTACHMENT`

Then register `~/.ssh/id_ed25519_personal.pub` in your GitHub account and verify with `ssh -T github`.

If Bitwarden metadata, `bw`, or `BW_SESSION` is missing, chezmoi skips the secret env files and SSH key materialization rather than writing empty key files.
The legacy `data.bitwarden.sshKeyItemId`, `data.bitwarden.sshPrivateAttachment`, and `data.bitwarden.sshPublicAttachment` keys are still supported when no active profile is configured.

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

## Agent Skills

Agent skills are managed by GitHub CLI `gh skill`.

This repository keeps only the desired GitHub-backed skill list in:

```text
agent-skills.tsv
```

Install the listed skills for Codex user scope:

```bash
make skills-install
```

The install target passes `--force` by default so bootstrap runs non-interactively. Override with `SKILL_INSTALL_FLAGS=` when you want `gh skill install` to protect existing local edits.

Install the same list for another supported agent by overriding `SKILL_AGENT`:

```bash
make skills-install SKILL_AGENT=opencode
```

Update installed skills with:

```bash
make skills-update
```

`gh skill` injects source tracking metadata into installed skills, and `gh skill update` uses that metadata for future updates. This repository no longer publishes `SKILL.md` copies into `~/.agents/skills/` with chezmoi.

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
