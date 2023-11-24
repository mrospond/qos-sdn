#!/bin/bash

echo "starting..."
ryu-manager ryu.app.rest_qos ryu.app.qos_rest_router ryu.app.rest_conf_switch \
 ryu.app.qos_simple_switch_13