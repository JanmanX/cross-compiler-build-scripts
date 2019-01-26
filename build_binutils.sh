#!/bin/bash

# Requires: make gcc gcc-c++ bison

# Print all output
set -x
export NJOBS=7

export PREFIX="$HOME/bin/cross"
export TARGET=x86_64-w64-mingw32
export PATH="$PREFIX/bin:$PATH"
export BINUTILS=binutils-2.31

#### BINUTILS
# Check if archive is already downloaded
if [ ! -f ./${BINUTILS}.tar.xz ]
then
	wget http://ftp.gnu.org/gnu/binutils/${BINUTILS}.tar.xz
fi

# Remove the old folder
rm ${BINUTILS} -rf

# Extract the archive
tar xf ${BINUTILS}.tar.xz

rm build-binutils -rf
mkdir build-binutils
cd build-binutils
../${BINUTILS}/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make all -j$(NJOBS)
make install

