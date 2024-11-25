#!/bin/sh

set -u

. "$(readlink -f functions.sh)"

trap exit INT TERM

while true; do
  reconcile
  sleep 10
done
