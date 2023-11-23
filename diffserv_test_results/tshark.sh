#!/bin/bash

tshark -i <interface> -f "udp and host <destination_ip> and port <destination_port>" -E separator=, -T fields -e frame.time_epoch -e ip.len -e udp.length -e ip.src -e ip.dst -e udp.srcport -e udp.dstport -e udp.checksum
