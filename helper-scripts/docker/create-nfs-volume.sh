#!/bin/bash

docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.171,rw --opt device=:/mnt/pool/global nfstest
