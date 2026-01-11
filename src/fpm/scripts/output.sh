#!/usr/bin/env bash
# Functions used to print out messages.


# Outputs a message using the given color.
# Arguments:
#   - The name of the color to use on message ouput
#   - The message to be printed out
color_msg() {
    case "$1" in
        red)
            COLOR="\e[1;31m"
        ;;
        green)
            COLOR="\e[1;32m"
        ;;
        yellow)
            COLOR="\e[1;33m"
        ;;
        blue)
            COLOR="\e[1;34m"
        ;;
        purple)
            COLOR="\e[1;35m"
        ;;
        cyan)
            COLOR="\e[1;36m"
        ;;
    esac

    echo -e "${COLOR}$2\e[0m"
}


# Prints a success message.
# Argumnents:
#   - The message to be printed out
success_msg() {
    color_msg green "$1"
}


# Prints an information message.
# Argumnents:
#   - The message to be printed out
info_msg() {
    color_msg cyan "[I] $1"
}


# Prints a warning message.
# Argumnents:
#   - The message to be printed out
warn_msg() {
    color_msg yellow "[W] $1"
}


# Prints an error message.
# Argumnents:
#   - The message to be printed out
error_msg() {
    color_msg red "[E] $1"
}