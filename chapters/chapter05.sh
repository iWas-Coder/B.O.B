#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/chapter05.html
# Author: Wasym Atieh Alonso

###########################################
# CHAPTER 05: Compiling a Cross-Toolchain #
###########################################
banner "CHAPTER 05: Compiling a Cross-Toolchain"; separator

cd $LFS/sources

# 5.2.1. Installation of Cross Binutils
source chapter05/binutils-pass1.sh

# 5.3.1. Installation of Cross GCC
source chapter05/gcc-pass1.sh
