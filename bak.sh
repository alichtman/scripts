#!/bin/bash

if [ $# -eq 1 ]; then
    cp -pvi "$1" "${1}.bak"
else
    echo "Info : $0 creates a local backup file (ending in .bak)"
    echo "Usage: $0 [path to file to be backed up]"
fi
