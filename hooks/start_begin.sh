# Read: For everything else besides the docker-compose command.

set -eE

trap 'exit_error' ERR
trap 'exit_zero' EXIT

exit_error() {

    echo "...oh no"

}

exit_zero() {

    local placeholder=

}

# Test environment vars
if [ -f .env ]; then

    . .env

else

    echo "Did you forget to symlink the appropriate .env file for your local machine?"
    exit 1

fi

# Test specified uid
! id $PUID 1>/dev/null && echo "User id $PUID not found, exiting" && exit 1

# Test docker installation
! which docker 1>/dev/null && echo "Please install docker." && exit 1

# Test required directories
[ ! -d "$POLARIS_VOLUME_MUSIC" ] && echo "$POLARIS_VOLUME_MUSIC not found, exiting" && exit 1
[ ! -d "$POLARIS_VOLUME_CACHE" ] && echo "$POLARIS_VOLUME_CACHE not found, exiting" && exit 1
[ ! -d "$POLARIS_VOLUME_DATA"  ] && echo "$POLARIS_VOLUME_DATA not found, exiting"  && exit 1

.
