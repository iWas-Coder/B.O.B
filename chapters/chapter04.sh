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
sudo mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do
    sudo ln -s usr/$i $LFS/$i
done
case $(uname -m) in
    x86_64) sudo mkdir -pv $LFS/lib64 ;;
esac

# Programs in Chapter 6 will be compiled with a cross-compiler.
# In order to separate this cross-compiler from the other programs, it will be installed in a special directory.
# Create this directory with:
sudo mkdir -pv $LFS/tools

# When logged in as user root, making a single mistake can damage or destroy a system.
# Therefore, the packages in the next two chapters are built as an unprivileged user.
# You could use your own user name, but to make it easier to set up a clean working environment,
# create a new user called lfs as a member of a new group (also named lfs) and use this user during the installation process.
# As root, issue the following commands to add the new user:
sudo groupadd lfs
sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs

# To log in as lfs (as opposed to switching to user lfs when logged in as root,
# which does not require the lfs user to have a password), give lfs a password:
sudo passwd lfs

# Grant lfs full access to all directories under $LFS by making lfs the directory owner:
sudo chown -R lfs $LFS

# IMPORTANT:
# Several commercial distributions add a non-documented instantiation of /etc/bash.bashrc to the initialization of bash.
# This file has the potential to modify the lfs user's environment in ways that can affect the building of critical LFS packages.
# To make sure the lfs user's environment is clean, check for the presence of /etc/bash.bashrc and, if present, move it out of the way.
# As the root user, run:
[ ! -e /etc/bash.bashrc ] || sudo mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

# Next, login as user lfs:
su - lfs

# Set up a good working environment by creating two new startup files for the bash shell.
# While logged in as user lfs, issue the following command to create a new .bash_profile:
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

# Create the .bashrc file now:
cat > ~/.bashrc << "EOF"
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
EOF

# Finally, to have the environment fully prepared for building the temporary tools, source the just-created user profile:
source ~/.bash_profile

# Checking the environment before starting Chapter 05:
banner "Environment Check"; separator
echo "LFS: $LFS"
echo "LC_ALL: $LC_ALL"
echo "LFS_TGT: $LFS_TGT"
echo "PATH: $PATH"
echo "CONFIG_SITE: $CONFIG_SITE"
separator
