#! /bin/bash

## Start variables
NAME='pcre'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Apply a patch if it exists
if [ -f "$SOURCE_DIR/$FOLDER_NAME-upstream_fixes-1.patch" ]
then
  patch -Np1 -i "$SOURCE_DIR/$FOLDER_NAME-upstream_fixes-1.patch"
fi
# Configure the source
./configure --prefix=/usr                          \
            --docdir="/usr/share/doc/$FOLDER_NAME" \
            --enable-unicode-properties            \
            --enable-pcre16                        \
            --enable-pcre32                        \
            --enable-pcregrep-libz                 \
            --enable-pcregrep-libbz2               \
            --enable-pcretest-libreadline          \
            --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  mv -v /usr/lib/libpcre.so.* /lib
  ln -sfv "../../lib/$(readlink /usr/lib/libpcre.so)" /usr/lib/libpcre.so
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
