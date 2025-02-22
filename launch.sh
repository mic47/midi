#!/bin/bash

SESSION=session
WINDOW=0
tmux new-session -d -s "$SESSION"

run_command_in_new_window() {
    ((WINDOW++))
    NAME="$1"
    shift
    local COMMAND=("$@")
    tmux new-window -t "$SESSION":"$WINDOW" -n "$NAME"
    tmux send-keys -t "$SESSION":"$WINDOW" "${COMMAND[*]}" C-m
}

run_command_in_new_window 'Jack Daemon' jackd -d alsa --device hw:0 --rate 44100 --period 256
sleep 1
run_command_in_new_window 'FluidSynth' fluidsynth --server --audio-driver=jack --gain 10 --connect-jack-outputs /usr/share/sounds/sf2/FluidR3_GM.sf2
sleep 1
run_command_in_new_window 'Rosegarden' rosegarden

# Attach to the session
tmux attach -t "$SESSION"
