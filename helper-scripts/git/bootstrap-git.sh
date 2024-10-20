#!/bin/bash

readonly NAME='jonathan'
readonly EMAIL='celluloid-demon@users.noreply.github.com'

git config --global user.name  "$NAME"
git config --global user.email "$EMAIL"

gh auth login
