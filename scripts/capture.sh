#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of arguments"
    echo "usage $0 INTERFACE"
    exit 1
fi

interface=$1

sudo tcpdump -i  $interface -n -tttt -q > $(dirname $0)/../results/capture-$interface.log & sleep 10
sudo pkill tcpdump