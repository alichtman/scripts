#! /bin/bash

# This script prepares a directory structure for a new HackTheBox writeup.
# Written by: Aaron Lichtman
# https://www.github.com/alichtman

[ -z "$1" ] && echo "HTB Machine name arg missing." && exit

mkdir "$1"
cd "$1" || exit
mkdir flags loot enumeration exploits
touch flags/{user,root}.txt
touch writeup.md
echo -e "# $1\n\n## IP:\n\n\n### Enumeration\n\n\n### Reverse Shell\n\n\n### User Privilege Escalation\n\n\n### Root Privilege Escalation" >> writeup.md
