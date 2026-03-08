#!/bin/bash
# Runs oh-my-pi in a container.
#
# Container image definition is in "omp.Containerfile".
#
# Mounts in the container:
# - current directory
# - ~/.config/omp/
# - ~/.config/gh/
set -euo pipefail

image=omp
MAX_AGE_DAYS=7

script_root=$(dirname "$(readlink -f "$0")")
container_file=$script_root/${image}.Containerfile
timestamp_file=~/.cache/.image-build-$image

should_build_image() {
  if ! podman image exists "$image" 2>/dev/null; then
    echo "Image not found locally, will pull" >&2
    return 0
  fi

  # Check if the container file is newer than the built image
  if [ ! -f "$timestamp_file" ] || [ "$container_file" -nt "$timestamp_file" ]; then
    echo "Containerfile ($container_file) has been modified since the image was created, will rebuild" >&2
    return 0
  fi

  # Check image age
  local image_created
  image_created=$(podman image inspect "$image" --format='{{.Created}}' 2>/dev/null | sed 's/ UTC$//' || echo "")

  local image_age_seconds
  image_age_seconds=$(( $(date +%s) - $(date -d "$image_created" +%s) ))
  local image_age_days=$(( image_age_seconds / 86400 ))

  if [ $image_age_days -gt $MAX_AGE_DAYS ]; then
    echo "Image is $image_age_days days old (max: $MAX_AGE_DAYS days), will rebuild" >&2
    return 0
  fi

  echo "Using cached image ($image_age_days days old)" >&2
  return 1
}

build_image() {
  script_root="$(dirname "$(readlink -f "$0")")"
  touch "$timestamp_file"
  podman build --pull=always -f "$container_file" -t "$image" .
}

if should_build_image && ! build_image; then
  echo "Error: Image build failed" >&2
  exit 1
fi

mkdir -p ~/.config/omp ~/.config/gh

workspace=$(readlink -f "$PWD")
exec podman run --rm -it \
  --security-opt label=disable \
  -v ~/.config/gh:/home/omp/.config/gh:rw \
  -v ~/.config/omp:/home/omp/.omp:rw \
  -v "$workspace":/workspace:rw \
  -w /workspace \
  --userns=keep-id:uid=1000,gid=1000 \
  "$image" \
  "$@"
