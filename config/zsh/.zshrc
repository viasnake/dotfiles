# Human-facing shell features live in Fish; keep zsh usable for agents.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
