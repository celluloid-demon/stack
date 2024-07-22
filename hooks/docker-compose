set -eE

trap 'exit_error' ERR
trap 'exit_zero' EXIT

exit_error() {

    echo "...oh no"

}

exit_zero() {

    local placeholder=

}

portainer_container_id=$(docker ps -aqf "name=$PORTAINER_CONTAINER_NAME")
