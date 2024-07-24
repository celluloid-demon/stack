#!/bin/bash

set -e

WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Syntax: hooks/docker-compose.sh <DOCKER-COMPOSE PROJECT NAME> <OPERATION> <SUB-OPERATION>
hooks/docker-compose.sh arr up begin && \
docker compose --file docker-compose.arr.yml up --detach && \
pid=$! && \
hooks/docker-compose.sh arr up end

wait $pid && \
hooks/docker-compose.sh arr down end
