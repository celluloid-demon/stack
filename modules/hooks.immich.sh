
doctor_immich() {

    test_dir "$UPLOAD_LOCATION"
    test_dir "$DB_DATA_LOCATION"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_immich

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
