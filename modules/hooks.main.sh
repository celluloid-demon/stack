
doctor_audiobookshelf() {

    test_dir "$ABS_VOLUME_CONFIG"
    test_dir "$ABS_VOLUME_METADATA"
    test_dir "$ABS_VOLUME_AUDIOBOOKS"
    test_dir "$ABS_VOLUME_PODCASTS"

}

doctor_calibre_web() {

    test_dir "$CALIBRE_VOLUME_CONFIG"
    test_dir "$CALIBRE_VOLUME_BOOKS"

}

doctor_das_wfpk() {

    test_dir "$DAS_WFPK_VOLUME_OUTPUT"

}

doctor_isponsorblocktv() {
    
    test_dir "$ISBTV_VOLUME_DATA"

}

doctor_kavita() {

    test_dir "$KAVITA_VOLUME_CONFIG"
    test_dir "$KAVITA_VOLUME_BOOKS"

}

doctor_polaris() {

    test_image $POLARIS_REPOSITORY

    test_dir "$POLARIS_VOLUME_MUSIC"
    test_dir "$POLARIS_VOLUME_CACHE"
    test_dir "$POLARIS_VOLUME_DATA"
    test_dir "$POLARIS_VOLUME_WFPK"

    # "Take note that you must create before the cache directory
    # /my/polaris/cache and data directory /my/polaris/data and set ownership
    # to UID/GID 100 in both, otherwise the main proccess will crash."
    
    # Source: https://github.com/ogarcia/docker-polaris

    test_owner "$POLARIS_VOLUME_CACHE" 100 100
    test_owner "$POLARIS_VOLUME_DATA"  100 100

}

doctor_resilio_sync() {

    test_dir "$RESILIO_VOLUME_CACHE"
    test_dir "$RESILIO_VOLUME_CONFIG"
    test_dir "$RESILIO_VOLUME_DATA"

}

doctor_silverbullet() {

    test_file "$SB_ENV_FILE"
    test_dir  "$SB_VOLUME_SPACE"

}

doctor_stirling_pdf() {

    test_dir "$SP_VOLUME_TESSDATA"
    test_dir "$SP_VOLUME_EXTRA_CONFIGS"

}

doctor_syncthing() {

    test_dir "$SYNCTHING_VOLUME_CONFIG"
    test_dir "$SYNCTHING_VOLUME_DATA"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    # doctor_audiobookshelf
    # doctor_calibre_web
    # doctor_das_wfpk
    doctor_isponsorblocktv
    doctor_kavita
    # doctor_polaris
    # doctor_resilio_sync
    # doctor_silverbullet
    # doctor_stirling_pdf
    # doctor_syncthing

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
