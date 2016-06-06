#! /bin/bash

## Start variables
PACKAGE="ffmpeg"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Add a linking flag in the configure file
sed -i 's/-lflite"/-lflite -lasound"/' configure
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
            --docdir="/usr/share/doc/ffmpeg-$VERSION"
# Build using the configured sources
make -j "$CORES"
gcc tools/qt-faststart.c -o tools/qt-faststart
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make install
    install -v -m755 tools/qt-faststart /usr/bin
    install -v -m644 doc/*.txt "/usr/share/doc/ffmpeg-$VERSION"
fi

popd

rm -rf "$FOLD_NAME"
## End script
