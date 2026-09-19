#!/usr/bin/env bash
set -euo pipefail

# Load PATH only; setup must not depend on personal shell startup files.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:$PATH"

if ! command -v fish >/dev/null 2>&1; then
  case "$(uname -s)" in
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
          | NONINTERACTIVE=1 /bin/bash
      fi
      brew install fish
      ;;
    Linux)
      # Debian / Ubuntu / WSL. For other distributions, install Fish yourself.
      sudo_cmd=()
      if [[ "$(id -u)" -ne 0 ]]; then sudo_cmd=(sudo); fi
      "${sudo_cmd[@]}" apt-get update
      "${sudo_cmd[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y fish
      ;;
    *) printf 'Install Fish manually on this OS.\n' >&2; exit 1 ;;
  esac
fi

if ! command -v mise >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://mise.run | env MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh
fi

# Run after copy.sh, outside the caller's project configuration.
(cd "$HOME" && mise install --yes)

if ! fish -c 'functions -q fisher'; then
  curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
    | fish -c 'source; fisher install jorgebucaran/fisher'
fi
fish -c 'fisher update'
