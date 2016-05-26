#! /bin/bash

## Start variables
PACKAGE="sudo"
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

# Configure the source
./configure --prefix=/usr                       \
            --disable-static                    \
            --libexecdir=/usr/lib               \
            --with-secure-path                  \
            --with-all-insults                  \
            --with-env-editor                   \
            --docdir=/usr/share/doc/sudo-1.8.16 \
            --with-passprompt="[sudo] password for %p"
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
    ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
fi

popd

rm -rf "$FOLD_NAME"
## End script
