#! /bin/bash

## Start variables
NAME='gtk+'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-2*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Edit the Makefile to prevent a documentation error
sed -i "s#l \(gtk-.*\).sgml#& -o \1#" docs/{faq,tutorial}/Makefile.in
sed -e 's#pltcheck.sh#$(NULL)#g' -i gtk/Makefile.in
# Configure the source
./configure --prefix=/usr --sysconfdir=/etc
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  gtk-query-immodules-2.0 --update-cache
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
