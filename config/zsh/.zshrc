# Only hand a human-operated terminal to Fish, never a command passed with -c.
if [[ -o interactive && -t 0 && -t 1 && -z ${ZSH_EXECUTION_STRING+x} && ${DOTFILES_NO_FISH:-0} != 1 ]] \
  && command -v fish >/dev/null 2>&1; then
  dotfiles_fish=(fish)
  if [[ -o login ]]; then
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
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
