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

  # ssh-agent
  if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)

    # Add keys from ssh config
    if test -f $HOME/.ssh/config
      for key in (grep -i 'IdentityFile' $HOME/.ssh/config | awk '{print $2}')
        if test -f $key
          ssh-add $key
        end
      end
    end
  end
else
  # mise
  mise activate fish --shims | source
end
