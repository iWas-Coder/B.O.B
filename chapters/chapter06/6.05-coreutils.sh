#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/coreutils.html
# Author: Wasym Atieh Alonso

###############################################
# CHAPTER 06: Cross Compiling Temporary Tools #
###############################################
# 6.5.1. Installation of Coreutils
# Approximate build time: 0.6 SBU
# Required disk space:    163 MB

banner "Coreutils - Extracting sources"; separator
tar -xvf coreutils*.tar.xz
separator
cd coreutils*/ || exit
banner "Coreutils - Configure"; separator; confirm
# Prepare Coreutils for compilation:
./configure --enable-silent-rules               \
            --prefix=/usr                       \
            --host="$LFS_TGT"                   \
            --build="$(build-aux/config.guess)" \
            --enable-install-program=hostname   \
            --enable-no-install-program=kill,uptime
separator
banner "Coreutils - Make [0.6 SBU | MT]"; separator; confirm
# Compile the package:
make -j"$(nproc)"
separator
banner "Coreutils - Make Install"; separator; confirm
# Install the package:
make DESTDIR="$LFS" install
separator
# Move programs to their final expected locations.
# Although this is not necessary in this temporary environment,
# we must do so because some programs hardcode executable locations:
mv -v "$LFS"/usr/bin/chroot "$LFS"/usr/sbin
mkdir -pv "$LFS"/usr/share/man/man8
mv -v "$LFS"/usr/share/man/man1/chroot.1 "$LFS"/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' "$LFS"/usr/share/man/man8/chroot.8
cd .. && rm -rf coreutils*/

# More details: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/coreutils.html#contents-coreutils
