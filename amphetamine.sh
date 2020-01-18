#!/bin/bash
# Amphetamine -- So your computer never sleeps
#
# Depends on insect: https://github.com/sharkdp/insect
#
# Usage: amphetamine.sh [number] [unit]
# unit must be something interpretable by insect (min, hour, etc.)

if [ -z "$1" ]; then
    echo "Usage: $0 [number] [unit]"
    echo "Unit must be something interpretable by insect (min, hour, etc.)"
    exit
fi

if [ -z "$2" ]; then
    echo "Error: Incorrect number of arguments given."
    exit
fi

echo "Staying awake for... $1 $2"
seconds="$(insect "$1$2 -> sec" | cut -d" " -f1)"
caffeinate -t "$seconds"
