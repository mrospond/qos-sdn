#!/bin/bash

iperf -s -u -p 5001 &
iperf -s -u -p 5002 &
iperf -s -u -p 5003 &
