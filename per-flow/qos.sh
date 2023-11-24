#!/bin/bash

# set ovsd_addr
curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

# set queue
curl -X POST -d '@queue.json' http://localhost:8080/qos/queue/0000000000000001 &> /dev/null

# install flow entry
curl -X POST -d '@flow.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null

# verify
curl http://localhost:8080/qos/rules/0000000000000001 | jq
curl http://localhost:8080/qos/queue/0000000000000001 | jq
