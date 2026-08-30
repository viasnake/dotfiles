# dotfiles

Personal terminal dotfiles for macOS, Linux, and WSL.

## Setup

```bash
git clone https://github.com/viasnake/dotfiles.git
cd dotfiles
./install.sh
```

`install.sh` links the configuration, installs mise when needed, installs the
configured mise tools, and updates Fisher plugins when Fish is available. Git
and curl are required; install Fish separately if it is not already present.

## Managed configuration

- Bash
- Fish and Fisher plugins
- Git
- SSH client
- mise and global tools
- Ghostty configuration

Git identity, SSH hosts and keys, and environment secrets remain local. Put
them in `~/.gitconfig.local`, `~/.ssh/config.local`, `~/.config/env.local`, and
`~/.config/env.local.fish` as needed. The Ghostty configuration expects
`Firge35Nerd Console`, but this repository does not install the font.

## Explicitly not managed

- GUI applications
- OS configuration
- Fonts
- Agent configuration
- Secrets
- VM or server provisioning

Files left in `$HOME` by older versions of this repository are not migrated or
removed automatically. Remove obsolete files manually after reviewing them.

## Update

```bash
git pull
./install.sh
```
