#! /bin/bash

## Start variables
NAME='gcc'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
VERSION=$(echo $FOLDER_NAME | sed -e "s/gcc-//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Make a build directory
mkdir "$FOLDER_NAME/build"
#Enter the build directory
pushd "$FOLDER_NAME/build"
# Configure the source
../libstdc++-v3/configure       \
  --host="$LFS_TGT"             \
  --prefix=/tools               \
  --disable-multilib            \
  --disable-nls                 \
  --disable-libstdcxx-threads   \
  --disable-libstdcxx-pch       \
  --with-gxx-include-dir="/tools/$LFS_TGT/include/c++/$VERSION"
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
