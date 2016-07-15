#! /bin/bash

## Start variables
NAME='git'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
VERSION=$(echo "$FOLDER_NAME" | sed -e "s/$NAME-//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
./configure --prefix=/usr \
		        --with-gitconfig=/etc/gitconfig
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  if [ -f "../git-manpages-$VERSION$EXTENSION" ]
  then
    tar xvf "$SOURCE_DIR/git-manpages-$VERSION$EXTENSION" \
      -C /usr/share/man                                \
      --no-same-owner                                  \
      --no-overwrite-dir                               \
      --with-libpcre
  fi
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
