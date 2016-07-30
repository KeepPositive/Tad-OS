#! /bin/bash

## Start variables
NAME='binutils'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Make a build directory
mkdir "$FOLDER_NAME/build"
# Enter the build directory
pushd "$FOLDER_NAME/build"
# Configure the source
CC=$LFS_TGT-gcc                         \
AR=$LFS_TGT-ar                          \
RANLIB=$LFS_TGT-ranlib                  \
../configure --prefix=/tools            \
             --disable-nls              \
             --disable-werror           \
             --with-lib-path=/tools/lib \
             --with-sysroot
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  make -C ld clean
  make -C ld LIB_PATH=/usr/lib:/lib
  cp -v ld/ld-new /tools/bin
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
