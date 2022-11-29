#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/chapter05.html
# Author: Wasym Atieh Alonso

###########################################
# CHAPTER 05: Compiling a Cross-Toolchain #
###########################################
banner "CHAPTER 05: Compiling a Cross-Toolchain"; separator

cd "$LFS"/sources || exit

# 5.2.1. Installation of Cross Binutils
source "$BOB"/chapters/chapter05/5.2-binutils-pass1.sh

# 5.3.1. Installation of Cross GCC
source "$BOB"/chapters/chapter05/5.3-gcc-pass1.sh

# 5.4.1. Installation of Linux API Headers
source "$BOB"/chapters/chapter05/5.4-linux-api-headers.sh

# 5.5.1. Installation of Glibc
source "$BOB"/chapters/chapter05/5.5-glibc.sh

# 5.6.1. Installation of Target Libstdc++
source "$BOB"/chapters/chapter05/5.6-libstdc++.sh

separator

banner "Archive + Compress + Save the state at the end of Chapter 05"; separator; confirm
tar -cvf - "$LFS" | pigz -v | sudo tee /mnt/lfs-ch05.tar.gz > /dev/null
separator
