#!/bin/bash

curl -X POST -d '{"port_name": "s1-eth1", "type": "linux-htb", "max_rate": "8000000", "queues":[{"max_rate": "8000000"}, {"min_rate": "500000"}, {"min_rate": "5000000"}]}' http://localhost:8080/qos/queue/0000000000000001
