#! /bin/bash

## Start variables
PACKAGE="libvorbis"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
#sed -i '/components.png \\/{n;d}' doc/Makefile.in
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
    #install -v -m644 doc/Vorbis* "/usr/share/doc/libvorbis-$VERSION"
fi

popd

rm -rf "$FOLD_NAME"
## End script
