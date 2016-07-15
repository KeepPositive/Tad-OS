#! /bin/bash

PACKAGE="expect"
VERSION=$1
FOLD_NAME="$PACKAGE$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"
pushd "$FOLD_NAME"

# Configure the source
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include

# Build using the configured sources
make -j "$CORES"

# Install the built package
popd
rm -rf "$FOLD_NAME"
