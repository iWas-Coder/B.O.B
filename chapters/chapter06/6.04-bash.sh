#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/bash.html
# Author: Wasym Atieh Alonso

###############################################
# CHAPTER 06: Cross Compiling Temporary Tools #
###############################################
# 6.4.1. Installation of Bash
# Approximate build time: 0.5 SBU
# Required disk space:    64 MB

banner "Bash - Extracting sources"; separator
tar -xvf bash*.tar.gz
separator
cd bash*/ || exit
banner "Bash - Configure"; separator; confirm
# Prepare Bash for compilation:
./configure --prefix=/usr                     \
            --build="$(support/config.guess)" \
            --host="$LFS_TGT"                 \
            --without-bash-malloc
separator
banner "Bash - Make [0.5 SBU | MT]"; separator; confirm
# Compile the package:
make -j"$(nproc)"
separator
banner "Bash - Make Install"; separator; confirm
# Install the package:
make DESTDIR="$LFS" install
separator
# Make a link for the programs that use sh for a shell:
ln -s bash "$LFS"/bin/sh
cd .. && rm -rf bash*/

# More details: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/bash.html#contents-bash
