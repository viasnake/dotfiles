# Fish configuration for terminal sessions.

if test -x /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
else if test -x /usr/local/bin/brew
  eval (/usr/local/bin/brew shellenv)
end

if test -d "$HOME/.local/bin"; and not contains -- "$HOME/.local/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH
end

if test -f "$HOME/.config/env.local.fish"
  source "$HOME/.config/env.local.fish"
end

if command -q mise
  mise activate fish | source
end

if status is-interactive
  if command -q zoxide
    zoxide init fish --cmd cd | source
  end

  if command -q fzf
    fzf --fish | source
  end

  set --universal pure_show_system_time true
end
