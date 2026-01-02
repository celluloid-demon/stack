
doctor_netmon() {

    test_dir "${NETMON_PROMETHEUS_VOLUME_CONFIG}"
    test_dir "${NETMON_PROMETHEUS_VOLUME_DATA}"

    test_owner "${NETMON_PROMETHEUS_VOLUME_CONFIG}" 65534 65534
    test_owner "${NETMON_PROMETHEUS_VOLUME_DATA}" 65534 65534

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_netmon

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
