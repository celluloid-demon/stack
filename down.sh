#!/bin/bash

# stack=${1:-"main"}
stack=$1

# Parse args
[ -z "$stack" ] && echo "Stack name must be specified!" && exit 1

# Aliases
[ $stack = '_' ] && stack='main'

docker compose --file docker-compose.${stack}.yml --project-name ${stack} down
