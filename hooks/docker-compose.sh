#!/bin/bash

# Description: For everything else besides the docker-compose command.

# Usage: hooks/docker-compose.sh <DOCKER-COMPOSE PROJECT NAME> <OPERATION> <SUB-OPERATION>

# Declare constants
readonly LIB='./lib'
readonly MACROS='./macros'

readonly STACK=$1 # AKA docker-compose project name
readonly OPERATION=$2
readonly SUB_OPERATION=$3

readonly ERROR="${LIB}/error.sh"
readonly TEST="${LIB}/test.sh"

readonly ENV="${MACROS}/env.sh"

# Source external libraries
. "$ERROR"
. "$TEST"

# Source external macros
. "$ENV"

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

doctor_recyclarr() {

    test_dir "$RECYCLARR_VOLUME_CONFIG"

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

    test_dir "$JELLYFIN_VOLUME_CACHE"
    test_dir "$JELLYFIN_VOLUME_CONFIG"
    test_dir "$JELLYFIN_VOLUME_MOVIES"
    test_dir "$JELLYFIN_VOLUME_TVSHOWS"
    test_dir "$JELLYFIN_VOLUME_SHORTS"
    test_dir "$JELLYFIN_VOLUME_MUSIC"

}

doctor_jellyfin_music() {

    test_dir "$JFM_VOLUME_CACHE"
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
    test_dir "$SYNCTHING_VOLUME_DATA"

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

doctor_backup() {

    test_file "$BACKUP_ENV_FILE"
    test_dir  "$BACKUP_VOLUME_BIN"

}

doctor_starr_apps() {

    test_file "$STARR_VERSIONS_FILE"

}

doctor_host() {

    test_file  .allow
    test_allow $STACK

}

doctor_hooks() {

    # NOTE: Easier just to test for the docker-compose file for first
    # positional parameter.

    test_file  "./docker-compose.${STACK}.yml"
    test_param "$OPERATION"     "up    down run"
    test_param "$SUB_OPERATION" "begin end"

}

doctor_navidrome() {

    test_dir "$NAVIDROME_VOLUME_CONFIG"
    test_dir "$NAVIDROME_VOLUME_MUSIC"

}

doctor_paperless() {

    test_dir "$PAPERLESS_VOLUME_CONSUME"
    test_dir "$PAPERLESS_VOLUME_DATA"
    test_dir "$PAPERLESS_VOLUME_DB"
    test_dir "$PAPERLESS_VOLUME_EXPORT"
    test_dir "$PAPERLESS_VOLUME_MEDIA"

}

doctor_haptic() {

    test_dir "$HAPTIC_VOLUME_CONFIG"
    test_dir "$HAPTIC_VOLUME_DATA"

}

doctor_silverbullet() {

    test_file "$SB_ENV_FILE"
    test_dir  "$SB_VOLUME_SPACE"

}

doctor_kavita() {

    test_dir "$KAVITA_VOLUME_CONFIG"
    test_dir "$KAVITA_VOLUME_BOOKS"

}

doctor_n8n() {

    test_file       "$N8N_ENV_FILE"
    test_file       "$N8N_INIT_DATA"
    test_executable "$N8N_INIT_DATA"
    test_dir        "$N8N_VOLUME_DATA"
    test_dir        "$N8N_VOLUME_DB"
    test_dir        "$N8N_VOLUME_REDIS"

}

doctor_calibre_web() {

    test_dir "$CALIBRE_VOLUME_CONFIG"
    test_dir "$CALIBRE_VOLUME_BOOKS"

}

doctor_bind9() {

    test_dir "$BIND_VOLUME_CACHE"
    test_dir "$BIND_VOLUME_CONFIG"
    test_dir "$BIND_VOLUME_RECORDS"

    test_file "$BIND_FILE_NAMED"

}

doctor_nginx_proxy_manager() {

    test_dir "$NPM_VOLUME_CONFIG"
    test_dir "$NPM_VOLUME_LETSENCRYPT"

}

doctor_pihole() {

    local placeholder=

}

doctor_kea() {

    test_dir "$KEA_VOLUME_CONFIG"
    test_dir "$KEA_VOLUME_LEASES"
    test_dir "$KEA_VOLUME_LOGS"
    test_dir "$KEA_VOLUME_SOCKETS"

    test_file "$KEA_FILE_CTRL_AGENT"
    test_file "$KEA_FILE_DHCP4"

}

doctor_traefik() {

    test_dir  "$TRAEFIK_VOLUME_LETSENCRYPT"

    test_file "$TRAEFIK_FILE_CONFIG"
    test_file "$REVERSE_PROXY_ENV_FILE"

}

doctor_homarr() {

    test_dir "$HOMARR_VOLUME_CONFIGS"
    test_dir "$HOMARR_VOLUME_DATA"
    test_dir "$HOMARR_VOLUME_ICONS"

}

doctor_homer() {

    test_dir "$HOMER_VOLUME_ASSETS"

}

doctor_tamari() {

    test_dir "$TAMARI_VOLUME_APPDATA"

}

doctor_tandoor() {

    test_file "$TANDOOR_ENV_FILE"

    test_dir "$TANDOOR_VOLUME_DATA"
    test_dir "$TANDOOR_VOLUME_MEDIA_FILES"

}

doctor_nextcloud() {

    test_dir "$NEXTCLOUD_VOLUME_CONFIG"
    test_dir "$NEXTCLOUD_VOLUME_DATA"
    test_dir "$NEXTCLOUD_VOLUME_DB"

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

##############################
#                            #
#          MAIN / _          #
#                            #
##############################

# NOTE: Each of these decision trees first attempts to match the user-supplied
# stack name to a known stack name (`stack=...`) and its healthcheck
# functions (`doctor_...`). Then, it will verify if the stack is allowed to
# run on the system (`grep $STACK .allow`).

stack=main

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_audiobookshelf
    # doctor_calibre_web
    doctor_das_wfpk
    doctor_isponsorblocktv
    doctor_kavita
    # doctor_polaris
    doctor_resilio_sync
    # doctor_silverbullet
    doctor_stirling_pdf
    doctor_syncthing

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

###################################
#                                 #
#          HOMEASSISTANT          #
#                                 #
###################################

stack=homeassistant

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_homeassistant

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

###############################
#                             #
#          DASHBOARD          #
#                             #
###############################

stack=dashboard

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_homer
    # doctor_homarr

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

############################
#                          #
#          IMMICH          #
#                          #
############################

stack=immich

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_immich

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

##############################
#                            #
#          JELLYFIN          #
#                            #
##############################

stack=jellyfin

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_jellyfin

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

#########################
#                       #
#          N8N          #
#                       #
#########################

stack=n8n

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_n8n

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

###############################
#                             #
#          NAVIDROME          #
#                             #
###############################

stack=navidrome

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_navidrome

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

###############################
#                             #
#          NEXTCLOUD          #
#                             #
###############################

stack=nextcloud

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_nextcloud

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

###################################
#                                 #
#          REVERSE-PROXY          #
#                                 #
###################################

stack=reverse-proxy

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_nginx_proxy_manager
    # doctor_traefik
    # doctor_bind9
    # doctor_kea
    # doctor_pihole

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

##########################
#                        #
#          ODOO          #
#                        #
##########################

stack=odoo

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_odoo

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

###############################
#                             #
#          PAPERLESS          #
#                             #
###############################

stack=paperless

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_paperless

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

############################
#                          #
#          PIHOLE          #
#                          #
############################

stack=pihole

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_pihole

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

###########################
#                         #
#          STARR          #
#                         #
###########################

stack=starr

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_starr_apps
    # doctor_bazarr
    doctor_gluetun
    # doctor_lidarr
    # doctor_mylar3
    doctor_prowlarr
    doctor_qbittorrent
    doctor_radarr
    # doctor_readarr
    doctor_recyclarr
    doctor_sonarr

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

############################
#                          #
#          TAMARI          #
#                          #
############################

stack=tamari

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_tamari

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

#############################
#                           #
#          TANDOOR          #
#                           #
#############################

stack=tandoor

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_tandoor

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

################################
#                              #
#          TIMETAGGER          #
#                              #
################################

stack=timetagger

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_timetagger

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

#############################
#                           #
#          VIKUNJA          #
#                           #
#############################

stack=vikunja

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_vikunja

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

###############################
#                             #
#          PORTAINER          #
#                             #
###############################

stack=portainer

if [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $STACK = $stack ] && [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi

#########################
#                       #
#          END          #
#                       #
#########################

# NOTE: Force exit code zero for any '&&' operations in host script
true
