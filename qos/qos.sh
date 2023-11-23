#!/bin/bash

diffserv(){
    # add queue
    curl -X POST -d '@queue.json' http://localhost:8080/qos/queue/0000000000000001 &> /dev/null

    # # match dscp with queue
    curl -X POST -d '@dscp26.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null
    curl -X POST -d '@dscp34.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null

    # set dscp marking rules (match flow with dscp)
    curl -X POST -d '@flow26.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    curl -X POST -d '@flow34.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
}

limitbw(){
    # curl -X POST http://localhost:8080/stats/meterentry/add -d '@addmeter1.json'
    # curl -X POST http://localhost:8080/stats/meterentry/add -d '@addmeter2.json'
    # curl -X POST http://localhost:8080/stats/flowentry/add -d '@switchflow1.json'
    # curl -X POST http://localhost:8080/stats/flowentry/add -d '@switchflow2.json'
    curl -X POST -d '@ratelimit.json' http://localhost:8080/qos/meter/0000000000000001 &> /dev/null
    curl -X POST -d '@ratelimit.json' http://localhost:8080/qos/meter/0000000000000002 &> /dev/null

    curl -X POST -d '@matchlimit0.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    # curl -X POST -d '@matchlimit26.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    # curl -X POST -d '@matchlimit34.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    curl -X POST -d '@matchlimit0.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null
    # curl -X POST -d '@matchlimit26.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null
    # curl -X POST -d '@matchlimit34.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null

}

# limitbw
diffserv


curl -X GET http://localhost:8080/qos/meter/0000000000000001 | jq
curl -X GET http://localhost:8080/qos/rules/0000000000000001 | jq


sudo ovs-ofctl -O OpenFlow13 dump-meters s1
sudo ovs-ofctl -O OpenFlow13 dump-meters s2
