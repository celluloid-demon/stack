#!/bin/bash

# stack=${1:-"main"}
stack=$1

# Parse args
[ -z "$stack" ] && echo "Stack name must be specified!" && exit 1

# Aliases
[ $stack = '_'     ] && stack='main'
[ $stack = 'net'   ] && stack='network'
[ $stack = 'ts'    ] && stack='tailscale'
[ $stack = 'proxy' ] && stack='reverse-proxy'

# n8n entrypoint
[ $stack = 'n8n' ] && . .env && . "$N8N_ENV_FILE"

# Reverse-proxy entrypoint (Traefik)
[ $stack = 'reverse-proxy' ] && . .env && . "$REVERSE_PROXY_ENV_FILE"

# Starr apps entrypoint
[ $stack = 'starr' ] && . .env && . "$STARR_VERSIONS_FILE"

docker compose --file docker-compose.${stack}.yml --project-name ${stack} down
