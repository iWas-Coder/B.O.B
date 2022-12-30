#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/linux-headers.html
# Author: Wasym Atieh Alonso

###########################################
# CHAPTER 05: Compiling a Cross-Toolchain #
###########################################
# 5.4.1. Installation of Linux API Headers
# Approximate build time: 0.1 SBU
# Required disk space:    1.4 GB

banner "Linux API Headers - Extracting sources"; separator
tar -xvf linux*.tar.xz
separator
# The Linux kernel needs to expose an API for the system's C library (Glibc in LFS) to use.
# This is done by way of sanitizing various C header files that are shipped in the Linux kernel source tarball.
cd linux*/ || exit
# Make sure there are no stale files embedded in the package:
make mrproper
banner "Linux API Headers - Make Headers [0.1 SBU | ST]"; separator; confirm
# Now extract the user-visible kernel headers from the source.
# The recommended make target “headers_install” cannot be used, because it requires rsync, which may not be available.
# The headers are first placed in ./usr, then copied to the needed location.
make headers
separator
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include "$LFS"/usr
cd .. && rm -rf linux*/
