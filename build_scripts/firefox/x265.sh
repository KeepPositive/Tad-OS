#! /bin/bash

## Start variables
PACKAGE="x265"
VERSION=$1
FOLD_NAME=${PACKAGE}_${VERSION}
BUILD_DIR="$FOLD_NAME/bld"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Apply a patch
patch -Np1 -i "$PACKAGE_DIR/x265-1.9-enable_static-1.patch"
# Apply a patch for the RPi3
case $SYSTEM in
"rpi")
    patch -Np1 -i "$PACKAGE_DIR/arm.patch"
;;
esac

popd

# Make and enter a build directory
mkdir "$BUILD_DIR"
pushd "$BUILD_DIR"
# Configure the source
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DENABLE_STATIC=OFF         \
      -DENABLE_SHARED=ON          \
      ../source
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make install
fi

popd

rm -rf "$FOLD_NAME"
## End script
