# Nix Tool Layer

Nix owns the bootstrap/system tool layer for this dotfiles repo. The default
chezmoi script installs Nix when it is missing, then builds the
`dotfiles-tools` profile from `flake.nix`.

The current Nix tool profile covers:

- `fish`
- `fzf` and `ghq`, required by the managed fish plugins
- `gmailctl`
- `jsonnet`
- `mise`
- `sqlite3`, used to apply the Codex diagnostic-log safeguard

It intentionally does not replace `home/dot_config/mise/config.toml`. The first
layer only covers tools needed before or outside mise. Versioned runtimes and
developer CLIs stay in mise.

## Commands

Show the flake outputs:

```bash
make nix-show
```

Validate packages and the Home Manager module:

```bash
make nix-check
```

Build the package profile without changing the active user profile:

```bash
make nix-build-tools
```

The Makefile target passes `--no-link` by default so validation does not leave a
`result` symlink in the repository. Override `NIX_BUILD_FLAGS=` when a local
build result symlink is useful.

The Makefile targets use `NIX_FLAKE=path:$PWD` by default. This keeps Nix
validation usable while `flake.nix` is still untracked during local development.

Build the Home Manager activation package for the current Linux validation:

```bash
nix --extra-experimental-features "nix-command flakes" \
  build "path:$PWD#homeConfigurations.dotfiles-nix-validation-x86_64-linux.activationPackage"
```

Do not run `home-manager switch` against this validation configuration. It uses a
placeholder user and home directory. The validation configuration also does not
install the `home-manager` CLI into the generated profile; it only checks that
the module can build. A later Home Manager migration should add a host- or
profile-specific configuration with the actual username and home path.

The Makefile targets pass `--no-write-lock-file` by default so validation
commands fail instead of silently changing `flake.lock`. Refresh the lock file
explicitly when updating inputs:

```bash
nix --extra-experimental-features "nix-command flakes" flake update
```

## Installation Notes

The official multi-user installer can be used for local validation:

```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install -o /tmp/nix-install.sh
sh /tmp/nix-install.sh --daemon --yes --no-channel-add --no-modify-profile
```

On Linux, the official installer may still add system-wide shell hooks such as
`/etc/profile.d/nix.sh`, `/etc/bash.bashrc`, or fish `conf.d` files. The Makefile
does not rely on those hooks; it falls back to
`/nix/var/nix/profiles/default/bin/nix` when `nix` is not on `PATH`.

## Migration Reading

The current setup keeps activation in chezmoi and package ownership in Nix.
Treat a full Home Manager migration as a separate decision.
