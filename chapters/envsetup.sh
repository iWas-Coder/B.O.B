#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd
# Author: Wasym Atieh Alonso

############################
# Script Environment Setup #
############################
# Colors for pretty-printing
C_RESET='\033[0m'
C_YELLOW='\033[1;33m'
C_RED='\033[1;31m'
# Functions for pretty-printing
ctrl_c () {
    echo -e "\n\n${C_RED}[-] Process cancelled by user. Exiting...\n${C_RESET}"
    tput cnorm; exit 1
}
trap ctrl_c INT
separator () {
    echo -ne "$C_RED"
    printf '%.s─' $(seq 1 "$(tput cols)")
    echo -ne "$C_RESET"
    sleep 2
}
banner () {
    echo -e "${C_YELLOW}[*] $1:${C_RESET}"
}
confirm () {
    echo -ne "${C_YELLOW}Still alive? Continue? (y/n) ${C_RESET}"
    read -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then ctrl_c; fi
    separator
}
# Sudo privileges
sudo whoami &>/dev/null
# Hide cursor
tput civis; clear
# Base directories
BOB=$(pwd)
LFS="/mnt/lfs"
sudo mkdir -p "$LFS"
banner "Script Environment Setup"; separator
echo "BOB: $BOB"
echo "LFS: $LFS"
echo
