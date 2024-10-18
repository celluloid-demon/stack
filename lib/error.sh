#!/bin/bash

# Exit on error
set -eE

trap 'exit_error $LINENO' ERR
trap 'exit_zero' EXIT

exit_zero() {

    local do_nothing=

    # todo add conditionals based on event / operation (even if it's just optional log stuff)

}

exit_error() {

    echo "...oh no $1"

    # todo add conditionals based on event / operation 

}
