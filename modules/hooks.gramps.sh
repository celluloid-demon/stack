
doctor_gramps() {

    test_dir  "$GRAMPS_VOLUME_CACHE"
    test_dir  "$GRAMPS_VOLUME_DB"
    test_dir  "$GRAMPS_VOLUME_INDEX"
    test_dir  "$GRAMPS_VOLUME_MEDIA"
    test_dir  "$GRAMPS_VOLUME_SECRET"
    test_dir  "$GRAMPS_VOLUME_THUMB_CACHE"
    test_dir  "$GRAMPS_VOLUME_TMP"
    test_dir  "$GRAMPS_VOLUME_USERS"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_gramps

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
