
doctor_starr_apps() {

    test_file "$STARR_VERSIONS_FILE"

}

doctor_bazarr() {

    test_dir "$BAZARR_VOLUME_CONFIG"
    test_dir "$BAZARR_VOLUME_DATA"

}

doctor_gluetun() {

    # Test OpenVPN login credentials for gluetun
    test_file "${GLUETUN_ENV_FILE}"

}

doctor_qbittorrent() {

    test_dir "$QBITTORRENT_VOLUME_CONFIG"
    test_dir "$QBITTORRENT_VOLUME_DOWNLOADS"

}

doctor_radarr() {

    test_dir "$RADARR_VOLUME_CONFIG"
    test_dir "$RADARR_VOLUME_DATA"

}

doctor_sonarr() {

    test_dir "$SONARR_VOLUME_CONFIG"
    test_dir "$SONARR_VOLUME_DATA"

}

doctor_recyclarr() {

    test_dir "$RECYCLARR_VOLUME_CONFIG"

}

doctor_lidarr() {

    test_dir "$LIDARR_VOLUME_CONFIG"
    test_dir "$LIDARR_VOLUME_DATA"

}

doctor_readarr() {

    test_dir "$READARR_VOLUME_CONFIG"
    test_dir "$READARR_VOLUME_DATA"

}

doctor_mylar3() {

    test_dir "$MYLAR3_VOLUME_CONFIG"
    test_dir "$MYLAR3_VOLUME_DATA"

}

doctor_prowlarr() {

    test_dir "$PROWLARR_VOLUME_CONFIG"

}

doctor_notifiarr() {

    test_dir  "$NOTIFIARR_VOLUME_CONFIG"
    test_file "$NOTIFIARR_ENV_PASSWORDS"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_starr_apps
    # doctor_bazarr
    doctor_gluetun
    # doctor_lidarr
    # doctor_mylar3
    doctor_prowlarr
    doctor_qbittorrent
    doctor_radarr
    # doctor_readarr
    doctor_recyclarr
    doctor_sonarr

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
