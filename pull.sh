#!/bin/bash

set -e

stack=${1:-"main"}

WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Syntax: hooks/docker-compose.sh <DOCKER-COMPOSE PROJECT NAME> <OPERATION> <SUB-OPERATION>
hooks/docker-compose.sh ${stack} pull begin && \
docker compose --file docker-compose.${stack}.yml --project-name ${stack} pull && \
hooks/docker-compose.sh ${stack} pull end
