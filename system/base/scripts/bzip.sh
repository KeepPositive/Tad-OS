#! /bin/bash

PACKAGE="bzip2"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"
# Apply a patch
patch -Np1 -i $PACKAGE_DIR/bzip2-$VERSION-install_docs-1.patch
# Edit the makefile a little for man pages and relative sym links
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
# Some more preparation for building
make -f Makefile-libbz2_so
make clean
# Build using the configured sources
make -j "$CORES"
# Install the built package
	ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
	rm -v /usr/bin/{bunzip2,bzcat,bzip2}
	ln -sv bzip2 /bin/bunzip2
	ln -sv bzip2 /bin/bzcat
fi

popd

rm -rf "$FOLD_NAME"
