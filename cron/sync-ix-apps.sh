#!/bin/bash

# Note: Recommended to save cron scripts to bin folder in pool or user home folder

POOL='/mnt/lake/pool.6d86b5884ec6e9d1de8a908766de61c5'

SOURCE="/mnt/.ix-apps"
DESTINATION="${POOL}/backup/docker_apps"

# TODO: 'bake' source of truth into this script when flashed to system (have tmp keyword replaced at flash time)
LOGDIR="/var/log/"
LOGFILE="/var/log/sync-ix-apps.log"

rsync -avAHX --exclude="*/.zfs/*" "${SOURCE}/" "${DESTINATION}/"

# Prometheus node_exporter textfile collector metric to indicate last successful run time
mkdir -p "$LOGDIR"
echo "$(date +%s): SUCCESS" > /path/to/directory/my_batch_job.prom.$$
mv /path/to/directory/my_batch_job.prom.$$ /path/to/directory/my_batch_job.prom
