#!/bin/bash

iperf3 -c 172.16.20.9 -p $1 -u -b 8M
