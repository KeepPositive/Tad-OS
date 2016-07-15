#! /bin/bash

## Start variables
PACKAGE="startup-notification"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package
    "/usr/share/doc/startup-notification-$VERSION/startup-notification.txt"
fi

popd

rm -rf "$FOLD_NAME"
## End script
