#!/usr/bin/env bash

set -euo pipefail

cd "$HOME/dotfiles"

mode="${DOTFILES_CONTAINER_TEST_MODE:-smoke}"

if [[ "$mode" == "full" ]]; then
  make init
else
  make ensure-chezmoi
  "$HOME/.local/bin/chezmoi" --source "$PWD" apply --exclude=scripts
  mkdir -p "$HOME/.config/mise"
  printf '[tools]\nnode = "25.6.0"\n' >"$HOME/.config/mise/config.toml"
  : >"$HOME/.config/fish/fish_plugins"
  "$HOME/.local/bin/chezmoi" --source "$PWD" apply --include=scripts
fi

fish_path="$(command -v fish)"
login_shell="$(getent passwd "$(id -un)" | awk -F: '{ print $7 }')"

if [[ "$login_shell" != "$fish_path" ]]; then
  printf 'login shell mismatch: expected %s, got %s\n' "$fish_path" "$login_shell" >&2
  exit 1
fi

if ! grep -qxF "$fish_path" /etc/shells; then
  printf 'fish path is missing from /etc/shells: %s\n' "$fish_path" >&2
  exit 1
fi

fish -lc 'command -q mise; and mise --version >/dev/null'

if [[ "$mode" == "full" ]]; then
  fish -lc 'command -q jq; and jq --version >/dev/null'
  fish -lc 'command -q rg; and rg --version >/dev/null'
  fish -lc 'command -q fzf; and command -q ghq; and command -q zoxide'
  fish -lc 'command -q codex'
  mise where jq >/dev/null
  mise where rg >/dev/null
  mise where fzf >/dev/null
  mise where ghq >/dev/null
  mise where zoxide >/dev/null
else
  fish -lc 'command -q node; and node --version | string match -q "v25.6.0"'
  mise where node >/dev/null
fi
