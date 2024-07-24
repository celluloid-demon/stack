#!/bin/bash

set -eE

trap 'exit_error' ERR
trap 'exit_zero' EXIT

exit_zero() {

    local do_nothing=

}

exit_error() {

    docker_log_error "...oh no"

}

docker_log() {

    echo "$1" > /proc/1/fd/1 # docker stdin

}

docker_log_error() {

    echo "$1" > /proc/1/fd/2 # docker stderr

}

# Test required env vars
[ ! -n "$CRON_SCHEDULE"        ] && docker_log_error "missing var" && exit 1
[ ! -n "$DURATION"             ] && docker_log_error "missing var" && exit 1
[ ! -n "$OUTPUT_FILE_BASENAME" ] && docker_log_error "missing var" && exit 1
[ ! -n "$STREAM_URL"           ] && docker_log_error "missing var" && exit 1

# Make tmp file to populate crontab
cron_file_tmp=$(mktemp)

echo "${CRON_SCHEDULE} /usr/local/bin/download-audio-stream # ${CRON_COMMENT}" >> ${cron_file_tmp}
echo "# NOTE: Remember to end this file with an empty newline"                 >> ${cron_file_tmp}
echo ""                                                                        >> ${cron_file_tmp}

crontab ${cron_file_tmp} && crontab -l
rm ${cron_file_tmp}

# NOTE: For people not using alpine, the crond supporting the '-d 8' parameter is not the standard cron, it is the crond command from busybox (which alpine ships with). For example from ubuntu, you can run this as 'busybox crond -f -d 8'. For older versions you have to use '... -L /dev/stdout/'.

# Start crond with log level 8 in foreground, output to stderr
crond -f -d 8
