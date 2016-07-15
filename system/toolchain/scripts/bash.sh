#! /bin/bash

PACKAGE="bash"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"


tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
./configure --prefix=/tools --without-bash-malloc

# Build using the configured sources
make -j "$CORES"

# Install the built package
fi

popd
rm -rf "$FOLD_NAME"
