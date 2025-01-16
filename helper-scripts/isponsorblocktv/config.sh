#!/bin/bash

# NOTE: Remove `--net=host` line on windows and macOS. If you want to auto discover your device, you need to run the container with the --net=host flag. This only works on linux.

# NOTE: Remove `-e TERM=$TERM...` line if you get errors/graphical glitches

docker run --rm -it \
    -v /mnt/pool/db/isponsorblocktv/data:/app/data \
    --net=host \
    -e TERM=$TERM -e COLORTERM=$COLORTERM \
    ghcr.io/dmunozv04/isponsorblocktv:latest \
    --setup
