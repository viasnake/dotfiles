# shellcheck shell=bash
# Load tool paths before the interactive guard for SSH / agent commands.
. "$HOME/.config/shell/env.sh"

case $- in
  *i*) ;;
  *) return ;;
esac

# Only hand a human-operated terminal to Fish, never a command passed with -c.
if [[ -t 0 && -t 1 && -z ${BASH_EXECUTION_STRING+x} && ${DOTFILES_NO_FISH:-0} != 1 ]] \
  && command -v fish >/dev/null 2>&1; then
  dotfiles_fish=(fish)
  if shopt -q login_shell; then
    dotfiles_fish+=(--login)
  fi
  if [[ ${DOTFILES_NO_TERMLOG:-0} != 1 && -x "$HOME/.local/bin/termlog" ]]; then
    if [[ ${TERMLOG_ACTIVE:-0} != 1 ]]; then
      printf 'dotfiles: termlog is recording this terminal (screen output is saved).\n' >&2
    fi
    # termlog validates and reuses an inherited recorder instead of nesting one.
    exec "$HOME/.local/bin/termlog" run -- "${dotfiles_fish[@]}"
  fi
  exec "${dotfiles_fish[@]}"
fi

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
  fi
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi
