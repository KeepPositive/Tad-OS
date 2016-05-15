#! /bin/bash

PACKAGE="gcc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$LFS/$FOLD_NAME/build"
MPFR_VER=$2
GMP_VER=$3
MPC_VER=$4

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

case $SYSTEM in
"rpi")
    patch -Np1 -i "$PACKAGE_DIR/gcc-5.3.0-rpi3-cpu-default.patch"
;;
esac

popd

mkdir "$BUILD_DIR"

pushd "$BUILD_DIR"

# Configure the source
SED=sed ../configure --prefix=/usr    \
                     --enable-languages=c,c++ \
                     --disable-multilib       \
                     --disable-bootstrap      \
                     --with-system-zlib
# Edit the Makefile to prevent a Pi build error
case $SYSTEM in
"rpi")
    sed -i 's/none-/armv6l-/' Makefile
    sed -i 's/none-/armv7l-/' Makefile
;;
esac

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
    ln -sv ../usr/bin/cpp /lib
    ln -sv gcc /usr/bin/cc
    install -v -dm755 /usr/lib/bfd-plugins
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/6.1.0/liblto_plugin.so \
            /usr/lib/bfd-plugins/
    # A small test here...
    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log
    readelf -l a.out | grep ': /lib'
    # Some grep tests to also ensure a working base
    grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
    grep -B4 '^ /usr/include' dummy.log
    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    grep "/lib.*/libc.so.6 " dummy.log
    grep found dummy.log
    rm -v dummy.c a.out dummy.log
    # Apparently some files get misplaced, so put them in their place
    mkdir -pv /usr/share/gdb/auto-load/usr/lib
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
fi

popd

rm -rf "$FOLD_NAME"
