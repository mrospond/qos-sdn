# qos-sdn

### Prerequisites
* mininet - https://mininet.org/download/
* Open vSwitch - https://docs.openvswitch.org/en/latest/
* Ryu SDN Controller- https://ryu-sdn.org/

### SDN QoS
1. per-flow QoS
1. DiffServ
1. OpenFlow meters, queues

### ovs egress traffic shaping
```
sudo ovs-vsctl -- \
  add-br br0 -- \
  add-port br0 eth0 -- \
  add-port br0 vif1.0 -- set interface vif1.0 ofport_request=5 -- \
  add-port br0 vif2.0 -- set interface vif2.0 ofport_request=6 -- \
  set port eth0 qos=@newqos -- \
  --id=@newqos create qos type=linux-htb \
      other-config:max-rate=1000000000 \
      queues:123=@vif10queue \
      queues:234=@vif20queue -- \
  --id=@vif10queue create queue other-config:max-rate=10000000 -- \
  --id=@vif20queue create queue other-config:max-rate=20000000
```

Multi Queue Policer for OVS-DPDK
```
sudo ovs-vsctl --timeout=5 set port dpdk1 qos=@myqos -- \
    --id=@myqos create qos type=trtcm-policer \
    other-config:cir=50000 other-config:cbs=2048 \
    other-config:eir=50000 other-config:ebs=2048  \
    queues:10=@dpdk1Q10 queues:20=@dpdk1Q20 -- \
     --id=@dpdk1Q10 create queue \
      other-config:cir=100000 other-config:cbs=2048 \
      other-config:eir=0 other-config:ebs=0 -- \
     --id=@dpdk1Q20 create queue \
       other-config:cir=0 other-config:cbs=0 \
       other-config:eir=50000 other-config:ebs=2048
```

### OVSDB
https://docs.openvswitch.org/en/latest/faq/qos/

```
sudo ovs-vsctl -- --all destroy QoS -- --all destroy Queue

sudo ovs-vsctl list QoS
sudo ovs-vsctl list Queue
```
list queues on a switch
```
sudo ovs-ofctl queue-stats s2 -O OpenFlow13
```