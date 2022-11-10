#!/bin/bash

tput civis

C_RESET='\033[0m'
C_YELLOW='\033[1;33m'
C_RED='\033[1;31m'

GNU_URL="https://ftpmirror.gnu.org/"
LINUX_URL="https://cdn.kernel.org/pub/linux/kernel/"
FILE_URL="https://astron.com/pub/"
XZ_URL="https://tukaani.org/"

MODE=$1


separator () {
  echo -ne "$C_RED"
  printf '%.s─' $(seq 1 $(tput cols))
  echo -ne "$C_RESET"
}


banner () {
  echo -e "${C_YELLOW}[*] $1:${C_RESET}"
}


help_text () {
  echo "usage: ./builder [-h / --help] <SECTION>"
  echo -e "\tsections:"
  echo -e "\t0 -> Cross-Toolchain"
  echo -e "\t1 -> Temporary-Tools"
  tput cnorm; exit 0
}


binutils_preparation () {
  banner "Binutils Preparation"; separator
  pushd binutils* &>/dev/null
  
  mkdir build && cd $_
  
  ../configure --prefix=$PREFIX        \
               --with-sysroot=$SYSROOT \
               --target=$TARGET        \
               --disable-nls           \
               --enable-gprofng=no     \
               --disable-werror
  
  separator
}


binutils_compilation () {
  banner "Binutils Compilation"; separator
  make
  make install
  separator
  popd &>/dev/null
}


gcc_preparation () {
  banner "GCC Preparation"; separator
  pushd gcc* &>/dev/null

  case $(uname -m) in
    x86_64)
      sed -e '/m64=/s/lib64/lib/' \
          -i.orig gcc/config/i386/t-linux64
    ;;
  esac

  mkdir build && cd $_

  ../configure --target=$TARGET          \
               --prefix=$PREFIX          \
               --with-glibc-version=2.36 \
               --with-sysroot=$SYSROOT   \
               --with-newlib             \
               --without-headers         \
               --disable-nls             \
               --disable-shared          \
               --disable-multilib        \
               --disable-decimal-float   \
               --disable-threads         \
               --disable-libatomic       \
               --disable-libgomp         \
               --disable-libquadmath     \
               --disable-libssp          \
               --disable-libvtv          \
               --disable-libstdcxx       \
               --enable-languages=c,c++

  separator
}


cross_toolchain () {
  # ENV Variables
  SYSROOT="$(pwd)/ROOT"
  PREFIX="$(pwd)/Cross-Toolchain/bin"
  TARGET="$(uname -m)-bob-linux-gnu"

  echo "SYSROOT: $SYSROOT"
  echo "PREFIX: $PREFIX"
  echo "TARGET: $TARGET"
  exit 101

  pushd Cross-Toolchain/src &>/dev/null
  
  # === Binutils === #
  binutils_preparation
  separator
  binutils_compilation
  clear

  # === GCC === #
  gcc_preparation
  separator
  gcc_compilation
  clear

  # === Linux Headers === #
  linux_headers_preparation
  separator
  linux_headers_compilation
  clear

  # === Glibc === #
  glibc_preparation
  separator
  glibc_compilation
  clear

  popd &>/dev/null
  tput cnorm; exit 0
}


temporary_tools () {
  pushd Temporary-Tools/src &>/dev/null
  
  for pkg in $(ls); do
    banner "$pkg"
    separator
    echo "Building... (dry run)"
    separator 
  done

  popd &>/dev/null
  tput cnorm; exit 0
}


case $MODE in
  # === Help === #
  "-h" ) help_text;;
  "--help" ) help_text;;
  
  # === Sections === #
  "0" ) cross_toolchain;;
  "1" ) temporary_tools;;
esac

echo -e "${C_RED}[-] ERROR: Bad arguments! -h/--help to see usage${C_RESET}"
tput cnorm; exit 1
