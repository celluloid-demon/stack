#!/bin/bash

test_dir() {

    # Test required directories.

    [ ! -d "$1" ] && echo "$1 (dir) not found, exiting" && exit 1

    true

}

test_file() {

    # Test required files.

    [ ! -f "$1" ] && echo "$1 (file) not found, exiting" && exit 1

    true

}

test_command() {

    # Test required commands/executables.

    ! which $1 1>/dev/null && echo "please install $1" && exit 1

    true

}

test_image() {

    # Test required docker images.

    ! docker image ls --quiet $1 > /dev/null && echo "$1 image missing (please build)" && exit 1

    true

}

test_executable() {

    # Test execute permissions of a binary/script.

    [ ! -x "$1" ] && echo "$1 not executable, exiting" && exit 1

    true

}

test_owner() {

    # Test ownership of a file.

    # 1: file
    # 2: uid
    # 3: gid

    [ "$(stat -c "%u:%g" $1)" != "$2:$3" ] && echo "$1 wrong ownership" && exit 1

    # todo would be real nice if this would interactively prompt user and ask
    # if they want to fix permissions (assuming this script is NOT run as
    # root, the user will be directed to copy + paste a sudo oneliner to fix
    # the issue, with reminder to run calling script again)

    true

}

test_param() {

    # Test required parameters.

    local    _param=$1
    local -a _valid_params=( $2 )

    if [[ ! "${_valid_params[*]}" =~ "$_param" ]]; then

        echo "Invalid parameter \"$_param\""
        exit 1

    fi

}

test_allow() {

    # Test service 'allow' status.

    ! grep -q $1 .allow && echo "Service stack \"$1\" not yet allowed on system (add to .allow to change this)." && exit 1

    true

}
