#!/usr/bin/env bash
# https://github.com/alichtman/scripts/blob/master/backup-and-update-dotfiles.sh
# Written by Aaron Lichtman (@alichtman on GitHub)

# Backup and synchronize dotfiles across multiple machines using shallow-backup
# USAGE: ./backup-and-update-dotfiles.sh [COMMIT MESSAGE]

###
# Colored output library from: https://github.com/mercuriev/bash_colors
###

CLR_ESC="\033["
# All these variables has a function with the same name, but in lower case.

CLR_RESET=0             # reset all attributes to their defaults
CLR_RESET_UNDERLINE=24  # underline off
CLR_RESET_REVERSE=27    # reverse off
CLR_DEFAULT=39          # set underscore off, set default foreground color
CLR_DEFAULTB=49         # set default background color

CLR_BOLD=1              # set bold
CLR_BRIGHT=2            # set half-bright (simulated with color on a color display)
CLR_UNDERSCORE=4        # set underscore (simulated with color on a color display)
CLR_REVERSE=7           # set reverse video

CLR_BLACK=30            # set black foreground
CLR_RED=31              # set red foreground
CLR_GREEN=32            # set green foreground
CLR_BROWN=33            # set brown foreground
CLR_BLUE=34             # set blue foreground
CLR_MAGENTA=35          # set magenta foreground
CLR_CYAN=36             # set cyan foreground
CLR_WHITE=37            # set white foreground

CLR_BLACKB=40           # set black background
CLR_REDB=41             # set red background
CLR_GREENB=42           # set green background
CLR_BROWNB=43           # set brown background
CLR_BLUEB=44            # set blue background
CLR_MAGENTAB=45         # set magenta background
CLR_CYANB=46            # set cyan background
CLR_WHITEB=47           # set white background


# check if string exists as function
# usage: if fn_exists "sometext"; then ... fi
function fn_exists
{
    type -t "$1" | grep -q 'function'
}

