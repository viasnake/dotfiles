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

Create a local secrets file for tools that read runtime env vars (for example, Context7):

```bash
mkdir -p ~/.config/secrets
chmod 700 ~/.config/secrets
cat > ~/.config/secrets/runtime.env.secret <<'EOF'
CONTEXT7_API_KEY=<your-context7-api-key>
EOF
chmod 600 ~/.config/secrets/runtime.env.secret
```

Notes:

- Format: `KEY=VALUE`
- Lines starting with `#` are ignored
- You can override the path with `SECRETS_ENV_FILE`
- Never commit secret files

## Optional: SSH for GitHub

This repo links SSH config that uses `~/.ssh/id_ed25519_personal` for `github`/`github.com`.

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

## Uninstall

```bash
make uninstall
```
