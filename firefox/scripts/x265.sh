#! /bin/bash

## Start variables
NAME='x265'
EXTENSION='.tar.gz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Apply a patch
patch -Np1 -i ".$SOURCE_DIR/x265-1.9-enable_static-1.patch"
# Apply a patch for the RPi3
case $SYSTEM in
"rpi")
    patch -Np1 -i "$SOURCE_DIR/arm.patch"
;;
esac
# Leave the source directory
popd
# Make a build directory
mkdir "$FOLDER_NAME/x265-build"
#Enter the build directory
pushd "$FOLDER_NAME/x265-build"
# Configure the sources
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DENABLE_STATIC=OFF         \
      -DENABLE_SHARED=ON          \
      ../source
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
