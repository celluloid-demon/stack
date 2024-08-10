#!/bin/bash

# Exit on error, functions inherit parent scope for traps (-E same as `set -o errexit -o errtrace`)

set -eE

# Standard signal / pseudo-signal cheat sheet:

#   DEBUG:      This signal triggers right before a command is to be run.
#   ERR:        When a command ends in a non-zero status triggers this trap. Be aware that commands in if statements, loops, or strung-together commands may not trigger this signal.
#   EXIT:       The EXIT trap is used to specify actions that should be done before the script exits (zero as well as non-zero).
#   RETURN:     The RETURN signal is triggered after a function or sourced script exits.
#   SIGINT:     Interrupt from keyboard (ctrl + c)
#   SIGTERM:    Termination signal

# NOTE: You need single quotes to prevent $LINENO from being expanded when the trap line is first parsed.

# NOTE: Thanks to -E / -o errtrace, this still triggers the trap, even if a failure occurs *inside a function / loop*. With -e (but without -E), when a command fails inside a function, bash *instantly* exits, directly from the function scope - and since there is no ERR trap in effect there (because it wasn't inherited from the parent scope), your trap is not called. Source: https://stackoverflow.com/questions/35800082/how-to-trap-err-when-using-set-e-in-bash

# Trap signals

trap 'exit_non_zero $LINENO' ERR
trap 'exit_zero' EXIT SIGINT

# Declare constants

LOCKFILE="/tmp/rsync-wrapper.lock"
LOG_FOLDER="/home/jonathan/Desktop"
REMOTE="jonathan@raspberry-pi"

LOG="${LOG_FOLDER}/rsync-wrapper.log"
LOG_ERROR="${LOG_FOLDER}/ERROR.log"

SWITCH_run=1

##############################################
#                                            #
#          BEGIN USER CONFIGURATION          #
#                                            #
##############################################

declare -a job=(
    
    APPLICATIONS
    FILES
    HOMEASSISTANT
    ISO
    MEDIA
    ODOO
    RESILIO_SYNC
    SHARED_FILES
    SSH
    SSH_FOR_WINDOWS
    VAULT
    VIKUNJA
    WINDOWS_FILES
    
    )

declare -A source=(

    [APPLICATIONS]="${REMOTE}:/tank0/ds0/@applications"
    [FILES]="${REMOTE}:/tank0/ds0/@files"
    [HOMEASSISTANT]="${REMOTE}:/tank0/ds0/@homeassistant"
    [ISO]="${REMOTE}:/tank0/ds0/@iso"
    [MEDIA]="${REMOTE}:/tank0/ds0/@media"
    [ODOO]="${REMOTE}:/tank0/ds0/@odoo.root"
    [RESILIO_SYNC]="${REMOTE}:/tank0/ds0/@resilio-sync"
    [SHARED_FILES]="${REMOTE}:/tank0/ds0/@shared-files"
    [SSH]="${REMOTE}:/tank0/ds0/@ssh"
    [SSH_FOR_WINDOWS]="${REMOTE}:/tank0/ds0/@ssh-for-windows"
    [VAULT]="${REMOTE}:/tank0/ds0/@vault"
    [VIKUNJA]="${REMOTE}:/tank0/ds0/@vikunja"
    [WINDOWS_FILES]="${REMOTE}:/tank0/ds0/@windows-files"

)

# NOTE: /mnt/e = tank1
declare -A destination=(

    [APPLICATIONS]="/mnt/e/ds0/@applications"
    [FILES]="/mnt/e/ds0/@files"
    [HOMEASSISTANT]="/mnt/e/ds0/@homeassistant"
    [ISO]="/mnt/e/ds0/@iso"
    [MEDIA]="/mnt/e/ds0/@media"
    [ODOO]="/mnt/e/ds0/@odoo.root"
    [RESILIO_SYNC]="/mnt/e/ds0/@resilio-sync"
    [SHARED_FILES]="/mnt/e/ds0/@shared-files"
    [SSH]="/mnt/e/ds0/@ssh"
    [SSH_FOR_WINDOWS]="/mnt/e/ds0/@ssh-for-windows"
    [VAULT]="/mnt/e/ds0/@vault"
    [VIKUNJA]="/mnt/e/ds0/@vikunja"
    [WINDOWS_FILES]="/mnt/e/ds0/@windows-files"

)

############################################
#                                          #
#          END USER CONFIGURATION          #
#                                          #
############################################

run_rsync() {

    rsync \
            --append \
            --archive \
            --exclude *".lnk" \
            --exclude "desktop.ini" \
            --exclude "Google Drive" \
            --exclude "iCloud Drive" \
            --exclude "Images" \
            --exclude '$RECYCLE.BIN' \
            --exclude ".snapshots" \
            --exclude "System Volume Information" \
            --exclude ".Trash"* \
            --hard-links \
            --info=progress2 \
            --partial \
            "$1" \
            "$2"

}

write_log_error() {

    [ ! -f "$LOG_ERROR" ] && touch "$LOG_ERROR"

    echo "$1" >> "$LOG_ERROR"

}

write_log() {

    [ ! -f "$LOG" ] && touch "$LOG"

    echo "$1" >> "$LOG"

}

exit_non_zero() {

    message="Error on line $1"

    echo "$message"
    
    write_log_error "$message"

    [ -d "$LOCKFILE" ] && rmdir "$LOCKFILE"

}

exit_zero() {

    # Release the lock "file"

    [ -d "$LOCKFILE" ] && rmdir "$LOCKFILE"

    echo
    echo "  Completed successfully!"
    echo

}

main() {

    # Try to acquire the lock

    if mkdir "$LOCKFILE"; then

        # Lock acquired, perform rsync backups

        for i in "${job[@]}"; do

            # (NOTE: The reason you're not backing up windows files with robocopy is because you want checksums.)

            echo
            echo "Source:      ${source[$i]}"
            echo "Destination: ${destination[$i]}"

            run_rsync "${source[$i]}/" "${destination[$i]}/"

        done

    else

        # Unable to acquire the lock, a previous instance is still running

        message="Previous rsync job is still in progress (LOCKFILE path: ${LOCKFILE}), exiting..."

        echo "$message"

    fi

}

main
