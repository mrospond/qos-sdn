#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of arguments"
    echo "usage $0 dump_file"
    exit 1
fi

dump_file=$1

awk '{if (prev_time) print $1 - prev_time; prev_time=$1}' $dump_file | awk '{sum+=$1; sumsq+=$1*$1} END {print sqrt(sumsq/NR - (sum/NR)^2)}'
