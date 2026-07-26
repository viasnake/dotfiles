prepend_path() {
  local path_entry="$1"

  if [[ -d "$path_entry" ]]; then
    case ":$PATH:" in
      *":$path_entry:"*) ;;
      *) PATH="$path_entry:$PATH" ;;
    esac
    export PATH
  fi
}

nix_command() {
  if command -v nix >/dev/null 2>&1; then
    command -v nix
    return
  fi

  if [[ -x "$HOME/.nix-profile/bin/nix" ]]; then
    printf '%s\n' "$HOME/.nix-profile/bin/nix"
    return
  fi

  if [[ -x /nix/var/nix/profiles/default/bin/nix ]]; then
    printf '%s\n' /nix/var/nix/profiles/default/bin/nix
    return
  fi

  return 1
}

load_nix_env() {
  if [[ -f /etc/profile.d/nix.sh ]]; then
    unset __ETC_PROFILE_NIX_SOURCED
    # shellcheck disable=SC1091
    . /etc/profile.d/nix.sh
  elif [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    unset __ETC_PROFILE_NIX_SOURCED
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    unset __ETC_PROFILE_NIX_SOURCED
    # shellcheck disable=SC1091
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi

  prepend_path /nix/var/nix/profiles/default/bin
  prepend_path "$HOME/.nix-profile/bin"
  prepend_path "$HOME/.local/state/nix/profile/bin"
  prepend_path "$HOME/.local/state/nix/profiles/dotfiles-tools/bin"
}
