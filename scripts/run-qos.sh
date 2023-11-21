#!/bin/bash

echo "starting..."
ryu-manager ryu.app.rest_qos ryu.app.qos_simple_switch_13 ryu.app.rest_conf_switch

#ryu-manager ryu.app.rest_qos ryu.app.rest_conf_switch ../ryu-apps/qos_simple_switch_13.py
