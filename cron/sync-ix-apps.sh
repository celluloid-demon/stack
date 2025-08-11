#!/bin/bash

# Note: Recommended to save cron scripts to bin folder in pool or user home folder

SOURCE='/mnt/.ix-apps'
DESTINATION='/mnt/lake/pool.6d86b5884ec6e9d1de8a908766de61c5/backup/apps'

rsync -avAHX "${SOURCE}/" "${DESTINATION}/"
