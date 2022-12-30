#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter04/chapter04.html
# Author: Wasym Atieh Alonso

##################################
# CHAPTER 04: Final Preparations #
##################################
banner "CHAPTER 04: Final Preparations"; separator

# The first task performed in the LFS partition is to create a limited directory hierarchy
# so that programs compiled in Chapter 6 may be installed in their final location.
# This is needed so that those temporary programs be overwritten when rebuilding them in Chapter 8.
# Create the required directory layout by running the following as root:
# Regular directories
sudo mkdir -pv "$LFS"/{etc,var,usr}
sudo mkdir -pv "$LFS"/usr/{bin,lib,sbin}
case $(uname -m) in
    x86_64) sudo mkdir -pv "$LFS"/lib64 ;;
esac
# Symbolic links
sudo rm -f "$LFS"/{bin,lib,sbin}
sudo ln -sv "$LFS"/usr/bin "$LFS"/bin
sudo ln -sv "$LFS"/usr/lib "$LFS"/lib
sudo ln -sv "$LFS"/usr/sbin "$LFS"/sbin

# Programs in Chapter 6 will be compiled with a cross-compiler.
# In order to separate this cross-compiler from the other programs, it will be installed in a special directory.
# Create this directory with:
sudo mkdir -pv "$LFS"/tools

# Grant lfs full access to all directories under $LFS by making lfs the directory owner:
sudo chown -R "$(logname)" "$LFS"

# Set all needed environment variables:
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE

separator

# Checking the environment before starting Chapter 05:
banner "Environment Check"; separator
echo "LFS: $LFS"
echo "LC_ALL: $LC_ALL"
echo "LFS_TGT: $LFS_TGT"
echo "PATH: $PATH"
echo "CONFIG_SITE: $CONFIG_SITE"
separator
