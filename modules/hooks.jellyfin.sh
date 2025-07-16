
doctor_jellyfin() {

    test_dir "$JELLYFIN_VOLUME_CACHE"
    test_dir "$JELLYFIN_VOLUME_CONFIG"
    test_dir "$JELLYFIN_VOLUME_MOVIES"
    test_dir "$JELLYFIN_VOLUME_TVSHOWS"
    test_dir "$JELLYFIN_VOLUME_SHORTS"
    test_dir "$JELLYFIN_VOLUME_MUSIC"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_jellyfin

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
