#!/bin/bash
# $ tls -- tmux list sessions
# Pretty print tmux session list.
# Written by Aaron Lichtman (@alichtman on GitHub)

set -e;

BOLD="\033[1m"
BLUE="\033[94m"
RED="\033[31m"
RESET="\033[0m"

echo -e "$BOLD$BLUE  == Active tmux Sessions ==$RESET";

sessions=$(tmux list-sessions | cut -d ":" -f1)
for i in $sessions ; do
    echo -e "$BOLD$RED     [*] $i"
done;

