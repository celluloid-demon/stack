#!/bin/bash

# More info: https://github.com/mikf/gallery-dl

# Usage:
#   run.sh tamari-gallery-dl <URL>

readonly URL="$1"

docker  run \
        --interactive \
        --rm \
        --tty \
        --volume "${TGL_FILE_CONFIG}":/etc/gallery-dl.conf \
        --volume "${TGL_VOLUME_DOWNLOADS}":/gallery-dl \
        mikf123/gallery-dl:latest \
        "$URL"
