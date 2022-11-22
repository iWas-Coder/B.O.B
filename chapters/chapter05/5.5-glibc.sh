#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/glibc.html
# Author: Wasym Atieh Alonso

###########################################
# CHAPTER 05: Compiling a Cross-Toolchain #
###########################################
# 5.5.1. Installation of Glibc
# Approximate build time: 4.4 SBU
# Required disk space:    821 MB

banner "Glibc - Extracting sources"; separator
tar -xvf glibc*.tar.xz
separator
# First, create a symbolic link for LSB compliance.
# Additionally, for x86_64, create a compatibility symbolic link required for proper operation of the dynamic library loader:
case $(uname -m) in
    i?86)   ln -sfv /usr/lib/ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv /usr/lib64/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv /usr/lib64/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac
# Some of the Glibc programs use the non-FHS compliant /var/db directory to store their runtime data.
# Apply the following patch to make such programs store their runtime data in the FHS-compliant locations:
cd glibc*/
patch -Np1 -i ../glibc-2.36-fhs-1.patch
# The Glibc documentation recommends building Glibc in a dedicated build directory:
mkdir build && cd $_
# Ensure that the ldconfig and sln utilities are installed into /usr/sbin:
echo "rootsbindir=/usr/sbin" > configparms
banner "Glibc - Configure"; separator; confirm
# Next, prepare Glibc for compilation:
../configure                           \
    --prefix=/usr                      \
    --host=$LFS_TGT                    \
    --build=$(../scripts/config.guess) \
    --enable-kernel=3.2                \
    --with-headers=$LFS/usr/include    \
    libc_cv_slibdir=/usr/lib
separator
banner "Glibc - Make [4.4 SBU | ST]"; separator; confirm
# Compile the package:
make
separator
banner "Glibc - Make Install"; separator; confirm
# Install the package:
make DESTDIR=$LFS install
separator
# Fix hardcoded path to the executable loader in ldd script:
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
# At this point, it is imperative to stop and ensure that the basic functions (compiling and linking)
# of the new toolchain are working as expected.
# To perform a sanity check, run the following commands:
banner "Toolchain Sanity Check"; separator
echo 'int main(){}' | gcc -xc -
readelf -l a.out | grep ld-linux
# Once all is well, clean up the test file:
rm a.out
separator
# Now that our cross-toolchain is complete, finalize the installation of the limits.h header.
# For doing so, run a utility provided by the GCC developers:
$LFS/tools/libexec/gcc/$LFS_TGT/12.2.0/install-tools/mkheaders
cd ../.. && rm -rf glibc*/

# More details: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/glibc.html#contents-glibc
