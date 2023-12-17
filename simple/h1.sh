#!/bin/bash

ip addr del 10.0.0.1/8 dev h1-eth0
ip addr add 172.16.10.9/24 dev h1-eth0

ip route add default via 172.16.10.1