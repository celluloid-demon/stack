#!/bin/bash

# Exit on error
set -eE

trap 'exit_error' ERR
trap 'exit_zero' EXIT

# Declare constants
DEVICE_IP=$(hostname -I | awk '{print $1}')

exit_error() {

    echo "...oh no (is docker engine running?)"

}

exit_zero() {

    local placeholder=

}

main() {

    # Set working directory
    cd "$(dirname "$0")"

    # Test root user
    # [ "$(id -u)" != "0" ] && echo "Script must be run as root." && exit 1

    # Test environment vars
    if [ -f .env ]; then

        . .env

    else

        echo "Did you forget to symlink the appropriate .env file for your local machine?"
        exit 1

    fi

    # Test specified uid
    # ! id $PUID 1>/dev/null && echo "User id $PUID not found, exiting" && exit 1

    # Test docker installation
    ! which docker 1>/dev/null && echo "Please install docker." && exit 1

    # Test required directories
    # [ ! -d "$POLARIS_VOLUME_MUSIC" ] && echo "$POLARIS_VOLUME_MUSIC not found, exiting" && exit 1
    # [ ! -d "$POLARIS_VOLUME_CACHE" ] && echo "$POLARIS_VOLUME_CACHE not found, exiting" && exit 1
    # [ ! -d "$POLARIS_VOLUME_DATA"  ] && echo "$POLARIS_VOLUME_DATA not found, exiting"  && exit 1

    docker compose up --detach

    echo "${DEVICE_IP}:${PORTAINER_PORT_WEB_UI}"

    local portainer_container_id=$(docker ps -aqf "name=$PORTAINER_CONTAINER_NAME")

    docker container wait $portainer_container_id && eval "hooks/down.sh"

    exit 0

}

main
