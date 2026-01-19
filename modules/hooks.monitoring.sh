
doctor_monitoring() {

    # Loki volumes

    test_dir "${MONITORING_LOKI_VOLUME_CONFIG}"
    test_dir "${MONITORING_LOKI_VOLUME_DATA}"

    # Node exporter volumes

    # test_dir "${GLOBAL_TEXTFILE_COLLECTOR_DIR}" # for custom metrics

    # Prometheus volumes

    # test_dir "${MONITORING_PROMETHEUS_VOLUME_CONFIG}"
    # test_dir "${MONITORING_PROMETHEUS_VOLUME_DATA}"

    # test_owner "${MONITORING_PROMETHEUS_VOLUME_CONFIG}" 65534 65534
    # test_owner "${MONITORING_PROMETHEUS_VOLUME_DATA}" 65534 65534

    # Grafana volumes

    # test_dir "${MONITORING_GRAFANA_VOLUME_DATA}"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_monitoring

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
