#!/bin/bash

# Meter Table curls:

## QoS
curl -X POST -d '{"match": {"ip_dscp": "0", "in_port": "2"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X POST -d '{"match": {"ip_dscp": "10", "in_port": "2"}, "actions":{"queue": "3"}}' http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X POST -d '{"match": {"ip_dscp": "12", "in_port": "2"}, "actions":{"queue": "2"}}' http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X POST -d '{"match": {"ip_dscp": "0", "in_port": "3"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X POST -d '{"match": {"ip_dscp": "10", "in_port": "3"}, "actions":{"queue": "3"}}' http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X POST -d '{"match": {"ip_dscp": "12", "in_port": "3"}, "actions":{"queue": "2"}}' http://localhost:8080/qos/rules/0000000000000001 | jq

## meter entries -> ryu.app.rest_qos
# curl -X POST -d '{"match": {"ip_dscp": "10"}, "actions":{"meter": "1"}}' http://localhost:8080/qos/rules/0000000000000002 | jq
# curl -X POST -d '{"meter_id": "1", "flags": "KBPS", "bands":[{"type":"DSCP_REMARK", "rate":"400", "prec_level": "1"}]}' http://localhost:8080/qos/meter/0000000000000002 | jq
# curl -X POST -d '{"match": {"ip_dscp": "10"}, "actions":{"meter": "1"}}' http://localhost:8080/qos/rules/0000000000000003 | jq
# curl -X POST -d '{"meter_id": "1", "flags": "KBPS", "bands":[{"type":"DSCP_REMARK", "rate":"400", "prec_level": "1"}]}' http://localhost:8080/qos/meter/0000000000000003 | jq

## meter entries -> ryu.app.ofctl_rest
curl -X POST -d '@addmeter2.json' http://localhost:8080/stats/meterentry/add
curl -X POST -d '@switch_flow2.json' http://localhost:8080/stats/flowentry/add
curl -X POST -d '@addmeter3.json' http://localhost:8080/stats/meterentry/add
curl -X POST -d '@switch_flow3.json' http://localhost:8080/stats/flowentry/add

## verify
curl -X GET http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X GET http://localhost:8080/qos/rules/0000000000000002 | jq
curl -X GET http://localhost:8080/qos/rules/0000000000000003 | jq
