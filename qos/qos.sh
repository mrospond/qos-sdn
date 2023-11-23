#!/bin/bash

IP_S1_ETH1="172.16.10.1/24" #s1-h1
IP_S1_ETH2="172.16.30.1/24" #s1-h3
IP_S1_ETH3="172.16.40.1/24" #s1-s2
IP_S2_ETH1="172.16.40.2/24" #s2-s1
IP_S2_ETH2="172.16.20.2/24" #s2-h2

S1_GW="172.16.40.2"
S2_GW="172.16.40.1"

case $1 in
    diffserv) diffserv ;;
    *)
      echo "no arg provided, using default arg" ;
      echo "configure router ip"
      ;;
esac

# set ovsdb_addr
curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr &> /dev/null

# router ip settings
ip() {
    curl -X POST -d "{\"address\": \"$IP_S1_ETH1\"}" http://localhost:8080/router/0000000000000001 &> /dev/null
    curl -X POST -d "{\"address\": \"$IP_S1_ETH2\"}" http://localhost:8080/router/0000000000000001 &> /dev/null
    curl -X POST -d "{\"address\": \"$IP_S1_ETH3\"}" http://localhost:8080/router/0000000000000001 &> /dev/null
    curl -X POST -d "{\"address\": \"$IP_S2_ETH1\"}" http://localhost:8080/router/0000000000000002 &> /dev/null
    curl -X POST -d "{\"address\": \"$IP_S2_ETH2\"}" http://localhost:8080/router/0000000000000002 &> /dev/null
    curl -X POST -d "{\"gateway\": \"$S1_GW\"}" http://localhost:8080/router/0000000000000001 &> /dev/null
    curl -X POST -d "{\"gateway\": \"$S2_GW\"}" http://localhost:8080/router/0000000000000002 &> /dev/null

    # verify
    curl -X GET http://localhost:8080/router/0000000000000001 | jq
    curl -X GET http://localhost:8080/router/0000000000000002 | jq
}

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
    curl -X POST http://localhost:8080/qos/meter/0000000000000001 -d '@ratelimit.json' | jq
    curl -X POST http://localhost:8080/qos/meter/0000000000000002 -d '@ratelimit.json' | jq

    curl -X POST http://localhost:8080/qos/rules/0000000000000001 -d '@matchlimit0.json' | jq
    # curl -X POST http://localhost:8080/qos/rules/0000000000000001 -d '@matchlimit26.json' | jq
    # curl -X POST http://localhost:8080/qos/rules/0000000000000001 -d '@matchlimit34.json' | jq

    curl -X POST http://localhost:8080/qos/rules/0000000000000002 -d '@matchlimit0.json' | jq
    # curl -X POST http://localhost:8080/qos/rules/0000000000000002 -d '@matchlimit26.json' | jq
    # curl -X POST http://localhost:8080/qos/rules/0000000000000002 -d '@matchlimit34.json' | jq

}

# ip
limitbw
# diffserv


curl -X GET http://localhost:8080/qos/meter/0000000000000001 | jq
curl -X GET http://localhost:8080/qos/rules/0000000000000001 | jq


sudo ovs-ofctl -O OpenFlow13 dump-meters s1
sudo ovs-ofctl -O OpenFlow13 dump-meters s2
