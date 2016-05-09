#! /bin/bash

PACKAGE="perl"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"
pushd "$FOLD_NAME"

# Configure the source
sh Configure -des -Dprefix=/tools -Dlibs=-lm

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]; then
    cp -v perl cpan/podlators/pod2man /tools/bin
    mkdir -pv /tools/lib/perl5/5.22.1
    cp -Rv lib/* /tools/lib/perl5/5.22.1
fi

popd
rm -rf "$FOLD_NAME"
