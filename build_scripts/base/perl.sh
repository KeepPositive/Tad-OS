#! /bin/bash

PACKAGE="perl"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_ZLIB=False
BUILD_BZIP2=0


if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Create a file
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
# Configure the source
sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make install
    unset BUILD_ZLIB BUILD_BZIP2
fi

popd
rm -rf "$FOLD_NAME"
