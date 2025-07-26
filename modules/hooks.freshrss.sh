
doctor_freshrss() {

    test_dir "$FRESHRSS_VOLUME_DATA"
    test_dir "$FRESHRSS_VOLUME_EXTENSIONS"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_freshrss

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
