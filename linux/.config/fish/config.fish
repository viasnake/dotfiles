if status is-interactive
  # linuxbrew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

  # mise
  ~/.local/bin/mise activate fish | source
end
