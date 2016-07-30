#! /bin/bash

## Start variables
NAME='readline'
EXTENSION='.tar.gz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Apply a patch and sed
patch -Np1 -i "$PACKAGE_DIR/$FOLDER_NAME-upstream_fixes-3.patch"
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
# Configure the source
./configure --prefix=/usr    \
            --disable-static \
            --docdir="/usr/share/doc/$FOLDER_NAME"
# Build using the configured sources
make -j "$CORES" SHLIB_LIBS=-lncurses
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make SHLIB_LIBS=-lncurses install
  mv -v /usr/lib/lib{readline,history}.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
  ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
  install -v -m644 doc/*.{ps,pdf,html,dvi} "/usr/share/doc/$FOLDER_NAME"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
