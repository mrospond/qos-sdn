#!/bin/bash

# curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

# curl -X POST -d '{"port_name": "s1-eth1", "type": "linux-htb", "max_rate": "1000000", "queues":[{"max_rate": "1000000"}, {"min_rate": "200000"}, {"min_rate": "500000"}]}' http://localhost:8080/qos/queue/0000000000000001


# curl -X POST -d '{"address": "172.16.20.1/24"}' http://localhost:8080/router/0000000000000001

# curl -X POST -d '{"address": "172.16.30.10/24"}' http://localhost:8080/router/0000000000000001

# curl -X POST -d '{"gateway": "172.16.30.1"}' http://localhost:8080/router/0000000000000001

# curl -X POST -d '{"address": "172.16.10.1/24"}' http://localhost:8080/router/0000000000000002

# curl -X POST -d '{"address": "172.16.30.1/24"}' http://localhost:8080/router/0000000000000002


# curl -X POST -d '{"gateway": "172.16.30.10"}' http://localhost:8080/router/0000000000000002

# curl -X POST -d '{"match": {"ip_dscp": "26"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001

# curl -X POST -d '{"match": {"ip_dscp": "34"}, "actions":{"queue": "2"}}' http://localhost:8080/qos/rules/0000000000000001


# curl -X POST -d '{"match": {"nw_dst": "172.16.20.10", "nw_proto": "UDP", "tp_dst": "5002"},"actions":{"mark": "26"}}' http://localhost:8080/qos/rules/0000000000000002

# curl -X POST -d '{"match": {"nw_dst": "172.16.20.10", "nw_proto": "UDP", "tp_dst": "5003"},"actions":{"mark": "34"}}' http://localhost:8080/qos/rules/0000000000000002

curl -X GET http://localhost:8080/qos/rules/0000000000000001 | jq
 
curl -X GET http://localhost:8080/qos/rules/0000000000000002 | jq