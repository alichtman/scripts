#!/bin/bash

# Copyright © 2018 Kay <RedL0tus@users.noreply.github.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the LICENSE file for more details.

# Modified by Aaron Lichtman in Oct 2019.

set -e;

function GET_PERCENTAGE {
    local CURRENT_YEAR
    CURRENT_YEAR=$(date +%Y);
    if [ $((CURRENT_YEAR % 400)) -eq 0 ]; then
            local TOTAL_DAYS=366;
    elif [ $((CURRENT_YEAR % 100)) -eq 0 ]; then
            local TOTAL_DAYS=365;
    elif [ $((CURRENT_YEAR % 4)) -eq 0 ]; then
            local TOTAL_DAYS=366;
    else
            local TOTAL_DAYS=365;
    fi
    CURRENT_DAY=$(echo "$(date +%j) + 0" | bc)
    echo $((200 * CURRENT_DAY/ TOTAL_DAYS % 2 + 100 * CURRENT_DAY / TOTAL_DAYS));
}

function PRINT_YEAR_PROGRESS {
    local PERCENTAGE
    PERCENTAGE=$(GET_PERCENTAGE);
    local LENGTH=20

    local BAR="";
    local FILLED=$((LENGTH * PERCENTAGE / 100));
    for ((i = 0; i < FILLED; i++)) {
        BAR=${BAR}"▓";
    }

    local BLANK=$((LENGTH - FILLED));
    for ((i = 0; i < BLANK; i++)) {
        BAR=${BAR}"░";
    }
    BAR="${BAR} ${PERCENTAGE}%";
    echo -e "\033[92m$BAR";
}

function BANNER() {
    msg="# $* #"
    edge=$(echo "$msg" | sed 's/./#/g')
    color="\033[92m"
    echo -e "$color$edge"
    echo -e "$color$msg"
    echo -e "$color$edge\n"
}

function MAIN {
    BANNER "Year Progress"
    PRINT_YEAR_PROGRESS;
}

MAIN;
