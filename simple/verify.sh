#!/bin/bash

curl -X GET http://localhost:8080/qos/rules/0000000000000001 | jq
curl -X GET http://localhost:8080/qos/rules/0000000000000002 | jq

curl -X GET http://localhost:8080/router/0000000000000001 | jq
curl -X GET http://localhost:8080/router/0000000000000002 | jq