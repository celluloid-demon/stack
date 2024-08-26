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

    [ ! -d "$1" ] && echo "$1 (dir) not found, exiting" && exit 1

    true

}

test_file() {

    [ ! -f "$1" ] && echo "$1 (file) not found, exiting" && exit 1

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

    # Docker engine
    test_command docker

    # Docker network (macvlan, if you're using it)
    # if ! docker network ls | grep -q "$DOCKER_NETWORK_MACVLAN"; then

    #     echo "Docker network \"$DOCKER_NETWORK_MACVLAN\" not set, exiting"
    #     exit 1

    # fi

}

doctor_das_wfpk() {

    test_dir "$DAS_WFPK_VOLUME_OUTPUT"

}

doctor_polaris() {

    test_image $POLARIS_REPOSITORY

    test_dir "$POLARIS_VOLUME_MUSIC"
    test_dir "$POLARIS_VOLUME_CACHE"
    test_dir "$POLARIS_VOLUME_DATA"
    test_dir "$POLARIS_VOLUME_WFPK"

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
    test_file "${GLUETUN_ENV_FILE}"

}

doctor_gluetun_alt() {

    # Test OpenVPN login credentials for gluetun
    test_file "${HOME}/.config/gluetun/password.env"

}

doctor_qbittorrent() {

    test_dir "$QBITTORRENT_VOLUME_CONFIG"
    test_dir "$QBITTORRENT_VOLUME_DOWNLOADS"

}

doctor_qbittorrent_alt() {

    test_dir "$QBITTORRENT_ALT_VOLUME_CONFIG"
    test_dir "$QBITTORRENT_ALT_VOLUME_DOWNLOADS"

}

doctor_radarr() {

    test_dir "$RADARR_VOLUME_CONFIG"
    test_dir "$RADARR_VOLUME_DATA"

}

doctor_radarr_alt() {

    test_dir "$RADARR_ALT_VOLUME_CONFIG"
    test_dir "$RADARR_ALT_VOLUME_DATA"

}

doctor_sonarr() {

    test_dir "$SONARR_VOLUME_CONFIG"
    test_dir "$SONARR_VOLUME_DATA"

}

doctor_sonarr_alt() {

    test_dir "$SONARR_ALT_VOLUME_CONFIG"
    test_dir "$SONARR_ALT_VOLUME_DATA"

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

doctor_prowlarr_alt() {

    test_dir "$PROWLARR_ALT_VOLUME_CONFIG"

}

doctor_jellyfin() {

    test_dir "$JELLYFIN_VOLUME_CONFIG"
    test_dir "$JELLYFIN_VOLUME_MOVIES"
    test_dir "$JELLYFIN_VOLUME_TVSHOWS"
    test_dir "$JELLYFIN_VOLUME_SHORTS"

}

doctor_jellyfin_music() {

    test_dir "$JFM_VOLUME_CONFIG"
    test_dir "$JFM_VOLUME_MUSIC"

}

doctor_vikunja() {

    test_file "$VIKUNJA_ENV_PASSWORDS"
    test_dir  "$VIKUNJA_VOLUME_FILES"
    test_dir  "$VIKUNJA_DB_VOLUME_MYSQL"

}

doctor_bazarr() {

    test_dir "$BAZARR_VOLUME_CONFIG"
    test_dir "$BAZARR_VOLUME_DATA"

}

doctor_notifiarr() {

    test_dir  "$NOTIFIARR_VOLUME_CONFIG"
    test_file "$NOTIFIARR_ENV_PASSWORDS"

}

doctor_notifiarr_alt() {

    test_dir  "$NOTIFIARR_ALT_VOLUME_CONFIG"
    test_file "$NOTIFIARR_ALT_ENV_PASSWORDS"

}

doctor_audiobookshelf() {

    test_dir "$ABS_VOLUME_CONFIG"
    test_dir "$ABS_VOLUME_METADATA"
    test_dir "$ABS_VOLUME_AUDIOBOOKS"
    test_dir "$ABS_VOLUME_PODCASTS"

}

doctor_homeassistant() {

    test_dir "$HASS_VOLUME_CONFIG"

}

doctor_odoo() {

    test_file "$ODOO_ENV_FILE"

    test_dir "$ODOO_VOLUME_ADDONS"
    test_dir "$ODOO_VOLUME_CONFIG"
    test_dir "$ODOO_VOLUME_PG_DATA"
    test_dir "$ODOO_VOLUME_WEB_DATA"

}

doctor_immich() {

    test_dir "$UPLOAD_LOCATION"
    test_dir "$DB_DATA_LOCATION"

}

doctor_timetagger() {

    test_file "$TIMETAGGER_ENV_FILE"
    test_dir  "$TIMETAGGER_VOLUME_DATA"

}

doctor_mealie() {

    test_dir "$MEALIE_VOLUME_DATA"
    test_dir "$MEALIE_VOLUME_PGDATA"

}

doctor_syncthing() {

    test_dir "$SYNCTHING_VOLUME_CONFIG"
    test_dir "$HOST_DATA_1"
    test_dir "$HOST_DATA_2"

}

doctor_stirling_pdf() {

    test_dir "$SP_VOLUME_TESSDATA"
    test_dir "$SP_VOLUME_EXTRA_CONFIGS"

}

doctor_isponsorblocktv() {
    
    test_dir "$ISBTV_VOLUME_DATA"

}

doctor_pihole() {

    test_file "$PIHOLE_ENV_FILE"
    test_dir  "$PIHOLE_VOLUME_CONFIG_PIHOLE"
    test_dir  "$PIHOLE_VOLUME_CONFIG_DNSMASQ"

}

load_env

##############################
#                            #
#          MAIN / _          #
#                            #
##############################

if [ $1 = main ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required
            doctor_audiobookshelf
            doctor_das_wfpk
            doctor_homeassistant
            doctor_isponsorblocktv
            doctor_jellyfin
            doctor_jellyfin_music
            doctor_polaris
            doctor_resilio_sync
            doctor_stirling_pdf
            doctor_syncthing

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

############################
#                          #
#          IMMICH          #
#                          #
############################

elif [ $1 = immich ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required
            doctor_immich

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

############################
#                          #
#          MEALIE          #
#                          #
############################

elif [ $1 = mealie ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required
            doctor_mealie

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

##########################
#                        #
#          ODOO          #
#                        #
##########################

elif [ $1 = odoo ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required
            doctor_odoo

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

############################
#                          #
#          PIHOLE          #
#                          #
############################

elif [ $1 = pihole ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required
            doctor_pihole

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

###########################
#                         #
#          STARR          #
#                         #
###########################

elif [ $1 = starr ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required
            doctor_bazarr
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

################################
#                              #
#          TIMETAGGER          #
#                              #
################################

elif [ $1 = timetagger ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required
            doctor_timetagger

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

#############################
#                           #
#          VIKUNJA          #
#                           #
#############################

elif [ $1 = vikunja ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required
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

###############################
#                             #
#          PORTAINER          #
#                             #
###############################

elif [ $1 = portainer ]; then

    # <OPERATION>
    if [ $2 = up ]; then

        # <SUB-OPERATION>
        if [ $3 = begin ]; then

            doctor_docker # required

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
