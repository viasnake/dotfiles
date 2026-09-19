#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pending=0

# Add a copy_file call below to manage another file.
copy_file() {
  local source="$1" target="$2" parent answer backup temporary status
  parent="$(dirname "$target")"

  # Old setups may have linked whole directories into the repository.
  while [[ "$parent" != "$HOME" && "$parent" != / ]]; do
    if [[ -L "$parent" ]]; then
      printf 'dotfiles: pending %s (parent is a symlink: %s; migrate it manually)\n' "$target" "$parent" >&2
      pending=$((pending + 1))
      return
    fi
    parent="$(dirname "$parent")"
  done

  if [[ -e "$target" && ! -f "$target" ]]; then
    printf 'dotfiles: pending %s (not a regular file; move it manually)\n' "$target" >&2
    pending=$((pending + 1))
    return
  fi

  if [[ -f "$target" ]] && cmp -s "$target" "$source" && [[ ! -L "$target" ]]; then
    printf 'dotfiles: unchanged %s\n' "$target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    printf '\ndotfiles: review %s\n' "$target"
    if [[ -L "$target" ]]; then
      printf 'Replace symlink -> %s with an independent copy.\n' "$(readlink "$target")"
    fi
    if [[ -f "$target" ]]; then
      # The diff shows the installed file first and the repository version second.
      status=0
      diff -u "$target" "$source" || status=$?
      if [[ "$status" -gt 1 ]]; then return "$status"; fi
    fi

    answer=n
    if [[ -t 0 ]]; then
      while true; do
        read -r -p 'Back up and replace? [y/N/q] ' answer || answer=n
        case "$answer" in
          y|Y|n|N|'') break ;;
          q|Q) printf 'dotfiles: cancelled\n' >&2; exit 1 ;;
        esac
      done
    fi
    case "$answer" in
      y|Y) ;;
      *)
        printf 'dotfiles: pending %s (kept existing file)\n' "$target"
        pending=$((pending + 1))
        return
        ;;
    esac

    backup="$(mktemp -d "${target}.backup.XXXXXX")"
    if [[ -f "$target" ]]; then
      # Preserve the old contents, even when the target is a symlink.
      cp -pL "$target" "$backup/original"
    else
      cp -P "$target" "$backup/original"
    fi
    printf 'dotfiles: backup %s/original\n' "$backup"
  fi

  mkdir -p "$(dirname "$target")"
  temporary="$(mktemp "${target}.tmp.XXXXXX")"
  # Rename a new file into place: never write through an existing symlink.
  if ! { cp -p "$source" "$temporary" && mv -f "$temporary" "$target"; }; then
    rm -f "$temporary"
    return 1
  fi
  printf 'dotfiles: copied %s\n' "$target"
}

copy_file "$ROOT/config/shell/env.sh" "$HOME/.config/shell/env.sh"
copy_file "$ROOT/config/bash/.bash_profile" "$HOME/.bash_profile"
copy_file "$ROOT/config/bash/.bashrc" "$HOME/.bashrc"
copy_file "$ROOT/config/zsh/.zshenv" "$HOME/.zshenv"
copy_file "$ROOT/config/zsh/.zprofile" "$HOME/.zprofile"
copy_file "$ROOT/config/zsh/.zshrc" "$HOME/.zshrc"
copy_file "$ROOT/config/git/.gitconfig" "$HOME/.gitconfig"
copy_file "$ROOT/config/ssh/config" "$HOME/.ssh/config"
copy_file "$ROOT/config/ssh/config.d/00-base.conf" "$HOME/.ssh/config.d/00-base.conf"
copy_file "$ROOT/config/fish/config.fish" "$HOME/.config/fish/config.fish"
copy_file "$ROOT/config/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"
copy_file "$ROOT/config/fish/functions/fish_greeting.fish" "$HOME/.config/fish/functions/fish_greeting.fish"
copy_file "$ROOT/config/ghostty/config" "$HOME/.config/ghostty/config"
copy_file "$ROOT/config/mise/config.toml" "$HOME/.config/mise/config.toml"

if [[ "$pending" -gt 0 ]]; then
  printf '\ndotfiles: %s file(s) pending; review them and rerun interactively. Tool installation has not started.\n' "$pending" >&2
  exit 1
fi
chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"
