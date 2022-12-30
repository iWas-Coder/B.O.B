#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/ncurses.html
# Author: Wasym Atieh Alonso

###############################################
# CHAPTER 06: Cross Compiling Temporary Tools #
###############################################
# 6.3.1. Installation of Ncurses
# Approximate build time: 0.7 SBU
# Required disk space:    50 MB

banner "Ncurses - Extracting sources"; separator
tar -xvf ncurses*.tar.gz
separator
cd ncurses*/ || exit
# First, ensure that gawk is found first during configuration:
sed -i s/mawk// configure
banner "Build the 'tic' program"; separator; confirm
# Then, run the following commands to build the “tic” program on the build host:
mkdir -p build && pushd "$_" &>/dev/null
../configure
make -C include
make -C progs tic
popd &>/dev/null || exit
separator
banner "Ncurses - Configure"; separator; confirm
# Prepare Ncurses for compilation:
./configure --prefix=/usr                  \
            --host="$LFS_TGT"              \
            --build="$(./config.guess)"    \
            --mandir=/usr/share/man        \
            --with-manpage-format=normal   \
            --with-shared                  \
            --without-normal               \
            --with-cxx-shared              \
            --without-debug                \
            --without-ada                  \
            --disable-stripping            \
            --enable-widec
separator
banner "Ncurses - Make [0.7 SBU | MT]"; separator; confirm
# Compile the package:
make -j"$(nproc)"
separator
banner "Ncurses - Make Install"; separator; confirm
# Install the package:
make DESTDIR="$LFS" TIC_PATH="$(pwd)"/build/progs/tic install
echo "INPUT(-lncursesw)" > "$LFS"/usr/lib/libncurses.so
separator
cd .. && rm -rf ncurses*/

# More details: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/ncurses.html
