
doctor_grocy() {

    test_dir "$GROCY_VOLUME_CONFIG"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_grocy

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
