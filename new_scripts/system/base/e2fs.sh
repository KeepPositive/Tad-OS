#! /bin/bash

## Start variables
NAME='e2fsprogs'
EXTENSION='.tar.gz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Make a build directory
mkdir "$FOLDER_NAME/build"
# Enter the source directory
pushd "$FOLDER_NAME/build"
# Configure the source
LIBS=-L/tools/lib                    \
CFLAGS=-I/tools/include              \
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  make install-libs
  chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
  gunzip -v /usr/share/info/libext2fs.info.gz
  install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
  makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
  install -v -m644 doc/com_err.info /usr/share/info
  install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
