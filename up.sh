#!/bin/bash

set -e

# stack=${1:-'main'}
stack=$1

# Parse args
[ -z "$stack" ] && echo "Stack name must be specified!" && exit 1

# Aliases
[ $stack = '_'  ] && stack='main'
[ $stack = 'ts' ] && stack='tailscale'

# n8n entrypoint
[ $stack = 'n8n' ] && . .env && . "$N8N_ENV_FILE"

# Starr apps entrypoint
[ $stack = 'starr' ] && . .env && . "$STARR_VERSIONS_FILE"

# Tailscale entrypoint
[ $stack = 'tailscale' ] && sudo tailscale up && exit 0

WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Syntax: hooks/docker-compose.sh <DOCKER-COMPOSE PROJECT NAME> <OPERATION> <SUB-OPERATION>
hooks/docker-compose.sh ${stack} up begin && \
docker compose --file docker-compose.${stack}.yml --project-name ${stack} up --detach --remove-orphans && \
pid=$! && \
hooks/docker-compose.sh ${stack} up end

# todo this don't quite work lol
# wait $pid && \
# hooks/docker-compose.sh ${stack} down end
