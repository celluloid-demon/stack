#!/bin/bash

readonly VM_ID=$1
readonly BACKUP_DIR='/mnt/pve/global/dump'

vzdump $VM_ID --dumpdir $BACKUP_DIR --mode snapshot
