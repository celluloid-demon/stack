
doctor_nginx_proxy_manager_alt() {

    test_dir "$NPM_ALT_VOLUME_CONFIG"
    test_dir "$NPM_ALT_VOLUME_LETSENCRYPT"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_nginx_proxy_manager_alt

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
