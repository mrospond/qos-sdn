#!/bin/bash

#ofctl_rest for meters (rest_qos meters not working) => its ovs's fault
#ryu-manager ryu.app.ofctl_rest ryu.app.rest_qos ryu.app.qos_simple_switch_13 ryu.app.rest_conf_switch

#DiffServ
sudo ovs-vsctl set-manager ptcp:6632

echo "run manager..."
ryu-manager ryu.app.rest_qos ryu.app.qos_rest_router ryu.app.rest_conf_switch