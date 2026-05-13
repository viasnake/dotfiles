ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    make \
    sudo \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash dotfiles \
  && printf 'dotfiles ALL=(ALL) NOPASSWD:ALL\n' >/etc/sudoers.d/dotfiles \
  && chmod 0440 /etc/sudoers.d/dotfiles

USER dotfiles
ENV HOME=/home/dotfiles
WORKDIR /home/dotfiles/dotfiles

COPY --chown=dotfiles:dotfiles . .

CMD ["bash", "test/ubuntu/run.sh"]
