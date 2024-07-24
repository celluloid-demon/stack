#!/bin/bash

stack=${1:-"main"}

docker compose --file docker-compose.${stack}.yml --project-name ${stack} down
