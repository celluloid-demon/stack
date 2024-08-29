#!/bin/bash

set -e

WORKDIR="$(dirname "$0")/build" && \
mkdir -p "$WORKDIR" && \
cd "$WORKDIR"

git clone "https://github.com/ogarcia/docker-polaris/" && \
cd docker-polaris && \
git checkout 1e6b9414f251a118cdcf94cbe8a1bc4796b85486

make
