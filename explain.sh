#!/usr/bin/env bash
# https://www.reddit.com/r/linuxquestions/comments/ewbl9f/explainshellcom_is_an_awesome_resource/fg2uma9/

if [[ -z $* ]]; then
    read -rp "Command: " input
else
    input=$*
fi

curl -Gs "https://www.mankier.com/api/explain/?cols=$COLUMNS" --data-urlencode "q=$input"
