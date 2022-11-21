#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/chapter06.html
# Author: Wasym Atieh Alonso

###############################################
# CHAPTER 06: Cross Compiling Temporary Tools #
###############################################
banner "CHAPTER 06: Cross Compiling Temporary Tools"; separator

# 6.2.1. Installation of M4
source $BOB/chapters/chapter06/6.2-m4.sh

# 6.3.1. Installation of Ncurses
source $BOB/chapters/chapter06/6.3-ncurses.sh

# 6.4.1. Installation of Bash
source $BOB/chapters/chapter06/6.4-bash.sh