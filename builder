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


confirm () {
  echo -e "${C_YELLOW}Still alive? Continue? (y/n) ${C_RESET}"
  read -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    tput cnorm; exit 1
  fi
  separator
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
  banner "GCC Preparation"; separator
  SYSROOT="$(pwd)/root"
  echo "SYSROOT: $SYSROOT"
  PREFIX="$(pwd)/Cross-Toolchain/bin"
  echo "PREFIX: $PREFIX"
  TARGET="$(uname -m)-bob-linux-gnu"
  echo "TARGET: $TARGET"
  separator

  pushd Cross-Toolchain/src &>/dev/null
  
  # === Binutils === #
  confirm
  binutils_preparation
  separator
  confirm
  binutils_compilation
  clear

  # === GCC === #
  # confirm
  # gcc_preparation
  # separator
  # confirm
  # gcc_compilation
  # clear

  # === Linux Headers === #
  # confirm
  # linux_headers_preparation
  # separator
  # confirm
  # linux_headers_compilation
  # clear

  # === Glibc === #
  # confirm
  # glibc_preparation
  # separator
  # confirm
  # glibc_compilation
  # clear

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
