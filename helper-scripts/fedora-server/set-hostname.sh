#!/bin/bash

readonly NEW_HOSTNAME=$1

hostnamectl set-hostname --static $NEW_HOSTNAME
