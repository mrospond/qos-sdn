#!/bin/bash

set -eo pipefail

session="qos-sdn"

start_session() {
    tmux new-session -d -s $session

    tmux rename-window -t $session:0 "mininet"
    tmux send-keys -t $session:0 "./per-flow/topology.sh" C-m

    tmux new-window -t $session:1 -n "ryu"
    tmux send-keys -t $session:1 "./per-flow/controller.sh" C-m

    tmux attach-session -t $session # Ctrl+B D to detach
}

kill_session() {
    tmux kill-session -t $session #2> /dev/null
}

case $1 in
    start) start_session ;;
    kill) kill_session ;;
    *)
      echo "no arg provided, using default arg" ;
      start_session
      ;;
esac