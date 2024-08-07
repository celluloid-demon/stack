#!/bin/bash

set -e

WORKDIR="$(dirname "$0")/build" && \
mkdir -p "$WORKDIR" && \
cd "$WORKDIR"

git clone "https://github.com/ogarcia/docker-polaris" && \
cd docker-polaris

make
