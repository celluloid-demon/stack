
doctor_wger() {

    test_dir "$WGER_VOLUME_BEAT"
    test_dir "$WGER_VOLUME_DB"
    test_dir "$WGER_VOLUME_MEDIA"
    test_dir "$WGER_VOLUME_STATIC"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_wger

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
