#!/bin/bash

packet_size_bytes=1328  # replace with your packet size
total_packets=$(awk '{print $1}' capture.log | paste -sd+ - | bc)
duration=10
throughput=$((($packet_size_bytes * $total_packets) / $duration))
echo "Average throughput: $throughput bytes per second"
