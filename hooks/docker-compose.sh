#!/bin/bash

# Usage: hooks/docker-compose.sh <DOCKER-COMPOSE PROJECT NAME> <OPERATION> <SUB-OPERATION>

# Description: For everything else besides the docker-compose command.

set -eE

trap 'exit_error $LINENO' ERR
trap 'exit_zero' EXIT

exit_zero() {

    local do_nothing=

    # todo add conditionals based on event / operation (even if it's just optional log stuff)

}

exit_error() {

    echo "...oh no $1"

    # todo add conditionals based on event / operation 

}

# Test required directories
test_dir() {

    [ ! -d "$1" ] && echo "$1 not found, exiting" && exit 1

    true

}

test_file() {

    [ ! -f "$1" ] && echo "$1 not found, exiting" && exit 1

    true

}

test_command() {

    ! which $1 1>/dev/null && echo "please install $1" && exit 1

    true

}

test_image() {

    ! docker image ls --quiet $1 > /dev/null && echo "$1 image missing (please build)" && exit 1

    true

}

test_owner() {

    # 1: file
    # 2: uid
    # 3: gid

    [ "$(stat -c "%u:%g" $1)" != "$2:$3" ] && echo "$1 wrong ownership" && exit 1

    true

}

load_env() {

    test_file .env

    . .env

}

doctor_docker() {

    test_command docker

}

doctor_das_wfpk() {

    test_dir "$DAS_WFPK_VOLUME_OUTPUT"

}

doctor_polaris() {

    test_image $POLARIS_REPOSITORY

    test_dir "$POLARIS_VOLUME_MUSIC"
    test_dir "$POLARIS_VOLUME_CACHE"
    test_dir "$POLARIS_VOLUME_DATA"

    # "Take note that you must create before the cache directory
    # /my/polaris/cache and data directory /my/polaris/data and set ownership
    # to UID/GID 100 in both, otherwise the main proccess will crash."
    
    # Source: https://github.com/ogarcia/docker-polaris

    test_owner "$POLARIS_VOLUME_CACHE" 100 100
    test_owner "$POLARIS_VOLUME_DATA"  100 100

}

doctor_resilio_sync() {

    test_dir "$RESILIO_VOLUME_CACHE"
    test_dir "$RESILIO_VOLUME_CONFIG"
    test_dir "$RESILIO_VOLUME_DATA"

}

doctor_gluetun() {

    # Test OpenVPN login credentials for gluetun
    test_file "${HOME}/.config/gluetun/password.env"

}

doctor_qbittorrent() {

    test_dir "$QBITTORRENT_VOLUME_CONFIG"
    test_dir "$QBITTORRENT_VOLUME_DOWNLOADS"

}

doctor_radarr() {

    test_dir "$RADARR_VOLUME_CONFIG"
    test_dir "$RADARR_VOLUME_DATA"

}

doctor_sonarr() {

    test_dir "$SONARR_VOLUME_CONFIG"
    test_dir "$SONARR_VOLUME_DATA"

}

doctor_lidarr() {

    test_dir "$LIDARR_VOLUME_CONFIG"
    test_dir "$LIDARR_VOLUME_DATA"

}

doctor_readarr() {

    test_dir "$READARR_VOLUME_CONFIG"
    test_dir "$READARR_VOLUME_DATA"

}

doctor_mylar3() {

    test_dir "$MYLAR3_VOLUME_CONFIG"
    test_dir "$MYLAR3_VOLUME_DATA"

}

doctor_prowlarr() {

    test_dir "$PROWLARR_VOLUME_CONFIG"

}

doctor_jellyfin() {

    test_dir "$JELLYFIN_VOLUME_CONFIG"
    test_dir "$JELLYFIN_VOLUME_MOVIES"
    test_dir "$JELLYFIN_VOLUME_TVSHOWS"

}

doctor_vikunja() {

    test_file "$VIKUNJA_ENV_PASSWORDS"
    test_dir  "$VIKUNJA_VOLUME_FILES"
    test_dir  "$VIKUNJA_DB_VOLUME_MYSQL"

}

load_env

# <DOCKER-COMPOSE PROJECT NAME>
if [ $1 = main ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker
            doctor_das_wfpk
            doctor_jellyfin
            doctor_polaris
            doctor_resilio_sync
            doctor_vikunja

        # <SUB-OPERATION>
        elif [ $3 = end ]; then

            do_nothing=

        else

            echo "$3 not recognized" && exit 1

        fi

    # <OPERATION>
    elif [ $2 = down ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            do_nothing=

        # <SUB-OPERATION>
        elif [ $3 = end ]; then

            do_nothing=

        else

            echo "$3 not recognized" && exit 1

        fi

    else

        echo "$2 not recognized" && exit 1

    fi

# <DOCKER-COMPOSE PROJECT NAME>
elif [ $1 = arr ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker
            doctor_gluetun
            doctor_lidarr
            doctor_mylar3
            doctor_prowlarr
            doctor_qbittorrent
            doctor_radarr
            doctor_readarr
            doctor_sonarr

        # <SUB-OPERATION>
        elif [ $3 = end ]; then

            do_nothing=

        else

            echo "$3 not recognized" && exit 1

        fi

    # <OPERATION>
    elif [ $2 = down ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            do_nothing=

        # <SUB-OPERATION>
        elif [ $3 = end ]; then

            do_nothing=

        else

            echo "$3 not recognized" && exit 1

        fi

    else

        echo "$2 not recognized" && exit 1

    fi

# <DOCKER-COMPOSE PROJECT NAME>
elif [ $1 = portainer ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker

        # <SUB-OPERATION>
        elif [ $3 = end ]; then

            do_nothing=

        else

            echo "$3 not recognized" && exit 1

        fi

    # <OPERATION>
    elif [ $2 = down ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            do_nothing=

        # <SUB-OPERATION>
        elif [ $3 = end ]; then

            do_nothing=

        else

            echo "$3 not recognized" && exit 1

        fi

    else

        echo "$2 not recognized" && exit 1

    fi

else

    echo "$1 not recognized" && exit 1

fi

# Force exit code zero for any '&&' operations in host script
true
