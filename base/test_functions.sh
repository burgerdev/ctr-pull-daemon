#!/bin/sh

set -eu

. ./functions.sh

check() {
  expected=$2
  got=$(sanitize_image "$1")
  if [ "$expected" = "$got" ]; then
    return
  fi
  printf "Expected:\n  '%s'\nGot:\n  '%s'\n" "$expected" "$got"
  exit 1
}

check "nginx" "docker.io/library/nginx:latest"

check "nginx:1.5" "docker.io/library/nginx:1.5"

check "nginx@foo" "docker.io/library/nginx@foo"

check "nicolaka/netshoot" "docker.io/nicolaka/netshoot:latest"

check "nicolaka/netshoot:1.5" "docker.io/nicolaka/netshoot:1.5"

check "nicolaka/netshoot@foo" "docker.io/nicolaka/netshoot@foo"

check "ghcr.io/foo/bar" "ghcr.io/foo/bar:latest"

check "ghcr.io/foo/bar:1.5" "ghcr.io/foo/bar:1.5"

check "ghcr.io/foo/bar@foo" "ghcr.io/foo/bar@foo"