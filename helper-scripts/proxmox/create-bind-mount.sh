#!/bin/bash

readonly ID=$1
readonly INDEX=$2
readonly DIR=$3
readonly MP=$4

pct set $ID -mp${INDEX} "${DIR},mp=${MP}"
