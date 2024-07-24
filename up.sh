#!/bin/bash

set -e

WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Syntax: hooks/docker-compose.sh <DOCKER-COMPOSE PROJECT NAME> <OPERATION> <SUB-OPERATION>
hooks/docker-compose.sh DEFAULT up begin && \
docker compose up --detach --remove-orphans && \
pid=$! && \
hooks/docker-compose.sh DEFAULT up end

wait $pid && \
hooks/docker-compose.sh DEFAULT down end
