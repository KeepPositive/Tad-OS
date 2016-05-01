#! /bin/bash

PACKAGE=git
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION

if [ -z "$CORES" ] 
then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"
pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr \
		    --with-gitconfig=/etc/gitconfig
# Build using the configured sources
make -j $CORES
# I would like to add the packages for building the docs, but not now.
# Install the built package
if [ "$INSTALL" -eq 1 ] 
then
    make install
    if [ -f "../git-manpages-$VERSION.tar.xz" ]
    then
        tar xf "../git-manpages-$VERSION.tar.xz" \
            -C /usr/share/man  \
            --no-same-owner    \
            --no-overwrite-dir \
            --with-libpcre
    fi
fi

popd
rm -rf "$FOLD_NAME"
