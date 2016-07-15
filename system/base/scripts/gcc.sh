#! /bin/bash

PACKAGE="gcc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="/$FOLD_NAME/build"


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
SED=sed                                 \
../configure --prefix=/usr              \
             --enable-languages=c,c++   \
             --disable-multilib         \
             --disable-bootstrap        \
             --with-system-zlib

# Build using the configured sources
make -j "$CORES"

# Install the built package
    ln -sv gcc /usr/bin/cc
    install -v -dm755 /usr/lib/bfd-plugins
    ln -sfv ../../libexec/gcc/"$(gcc -dumpmachine)"/6.1.0/liblto_plugin.so \
            /usr/lib/bfd-plugins/
    # Apparently some files get misplaced, so put them in their place
    mkdir -pv /usr/share/gdb/auto-load/usr/lib
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
fi

popd

rm -rf "$FOLD_NAME"
