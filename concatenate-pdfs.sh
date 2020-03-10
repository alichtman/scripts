#!/usr/bin/env bash
# USAGE: concatenate_pdfs INPUTS
# Outputs the concatenated file as Merged.pdf

# Written by: Aaron Lichtman
# https://github.com/alichtman/scripts/blob/master/concatenate-pdfs.sh


if [ -z "$*" ]; then
    echo "Error: No args.";
    exit 1;
fi
OUTPUT_FILE="Merged.pdf"
if [ -f "$OUTPUT_FILE" ]; then
    # shellcheck disable=SC2162
    # For some reason, read -r doesn't play well with macOS (GNU bash, version 5.0.11)
	read -p "Warning: Merged.pdf will be overwritten. Continue? [y/N] " choice

	case "$choice" in
	  y|Y ) rm "$OUTPUT_FILE";;
	  n|N|* ) echo "Aborting."; exit 1;;
	esac
fi

gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE="$OUTPUT_FILE" -dPDFSETTINGS=/prepress -dBATCH ./*

