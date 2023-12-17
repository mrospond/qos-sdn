#!/bin/bash

ip addr del 10.0.0.2/8 dev h2-eth0
ip addr add 172.16.20.9/24 dev h2-eth0

ip route add default via 172.16.20.2