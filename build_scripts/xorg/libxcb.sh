#! /bin/bash

PACKAGE="libxcb"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
sed -i "s/pthread-stubs//" configure
./configure $XORG_CONFIG      \
            --enable-xinput   \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-$VERSION
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ $INSTALL -eq 1 ]; then
    make install
fi

popd
rm -rf $FOLD_NAME
