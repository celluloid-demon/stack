
doctor_jellyfin_music() {

    test_dir "$JFM_VOLUME_CACHE"
    test_dir "$JFM_VOLUME_CONFIG"
    test_dir "$JFM_VOLUME_MUSIC"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_jellyfin_music

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
