#!/bin/bash

# Exit on error
set -eE

# Declare constants

SCRIPT_FOLDER="$(dirname "$0")"

RESOURCES="${SCRIPT_FOLDER}/resources"
WORKING_FOLDER="${SCRIPT_FOLDER}/working_folder"

BIN="/usr/local/bin"

SYSTEM_UNITS="/etc/systemd/system"
USER_UNITS="${HOME}/.config/systemd/user"

TIMER="rsync.timer"
SERVICE="rsync.service"

EXEC="rsync-wrapper"

OS="$(uname --all)"

# User-defined switches

# Valid enums:

#   SYSTEM
#   USER

SYSTEMD_MODE=USER

# Initialize flags with default values
FLAG_os_is_steamos=0

echo "$OS" | grep -q steam && FLAG_os_is_steamos=1

# Initialize working copies of unit files if missing (you'll configure these working copies then flash them to the system)

mkdir -p "${WORKING_FOLDER}"

[ ! -f "${WORKING_FOLDER}/${TIMER}"   ] && cp "${RESOURCES}/${TIMER}"   "${WORKING_FOLDER}/"
[ ! -f "${WORKING_FOLDER}/${SERVICE}" ] && cp "${RESOURCES}/${SERVICE}" "${WORKING_FOLDER}/"
[ ! -f "${WORKING_FOLDER}/${EXEC}"    ] && cp "${RESOURCES}/${EXEC}"    "${WORKING_FOLDER}/"

# *for steamos system compatability

[ $FLAG_os_is_steamos -eq 1 ] && sudo steamos-readonly disable

# "Flash" executable file itself

sudo cp "${WORKING_FOLDER}/${EXEC}" "${BIN}/"

if [ $SYSTEMD_MODE = SYSTEM ]; then

    # "Flash" unit files (copy configured unit files to system)

    sudo cp "${WORKING_FOLDER}/${TIMER}" "${SYSTEM_UNITS}/"
    sudo cp "${WORKING_FOLDER}/${SERVICE}" "${SYSTEM_UNITS}/"

    # Verify unit files

    systemd-analyze verify "${SYSTEM_UNITS}/${TIMER}"
    systemd-analyze verify "${SYSTEM_UNITS}/${SERVICE}"

    # Enable timer

    set +eE
    sudo systemctl enable "$TIMER"
    sudo systemctl status "$TIMER"
    set -eE

elif [ $SYSTEMD_MODE = USER ]; then

    # "Flash" unit files (copy configured unit files to system)

    mkdir -p "$USER_UNITS"

    cp "${WORKING_FOLDER}/${TIMER}" "${USER_UNITS}/"
    cp "${WORKING_FOLDER}/${SERVICE}" "${USER_UNITS}/"

    # Verify unit files

    systemd-analyze --user verify "${USER_UNITS}/${TIMER}"
    systemd-analyze --user verify "${USER_UNITS}/${SERVICE}"

    # Enable timer

    set +eE
    systemctl --user enable "$TIMER"
    systemctl --user status "$TIMER"
    set -eE

fi

[ $FLAG_os_is_steamos -eq 1 ] && sudo steamos-readonly enable

echo
echo "  ######################################################################"
echo "  #                                                                    #"
echo "  #     NOTE: Timer enabled at boot, but not started to give you a     #"
echo "  #           chance to configure things (re-flash to update           #"
echo "  #           system unit files).                                      #"
echo "  #                                                                    #"
echo "  ######################################################################"
echo
