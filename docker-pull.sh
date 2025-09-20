#!/bin/bash

# Exit on error
set -eE

trap 'exit_error $LINENO' ERR
trap 'exit_zero' EXIT

# Set working directory
WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Declare constants
readonly LIB='./lib'

readonly ERROR="${LIB}/error.sh"

# Source external libraries
[ -f "$ERROR" ] && . "$ERROR"

# Parse args
stack=$1
[ -z "$stack" ] && echo "Stack name must be specified!" && exit 1

# Source aliases
[ -f aliases.sh       ] && . aliases.sh
[ -f local/aliases.sh ] && . local/aliases.sh

# Source env
[ -f ./modules/.env ] && . ./modules/.env

# Run custom entrypoint if available
[ -f  "modules/entrypoint.${stack}.sh" ] && . "modules/entrypoint.${stack}.sh"

# Run docker-compose with hooks
[ -f "./entrypoint.hooks.sh"                ] && ./entrypoint.hooks.sh ${stack} up begin
[ -f "modules/docker-compose.${stack}.yml"  ] && eval $CONTAINER_ENGINE compose --file modules/docker-compose.${stack}.yml --project-name ${stack} pull
[ -f "./entrypoint.hooks.sh"                ] && ./entrypoint.hooks.sh ${stack} up end
