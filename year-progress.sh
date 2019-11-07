#!/bin/bash

# Copyright © 2018 Kay <RedL0tus@users.noreply.github.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the LICENSE file for more details.

# Modified by Aaron Lichtman in Oct 2019.

set -e;

function GET_TOTAL_DAYS_IN_YEAR {
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
    echo $TOTAL_DAYS
}

function GET_CURRENT_DAY {
    echo "$(date +%j) + 0" | bc
}

function GET_DAYS_REMAINING {
    echo $(expr $(GET_TOTAL_DAYS_IN_YEAR) - $(GET_CURRENT_DAY))
}

function GET_PERCENTAGE {
    TOTAL_DAYS=$(GET_TOTAL_DAYS_IN_YEAR)
    CURRENT_DAY=$(GET_CURRENT_DAY)
    echo $((200 * CURRENT_DAY / TOTAL_DAYS % 2 + 100 * CURRENT_DAY / TOTAL_DAYS));
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
    # Green bar
    color="\033[92m"
    echo -e "$color$BAR complete";
}

function BANNER() {
    msg="# $* #"
    edge=$(echo "$msg" | sed 's/./#/g')
    # Blue header
    color="\033[92m"
    echo -e "$color$edge"
    echo -e "$color$msg"
    echo -e "$color$edge\n\033[0m"
}

function MAIN {
    BANNER "Year Progress"
    echo -e "Current date:        $(date +'%b %d %Y')"
    echo -e "Days Remaining:      $(GET_DAYS_REMAINING)"
    PRINT_YEAR_PROGRESS;
}

MAIN;
