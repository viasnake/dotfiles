# SSH agent policy

## Default policy

- SSH agent is enabled for all hosts via `Host *`.
- `ssh.alflag.internal` is an explicit exception with:
  - `ForwardAgent no`
  - `IdentityAgent none`

## Local usage

Use Bitwarden Desktop SSH Agent. If `SSH_AUTH_SOCK` is missing, SSH auth should fail by design.

## Server usage (non-interactive)

Use the helper script:

```bash
script/ssh/with-agent-secrets -- <command>
```

This script:

1. Loads runtime secrets from `SECRETS_ENV_FILE` or `~/.config/secrets/runtime.env.secret`.
2. Logs into Bitwarden with `bw login --apikey`.
3. Unlocks with `bw unlock --passwordenv BW_PASSWORD --raw`.
4. Reads the SSH private key from `BW_SSH_KEY_ITEM_ID`.
5. Loads it into a temporary `ssh-agent` using `ssh-add -`.
6. Runs the target command.
7. Kills the temporary agent on exit.

Required variables:

- `BW_CLIENTID`
- `BW_CLIENTSECRET`
- `BW_PASSWORD`
- `BW_SSH_KEY_ITEM_ID`

Recommended secret file permissions:

```bash
chmod 700 ~/.config/secrets
chmod 600 ~/.config/secrets/runtime.env.secret
```
