#!/bin/bash

set -euo pipefail

session="qos-sdn"

arg=${1:-start}
echo "$arg"
tmux ls

if [[ $arg == kill ]]; then
    tmux kill-session -t $session
    sudo mn -c
elif [[ $arg == start ]]; then
    tmux new-session -d -s $session

    tmux rename-window -t $session:0 "mininet"
    tmux send-keys -t $session:0 "./scripts/run-mn.sh" C-m

    tmux new-window -t $session:1 -n "ryu"
    tmux send-keys -t $session:1 "./scripts/prereq.sh && ./scripts/run-qos.sh" C-m

    tmux attach-session -t $session
fi