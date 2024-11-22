#!/bin/bash

# Usage: hooks/docker.sh <DOCKER SERVICE NAME> <OPERATION> <SUB-OPERATION>

# Description: For running commands inside one-off docker containers.

# Declare constants
readonly LIB='./lib'

readonly STACK=$1 # docker service name
readonly OPERATION=$2
readonly SUB_OPERATION=$3

readonly ENV="${LIB}/env.sh"
readonly ERROR="${LIB}/error.sh"
readonly TEST="${LIB}/test.sh"

# Source external libraries
. "$ENV"
. "$ERROR"
. "$TEST"

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

    # NOTE: WE DON'T TEST FOR STACK'S COMPOSE YML FILE IN REGULAR DOCKER HOOKS

    test_param "$OPERATION"     "exec  run"
    test_param "$SUB_OPERATION" "begin end"

}

doctor_host() {

    test_file  .allow
    test_allow $STACK

}

doctor_tamari_gallery_dl() {

    test_file "$TGL_FILE_CONFIG"
    test_dir  "$TGL_VOLUME_DOWNLOADS"

}

###########################
#                         #
#          SETUP          #
#                         #
###########################

load_env
doctor_docker
doctor_hooks
doctor_host

########################################
#                                      #
#          TAMARI-GALLLERY-DL          #
#                                      #
########################################

stack=tamari-gallery-dl

if [ $STACK = $stack ] && [ $OPERATION = 'run' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_tamari_gallery_dl

elif [ $STACK = $stack ] && [ $OPERATION = 'run' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

#########################
#                       #
#          END          #
#                       #
#########################

# NOTE: Force exit code zero for any '&&' operations in parent script
true
