#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/chapter03.html
# Author: Wasym Atieh Alonso

####################################
# CHAPTER 03: Packages and Patches #
####################################
banner "CHAPTER 03: Packages and Patches"; separator

# $LFS/sources can be used both as the place to store the tarballs and patches and as a working directory.
# To create this directory, execute the following command, as user root, before starting the download session:
sudo mkdir -p "$LFS"/sources

# Make this directory writable and sticky.
# “Sticky” means that even if multiple users have write permission on a directory, only the owner of a file can delete the file within a sticky directory.
# The following command will enable the write and sticky modes:
sudo chmod a+wt "$LFS"/sources

# To download all of the packages and patches use:
for pkg in $(cat "$BOB"/sources/sources.list); do
    wget -nc "$pkg" -P "$LFS"/sources
done
separator

# Checking checksums (md5, sha1, sha256, sha384, sha512) for all sources downloaded previously at $LFS/sources:
pushd "$LFS"/sources &>/dev/null
banner "Checking MD5 of downloaded sources"; separator
md5sum -c "$BOB"/sources/sources.md5
separator
banner "Checking SHA1 of downloaded sources"; separator
sha1sum -c "$BOB"/sources/sources.sha1
separator
banner "Checking SHA256 of downloaded sources"; separator
sha256sum -c "$BOB"/sources/sources.sha256
separator
banner "Checking SHA384 of downloaded sources"; separator
sha384sum -c "$BOB"/sources/sources.sha384
separator
banner "Checking SHA512 of downloaded sources"; separator
sha512sum -c "$BOB"/sources/sources.sha512
separator
popd &>/dev/null
