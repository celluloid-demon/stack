#!/bin/bash

# More info: https://nfs.sourceforge.net/nfs-howto/ar01s05.html

readonly OUT='fio-test'

# Test
fio --name=${OUT} --rw=read --direct=1 --ioengine=libaio --bs=32k --numjobs=4 --iodepth=4 --size=1G --runtime=30 --group_reporting

# Cleanup
rm ./${OUT}*
