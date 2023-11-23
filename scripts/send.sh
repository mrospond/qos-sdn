#!/bin/bash

exec sudo -u test vlc-wrapper -I "dummy" \
--loop $(dirname $0)/../big_buck_bunny_480p_h264.mov \
--sout "#rtp{proto=udp,mux=ts,dst=172.16.20.9,port=5004}" &