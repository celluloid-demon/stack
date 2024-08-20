#!/bin/bash

# Exit on error
set -eE

# Declare constants
BIN="/usr/local/bin"
EXEC="sync-data"
EXEC_WRAPPER="sync-data-wrapper"
SCRIPT_FOLDER="$(dirname "$0")"

RESOURCES="${SCRIPT_FOLDER}/resources"
STAGING_FOLDER="${SCRIPT_FOLDER}/tmp"

# Initialize working copies of unit files if missing (you'll configure these working copies then flash them to the system)
mkdir -p "${STAGING_FOLDER}"
[ ! -f   "${STAGING_FOLDER}/${EXEC_WRAPPER}" ] && cp "${RESOURCES}/${EXEC_WRAPPER}" "${STAGING_FOLDER}/"

# "Flash" executable files to system
sudo cp "${RESOURCES}/${EXEC}"              "${BIN}/"
sudo cp "${STAGING_FOLDER}/${EXEC_WRAPPER}" "${BIN}/"
