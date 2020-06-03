#!/usr/bin/env bash
# Written by Aaron Lichtman (@alichtman on Gitgit)

# Backup and update dotfiles using shallow-backup
# USAGE: ./backup-and-update-dotfiles.sh [COMMIT MESSAGE]

# First, cd into ~/shallow-backup/dotfiles and git pull. Drop into a manual subshell if it doesn't exit cleanly.
# Then reinstall the dotfiles from the repo and you should have globally identical dots.

# TODO: Colored output

echo "Updating dotfiles repo from git remote..."
# xargs is used to strip the surrounding quotes
dotfiles_backup_path="$(jq ".backup_path" ~/.config/shallow-backup.conf | xargs)/dotfiles"
# Expand ~
dotfiles_backup_path="${dotfiles_backup_path/#\~/$HOME}"

(
    # First, cd into ~/shallow-backup/dotfiles and git pull. Drop into a manual subshell if it doesn't exit cleanly.
    cd "$dotfiles_backup_path" || (echo "Invalid backup path: $dotfiles_backup_path" && exit 1)

    # Show what files will change from this git pull to let the user decide if they'd rather do it manually.
    echo "These files in the repo will change from this git pull."
    echo "If there are files you'd like to manually sync, like the shallow-backup config file, please do so now."
    git fetch && git diff --name-only ..origin

	# TODO: Check to see if ~/.config/shallow-backup.conf matches $dotfiles_backup_path/shallow-backup.conf.

    # shellcheck disable=SC2162
    read -p "Do you want to continue? [y/N] " yn
    case $yn in
        [Yy]* ) ;;
        [Nn]* | * ) exit;;
    esac

    if ! git pull; then
		echo "Git pull did not exit cleanly. Fix manually in subshell and Ctrl-D when done."
		$SHELL
	fi

    # Backup the dotfiles on this computer and commit and push that.
	if ! shallow-backup -no-splash -backup-dots -separate-dotfiles-repo; then
        echo "ERROR: Dotfile backup did not complete" && exit
	fi
	git add .
	commit_msg="$1"
	if [ -z "$commit_msg" ]
	then
		git commit --verbose
	else
		git commit -m "$commit_msg"
	fi
	# If the commit is aborted, don't reinstall the dots.
    # shellcheck disable=SC2181
	if [ "$?" -ne 0 ]; then
		echo "No commit made. Exiting..." && exit
	fi

    # Push changes to remote
	git push

    # Then reinstall the dots and you should have globally sync'd dots.
    shallow-backup -reinstall-dots -dry-run
    shallow-backup -reinstall-dots
)
