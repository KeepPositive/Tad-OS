#! /bin/bash

## Start variables
PACKAGE="libvpx"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$FOLD_NAME/libvpx-build"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.bz2"

pushd "$FOLD_NAME"

# Correct some file permission on install
sed -i 's/cp -p/cp/' build/make/Makefile

# Create two temporary links if building on the Raspberry Pi
case $SYSTEM in
"rpi")
    ln -sv /usr/bin/arm7l-unknown-linux-gnueabihf-gcc \ 
           /usr/bin/arm-none-gnueabi-gcc
    ln -sv /usr/bin/as /usr/bin/arm-none-gnueabi-as
;;
esac

popd

# Enter a build directory
mkdir $BUILD_DIR
pushd $BUILD_DIR
# Configure the source
../configure --prefix=/usr            \
             --enable-shared          \
             --disable-static
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
