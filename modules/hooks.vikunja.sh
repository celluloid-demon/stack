
doctor_vikunja() {

    test_file "$VIKUNJA_ENV_PASSWORDS"
    test_dir  "$VIKUNJA_VOLUME_FILES"
    test_dir  "$VIKUNJA_DB_VOLUME_MYSQL"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_vikunja

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
