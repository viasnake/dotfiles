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
git clone git@github.com:viasnake/dotfiles.git
cd dotfiles
make install
```

## How to uninstall

```bash
make uninstall
```
