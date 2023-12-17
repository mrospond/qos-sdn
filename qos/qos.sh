#!/bin/bash

diffserv(){
    # match dscp with queue
    curl -X POST -d '@dscp26.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null
    curl -X POST -d '@dscp34.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null

    # set dscp marking rules (match flow with dscp)
    curl -X POST -d '@flow26.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    curl -X POST -d '@flow34.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null

    curl http://localhost:8080/qos/rules/0000000000000001 | jq
    curl http://localhost:8080/qos/rules/0000000000000002 | jq

}

limitbw(){
    curl -X POST -d '@ratelimit.json' http://localhost:8080/qos/meter/0000000000000001 &> /dev/null
    curl -X POST -d '@ratelimit.json' http://localhost:8080/qos/meter/0000000000000002 &> /dev/null

    curl -X POST -d '@matchlimit0.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    # curl -X POST -d '@matchlimit26.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    # curl -X POST -d '@matchlimit34.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    curl -X POST -d '@matchlimit0.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null
    # curl -X POST -d '@matchlimit26.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null
    # curl -X POST -d '@matchlimit34.json' http://localhost:8080/qos/rules/0000000000000002 &> /dev/null
}

ratelimit() {
    curl -X POST -d '@rate26.json' http://localhost:8080/qos/meter/0000000000000001 &> /dev/null
    curl -X POST -d '@ratebe.json' http://localhost:8080/qos/meter/0000000000000001 &> /dev/null

    curl -X POST -d '@matchlimit26.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null
    curl -X POST -d '@matchlimitbe.json' http://localhost:8080/qos/rules/0000000000000001 &> /dev/null

    sudo ovs-ofctl -O OpenFlow13 dump-meters s1
    sudo ovs-ofctl -O OpenFlow13 dump-meters s2
}

# ratelimit
# limitbw
diffserv


# curl http://localhost:8080/qos/meter/0000000000000002 | jq
# curl http://localhost:8080/qos/rules/0000000000000002 | jq
