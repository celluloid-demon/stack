#!/bin/bash

DATASET_ROOT=/mnt/pool

DEVCONTAINER_VOLUME_GIT=${DATASET_ROOT}/git
DEVCONTAINER_VOLUME_HOME=/root # for saving github credentials

docker run -it --volume ${DEVCONTAINER_VOLUME_HOME}:/root --volume ${DEVCONTAINER_VOLUME_GIT}:/root/git devcontainer
