# Preserve the machine's existing login environment.
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi
. "$HOME/.bashrc"
