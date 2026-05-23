# homebrew / linuxbrew
if command -q brew
  eval (brew shellenv)
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
else if test -x $HOME/.linuxbrew/bin/brew
  eval ($HOME/.linuxbrew/bin/brew shellenv)
else if test -x /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
else if test -x /usr/local/bin/brew
  eval (/usr/local/bin/brew shellenv)
end

if test -f ~/.config/dotfiles/secrets.fish
  source ~/.config/dotfiles/secrets.fish
end

if status is-interactive
  if command -q mise
    mise activate fish | source
  end
  if command -q zoxide
    zoxide init fish --cmd cd | source
  end
  if command -q fzf
    fzf --fish | source
  end

  #
  set --universal pure_show_system_time true

else
  if command -q mise
    mise activate fish --shims | source
  end
end
