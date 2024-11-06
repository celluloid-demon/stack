#!/bin/bash

# More info: https://cluster00.sixducks.org/pve-docs/chapter-sysadmin.html#first_guest_boot_delay

# Hint: This is to delay the start of ALL containers on any node that's
# downstream of the node hosting required nfs shares.

readonly DELAY=$1

pvenode config set --startall-onboot-delay $DELAY
