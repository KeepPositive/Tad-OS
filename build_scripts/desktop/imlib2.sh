#! /bin/bash

## Start variables
PACKAGE="imlib2"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
    install -v -m755 -d "/usr/share/doc/imlib2-$VERSION"
    install -v -m644    doc/{*.gif,index.html} "/usr/share/doc/imlib2-$VERSION"
fi

popd

rm -rf "$FOLD_NAME"
## End script
