# dotfiles

Personal terminal dotfiles for macOS, Linux, and WSL. Plain Shell scripts and
configuration files: edit them directly to change how the machine is set up.

## Setup

Git, curl, Bash, Python 3, and a C linker are required. Run setup in an
interactive terminal. Fish is installed through Homebrew on macOS
(Homebrew is installed if missing), or apt-get on Debian / Ubuntu / WSL.
Linux package installation requires root or sudo. On other distributions,
install Fish with your package manager first.

```sh
git clone https://github.com/viasnake/dotfiles.git
cd dotfiles
./install.sh
```

The entrypoint runs three ordinary Bash scripts in order:

- `script/copy.sh`: copy configuration files except Ghostty into your home directory.
- `script/tools.sh`: install Fish, mise, mise tools (including Rust), and Fisher plugins.
- `script/termlog.sh`: install termlog, verify recording, and configure Ghostty.

You can run the steps yourself. Run the copy step before the first tool install:

```sh
bash script/copy.sh
bash script/tools.sh
bash script/termlog.sh
```

Configuration is installed as independent files, so local edits (including
changes made by tools) do not modify this repository.

- Missing files are copied. Identical regular files are left untouched.
- Different files show a unified diff: local contents first, repository contents
  second. Choose `y` to back up and replace, Enter / `n` to keep, or `q` to quit.
- Existing file symlinks require confirmation even if their contents match.
  Replacement creates a regular file without modifying the symlink's referent.
- Before an approved replacement, the old contents are saved beside the target
  in `<filename>.backup.XXXXXX/original`; the exact path is printed. A broken
  symlink is backed up as a symlink. Backups remain until you remove them.
- Directories, special files, and symlinked parent directories require manual
  migration. They are reported and left untouched.
- Without a terminal on stdin, conflicts are kept and reported; piped `yes`
  cannot approve replacements. No files needing confirmation are overwritten.

If any file is kept or needs manual migration, the copy step returns a nonzero
status, and `install.sh` does not proceed to tool installation. Review the pending
files and rerun interactively. New or approved copies from earlier in the run
remain in place. You can deliberately retain a local version and run
`bash script/tools.sh` separately once you have reviewed the configuration.

## Shells: Bash / zsh for programs, Fish for people

Keep the account login shell as Bash on Linux / WSL, or zsh on macOS.
Setup does not run `chsh` or change `/bin/sh`. If an older setup made Fish your
login shell, run `chsh -s /bin/bash` on Linux or `chsh -s /bin/zsh` on macOS,
then log out and back in.

Ghostty starts `termlog run -- /bin/bash -lc 'exec fish'`: recording begins,
then Bash loads the login environment and Fish provides the interactive terminal. In other terminals, configure the
same command, or run `fish` yourself. Bash / zsh startup files never switch to
Fish automatically. Fish keeps an inherited Bash / zsh / sh `SHELL`, falling
back to `/bin/zsh` on macOS or `/bin/bash` elsewhere.

- `config/shell/env.sh` uses POSIX syntax for shared PATH and local environment.
- Bash loads it through `.bashrc`; `.bash_profile` also reads the existing
  `.profile` and `.bashrc` for login sessions.
- zsh loads it through `.zshenv` and again after the system login configuration
  through `.zprofile` (including macOS PATH setup).
- mise shims expose tools without interactive hooks. Interactive Bash, zsh,
  and Fish additionally enable mise activation for project environments.
- Fish owns the prompt, zoxide, and fzf integration.

Use `#!/bin/sh` for portable POSIX scripts or `#!/usr/bin/env bash` for Bash
scripts. Bash and zsh also have their own extensions; neither is being forced
into POSIX mode here. Agent-specific shell settings, when present, should name
Bash or zsh. `SHELL` alone does not override every application's shell selection.
A standalone non-login `bash -c` inherits its environment; from a clean process,
use `bash -lc` or explicitly source `~/.config/shell/env.sh`.

## Change or extend

- Add a configuration file under `config/` and a `copy_file` line in
  `script/copy.sh`.
- Add tool versions to `config/mise/config.toml` and Fish plugins to
  `config/fish/fish_plugins`.
- Add installation commands directly to `script/tools.sh`. For a larger task,
  create another Bash script and call it explicitly from `install.sh`.
- Edit the matching file under `config/`, then run `bash script/copy.sh` to
  apply shared changes. Edit installed files directly for machine-only changes;
  future runs will ask before replacing those differences.

No Makefile, task framework, automatic script discovery, or test suite is
required. There is no test CI; changes are checked manually on the machines
where these dotfiles are used.

## Local settings

Keep identity, hosts, and secrets outside this repository:

| File | Contents |
| --- | --- |
| `~/.gitconfig.local` | Git identity and machine-specific Git settings |
| `~/.ssh/config.local` | SSH hosts and key paths |
| `~/.config/env.local` | POSIX `export NAME=value` statements for Bash / zsh |
| `~/.config/env.local.fish` | Fish-specific `set -gx NAME value` statements |

Fish launched through the Ghostty command inherits exported variables from
`env.local`. A Fish session started without that parent environment needs its
own `env.local.fish`. Keep environment files quiet and safe to source repeatedly.
The default configuration paths under `~/.config` and zsh files under `$HOME`
are assumed; custom XDG_CONFIG_HOME / ZDOTDIR layouts require editing the copy destinations
and startup files.

Ghostty expects `Firge35Nerd Console`; install the font separately. GUI apps,
OS provisioning, agent configuration files, and secrets are not installed.
Files left by older versions are not migrated or removed automatically.

## Update

```sh
git pull
./install.sh
```

Pinned mise versions stay pinned; `latest` / `stable` and Fisher plugins can
change on subsequent installs.

## Terminal recording

`./install.sh` always installs [termlog](https://github.com/viasnake/termlog)
from the commit pinned in `script/termlog.sh` into `~/.local/bin`. No separate
checkout or option is needed. After a recording smoke test succeeds, it configures
Ghostty with the absolute binary path, preserving other existing Ghostty settings
and backing up changes. New installations use `config/ghostty/config` as a template.
Subsequent runs keep recording enabled.

Safe mode is configured in `config/termlog/config.toml`.
Hidden input is excluded; text printed on screen is recorded.

Logs go to `~/.local/state/termlog/YYYY-MM-DD/session-UUID/` (or under
`$XDG_STATE_HOME/termlog`). Use `termlog status`, `termlog search 'pattern'`, or
`termlog show UUID`. To disable recording, restore
`command = /bin/bash -lc 'exec fish'`; existing logs remain. Running setup
again enables recording.

## References

- [Earlier Shell-based layout](https://github.com/viasnake/dotfiles/tree/3d59ef03d51b5d841b60568f5fb871ef29c92bc4)
- [Fish for interaction and a separate shell for programs](https://www.heyuan110.com/posts/linux/2026-04-18-fish-shell-rust-2026/)
- [mise shims](https://mise.jdx.dev/dev-tools/shims.html)
- [Ghostty command configuration](https://ghostty.org/docs/config/reference#command)
