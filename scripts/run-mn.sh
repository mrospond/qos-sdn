#!/bin/bash

#sudo mn --controller=remote,ip=127.0.0.1 --mac -i 10.1.1.0/24 --switch=ovsk,protocols=OpenFlow13 --topo=single,4
sudo python3 $(dirname $0)/../qos_sample_topology.py