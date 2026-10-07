# Preserve the machine's existing login environment.
if [ -f "$HOME/.profile" ]; then
  # .profile may source .bashrc; finish the login environment before switching.
  DOTFILES_NO_FISH=1 . "$HOME/.profile"
fi
. "$HOME/.bashrc"
