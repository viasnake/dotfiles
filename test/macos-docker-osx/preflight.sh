#!/usr/bin/env bash

set -euo pipefail

image="${DOCKER_OSX_IMAGE:-sickcodes/docker-osx:latest}"
required_kib="$((50 * 1024 * 1024))"

if ! docker info >/dev/null 2>&1; then
  printf 'Docker daemon is unavailable to the current user.\n' >&2
  exit 1
fi

if [[ "$(uname -m)" != "x86_64" ]]; then
  printf 'Docker-OSX requires an x86_64 KVM-capable host; got %s.\n' "$(uname -m)" >&2
  exit 1
fi

if [[ ! -c /dev/kvm ]]; then
  printf 'Docker-OSX requires /dev/kvm on the host, but it is not available.\n' >&2
  exit 1
fi

docker_root="$(docker info --format '{{.DockerRootDir}}')"
available_kib="$(df -Pk "$docker_root" | awk 'NR == 2 { print $4 }')"

if [[ -n "$available_kib" && "$available_kib" -lt "$required_kib" ]]; then
  printf 'Docker-OSX needs at least 50 GiB free under %s; available: %s KiB.\n' \
    "$docker_root" "$available_kib" >&2
  exit 1
fi

docker manifest inspect "$image" >/dev/null

printf 'Docker-OSX preflight passed for %s.\n' "$image"
