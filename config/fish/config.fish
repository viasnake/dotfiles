if status is-interactive
  # linuxbrew
  if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  end

  # homebrew
  if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
  end

  #
  mise activate fish | source
  zoxide init fish --cmd cd | source
  fzf --fish | source

  #
  set --universal pure_show_system_time true
else
  # mise
  mise activate fish --shims | source
end
