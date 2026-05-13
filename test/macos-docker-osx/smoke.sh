#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
image="${DOCKER_OSX_IMAGE:-sickcodes/docker-osx:latest}"
container_name="${DOCKER_OSX_CONTAINER_NAME:-dotfiles-docker-osx-smoke}"
shortname="${DOCKER_OSX_SHORTNAME:-catalina}"
timeout_seconds="${DOCKER_OSX_SMOKE_TIMEOUT:-120}"

"$script_dir/preflight.sh"

cleanup() {
  docker rm -f "$container_name" >/dev/null 2>&1 || true
}
trap cleanup EXIT

cleanup

docker run \
  --name "$container_name" \
  --detach \
  --device /dev/kvm \
  -p "${DOCKER_OSX_SSH_PORT:-50922}:10022" \
  -e "EXTRA=${DOCKER_OSX_EXTRA:--display none}" \
  -e "SHORTNAME=$shortname" \
  "$image" >/dev/null

deadline=$((SECONDS + timeout_seconds))

while (( SECONDS < deadline )); do
  if docker exec "$container_name" pgrep -fa qemu-system >/dev/null 2>&1; then
    docker exec "$container_name" pgrep -fa qemu-system
    printf 'Docker-OSX QEMU smoke test passed for %s.\n' "$image"
    exit 0
  fi

  if [[ "$(docker inspect -f '{{.State.Running}}' "$container_name")" != "true" ]]; then
    docker logs "$container_name" >&2 || true
    printf 'Docker-OSX container exited before QEMU started.\n' >&2
    exit 1
  fi

  sleep 5
done

docker logs "$container_name" >&2 || true
printf 'Timed out waiting for qemu-system in Docker-OSX container.\n' >&2
exit 1
