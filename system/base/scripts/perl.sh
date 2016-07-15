#! /bin/bash

PACKAGE="perl"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_ZLIB=False
BUILD_BZIP2=0


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
fi

popd
rm -rf "$FOLD_NAME"
