#!/bin/bash

# Description: Make test-query to kea-dhcp4 server via its control agent.

curl -X POST -H "Content-Type: application/json" \
    -d '{ "command": "config-get", "service": [ "dhcp4" ] }' \
    http://localhost:8002/
