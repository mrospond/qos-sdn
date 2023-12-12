#!/bin/bash

iperf -c 172.16.20.9 -p $1 -u -b 8M