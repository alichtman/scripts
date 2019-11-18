#!/bin/bash

if [ $# -eq 1 ]; then
 cp -pvi "$1" "${1}.bak"
else
 echo "Info:  $0 copies to a backup file"
 echo "Usage: $0 <file to be backed up with .bak extension>"
fi
