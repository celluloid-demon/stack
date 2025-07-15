#!/bin/bash

# Exit on error
set -eE

# Set working directory
WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Parse args
stack=$1
[ -z "$stack" ] && echo "Stack name must be specified!" && exit 1

# Source aliases
[ -f aliases.sh       ] && . aliases.sh
[ -f local/aliases.sh ] && . local/aliases.sh

# Run custom entrypoint if available
[ -f  "modules/${stack}/entrypoint.sh" ] && . "modules/${stack}/entrypoint.sh"

# Run docker-compose with hooks
hooks/docker-compose.sh ${stack} up begin && \
docker compose --file modules/${stack}/docker-compose.yml --project-name ${stack} up --detach --remove-orphans && \
hooks/docker-compose.sh ${stack} up end
