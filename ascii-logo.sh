#!/bin/bash

# This script creates ascii logos for text.
# Example usage: $ ascii-logo text

# Depends on:
# - figlet
# - ANSI-Shadow font from: https://github.com/xero/figlet-fonts/blob/master/ANSI%20Shadow.flf
#       -> Install to /usr/local/Cellar/figlet/<version>/share/figlet/fonts/ on macOS

TEXT="$1"

print_font() {
    FONT="$1"
    figlet -f "$FONT" -k "$TEXT"
    figlet -f "$FONT" -W "$TEXT"
}

print_font colossal
print_font univers
print_font ANSI-Shadow
