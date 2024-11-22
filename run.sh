#!/bin/bash

# Usage:
#   $ run.sh <STACK_NAME> [extra args]

# Exit on error
set -eE

stack=$1

# Parse args
[ -z "$stack" ] && echo "Stack name must be specified!" && exit 1

# Aliases
[ $stack = 'tgl'   ] && stack='tamari-gallery-dl'

WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Hooks
hooks/docker.sh ${stack} run begin

# tamari-gallery-dl entrypoint
[ $stack = 'tamari-gallery-dl' ] && . .env && readonly URL="$2" && run/tamari/gallery-dl.sh "$URL"
