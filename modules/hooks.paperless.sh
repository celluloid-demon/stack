
doctor_paperless() {

    test_dir "$PAPERLESS_VOLUME_CONSUME"
    test_dir "$PAPERLESS_VOLUME_DATA"
    test_dir "$PAPERLESS_VOLUME_DB"
    test_dir "$PAPERLESS_VOLUME_EXPORT"
    test_dir "$PAPERLESS_VOLUME_MEDIA"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_paperless

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
