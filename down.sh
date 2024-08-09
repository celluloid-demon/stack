#!/bin/bash

stack=${1:-"main"}

# Aliases
[ $stack = '_' ] && stack='main'

docker compose --file docker-compose.${stack}.yml --project-name ${stack} down
