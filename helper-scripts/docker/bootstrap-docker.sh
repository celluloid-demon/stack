#!/bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh && \
sh get-docker.sh && \
systemctl enable docker && \
systemctl enable containerd && \
systemctl start docker && \
systemctl start containerd && \
docker run hello-world
