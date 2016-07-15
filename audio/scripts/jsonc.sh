#! /bin/bash

## Start variables
PACKAGE="json-c"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$PACKAGE-$PACKAGE-$VERSION"

# Configure the source
sed -i s/-Werror// Makefile.in
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j 1
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
fi

popd

rm -rf "$PACKAGE-$PACKAGE-$VERSION"
## End script
