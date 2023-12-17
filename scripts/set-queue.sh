#!/bin/bash

tc qdisc del dev s2-eth2 root

ovs-vsctl clear port s2-eth2 qos
ovs-vsctl -- --all destroy QoS -- --all destroy Queue

ovs-vsctl set port s2-eth2 qos=@newqos -- \
--id=@newqos create qos type=linux-htb \
other-config:max-rate=8000000 \
queues:1=@dupa1queue \
queues:2=@dupa2queue -- \
--id=@dupa1queue create queue other-config:min-rate=500000 -- \
--id=@dupa2queue create queue other-config:min-rate=5000000

# ovs-vsctl set port s2-eth2 qos=@newqos -- \
# --id=@newqos create qos type=linux-htb \
# other-config:max-rate=8000000 \
# queues:0=@default \
# queues:1=@dupa1queue \
# queues:2=@dupa2queue -- \
# --id=@default create queue other-config:min-rate=2000000 -- \
# --id=@dupa1queue create queue other-config:max-rate=500000 -- \
# --id=@dupa2queue create queue other-config:min-rate=5000000

