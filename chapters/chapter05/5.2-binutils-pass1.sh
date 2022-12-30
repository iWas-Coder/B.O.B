#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/binutils-pass1.html
# Author: Wasym Atieh Alonso

###########################################
# CHAPTER 05: Compiling a Cross-Toolchain #
###########################################
# 5.2.1. Installation of Cross Binutils
# Approximate build time: 1 SBU
# Required disk space:    629 MB

# It is important that Binutils be the first package compiled because both Glibc and GCC perform various tests
# on the available linker and assembler to determine which of their own features to enable.
banner "Binutils (Pass 1) - Extracting sources"; separator
tar -xvf binutils*.tar.xz
separator
cd binutils*/ || exit
# The Binutils documentation recommends building Binutils in a dedicated build directory:
mkdir -p build && cd "$_"
banner "Binutils (Pass 1) - Configure"; separator; confirm
# Now prepare Binutils for compilation:
../configure              \
    --enable-silent-rules \
    --prefix="$LFS"/tools \
    --with-sysroot="$LFS" \
    --target="$LFS_TGT"   \
    --disable-nls         \
    --enable-gprofng=no   \
    --disable-werror
separator
banner "Binutils (Pass 1) - Make [1 SBU | ST + Timer]"; separator; confirm
# Continue with compiling the package:
time make
separator
banner "Binutils (Pass 1) - Make Install"; separator; confirm
# Install the package:
make install
separator
cd ../.. && rm -rf binutils*/

# More details: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/binutils.html#contents-binutils
