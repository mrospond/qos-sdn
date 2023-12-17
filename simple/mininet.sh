#!/bin/bash

sudo mn --topo linear,2 --link tc,bw=8 --mac --switch ovsk --controller remote -x
