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

  if [[ -L "$target_path" ]]; then
    ln -sfn "$source_path" "$target_path"
  elif [[ -e "$target_path" ]]; then
    printf 'dotfiles: refusing to replace existing non-symlink: %s\n' "$target_path" >&2
    exit 1
  else
    ln -s "$source_path" "$target_path"
  fi

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

ensure_fish() {
  if command -v fish >/dev/null 2>&1; then
    return
  fi

  case "$(uname -s)" in
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        if ! command -v curl >/dev/null 2>&1; then
          printf 'dotfiles: curl is required to install Homebrew for Fish.\n' >&2
          exit 1
        fi

        info "installing Homebrew for Fish"
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
          | NONINTERACTIVE=1 /bin/bash
        load_homebrew_path
      fi

      info "installing Fish with Homebrew"
      brew install fish
      load_homebrew_path
      ;;
    Linux)
      if ! command -v apt-get >/dev/null 2>&1; then
        printf 'dotfiles: automatic Fish installation requires apt-get on Linux.\n' >&2
        exit 1
      fi

      info "installing Fish with apt-get"
      if [[ "$(id -u)" -eq 0 ]]; then
        DEBIAN_FRONTEND=noninteractive apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y fish
      elif command -v sudo >/dev/null 2>&1; then
        sudo env DEBIAN_FRONTEND=noninteractive apt-get update
        sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y fish
      else
        printf 'dotfiles: sudo is required to install Fish with apt-get.\n' >&2
        exit 1
      fi
      ;;
    *)
      printf 'dotfiles: automatic Fish installation is unsupported on %s.\n' "$(uname -s)" >&2
      exit 1
      ;;
  esac

  if ! command -v fish >/dev/null 2>&1; then
    printf 'dotfiles: Fish installation completed without a usable fish command.\n' >&2
    exit 1
  fi
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

link_file "$ROOT/config/bash/.bashrc" "$HOME/.bashrc"
link_file "$ROOT/config/git/.gitconfig" "$HOME/.gitconfig"
link_file "$ROOT/config/ssh/config" "$HOME/.ssh/config"
link_file "$ROOT/config/ssh/config.d/00-base.conf" "$HOME/.ssh/config.d/00-base.conf"
chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"
link_file "$ROOT/config/fish/config.fish" "$HOME/.config/fish/config.fish"
link_file "$ROOT/config/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"
link_file "$ROOT/config/fish/functions/fish_greeting.fish" "$HOME/.config/fish/functions/fish_greeting.fish"
link_file "$ROOT/config/ghostty/config" "$HOME/.config/ghostty/config"
link_file "$ROOT/config/mise/config.toml" "$HOME/.config/mise/config.toml"

mkdir -p "$HOME/.local/bin"
ensure_fish
export PATH="$HOME/.local/bin:$PATH"
ensure_mise
info "installing mise tools"
"$MISE_BIN" install --yes
update_fisher_plugins

info "setup complete"
