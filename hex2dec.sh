#!/bin/bash

hexNum="$1"
echo -n "$hexNum == "
echo "obase=10; ibase=16; $hexNum" | bc
