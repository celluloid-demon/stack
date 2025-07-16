
doctor_nextcloud() {

    test_dir "$NEXTCLOUD_VOLUME_CONFIG"
    test_dir "$NEXTCLOUD_VOLUME_DATA"
    test_dir "$NEXTCLOUD_VOLUME_DB"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_nextcloud

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
