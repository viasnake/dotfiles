#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MISE_BIN=""

info() {
  printf 'dotfiles: %s\n' "$1"
}

link_file() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [[ -d "$target_path" && ! -L "$target_path" ]]; then
    printf 'dotfiles: cannot replace directory with file link: %s\n' "$target_path" >&2
    exit 1
  fi

  ln -sfn "$source_path" "$target_path"
  info "linked $target_path"
}

load_homebrew_path() {
  local brew_path

  for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_path" ]]; then
      eval "$("$brew_path" shellenv)"
      return
    fi
  done
}

ensure_mise() {
  if command -v mise >/dev/null 2>&1; then
    MISE_BIN="$(command -v mise)"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    printf 'dotfiles: curl is required to install mise.\n' >&2
    exit 1
  fi

  info "installing mise"
  curl -fsSL https://mise.run | env \
    MISE_INSTALL_PATH="$HOME/.local/bin/mise" \
    MISE_INSTALL_SKIP_IF_EXISTS=1 \
    sh

  MISE_BIN="$HOME/.local/bin/mise"
  if [[ ! -x "$MISE_BIN" ]]; then
    printf 'dotfiles: mise installation failed: %s was not created.\n' "$MISE_BIN" >&2
    exit 1
  fi
}

update_fisher_plugins() {
  if ! command -v fish >/dev/null 2>&1; then
    info "Fish is not installed; linked its configuration without installing plugins"
    return
  fi

  if ! fish -c 'functions -q fisher'; then
    if ! command -v curl >/dev/null 2>&1; then
      printf 'dotfiles: curl is required to install Fisher.\n' >&2
      exit 1
    fi

    info "installing Fisher"
    fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher'
  fi

  info "updating Fisher plugins"
  fish -c 'fisher update'
}

load_homebrew_path
mkdir -p "$HOME/.local/bin" "$HOME/.config" "$HOME/.ssh/config.d"
chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"

link_file "$ROOT/config/bash/.bashrc" "$HOME/.bashrc"
link_file "$ROOT/config/fish/config.fish" "$HOME/.config/fish/config.fish"
link_file "$ROOT/config/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"
link_file "$ROOT/config/fish/functions/fish_greeting.fish" "$HOME/.config/fish/functions/fish_greeting.fish"
link_file "$ROOT/config/git/.gitconfig" "$HOME/.gitconfig"
link_file "$ROOT/config/ssh/config" "$HOME/.ssh/config"
link_file "$ROOT/config/ssh/config.d/00-base.conf" "$HOME/.ssh/config.d/00-base.conf"
link_file "$ROOT/config/ghostty/config" "$HOME/.config/ghostty/config"
link_file "$ROOT/config/mise/config.toml" "$HOME/.config/mise/config.toml"

export PATH="$HOME/.local/bin:$PATH"
ensure_mise
info "installing mise tools"
"$MISE_BIN" install --yes
update_fisher_plugins

info "setup complete"
