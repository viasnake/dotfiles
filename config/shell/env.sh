# POSIX syntax: shared by Bash and zsh, including agent login shells.
# Static shims also expose mise tools without interactive prompt hooks.
for dotfiles_bin in /home/linuxbrew/.linuxbrew/bin /usr/local/bin /opt/homebrew/bin \
  "$HOME/.local/bin" "${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims"; do
  case ":$PATH:" in
    *":$dotfiles_bin:"*) ;;
    *) PATH="$dotfiles_bin:$PATH" ;;
  esac
done
unset dotfiles_bin
export PATH

if [ -f "$HOME/.config/env.local" ]; then
  . "$HOME/.config/env.local"
fi
