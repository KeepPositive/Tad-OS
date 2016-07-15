#! /bin/bash

## Start variables
NAME='gettext'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME/gettext-tools"
# Configure the source
EMACS="no" ./configure --prefix=/tools --disable-shared
# Build using the configured sources
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
