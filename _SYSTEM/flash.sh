#!/bin/bash

FILE='./global.env'
DIR='/etc/stack'

mkdir -p "$DIR"

cp "$FILE" "${DIR}/"
