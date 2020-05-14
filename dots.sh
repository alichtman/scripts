#!/bin/bash
# Grab dotfiles and dotfolders from shallow-backup config and throw it in a fzf
# selector for editing

# Depends on jq and shallow-backup

# NOTE: Super broken.

dotfiles=$(jq '.dotfiles | keys' ~/.config/shallow-backup.conf | jq -r '.[]' | fzf --bind "enter:execute(nvim ~/{})")

# TODO: For each dotfolder, get list of all subfiles and add them to this list.

# selection=$(echo $dotfiles | fzf)

# Then open the selected file in nvim

# TODO: Add logic for adding nothing if it's an absolute path

# echo $dotfiles | fzf --bind "enter:execute(nvim ~/{})"
