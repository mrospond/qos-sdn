#!/bin/bash

ovs-vsctl set Bridge s2 protocols=OpenFlow13
ovs-vsctl set-manager ptcp:6632