#!/bin/bash

set -e

GATEWAY='192.168.1.1'
IP_RANGE=''
NETWORK_NAME='stack'
PARENT='end0' # often eth0
SUBNET='192.168.1.0/24' # your router's address range

docker network create \
                        -d macvlan \
                        --subnet="$SUBNET" \
                        --gateway="$GATEWAY" \
                        -o parent="$PARENT" \
                        -o macvlan_mode=bridge "$NETWORK_NAME"
