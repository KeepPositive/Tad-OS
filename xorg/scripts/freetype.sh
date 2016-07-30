#! /bin/bash

## Start variables
NAME='freetype'
EXTENSION='.tar.bz2'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# sed some stuff
sed -e "/AUX.*.gxvalid/s@^# @@" \
    -e "/AUX.*.otvalid/s@^# @@" \
    -i modules.cfg
sed -r -e 's:.*(#.*SUBPIXEL.*) .*:\1:' \
    -i include/freetype/config/ftoption.h
# Configure the source
./configure --prefix=/usr --disable-static
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  install -v -m755 -d "/usr/share/doc/$FOLDER_NAME"
	cp -v -R docs/* "/usr/share/doc/$FOLDER_NAME"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
