
##############################
#                            #
#          DEFAULTS          #
#                            #
##############################

CONTAINER_ENGINE=docker # possible values: docker, podman
DOCKER_NETWORK_MACVLAN='homelab'
POOL='/mnt/lake/pool.6d86b5884ec6e9d1de8a908766de61c5'
PUID=3000 # 3000=fam@nas (3000 is the truenas default unprivileged user id)
PGID=3000
MEDIA_PUID=3001
MEDIA_PGID=3001
OPERATOR_PUID=3002
OPERATOR_PGID=37
TZ='America/Los_Angeles' # see: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

CACHE="${POOL}/cache"
MEDIA="${POOL}/media"
PHOTOS="${POOL}/photos"
VOLUMES="${POOL}/volumes"

STARR_CONFIG_ROOT="${MEDIA}/starr"

STARR_VERSIONS_FILE="${STARR_CONFIG_ROOT}/versions.env"

############################
#                          #
#          GRAMPS          #
#                          #
############################

GRAMPS_VOLUME_CACHE="${VOLUMES}/gramps/cache"
GRAMPS_VOLUME_DB="${VOLUMES}/gramps/db"
GRAMPS_VOLUME_INDEX="${VOLUMES}/gramps/index"
GRAMPS_VOLUME_MEDIA="${VOLUMES}/gramps/media"
GRAMPS_VOLUME_SECRET="${VOLUMES}/gramps/secret"
GRAMPS_VOLUME_THUMB_CACHE="${VOLUMES}/gramps/thumb_cache"
GRAMPS_VOLUME_TMP="${VOLUMES}/gramps/tmp"
GRAMPS_VOLUME_USERS="${VOLUMES}/gramps/users"

###########################
#                         #
#          STARR          #
#                         #
###########################

# Gluetun

# NOTE: The env_file in docker-compose.yml is for setting variables in a
# container (just like the environment key). Those variables will NOT be
# available in the docker compose file! .env is for docker compose, whcih
# means it will be interpreted by docker compose and you can use the
# variables in the yaml file.

GLUETUN_ENV_FILE="${STARR_CONFIG_ROOT}/gluetun/password.env"

# Prowlarr

PROWLARR_VOLUME_CONFIG="${STARR_CONFIG_ROOT}/prowlarr"

# QBittorrent

QBITTORRENT_VOLUME_CONFIG="${STARR_CONFIG_ROOT}/qbittorrent"
QBITTORRENT_VOLUME_DOWNLOADS="${MEDIA}/downloads"

# Radarr

RADARR_VOLUME_CONFIG="${STARR_CONFIG_ROOT}/radarr"
RADARR_VOLUME_DATA="$MEDIA"

# Recyclarr

RECYCLARR_VOLUME_CONFIG="${STARR_CONFIG_ROOT}/recyclarr"

# Sonarr

SONARR_VOLUME_CONFIG="${STARR_CONFIG_ROOT}/sonarr"
SONARR_VOLUME_DATA="$MEDIA"

##############################
#                            #
#          FRESHRSS          #
#                            #
##############################

FRESHRSS_VOLUME_DATA="${VOLUMES}/freshrss/data"
FRESHRSS_VOLUME_EXTENSIONS="${VOLUMES}/freshrss/extensions"

###########################
#                         #
#          GROCY          #
#                         #
###########################

GROCY_VOLUME_CONFIG="${VOLUMES}/grocy"

###########################
#                         #
#          OTHER          #
#                         #
###########################

# Audiobookshelf

ABS_VOLUME_CONFIG="${MEDIA}/audiobookshelf/config"
ABS_VOLUME_METADATA="${MEDIA}/audiobookshelf/metadata"
ABS_VOLUME_AUDIOBOOKS="${MEDIA}/audiobooks"
ABS_VOLUME_PODCASTS="${MEDIA}/podcasts"

# Download Audio Stream (WFPK)

DAS_WFPK_CRON_COMMENT='in UTC (run script every weekday at 8:00 PM GMT / 3:00 PM Eastern / 12:00 PM Pacific)' # NOTE: sharp-# character not needed in string
DAS_WFPK_CRON_SCHEDULE='0 12 * * 1-5'
DAS_WFPK_DURATION='180' # in minutes
DAS_WFPK_OUTPUT_FILE_BASENAME='wfpk'
DAS_WFPK_STREAM_URL='http://lpm.streamguys1.com/wfpk-web'
DAS_WFPK_VOLUME_OUTPUT="${MEDIA}/radio/wfpk/raw"

# Home Assistant

HASS_VOLUME_CONFIG="${VOLUMES}/homeassistant/config"

# Homarr

HOMARR_VOLUME_CONFIGS="${VOLUMES}/homarr/configs"
HOMARR_VOLUME_DATA="${VOLUMES}/homarr/data"
HOMARR_VOLUME_ICONS="${VOLUMES}/homarr/icons"

# Immich

# IMMICH_DATABASE_NAME='immich'
# IMMICH_DATABASE_USERNAME='immich'
# IMMICH_ENV_FILE='/filepacks/photos/immich/password.env'
# IMMICH_VOLUME_UPLOAD='/filepacks/photos/upload'
# IMMICH_VOLUME_DB_DATA='/filepacks/photos/immich/db/data'

