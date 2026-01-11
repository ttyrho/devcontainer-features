#!/usr/bin/env bash
# ...


# Outputs a message using the given color.
# Arguments:
#   - The name of the color to use on message ouput
#   - The message to be printed out
msg() {
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