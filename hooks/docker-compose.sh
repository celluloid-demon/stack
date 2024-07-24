# Read: For everything else besides the docker-compose command.

set -eE

trap 'exit_error' ERR
trap 'exit_zero' EXIT

exit_zero() {

    local do_nothing=

    # todo add conditionals based on event / operation (even if it's just optional log stuff)

}

exit_error() {

    echo "sad face"

    # todo add conditionals based on event / operation 

}

hook_docker_compose_up_begin() {

    # Test docker installation
    ! which docker 1>/dev/null && echo "Please install docker." && exit 1

    # Test environment vars
    if [ -f .env ]; then

        . .env

    else

        echo "Did you forget to symlink the appropriate .env file for your local machine?"
        exit 1

    fi

    # Test specified uid
    # ! id $PUID 1>/dev/null && echo "User id $PUID not found, exiting" && exit 1

}

# Derive name for target docker-compose project from repo name (just being fancy):
# WORKDIR="$(pwd)"
# DEFAULT_DOCKER_COMPOSE_PROJECT=$(basename "$WORKDIR")

# declare -A docker_compose_projects

# docker_compose_projects["$DEFAULT_DOCKER_COMPOSE_PROJECT"]=DEFAULT

# if [ $1 = ${docker_compose_projects["$DEFAULT_DOCKER_COMPOSE_PROJECT"]} ]; then

if [ $1 = main ]; then

    if [ $2 = up ]; then

        if [ $3 = begin ]; then

            ####################################
            #                                  #
            #          DOCKER-COMPOSE          #
            #                                  #
            ####################################

            hook_docker_compose_up_begin

            ################################################
            #                                              #
            #          DOWNLOAD-AUDIO-STREAM-WFPK          #
            #                                              #
            ################################################

            # Test required directories
            [ ! -d "$DAS_WFPK_VOLUME_OUTPUT" ] && echo "$DAS_WFPK_VOLUME_OUTPUT not found, exiting" && exit 1

            #############################
            #                           #
            #          POLARIS          #
            #                           #
            #############################

            # Test required image
            ! docker image ls --quiet $POLARIS_REPOSITORY && echo "polaris image missing (please build)" && exit 1

            # Test required directories
            [ ! -d "$POLARIS_VOLUME_MUSIC" ] && echo "$POLARIS_VOLUME_MUSIC not found, exiting" && exit 1
            [ ! -d "$POLARIS_VOLUME_CACHE" ] && echo "$POLARIS_VOLUME_CACHE not found, exiting" && exit 1
            [ ! -d "$POLARIS_VOLUME_DATA"  ] && echo "$POLARIS_VOLUME_DATA not found, exiting"  && exit 1

            ##################################
            #                                #
            #          RESILIO-SYNC          #
            #                                #
            ##################################

            # Test required directories
            [ ! -d "$RESILIO_VOLUME_CACHE"  ] && echo "$RESILIO_VOLUME_CACHE not found, exiting"  && exit 1
            [ ! -d "$RESILIO_VOLUME_CONFIG" ] && echo "$RESILIO_VOLUME_CONFIG not found, exiting" && exit 1
            [ ! -d "$RESILIO_VOLUME_DATA"   ] && echo "$RESILIO_VOLUME_DATA not found, exiting"   && exit 1

        elif [ $3 = end ]; then

            do_nothing=

        fi

    elif [ $2 = down ]; then

        if [ $3 = begin ]; then

            do_nothing=

        elif [ $3 = end ]; then

            do_nothing=

        fi

    fi

elif [ $1 = arr ]; then

    if [ $2 = up ]; then

        if [ $3 = begin ]; then

            ####################################
            #                                  #
            #          DOCKER-COMPOSE          #
            #                                  #
            ####################################

            hook_docker_compose_up_begin

            #############################
            #                           #
            #          GLUETUN          #
            #                           #
            #############################

            # Test required environment vars
            [ ! -f "${HOME}/.config/gluetun/password.env" ] && echo "missing password.env file" && exit 1

            #################################
            #                               #
            #          QBITTORRENT          #
            #                               #
            #################################

            # Test required directories
            [ ! -d "$QBITTORRENT_VOLUME_CONFIG"    ] && echo "$QBITTORRENT_VOLUME_CONFIG not found, exiting"    && exit 1
            [ ! -d "$QBITTORRENT_VOLUME_DOWNLOADS" ] && echo "$QBITTORRENT_VOLUME_DOWNLOADS not found, exiting" && exit 1

            ############################
            #                          #
            #          RADARR          #
            #                          #
            ############################

            # Test required directories
            [ ! -d "$RADARR_VOLUME_CONFIG" ] && echo "$RADARR_VOLUME_CONFIG not found, exiting" && exit 1
            [ ! -d "$RADARR_VOLUME_DATA"   ] && echo "$RADARR_VOLUME_DATA not found, exiting"   && exit 1

            ############################
            #                          #
            #          SONARR          #
            #                          #
            ############################

            # Test required directories
            [ ! -d "$SONARR_VOLUME_CONFIG" ] && echo "$SONARR_VOLUME_CONFIG not found, exiting" && exit 1
            [ ! -d "$SONARR_VOLUME_DATA"   ] && echo "$SONARR_VOLUME_DATA not found, exiting"   && exit 1

            ############################
            #                          #
            #          LIDARR          #
            #                          #
            ############################

            # Test required directories
            [ ! -d "$LIDARR_VOLUME_CONFIG" ] && echo "$LIDARR_VOLUME_CONFIG not found, exiting" && exit 1
            [ ! -d "$LIDARR_VOLUME_DATA"   ] && echo "$LIDARR_VOLUME_DATA not found, exiting"   && exit 1

            #############################
            #                           #
            #          READARR          #
            #                           #
            #############################

            # Test required directories
            [ ! -d "$READARR_VOLUME_CONFIG" ] && echo "$READARR_VOLUME_CONFIG not found, exiting" && exit 1
            [ ! -d "$READARR_VOLUME_DATA"   ] && echo "$READARR_VOLUME_DATA not found, exiting"   && exit 1

            ############################
            #                          #
            #          MYLAR3          #
            #                          #
            ############################

            # Test required directories
            [ ! -d "$MYLAR3_VOLUME_CONFIG" ] && echo "$MYLAR3_VOLUME_CONFIG not found, exiting" && exit 1
            [ ! -d "$MYLAR3_VOLUME_DATA"   ] && echo "$MYLAR3_VOLUME_DATA not found, exiting"   && exit 1

            ##############################
            #                            #
            #          PROWLARR          #
            #                            #
            ##############################

            # Test required directories
            [ ! -d "$PROWLARR_VOLUME_CONFIG" ] && echo "$PROWLARR_VOLUME_CONFIG not found, exiting" && exit 1

        elif [ $3 = end ]; then

            do_nothing=

        fi

    elif [ $2 = down ]; then

        if [ $3 = begin ]; then

            do_nothing=

        elif [ $3 = end ]; then

            do_nothing=

        fi

    fi

fi

# Force exit code zero for any '&&' operations in host script
true
