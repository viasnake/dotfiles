# dotfiles

## Supported OS

- Debian
- Raspbian
- Ubuntu
- Zorin OS
- MacOS
- Windows Subsystem for Linux (WSL1)
- Windows Subsystem for Linux 2 (WSL2)

> [!TIP]
> Whether or not the OS is supported is determined by `/etc/os-release`.
> SEE: [bootstrap](https://github.com/viasnake/dotfiles/blob/master/script/bootstrap)

## How to use

### Prerequisites

- git
- make
- sudo

### Installation

```bash
git clone https://github.com/viasnake/dotfiles.git
cd dotfiles
make install
```

> [!TIP]
> Setup your git identity by editing the git config file:
> ```bash
> vim ~/.config/git
> ```
> Add the following lines:
> ```
> [user]
>     name = viasnake
>     email = admin@viasnake.com
> ```

## How to uninstall

```bash
make uninstall
```
