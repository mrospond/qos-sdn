#!/bin/bash

curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000002/ovsdb_addr

# curl -X POST -d '{"port_name": "s1-eth1", "type": "linux-htb", "max_rate": "8000000", "queues":[{"max_rate": "8000000"}, {"min_rate": "500000"}, {"min_rate": "5000000"}]}' http://localhost:8080/qos/queue/0000000000000001

curl -X POST -d '{"address": "172.16.10.1/24"}' http://localhost:8080/router/0000000000000001 | jq
curl -X POST -d '{"address": "172.16.40.1/24"}' http://localhost:8080/router/0000000000000001 | jq
curl -X POST -d '{"gateway": "172.16.40.2"}' http://localhost:8080/router/0000000000000001 | jq
curl -X POST -d '{"address": "172.16.20.2/24"}' http://localhost:8080/router/0000000000000002 | jq
curl -X POST -d '{"address": "172.16.40.2/24"}' http://localhost:8080/router/0000000000000002 | jq
curl -X POST -d '{"gateway": "172.16.40.1"}' http://localhost:8080/router/0000000000000002 | jq

curl -X POST -d '{"match": {"ip_dscp": "26"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X POST -d '{"match": {"ip_dscp": "34"}, "actions":{"queue": "2"}}' http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X POST -d '{"match": {"nw_dst": "172.16.20.9", "nw_proto": "UDP", "tp_dst": "5202"},"actions":{"mark": "26"}}' http://localhost:8080/qos/rules/0000000000000002 | jq
cuel -X POST -d '{"match": {"nw_dst": "172.16.20.9", "nw_proto": "UDP", "tp_dst": "5004"},"actions":{"mark": "34"}}' http://localhost:8080/qos/rules/0000000000000002 | jq
