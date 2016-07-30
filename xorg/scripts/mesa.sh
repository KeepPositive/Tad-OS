#! /bin/bash

## Start variables
NAME='mesa'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
GLL_DRV="nouveau,r300,r600,radeonsi,svga,swrast"
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Configure the source
case "$GRAPHICS_DRIVER" in
"rpi")
    ./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'    \
                --prefix=$XORG_PREFIX           \
                --sysconfdir=/etc               \
                --enable-texture-float          \
                --enable-gles1                  \
                --enable-gles2                  \
                --enable-osmesa                 \
                --enable-xa                     \
                --enable-gbmi			              \
		            --with-dri-drivers=             \
                --enable-glx-tls                \
                --enable-shared-glapi   	      \
                --with-egl-platforms="drm,x11"  \
                --with-gallium-drivers=vc4
;;
*)
    ./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'    \
                --prefix=$XORG_PREFIX           \
                --sysconfdir=/etc               \
                --enable-texture-float          \
                --enable-gles1                  \
                --enable-gles2                  \
                --enable-osmesa                 \
                --enable-xa                     \
                --enable-gbm                    \
                --enable-glx-tls                \
                --enable-r600-llvm-compiler     \
                --with-egl-platforms="drm,x11"  \
                --with-gallium-drivers=$GLL_DRV
;;
esac
# Build using the configured sources
make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
