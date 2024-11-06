#!/bin/bash

##########################################################################################
#                                                                                        #
#          !!WARNING: DO NOT TARGET NFS SHARE FROM SAME NODE AS TRUENAS GUEST!!          #
#                                                                                        #
##########################################################################################

readonly VM_ID=$1
readonly LIMIT=5000 # KiB/s (default: unlimited)
readonly BACKUP_DIR='/mnt/pve/global/dump'

# WARNING: Without BW limits, backup will always consume the max bandwidth. So
# if your backup server is on the same server, and the VMs etc, then this
# situation will happen (vzdump freezing the host).

# vzdump $VM_ID --bwlimit $LIMIT --dumpdir $BACKUP_DIR --mode snapshot
vzdump $VM_ID --dumpdir $BACKUP_DIR --mode snapshot
