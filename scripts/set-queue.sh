#!/bin/bash

ovs-vsctl set port s2 \
qos=@newqos -- \
--id=@newqos create qos type=linux-htb other-config:max-rate=80000000 \
queues:1=@dupa1queue queues:2=@dupa2queue -- --id=@dupa1queue create queue other-config:max-rate=8000000 -- --id=@dupa2queue create queue other-config:min-rate=6000000
