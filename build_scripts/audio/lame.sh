#! /bin/bash

## Start variables
PACKAGE="lame"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Fix some GCC related issue
case $(uname -m) in
    i?86) 
        sed -i -e '/xmmintrin\.h/d' configure 
    ;;
esac
# Configure the source
./configure --prefix=/usr 	\
			--enable-mp3rtp \
			--enable-nasm	\
			--disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make pkghtmldir="/usr/share/doc/lame-$VERSION" install
fi

popd

rm -rf "$FOLD_NAME"
## End script
