#!/bin/bash

echo "starting..."
sudo mn --mac --switch=ovsk,protocols=OpenFlow13 --controller=remote,ip=127.0.0.1
# sudo python $(dirname $0)/topo.py
