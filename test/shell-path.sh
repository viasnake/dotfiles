#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_home="$(mktemp -d)"

cleanup() {
  rm -rf "$tmp_home"
}
trap cleanup EXIT

mkdir -p "$tmp_home/.local/bin" "$tmp_home/.config/fish"
printf '#!/usr/bin/env sh\nexit 0\n' >"$tmp_home/.local/bin/dotfiles-path-sentinel"
chmod 0755 "$tmp_home/.local/bin/dotfiles-path-sentinel"

if ! HOME="$tmp_home" \
    XDG_CONFIG_HOME="$tmp_home/.config" \
    XDG_DATA_HOME="$tmp_home/.local/share" \
    PATH="/usr/bin:/bin" \
    BASH_ENV="$repo_root/home/dot_bashrc" \
    bash -c 'dotfiles-path-sentinel' 2>"$tmp_home/bash.err"; then
  cat "$tmp_home/bash.err" >&2
  exit 1
fi

if fish_bin="$(command -v fish 2>/dev/null)"; then
  install -m 0644 "$repo_root/home/dot_config/fish/config.fish" "$tmp_home/.config/fish/config.fish"
  if ! HOME="$tmp_home" \
      XDG_CONFIG_HOME="$tmp_home/.config" \
      XDG_DATA_HOME="$tmp_home/.local/share" \
      PATH="/usr/bin:/bin" \
      "$fish_bin" -lc 'dotfiles-path-sentinel' 2>"$tmp_home/fish.err"; then
    cat "$tmp_home/fish.err" >&2
    exit 1
  fi
else
  printf 'fish is unavailable; skipping fish PATH smoke test.\n' >&2
fi