# You can find documentation for all the supported env variables at https://immich.app/docs/install/environment-variables
# The location where your uploaded files are stored
UPLOAD_LOCATION="${PHOTOS}/upload"
# The location where your database files are stored
DB_DATA_LOCATION="${PHOTOS}/immich/db/data"
# To set a timezone, uncomment the next line and change Etc/UTC to a TZ identifier from this list: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
# TZ=Etc/UTC
# The Immich version to use. You can pin this to a specific version like "v1.71.0"
IMMICH_VERSION=release
# Connection secret for postgres. You should change it to a random password
DB_PASSWORD=postgres
# The values below this line do not need to be changed
###################################################################################
DB_USERNAME=postgres
DB_DATABASE_NAME=immich

# iSponsorBlockTV

ISBTV_VOLUME_DATA="${VOLUMES}/isponsorblocktv/data"

# Jellyfin

JELLYFIN_VOLUME_CACHE="${CACHE}/jellyfin" # should be on ssd
JELLYFIN_VOLUME_CONFIG="${MEDIA}/jellyfin"
JELLYFIN_VOLUME_MOVIES="${MEDIA}/movies"
JELLYFIN_VOLUME_TVSHOWS="${MEDIA}/tvshows"
JELLYFIN_VOLUME_SHORTS="${MEDIA}/shorts"
JELLYFIN_VOLUME_MUSIC="${MEDIA}/music"

# Jellyfin (Music)

JFM_VOLUME_CACHE="${CACHE}/jellyfin-music" # should be on ssd
JFM_VOLUME_CONFIG="${MEDIA}/jellyfin-music"
JFM_VOLUME_MUSIC="${MEDIA}/music"

# Kavita

KAVITA_VOLUME_CONFIG="${MEDIA}/kavita/config"
KAVITA_VOLUME_BOOKS="${MEDIA}/books"

# n8n

N8N_ENV_FILE="${VOLUMES}/n8n/password.env"
N8N_INIT_DATA="${VOLUMES}/n8n/init-data.sh"
N8N_VOLUME_DATA="${VOLUMES}/n8n/data"
N8N_VOLUME_DB="${VOLUMES}/n8n/db"
N8N_VOLUME_REDIS="${VOLUMES}/n8n/redis"

# Navidrome

NAVIDROME_VOLUME_CONFIG="${MEDIA}/navidrome/config"
NAVIDROME_VOLUME_MUSIC="${MEDIA}/music"

# Nextcloud

NEXTCLOUD_VOLUME_CONFIG="${VOLUMES}/nextcloud"
NEXTCLOUD_VOLUME_DATA='/mnt/pool/nextcloud'
NEXTCLOUD_VOLUME_DB="${VOLUMES}/nextcloud"

# Odoo

ODOO_ENV_FILE="${VOLUMES}/odoo/password.env"
ODOO_VOLUME_ADDONS="${VOLUMES}/odoo/addons"
ODOO_VOLUME_CONFIG="${VOLUMES}/odoo/config"
ODOO_VOLUME_PG_DATA="${VOLUMES}/odoo/data.pg"
ODOO_VOLUME_WEB_DATA="${VOLUMES}/odoo/data.web"

# Paperless

PAPERLESS_URL='https://paperless.sixducks.duckdns.org'
PAPERLESS_VOLUME_CONSUME="${VOLUMES}/paperless/consume"
PAPERLESS_VOLUME_DATA="${VOLUMES}/paperless/data"
PAPERLESS_VOLUME_DB="${VOLUMES}/paperless/db"
PAPERLESS_VOLUME_EXPORT="${VOLUMES}/paperless/export"
PAPERLESS_VOLUME_MEDIA="${VOLUMES}/paperless/media"

# Resilio Sync

RESILIO_VOLUME_CACHE="${VOLUMES}/resilio-sync/cache"
RESILIO_VOLUME_CONFIG="${VOLUMES}/resilio-sync/config"
RESILIO_VOLUME_DATA="${VOLUMES}/resilio-sync/shares"

# Stirling PDF

SP_VOLUME_TESSDATA="${VOLUMES}/stirling-pdf/tessdata"
SP_VOLUME_EXTRA_CONFIGS="${VOLUMES}/stirling-pdf/extra-configs"

# Syncthing

SYNCTHING_VOLUME_CONFIG="${VOLUMES}/syncthing/config"
SYNCTHING_VOLUME_DATA="${VOLUMES}" # NOTE: preference is to match paths across container / host (for your own sanity)

# Tamari

TAMARI_VOLUME_APPDATA="${VOLUMES}/tamari/appdata"

# TimeTagger

TIMETAGGER_ENV_FILE="${VOLUMES}/timetagger/password.env"
TIMETAGGER_PORT=34315
TIMETAGGER_VOLUME_DATA="${VOLUMES}/timetagger/data"

# Vikunja

VIKUNJA_ENV_PASSWORDS="${VOLUMES}/vikunja/password.env"
VIKUNJA_VOLUME_FILES="${VOLUMES}/vikunja/app/vikunja/files"

# Vikunja (db)

VIKUNJA_DB_VOLUME_MYSQL="${VOLUMES}/vikunja/var/lib/mysql"
