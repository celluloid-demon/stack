#!/bin/bash

DATASET_ROOT=/mnt/lake/pool.6d86b5884ec6e9d1de8a908766de61c5
DEVCONTAINER_VOLUME_HOME=/root # for saving github credentials

DEVCONTAINER_VOLUME_GIT=${DEVCONTAINER_VOLUME_HOME}/git
DEVCONTAINER_VOLUME_MEDIA=${DATASET_ROOT}/media
DEVCONTAINER_VOLUME_PHOTOS=${DATASET_ROOT}/photos

docker run -it \
    --volume ${DEVCONTAINER_VOLUME_HOME}:/root \
    --volume ${DEVCONTAINER_VOLUME_GIT}:/root/git \
    --volume ${DEVCONTAINER_VOLUME_MEDIA}:/mnt/media \
    --volume ${DEVCONTAINER_VOLUME_PHOTOS}:/mnt/photos \
    ubuntu:latest
