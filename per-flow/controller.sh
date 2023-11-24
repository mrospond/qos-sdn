#!/bin/bash

sudo ovs-vsctl set-manager ptcp:6632

echo "starting..."
ryu-manager ryu.app.rest_qos ryu.app.qos_simple_switch_13 ryu.app.rest_conf_switch