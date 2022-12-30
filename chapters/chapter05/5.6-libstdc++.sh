#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gcc-libstdc++.html
# Author: Wasym Atieh Alonso

###########################################
# CHAPTER 05: Compiling a Cross-Toolchain #
###########################################
# 5.6.1. Installation of Target Libstdc++
# Approximate build time: 0.4 SBU
# Required disk space:    1.1 GB

banner "Libstdc++ - Extracting sources"; separator
tar -xvf gcc*.tar.xz
separator
cd gcc*/ || exit
# Create a separate build directory for libstdc++ and enter it:
mkdir -p build && cd "$_"
banner "Libstdc++ - Configure"; separator; confirm
# Prepare libstdc++ for compilation:
../libstdc++-v3/configure             \
    --host="$LFS_TGT"                 \
    --build="$(../config.guess)"      \
    --prefix=/usr                     \
    --disable-multilib                \
    --disable-nls                     \
    --disable-libstdcxx-pch           \
    --with-gxx-include-dir=/tools/"$LFS_TGT"/include/c++/12.2.0
separator
banner "Libstdc++ - Make [0.4 SBU | MT]"; separator; confirm
# Compile libstdc++ by running:
make -j"$(nproc)"
separator
banner "Libstdc++ - Make Install"; separator; confirm
# Install the library:
make DESTDIR="$LFS" install
separator
# Remove the libtool archive files because they are harmful for cross compilation:
rm "$LFS"/usr/lib/lib{stdc++,stdc++fs,supc++}.la
cd ../.. && rm -rf gcc*/

# More details: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/gcc.html#contents-gcc
