#! /bin/bash

## Start variables
NAME='libvpx'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Correct some file permissions for installation
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
# Make a build directory
mkdir "$FOLDER_NAME/build"
#Enter the build directory
pushd "$FOLDER_NAME/build"
# Configure the source
./configure --prefix=/usr            \
            --enable-shared          \
            --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
