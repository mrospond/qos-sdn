#!/bin/bash

sudo mn -c
sudo pkill vlc
sudo pkill xterm
sudo ovs-vsctl -- --all destroy QoS -- --all destroy Queue