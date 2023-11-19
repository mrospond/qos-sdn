#!/bin/bash

ryu-manager --observe-links ~/flowmanager/flowmanager.py ryu.app.simple_switch_13

#ryu-manager --observe-links --config-file params.conf ~/flowmanager/flowmanager.py ./ryu-apps/app.py
