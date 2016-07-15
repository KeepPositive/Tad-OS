#! /bin/bash

## Start variables
PACKAGE="Python"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
CXX="/usr/bin/g++"              \
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --without-ensurepip
# Build using the configured sources
make -j "$CORES"
# Install the built package
    chmod -v 755 /usr/lib/libpython3.so
fi

popd

rm -rf "$FOLD_NAME"
## End script
