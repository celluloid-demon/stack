
doctor_netdata() {

    test_dir "$NETDATA_VOLUME_CACHE"
    test_dir "$NETDATA_VOLUME_CONFIG"
    test_dir "$NETDATA_VOLUME_LIB"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_netdata

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
