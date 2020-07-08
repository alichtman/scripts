#!/bin/bash

SPEEDS=$(speedtest)
UPLOAD=$(echo "$SPEEDS" | grep "Upload:" | cut -d':' -f2)
DOWNLOAD=$(echo "$SPEEDS" | grep "Download:" | cut -d':' -f2)

echo -e "Up: $UPLOAD\nDown: $DOWNLOAD"
