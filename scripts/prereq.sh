#!/bin/bash

ryu_path="/home/test/ryu"

function prereq() {
    sed '/OFPFlowMod(/,/)/s/0, cmd/1, cmd/' $ryu_path/ryu/app/rest_router.py > $ryu_path/ryu/app/qos_rest_router.py
    cd $ryu_path; sudo python ./setup.py install
    cd -
}

qos_rest_router="$ryu_path/ryu/app/qos_rest_router.py"

if [[ ! -e $qos_rest_router ]]; then
    echo "$qos_rest_router doesnt exist..."
    echo "installing..."
    prereq
fi

echo $(ls $qos_rest_router)