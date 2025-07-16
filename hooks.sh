#!/bin/bash

# Description: For everything else besides the docker-compose command.

# Usage: hooks/docker-compose.sh <DOCKER-COMPOSE PROJECT NAME> <OPERATION> <SUB-OPERATION>

# Exit on error
set -eE

trap 'exit_error $LINENO' ERR
trap 'exit_zero' EXIT

# Set working directory
WORKDIR="$(dirname "$0")" && \
cd "$WORKDIR"

# Declare constants
readonly LIB='./lib'

readonly STACK=$1 # AKA docker-compose project name
readonly OPERATION=$2
readonly SUB_OPERATION=$3

readonly ERROR="${LIB}/error.sh"
readonly TEST="${LIB}/test.sh"

# Source external libraries
[ -f "$ERROR" ] && . "$ERROR"
[ -f "$TEST"  ] && . "$TEST"

doctor_docker() {

    # Docker engine
    test_command docker

    # Docker network (macvlan, if you're using it)
    # if ! docker network ls | grep -q "$DOCKER_NETWORK_MACVLAN"; then

    #     echo "Docker network \"$DOCKER_NETWORK_MACVLAN\" not set, exiting"
    #     exit 1

    # fi

}

doctor_hooks() {

    # NOTE: Easier just to test for the docker-compose file for first
    # positional parameter.

    test_file  "modules/docker-compose.${STACK}.yml"
    test_param "$OPERATION"     "up    down run"
    test_param "$SUB_OPERATION" "begin end"

}

doctor_host() {

    test_file  .allow
    test_allow $STACK

}

load_env() {

    test_file .env

    . .env

}

source_hooks() {

    test_file ./modules/hooks.${STACK}.sh

    . "./modules/hooks.${STACK}.sh"

}

###########################
#                         #
#          START          #
#                         #
###########################

main() {

    load_env
    doctor_docker
    doctor_hooks
    doctor_host
    source_hooks

}

main

#########################
#                       #
#          END          #
#                       #
#########################

# NOTE: Force exit code zero for any '&&' operations in host script
true
