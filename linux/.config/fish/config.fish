if status is-interactive
  # linuxbrew
  if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  end

  # homebrew
  if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
  end
end
