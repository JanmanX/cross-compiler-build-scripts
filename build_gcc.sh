#!/bin/bash

# Requires: make gcc gcc-c++ bison

# Print all output
set -x
export NJOBS=7

export PREFIX="$HOME/bin/cross"
export TARGET=x86_64-w64-mingw32
export PATH="$PREFIX/bin:$PATH"
export GCC=gcc-8.2.0

#### GCC
# Check if archive is already downloaded
if [ ! -f ./${GCC}.tar.xz ]
then
	wget https://ftp.gnu.org/gnu/gcc/${GCC}/${GCC}.tar.xz
fi

# Remove the extracted directory
rm ${GCC} -rf

# Unzip the new archive
tar xf ${GCC}.tar.xz

# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH

cd ${GCC}
contrib/download_prerequisites
cd ..

rm build-gcc -rf
mkdir build-gcc
cd build-gcc
../${GCC}/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j $NJOBS
make all-target-libgcc -j $NJOBS
make install-gcc
make install-target-libgcc


# Messsage for user
echo 'Add to path: PATH="$HOME/opt/cross/bin:$PATH"'