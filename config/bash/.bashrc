# shellcheck shell=bash
# ~/.bashrc: Bash configuration for interactive terminal sessions.

case $- in
  *i*) ;;
  *) return ;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend checkwinsize

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ -d "$HOME/.local/bin" ]]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
  esac
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [[ -f "$HOME/.bash_aliases" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.bash_aliases"
fi

if [[ -f "$HOME/.config/env.local" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.config/env.local"
fi

if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    # shellcheck source=/dev/null
    . /etc/bash_completion
  fi
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi
