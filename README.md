# qos-sdn

### QoS

```
curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

curl -X POST -d '{"port_name": "s1-eth1", "type": "linux-htb", "max_rate": "1000000", "queues": [{"max_rate": "500000"}, {"min_rate": "800000"}]}' http://localhost:8080/qos/queue/0000000000000001


curl -X POST -d '{"match": {"nw_dst": "10.0.0.1", "nw_proto": "UDP", "tp_dst": "5002"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001
```


### references
* https://osrg.github.io/ryu-book/en/Ryubook.pdf
* https://buildmedia.readthedocs.org/media/pdf/openvswitch/latest/openvswitch.pdf
* flowmanager: https://github.com/martimy/flowmanager
* flowmanager ui: http://localhost:8080/home/index.html
* sflow: https://blog.sflow.com/2016/05/mininet-flow-analytics.html