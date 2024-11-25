#!/bin/sh

set -u

sanitize_image() {
  img="$1"
  if ! echo "$img" | grep -qF /; then
    img="docker.io/library/$img"
  fi
  if ! echo "$img" | sed 's/[:@].*//' | grep -qF .; then
    img="docker.io/$img"
  fi
  if ! echo "$img" | grep -qF -e : -e @; then
    img="$img:latest"
  fi
  printf "%s" "$img"
}

pull_image() {
  snapshotter=""
  if [ "$1" != "null" ]; then
    snapshotter="--snapshotter nydus-$1"
  fi
  image=$(sanitize_image "$2")
  echo "Pulling image $image (snapshotter: $snapshotter)"
  ctr -n k8s.io i pull $snapshotter "$image" >/dev/null
}

reconcile() {
  kubectl get pods -A -o json | jq -c -f broken_images.jq --arg node "$MYNODE" | tee -a /tmp/debug |
  while IFS="" read -r line || [ -n "$line" ]
  do
    pull_image "$(echo "$line" | jq -r '.runtimeClass')" "$(echo "$line" | jq -r '.image')" 
  done
}
