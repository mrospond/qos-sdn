#!/bin/bash

output_file=$1
duration=30
dest_ip="172.16.20.9"
dest_port="5004"

# Capture UDP packets and save to CSV
tcpdump -i any -n -tttt -vvv -s0 -w - "udp and host $dest_ip and port $dest_port" \
    | timeout $duration tcpdump -n -tttt -r - "udp" > "$output_file"
