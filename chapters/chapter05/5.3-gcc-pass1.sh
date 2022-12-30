#!/bin/bash

# Source: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gcc-pass1.html
# Author: Wasym Atieh Alonso

###########################################
# CHAPTER 05: Compiling a Cross-Toolchain #
###########################################
# 5.3.1. Installation of Cross GCC
# Approximate build time: 12 SBU
# Required disk space:    3.8 GB

banner "GCC (Pass 1) - Extracting sources"; separator
tar -xvf gcc*.tar.xz
# GCC requires the GMP, MPFR and MPC packages.
# As these packages may not be included in your host distribution, they will be built with GCC.
# Unpack each package into the GCC source directory and rename the resulting directories so the GCC
# build procedures will automatically use them:
tar -xvf mpfr*
mv mpfr*/ mpfr && mv mpfr gcc*/
tar -xvf gmp*
mv gmp*/ gmp && mv gmp gcc*/
tar -xvf mpc*
mv mpc*/ mpc && mv mpc gcc*/
separator
cd gcc*/ || exit
# On x86_64 hosts, set the default directory name for 64-bit libraries to “lib”:
case $(uname -m) in
    x86_64)
        sed -e '/m64=/s/lib64/lib/' \
            -i.orig gcc/config/i386/t-linux64
    ;;
esac
# The GCC documentation recommends building GCC in a dedicated build directory:
mkdir -f build && ( cd "$_" || exit )
banner "GCC (Pass 1) - Configure"; separator; confirm
# Prepare GCC for compilation:
../configure                    \
    --target="$LFS_TGT"         \
    --prefix="$LFS"/tools       \
    --with-glibc-version=2.36   \
    --with-sysroot="$LFS"       \
    --with-newlib               \
    --without-headers           \
    --disable-nls               \
    --disable-shared            \
    --disable-multilib          \
    --disable-decimal-float     \
    --disable-threads           \
    --disable-libatomic         \
    --disable-libgomp           \
    --disable-libquadmath       \
    --disable-libssp            \
    --disable-libvtv            \
    --disable-libstdcxx         \
    --enable-languages=c,c++
separator
banner "GCC (Pass 1) - Make [12 SBU | MT]"; separator; confirm
# Compile GCC by running:
make -j"$(nproc)"
separator
banner "GCC (Pass 1) - Make Install"; separator; confirm
# Install the package:
make install
separator
# This build of GCC has installed a couple of internal system headers.
# Normally one of them, limits.h, would in turn include the corresponding system limits.h header,
# in this case, $LFS/usr/include/limits.h. However, at the time of this build of GCC
# $LFS/usr/include/limits.h does not exist, so the internal header that has just been installed is a partial,
# self-contained file and does not include the extended features of the system header.
# This is adequate for building glibc, but the full internal header will be needed later.
# Create a full version of the internal header using a command that is identical to what the
# GCC build system does in normal circumstances:
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
    "$(dirname "$("$LFS_TGT"-gcc -print-libgcc-file-name)")"/install-tools/include/limits.h
cd .. && rm -rf gcc*/

# More details: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/gcc.html#contents-gcc
