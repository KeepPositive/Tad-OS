#! /bin/bash

## Start variables
NAME='ffmpeg'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
echo "$PACKAGE_FILE"
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Add a linking flag in the configure file
sed -i 's/-lflite"/-lflite -lasound"/' configure
# Configure the source
# Configure the source
echo "Configuring!"
./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --enable-x11grab     \
            --docdir="/usr/share/doc/$FOLDER_NAME"
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  install -v -m755 tools/qt-faststart /usr/bin
  install -v -m644 doc/*.txt "/usr/share/doc/$FOLDER_NAME"
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
