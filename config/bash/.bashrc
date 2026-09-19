# shellcheck shell=bash
# Load tool paths before the interactive guard for SSH / agent commands.
. "$HOME/.config/shell/env.sh"

case $- in
  *i*) ;;
  *) return ;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend checkwinsize

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [[ -f "$HOME/.bash_aliases" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.bash_aliases"
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
