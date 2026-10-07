# dotfiles

Personal terminal and AI agent settings for macOS, Linux, and WSL. Fish is the interactive
shell, including interactive SSH sessions. Bash / zsh remains the account login
shell and hands interactive terminals to Fish after loading the environment.
Non-interactive commands, including SSH remote commands, keep their original shell.
To open Bash or zsh explicitly, run `DOTFILES_NO_FISH=1 bash` or
`DOTFILES_NO_FISH=1 zsh`.

## Setup

Requires Git, curl, Bash, a C linker, and an interactive terminal. macOS uses
Homebrew 7+ (installed if absent); Debian-family Linux / WSL uses apt with root
or sudo. On other Linux distributions, install Fish beforehand.
Install Alacritty and the `Firge35Nerd Console` font separately if you use them.

```sh
./install.sh install    # Default when no action is given
./install.sh reinstall  # Reinstall mise-managed tools, Codex, and termlog
./install.sh update     # Update tools within the configured version constraints
./install.sh uninstall  # Remove managed configuration files; remove is an alias
```

Install, reinstall, and update all apply the repository configuration with review
and backup. Unresolved differences stop the operation without rolling back earlier
changes. Update preserves exact version pins; change `config/mise/config.toml` to
advance them. Reinstall and update refresh Codex, Fisher plugins, and termlog and
update mise itself when selected as a regular binary at `~/.local/bin/mise`. Fish
and a mise installed elsewhere or symlinked remain managed by their original
package manager.

Uninstall removes only the explicitly mapped configuration files, after backing
up each one. A modified file or symlink stops removal before any file is deleted;
back up and move that file manually, then rerun. Tools, plugins, personal settings,
authentication, history, recording logs, and backups remain. Previous configurations
are not restored automatically; the saved `*.backup.*/original` files are available
for manual restoration.

## Personal settings

| File | Purpose |
| --- | --- |
| `~/.gitconfig.local` | Git identity and personal settings |
| `~/.ssh/config.local` | SSH hosts and key paths |
| `~/.config/env.local` | Bash / zsh environment variables |
| `~/.config/env.local.fish` | Fish environment variables |

## AI agents

Setup installs Codex and OpenCode and copies their settings, instructions, agent
definitions, and the bundled `ja-writing-humanizer` skill for both agents.
Set `CONTEXT7_API_KEY` in your local environment for OpenCode's Context7 integration.

Changes made by agents to installed settings must be reviewed and copied back
here to keep them.

To suppress Codex SQLite diagnostics, install `sqlite3` and explicitly select the
log database (normally `~/.codex/logs_2.sqlite`):

```sh
bash script/tools.sh codex-disable-logging "$HOME/.codex/logs_2.sqlite"
```

This unofficial workaround reduces `/feedback` diagnostics. It preserves existing
records; drop the `block_log_inserts` trigger to undo it. Reapply if the database
is recreated.

## Terminal recording

Setup enables terminal recording in Alacritty and in interactive Bash / zsh
sessions that start Fish, including SSH. The latter start recording when termlog
is installed and announce it on screen. Hidden input is excluded, but text printed
on screen is recorded. Run `termlog status` inside the session to check recording.
View a recording from a different session: displaying its own `transcript.log`
inside the recorded terminal records that text again.

To disable automatic recording for Bash / zsh sessions, add
`export DOTFILES_NO_TERMLOG=1` to `~/.config/env.local` before opening a new session.
This prevents new recordings; it does not stop a recorder already enclosing a shell.

To disable recording, change Alacritty's shell setting:

```toml
[terminal.shell]
program = "/bin/bash"
args = ["-lc", "exec fish"]
```
Existing logs remain; a later setup offers to restore the recording setting.
