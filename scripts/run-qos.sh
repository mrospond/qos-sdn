#!/bin/bash

echo "starting..."
#ofctl_rest for meters (rest_qos meters not working)
ryu-manager ryu.app.ofctl_rest ryu.app.rest_qos ryu.app.qos_simple_switch_13 ryu.app.rest_conf_switch

#ryu-manager ryu.app.rest_qos ryu.app.rest_conf_switch ../ryu-apps/qos_simple_switch_13.py
