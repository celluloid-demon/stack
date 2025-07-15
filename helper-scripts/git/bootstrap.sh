#!/bin/bash

# NOTE: Set your desired NAME and EMAIL values in your shell befor running this script.

# Example:
# 
#   export NAME='jonathan'
#   export EMAIL='celluloid-demon@users.noreply.github.com'

git config --global user.name  "$NAME"
git config --global user.email "$EMAIL"

gh auth login
