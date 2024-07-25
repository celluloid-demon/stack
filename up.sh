#!/bin/bash

set -e

stack=${1:-"main"}

WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Syntax: hooks/docker-compose.sh <DOCKER-COMPOSE PROJECT NAME> <OPERATION> <SUB-OPERATION>
hooks/docker-compose.sh ${stack} up begin && \
docker compose --file docker-compose.${stack}.yml --project-name ${stack} up --detach --remove-orphans && \
pid=$! && \
hooks/docker-compose.sh ${stack} up end

wait $pid && \
hooks/docker-compose.sh ${stack} down end
