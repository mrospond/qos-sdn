#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of arguments"
    echo "usage $0 VIDEO_FILE"
    exit 1
fi

su test

#su test -c "cvlc -I dummy --loop \"$1\" --sout '#rtp{proto=udp,mux=ts,dst=172.16.20.9,port=5004}' &"
vlc-wrapper -I "dummy" --loop $1 --sout "#rtp{proto=udp,mux=ts,dst=172.16.20.9,port=5004}" &