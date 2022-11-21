#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/m4.html
# Author: Wasym Atieh Alonso

###############################################
# CHAPTER 06: Cross Compiling Temporary Tools #
###############################################
# 6.2.1. Installation of M4
# Approximate build time: 0.2 SBU
# Required disk space:    32 MB

tar -xvf m4*
cd m4*/
banner "M4 - Configure"; separator; confirm
# Prepare M4 for compilation:
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
separator
banner "M4 - Make"; separator; confirm
# Compile the package:
make -j$(nproc)
separator
banner "M4 - Make Install"; separator; confirm
# Install the package:
make DESTDIR=$LFS install
separator
cd .. && rm -rf m4*/

# More details: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/m4.html#contents-m4