# iterate through command arguments, o allow for iterative color application
function clr_layer
{
    # default echo setting
    CLR_ECHOSWITCHES="-e"
    CLR_STACK=""
    CLR_SWITCHES=""
    ARGS=("$@")

    # iterate over arguments in reverse
    for ((i=$#-1; i>=0; i--)); do
        ARG=${ARGS[$i]}
        # echo $ARG
        # set CLR_VAR as last argtype
        firstletter=${ARG:0:1}

        # check if argument is a switch
        if [ "$firstletter" = "-" ] ; then
            # if -n is passed, set switch for echo in clr_escape
            if [[ $ARG == *"n"* ]]; then
                CLR_ECHOSWITCHES="-en"
                CLR_SWITCHES=$ARG
            fi
        else
            # last arg is the incoming string
            if [ -z "$CLR_STACK" ]; then
                CLR_STACK=$ARG
            else
                # if the argument is function, apply it
                if [ -n "$ARG" ] && fn_exists "$ARG"; then
                    #continue to pass switches through recursion
                    CLR_STACK=$($ARG "$CLR_STACK" "$CLR_SWITCHES")
                fi
            fi
        fi
    done

    # pass stack and color var to escape function
    clr_escape "$CLR_STACK" "$1";
}

# General function to wrap string with escape sequence(s).
# Ex: clr_escape foobar $CLR_RED $CLR_BOLD
function clr_escape
{
    local result="$1"
    until [ -z "${2:-}" ]; do
	if ! [ "$2" -ge 0 ] && [ "$2" -le 47 ] 2>/dev/null; then
	    echo "clr_escape: argument \"$2\" is out of range" >&2 && return 1
	fi
        result="${CLR_ESC}${2}m${result}${CLR_ESC}${CLR_RESET}m"
	shift || break
    done

    echo "$CLR_ECHOSWITCHES" "$result"
}

function clr_reset           { clr_layer $CLR_RESET "$@";           }
function clr_reset_underline { clr_layer $CLR_RESET_UNDERLINE "$@"; }
function clr_reset_reverse   { clr_layer $CLR_RESET_REVERSE "$@";   }
function clr_default         { clr_layer $CLR_DEFAULT "$@";         }
function clr_defaultb        { clr_layer $CLR_DEFAULTB "$@";        }
function clr_bold            { clr_layer $CLR_BOLD "$@";            }
function clr_bright          { clr_layer $CLR_BRIGHT "$@";          }
function clr_underscore      { clr_layer $CLR_UNDERSCORE "$@";      }
function clr_reverse         { clr_layer $CLR_REVERSE "$@";         }
function clr_black           { clr_layer $CLR_BLACK "$@";           }
function clr_red             { clr_layer $CLR_RED "$@";             }
function clr_green           { clr_layer $CLR_GREEN "$@";           }
function clr_brown           { clr_layer $CLR_BROWN "$@";           }
function clr_blue            { clr_layer $CLR_BLUE "$@";            }
function clr_magenta         { clr_layer $CLR_MAGENTA "$@";         }
function clr_cyan            { clr_layer $CLR_CYAN "$@";            }
function clr_white           { clr_layer $CLR_WHITE "$@";           }
function clr_blackb          { clr_layer $CLR_BLACKB "$@";          }
function clr_redb            { clr_layer $CLR_REDB "$@";            }
function clr_greenb          { clr_layer $CLR_GREENB "$@";          }
function clr_brownb          { clr_layer $CLR_BROWNB "$@";          }
function clr_blueb           { clr_layer $CLR_BLUEB "$@";           }
function clr_magentab        { clr_layer $CLR_MAGENTAB "$@";        }
function clr_cyanb           { clr_layer $CLR_CYANB "$@";           }
function clr_whiteb          { clr_layer $CLR_WHITEB "$@";          }

clr_bold clr_underscore clr_cyan "Process for backing up and updating dotfiles with" -n; echo -n " "; clr_underscore clr_bold clr_red "shallow-backup"

clr_cyan "\n1. Go to shallow-backup/dotfiles directory and git pull. "
clr_cyan "2. Use shallow-backup to backup your dotfiles. Make any changes you have to manually with git."
clr_cyan "3. Push to remote."
clr_cyan "3. Use shallow-backup to reinstall dotfiles."

clr_white "\nYou should now have sync'd dots with the remote, which contains your latest version.\n"


clr_cyanb "STARTING ..."

clr_cyan "Updating dotfiles repo from git remote..."
# xargs is used to strip the surrounding quotes
dotfiles_backup_path="$(jq ".backup_path" ~/.config/shallow-backup.conf | xargs)/dotfiles"
# Expand ~
dotfiles_backup_path="${dotfiles_backup_path/#\~/$HOME}"

(
    #####
    # First, cd into ~/shallow-backup/dotfiles and git pull.
    # Drop into a manual subshell if it doesn't exit cleanly.
    #####
    cd "$dotfiles_backup_path" || (echo "Invalid backup path: $dotfiles_backup_path" && exit 1)

    # Show what files will change from this git pull to let the user decide if they'd rather do it manually.
    clr_cyan "\n\nThese files in the repo will change from this git pull."
    clr_cyan "If there are files you'd like to manually sync, like the shallow-backup config file, start a subshell to do so now."
    clr_cyan "Most of the time, it's safe to just continue. You'll have a chance to review the final git diff next.\n"
    git fetch && git diff --name-only ..origin

	# TODO: Check to see if ~/.config/shallow-backup.conf matches $dotfiles_backup_path/shallow-backup.conf.

    # shellcheck disable=SC2162
    read -p "Do you want to continue? [y/N] " yn
    case $yn in
        [Yy]* ) ;;
        [Nn]* | * ) exit;;
    esac

    if ! git pull; then
		clr_red "Git pull did not exit cleanly. Fix manually in subshell and Ctrl-D when done."
		$SHELL
	fi

    #####
    # Backup the dotfiles on this computer and commit and push that.
    #####
	if ! shallow-backup -no-splash -backup-dots -separate-dotfiles-repo; then
        clr_red "ERROR: Dotfile backup did not complete" && exit
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
		clr_red "No commit made. Exiting..." && exit
	fi

    # Push changes to remote
	git push

    # shellcheck disable=SC2162
    read -p "Your changes have been pushed to the remote. Would you like to run $ shallow-backup -reinstall-dots? [y/N] " yn
    case $yn in
        [Yy]* ) ;;
        [Nn]* | * ) exit;;
    esac

    #####
    # Then reinstall the dots and you should have globally sync'd dots.
    #####
    shallow-backup -reinstall-dots -dry-run
    shallow-backup -reinstall-dots
)
