#!/bin/bash

curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

# ovsdb
curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000002/ovsdb_addr

# queue
curl -X POST -d '@queue.json' http://localhost:8080/qos/queue/0000000000000002 > /dev/null
curl http://localhost:8080/qos/queue/0000000000000002 | jq

ovs-ofctl queue-stats s2 -O OpenFlow13