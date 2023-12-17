#!/bin/bash

sed '/OFPFlowMod(/,/)/s/0, cmd/1, cmd/' /home/test/ryu/ryu/app/rest_router.py > /home/test/ryu/ryu/app/qos_rest_router.py

cd /home/test/ryu;
sudo python ./setup.py install
