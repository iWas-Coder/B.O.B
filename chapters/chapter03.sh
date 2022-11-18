#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/chapter03.html
# Author: Wasym Atieh Alonso

####################################
# CHAPTER 03: Packages and Patches #
####################################

# $LFS/sources can be used both as the place to store the tarballs and patches and as a working directory.
# To create this directory, execute the following command, as user root, before starting the download session:
sudo mkdir $LFS/sources

# Make this directory writable and sticky.
# “Sticky” means that even if multiple users have write permission on a directory, only the owner of a file can delete the file within a sticky directory.
# The following command will enable the write and sticky modes:
sudo chmod a+wt $LFS/sources

# To download all of the packages and patches use:
for pkg in $(ls ../sources/sources.list); do
  wget -nc "$pkg" -P $LFS/sources
done

# Checking checksums (md5, sha1, sha256, sha384, sha512) for all sources downloaded previously at $LFS/sources.
# md5sum -c sources.md5
# sha1sum -c sources.sha1
# sha256sum -c sources.sha256
# sha384sum -c sources.sha384
# sha512sum -c sha512
