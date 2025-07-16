
doctor_odoo() {

    test_file "$ODOO_ENV_FILE"

    test_dir "$ODOO_VOLUME_ADDONS"
    test_dir "$ODOO_VOLUME_CONFIG"
    test_dir "$ODOO_VOLUME_PG_DATA"
    test_dir "$ODOO_VOLUME_WEB_DATA"

}

if [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'begin' ]; then

    doctor_odoo

elif [ $OPERATION = 'up' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'begin' ]; then

    do_nothing=

elif [ $OPERATION = 'down' ] && [ $SUB_OPERATION = 'end' ]; then

    do_nothing=

fi
