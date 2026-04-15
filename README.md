# dotfiles

Personal dotfiles for Linux, macOS, and WSL.
Main entrypoint: `make setup`.

## Requirements

- `git`
- `make`
- `sudo`

Supported environments: Debian, Raspbian, Ubuntu, Zorin OS, macOS, WSL1, WSL2.

## Quick Start

```bash
git clone https://github.com/viasnake/dotfiles.git
cd dotfiles
make setup
```

`make setup` runs:

- `make link`
- `make install`

If needed, set your Git identity in `~/.gitconfig`:

```ini
[user]
  name = <your-name>
  email = <your-email>
```

## Optional: Secrets

`make setup` (or `make install`) creates a local secrets template file for tools that read runtime env vars (for example, Context7):

- `~/.config/secrets/runtime.env.secret`
- The file is created only when missing
- The initial content is comments only

Then edit the file and add actual values as needed:

```bash
cat >> ~/.config/secrets/runtime.env.secret <<'EOF'
CONTEXT7_API_KEY=<your-context7-api-key>
EOF
```

Notes:

- Format: `KEY=VALUE`
- Lines starting with `#` are ignored
- You can override the path with `SECRETS_ENV_FILE`
- Never commit secret files

## Optional: SSH for GitHub

This repo copies SSH config to `~/.ssh/config` on first link only (existing file is kept) and uses `~/.ssh/id_ed25519_personal` for `github`/`github.com`.

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_personal -C "you@example.com"
chmod 600 ~/.ssh/id_ed25519_personal
chmod 644 ~/.ssh/id_ed25519_personal.pub
ssh -T github
```

Add `~/.ssh/id_ed25519_personal.pub` to your GitHub account before running `ssh -T github`.

## Verification

```bash
make opencode_validate
make test-smoke
```

Optional dry-run:

```bash
make -n setup
```

## OpenCode via ocx (personal)

This repository keeps OpenCode config in `config/opencode/` and publishes it into `~/.config/opencode/`.

- Available profiles: `personal`, `work`
- Default profile: `personal`
- Override profile per command: set `OCX_PROFILE=<name>`
- Runtime launcher: `script/opencode/run-with-secrets`

Install tools and link files:

```bash
make install
make link
```

Install the worktree plugin for your profile:

```bash
OCX_PROFILE=personal ocx add kdco/worktree --from https://registry.kdco.dev

# optional: work profile
OCX_PROFILE=work ocx add kdco/worktree --from https://registry.kdco.dev
```

This repository includes a starter worktree config at `.opencode/worktree.jsonc`.
Tune `sync` and `hooks` there as needed for your local workflow.

## Uninstall

```bash
make uninstall
```
