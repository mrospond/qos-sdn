# qos-sdn

### QoS

1. per-flow QoS
```
# start topology
sudo mn --mac --switch=ovsk,protocols=OpenFlow13 --controller=remote,ip=127.0.0.1 -x

# set listen port to acceess OVSDB
sudo ovs-vsctl set-manager ptcp:6632

# modify simple_switch_13.py to register flow entry into table id:1
sed '/OFPFlowMod(/,/)/s/)/, table_id=1)/' ~/ryu/ryu/app/simple_switch_13.py > ~/ryu/ryu/app/qos_simple_switch_13.py
cd ~/ryu; sudo python ./setup.py install

# start ryu
ryu-manager ryu.app.rest_qos ryu.app.qos_simple_switch_13 ryu.app.rest_conf_switch

# set ovsdb_addr
curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

# set queue
curl -X POST -d '{"port_name": "s1-eth1", "type": "linux-htb", "max_rate": "1000000", "queues": [{"max_rate": "500000"}, {"min_rate": "800000"}]}' http://localhost:8080/qos/queue/0000000000000001 | jq

# install the following flow entry to the switch
curl -X POST -d '{"match": {"nw_dst": "10.0.0.1", "nw_proto": "UDP", "tp_dst": "5002"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001 | jq

# verify settings
curl -X GET http://localhost:8080/qos/rules/0000000000000001 | jq
```

2. DiffServ

```
# start topology
sudo mn --topo linear,2 --mac --switch=ovsk,protocols=OpenFlow13 --controller=remote,ip=127.0.0.1 -x

# set listen port to access OVSDB 
sudo ovs-vsctl set-manager ptcp:6632

# h1:
ip addr del 10.0.0.1/8 dev h1-eth0
ip addr add 172.16.20.10/24 dev h1-eth0
ip route add default via 172.16.20.1

# h2:
ip addr del 10.0.0.2/8 dev h2-eth0
ip addr add 172.16.10.10/24 dev h2-eth0
ip route add default via 172.16.10.1

# modify rest_router.py to register flow entry into table id:1
sed '/OFPFlowMod(/,/)/s/0, cmd/1, cmd/' ~/ryu/ryu/app/rest_router.py > ~/ryu/ryu/app/qos_rest_router.py
cd ~/ryu; sudo python ./setup.py install

# start ryu
ryu-manager ryu.app.rest_qos ryu.app.qos_rest_router ryu.app.rest_conf_switch

# set ovsdb_addr
curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

# set queue
curl -X POST -d '{"port_name": "s1-eth1", "type": "linux-htb", "max_rate": "1000000", "queues":[{"max_rate": "1000000"}, {"min_rate": "200000"}, {"min_rate": "500000"}]}' http://localhost:8080/qos/queue/0000000000000001 | jq

# router settings
curl -X POST -d '{"address": "172.16.20.1/24"}' http://localhost:8080/router/0000000000000001 | jq

curl -X POST -d '{"address": "172.16.30.10/24"}' http://localhost:8080/router/0000000000000001 | jq

curl -X POST -d '{"gateway": "172.16.30.1"}' http://localhost:8080/router/0000000000000001 | jq

curl -X POST -d '{"address": "172.16.10.1/24"}' http://localhost:8080/router/0000000000000002 | jq

curl -X POST -d '{"address": "172.16.30.1/24"}' http://localhost:8080/router/0000000000000002 | jq

curl -X POST -d '{"gateway": "172.16.30.10"}' http://localhost:8080/router/0000000000000002 | jq

# install the following flow entry in accordance with DSCP value into the router (s1)
curl -X POST -d '{"match": {"ip_dscp": "26"}, "actions":{"queue": "1"}}'http://localhost:8080/qos/rules/0000000000000001 | jq

curl -X POST -d '{"match": {"ip_dscp": "34"}, "actions":{"queue": "2"}}'http://localhost:8080/qos/rules/0000000000000001 | jq

# install the following rules of marking the DSCP value into the router (s2)
curl -X POST -d '{"match": {"nw_dst": "172.16.20.10", "nw_proto": "UDP","tp_dst": "5002"},"actions":{"mark": "26"}}' http://localhost:8080/qos/rules/0000000000000002 | jq

curl -X POST -d '{"match": {"nw_dst": "172.16.20.10", "nw_proto": "UDP","tp_dst": "5003"},"actions":{"mark": "34"}}' http://localhost:8080/qos/rules/0000000000000002 | jq

# verify settings
curl -X GET http://localhost:8080/qos/rules/0000000000000001 | jq

```

3. Meter Table

The following shows an example of the network composed of the multiple DiffServ domain (DS domain). Traffic
metering are executed by the router (edge router) located on the boundary of the DS domain, and the traffic that
exceeds the specified bandwidth will be re-marking. Usually, re-marked packets are dropped preferentially or
treated as low priority class. In this example, perform the bandwidth guarantee of 800Kbps to AF1 class. Also,
AF11 class traffic transferred from each DS domain is guaranteed with 400Kbps bandwidth. Traffic that is more
than 400kbps is treated as excess traffic, and re-marked with AF12 class. However, it is still guaranteed that AF12
class is more preferentially transferred than the best effort class
```
```

### flowmanager
* flowmanager: https://github.com/martimy/flowmanager
* flowmanager ui: http://localhost:8080/home/index.html


### references
* https://osrg.github.io/ryu-book/en/Ryubook.pdf
* https://buildmedia.readthedocs.org/media/pdf/openvswitch/latest/openvswitch.pdf
* sflow: https://blog.sflow.com/2016/05/mininet-flow-analytics.html