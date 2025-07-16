
doctor_n8n() {

    test_file       "$N8N_ENV_FILE"
    test_file       "$N8N_INIT_DATA"
    test_executable "$N8N_INIT_DATA"
    test_dir        "$N8N_VOLUME_DATA"
    test_dir        "$N8N_VOLUME_DB"
    test_dir        "$N8N_VOLUME_REDIS"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_n8n

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
