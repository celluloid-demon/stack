#!/bin/bash

# readonly ID=$1
# readonly INDEX=$2
# readonly DIR=$3
# readonly MP=$4

# pct set $ID -mp${INDEX} "${DIR},mp=${MP}"

id=$1
index=$2
dir=$3

pct set $id -mp${index} "${dir},mp=${dir}"
