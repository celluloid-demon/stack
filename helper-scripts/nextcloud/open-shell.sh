#!/bin/bash

# Command cheat sheet:

#   php occ files:scan --all # rescan (all) files
#   php occ app:disable files_snapshots # disable the app files_snapshots (if it's preventing nextcloud from running due to being out-of-date)

readonly CONTAINER='ix-nextcloud-nextcloud-1'
readonly USER=33 # www-data

docker exec -u $USER -it $CONTAINER /bin/bash
