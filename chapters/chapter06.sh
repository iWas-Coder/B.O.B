#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/chapter06.html
# Author: Wasym Atieh Alonso

###############################################
# CHAPTER 06: Cross Compiling Temporary Tools #
###############################################
banner "CHAPTER 06: Cross Compiling Temporary Tools"; separator

# 6.2.1. Installation of M4
source "$BOB"/chapters/chapter06/6.02-m4.sh

# 6.3.1. Installation of Ncurses
source "$BOB"/chapters/chapter06/6.03-ncurses.sh

# 6.4.1. Installation of Bash
source "$BOB"/chapters/chapter06/6.04-bash.sh

# 6.5.1. Installation of Coreutils
source "$BOB"/chapters/chapter06/6.05-coreutils.sh

# 6.6.1. Installation of Diffutils
source "$BOB"/chapters/chapter06/6.06-diffutils.sh

# 6.7.1. Installation of File
source "$BOB"/chapters/chapter06/6.07-file.sh

# 6.8.1. Installation of Findutils
source "$BOB"/chapters/chapter06/6.08-findutils.sh

# 6.9.1. Installation of Gawk
source "$BOB"/chapters/chapter06/6.09-gawk.sh

# 6.10.1. Installation of Grep
source "$BOB"/chapters/chapter06/6.10-grep.sh

# 6.11.1. Installation of Gzip
source "$BOB"/chapters/chapter06/6.11-gzip.sh

# 6.12.1. Installation of Make
source "$BOB"/chapters/chapter06/6.12-make.sh

# 6.13.1. Installation of Patch
source "$BOB"/chapters/chapter06/6.13-patch.sh

# 6.14.1. Installation of Sed
source "$BOB"/chapters/chapter06/6.14-sed.sh

# 6.15.1. Installation of Tar
source "$BOB"/chapters/chapter06/6.15-tar.sh

# 6.16.1. Installation of Xz
source "$BOB"/chapters/chapter06/6.16-xz.sh

# 6.17.1. Installation of Binutils
source "$BOB"/chapters/chapter06/6.17-binutils-pass2.sh

# 6.18.1. Installation of GCC
source "$BOB"/chapters/chapter06/6.18-gcc-pass2.sh
