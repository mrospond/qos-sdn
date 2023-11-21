#!/bin/bash

curl -X POST http://localhost:8080/stats/meterentry/add -d '@addmeter.json'

curl -X POST http://localhost:8080/stats/flowentry/add -d '@switch_flow1.json'

